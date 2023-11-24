local _f = require(script.Parent)

local BitBuffer = _f.BitBuffer
local Persistence = {}
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local datacache = {}  
local STRING_LEN_LIMIT = 259900
local offsetByPlayer = {}
local keysByPlayer = {}

local MySqlService = _f.MySqlService
local PlayerDataStore = MySqlService:GetDatabase("PlayerData")
local PCDataStore = MySqlService:GetDatabase("PCData")
local ROPowerDataStore = MySqlService:GetDatabase("ROPowerBackups")

local BattledPlayers = MySqlService:GetDatabase("PVPHourBattleHistoryV3")
local BattleStreak = MySqlService:GetDatabase("PVPWinStreak")
local ApartmentStore  = MySqlService:GetDatabase('ApartmentsData')
local AdventureSlot1DataStore = MySqlService:GetDatabase("AdventureSlot1")
local AdventureSlot2DataStore = MySqlService:GetDatabase("AdventureSlot2")
local AdventureSlot1APRT = MySqlService:GetDatabase("AdventureSlot1APRT")
local AdventureSlot2APRT = MySqlService:GetDatabase("AdventureSlot2APRT")

Players.PlayerRemoving:Connect(function(player)
	if datacache[player.Name] then
		datacache[player.Name] = nil
	end
end)


local function reportBadSaveString(userId, data, errorNum)
	local errorTypes = {
		["-2"] = "PC Data Familiars mismatch.",
		["-1"] = "Empty Familiars in PC Data.",
		["1"] = "Div (;) mismatch.",
		["2"] = "Div2 (-) mismatch.",
	}
	pcall(function()
		_f.Logs:logError(game.Players:GetPlayerByUserId(userId), {
			ErrType = "Invalid/Bad Save String",
			Errors = errorTypes[tostring(errorNum)],  
		})
	end)
end
local function safetyCheck(mainData, pcData)
		if select(2, mainData:gsub(';', ';')) ~= 3 then
			return 1
		end

		local ok, valid = pcall(function()
			local header = mainData:match('^([^;]+);')
			return header and select(2, header:gsub('%-', '-')) == 4
		end)
		if not ok or not valid then
			return 2
		end

		if not pcData or pcData == "" then
			return 0
		end

		if pcData:find(',,') then
			return -1
		end

		local ok2, valid2 = pcall(function()
			local meta, familiarsArray = pcData:match('^([^;]+);(.*)$')
			if not meta then
				return false
			end

			local buffer = BitBuffer.Create()
			buffer:FromBase64(meta)

			local version = buffer:ReadUnsigned(6)

			if version >= 13 then
				buffer:ReadUnsigned(7) -- maxBoxes
				buffer:ReadUnsigned(7) -- currentBox

				if buffer:ReadBool() then
					local n = buffer:ReadUnsigned(7)
					for _ = 1, n do
						if buffer:ReadBool() then
							buffer:ReadString()
						end
					end
				end

				if buffer:ReadBool() then
					local n = buffer:ReadUnsigned(7)
					for _ = 1, n do
						if buffer:ReadBool() then
							buffer:ReadUnsigned(6)
						end
					end
				end

				if version >= 14 then
					if buffer:ReadBool() then
						local n = buffer:ReadUnsigned(7)
						for _ = 1, n do
							if buffer:ReadBool() then
								buffer:ReadString()
							end
						end
					end
				end

				local nStored = buffer:ReadUnsigned(12)

				if nStored == 0 then
					return familiarsArray == "" or familiarsArray == nil
				end

				local commaCount = select(2, familiarsArray:gsub(',', ','))
				return (commaCount + 1) == nStored
			else
				if version >= 2 then
					buffer:ReadBool()
				end

				buffer:ReadUnsigned(version >= 3 and 6 or 5)

				if version >= 6 then
					if buffer:ReadBool() then
						local n = buffer:ReadUnsigned(6)
						for _ = 1, n do
							if buffer:ReadBool() then
								buffer:ReadString()
							end
						end
					end

					if buffer:ReadBool() then
						local n = buffer:ReadUnsigned(6)
						for _ = 1, n do
							if buffer:ReadBool() then
								buffer:ReadUnsigned(version >= 7 and 6 or 5)
							end
						end
					end
				end

				local nStored = buffer:ReadUnsigned(version >= 1 and 11 or 10)

				if nStored == 0 then
					return familiarsArray == "" or familiarsArray == nil
				end

				local commaCount = select(2, familiarsArray:gsub(',', ','))
				return (commaCount + 1) == nStored
			end
		end)

		if not ok2 or not valid2 then
			return -2
		end

		return 0
	end

-- ---- Generic Save/Load for Adventure Slots ----
local function SaveAdventureSlot(player, slotNum, mainData, pcData)
	if player.UserId < 1 then return false end
	local id = tostring(player.UserId) .. "_Adv" .. slotNum

	-- Safety check
	local check = safetyCheck(mainData, pcData)
	if check ~= 0 then
		reportBadSaveString(player.UserId, check > 0 and mainData or pcData, check)
		return false
	end

	local offset = offsetByPlayer[player.UserId .. "_Adv" .. slotNum] or 0
	local nKeys = math.ceil(#pcData / STRING_LEN_LIMIT)

	-- Save PC chunks
	for i = 1, nKeys do
		local si = STRING_LEN_LIMIT * (i - 1) + 1
		local ei = math.min(#pcData, STRING_LEN_LIMIT * i)
		local success, err = pcall(function()
			local ds = slotNum == 1 and AdventureSlot1DataStore or AdventureSlot2DataStore
			ds:SetAsync(id .. "_" .. (i + offset), pcData:sub(si, ei))
		end)
		if not success then
			warn("❌ Error saving AdvSlot" .. slotNum .. " PC chunk", i, "for", player.Name, ":", err)
			return false
		end
	end

	-- Save main data
	local saveString = string.format("%d[%d]%s", offset, nKeys, mainData)
	local success, err = pcall(function()
		local ds = slotNum == 1 and AdventureSlot1DataStore or AdventureSlot2DataStore
		ds:SetAsync(id, saveString)
	end)

	offsetByPlayer[player.UserId .. "_Adv" .. slotNum] = offset
	keysByPlayer[player.UserId .. "_Adv" .. slotNum] = nKeys
	return success
end

local function LoadAdventureSlot(player, slotNum)
	if player.UserId < 1 then return true, "", "" end
	local id = tostring(player.UserId) .. "_Adv" .. slotNum

	local ds = slotNum == 1 and AdventureSlot1DataStore or AdventureSlot2DataStore

	local success, rawData = pcall(function()
		return ds:GetAsync(id)
	end)

	if not success or not rawData then
		return true, "", ""
	end

	local offset, nKeys, saveString = rawData:match('^(%d+)%[(%d+)%](.+)$')
	if not offset or not nKeys or not saveString then
		return true, "", ""
	end

	offset = tonumber(offset)
	nKeys = tonumber(nKeys)
	offsetByPlayer[player.UserId .. "_Adv" .. slotNum] = offset
	keysByPlayer[player.UserId .. "_Adv" .. slotNum] = nKeys

	local pcData = ""
	for i = 1, nKeys do
		local partSuccess, part = pcall(function()
			return ds:GetAsync(id .. "_" .. (i + offset))
		end)
		if partSuccess and part then
			pcData = pcData .. part
		end
	end

	return true, saveString, pcData
end

-- ---- Apartment Save/Load for Adventure Slots ----
local function SaveAdventureSlotAPRT(player, slotNum, apartmentData)
	if player.UserId < 1 then return false end
	local id = tostring(player.UserId) .. "_Adv" .. slotNum
	local ds = slotNum == 1 and AdventureSlot1APRT or AdventureSlot2APRT

	local success, err = pcall(function()
		ds:SetAsync(id, apartmentData)
	end)

	if not success then
		warn("❌ Failed to save apartment data for AdvSlot" .. slotNum, player.Name, ":", err)
	end
	return success
end

local function LoadAdventureSlotAPRT(player, slotNum)
	if player.UserId < 1 then return true, nil end
	local id = tostring(player.UserId) .. "_Adv" .. slotNum
	local ds = slotNum == 1 and AdventureSlot1APRT or AdventureSlot2APRT

	local success, data = pcall(function()
		return ds:GetAsync(id)
	end)

	if not success then
		warn("⚠️ Failed to load apartment data for AdvSlot" .. slotNum, player.Name)
		return true, nil
	end

	return true, data
end

-- ---- Expose functions ----
Persistence.SaveAdventureSlot1 = function(player, mainData, pcData)
	return SaveAdventureSlot(player, 1, mainData, pcData)
end

Persistence.LoadAdventureSlot1 = function(player)
	return LoadAdventureSlot(player, 1)
end

Persistence.SaveAdventureSlot2 = function(player, mainData, pcData)
	return SaveAdventureSlot(player, 2, mainData, pcData)
end

Persistence.LoadAdventureSlot2 = function(player)
	return LoadAdventureSlot(player, 2)
end

Persistence.SaveAdventureSlot1APRT = function(player, data)
	return SaveAdventureSlotAPRT(player, 1, data)
end

Persistence.LoadAdventureSlot1APRT = function(player)
	return LoadAdventureSlotAPRT(player, 1)
end

Persistence.SaveAdventureSlot2APRT = function(player, data)
	return SaveAdventureSlotAPRT(player, 2, data)
end

Persistence.LoadAdventureSlot2APRT = function(player)
	return LoadAdventureSlotAPRT(player, 2)
end


function Persistence.SaveData(player, mainData, pcData, gamemode)
	if player.UserId < 1 then return false end

	local id = tostring(player.UserId)
	if gamemode == "randomizer" then
		id = id .. "_Random"
	elseif gamemode == "spawner" then 
		id = id .. "_Spawn"
	end

	local check = safetyCheck(mainData, pcData)
	if check ~= 0 then
		reportBadSaveString(player.UserId, check > 0 and mainData or pcData, check)
		return false
	end

	local offset = offsetByPlayer[player] or 0
	local nKeys = math.ceil(#pcData / STRING_LEN_LIMIT)

	for i = 1, nKeys do
		local si = STRING_LEN_LIMIT * (i - 1) + 1
		local ei = math.min(#pcData, STRING_LEN_LIMIT * i)

		local success, err = pcall(function()
			return PCDataStore:SetAsync(id .. "_" .. (i + offset), pcData:sub(si, ei))
		end)

		if not success then
			warn("❌ Error saving PC chunk", i, "for", player.Name, ":", err)
			return false
		end
	end

	local saveString = string.format("%d[%d]%s", offset, nKeys, mainData)

	local success, err = pcall(function()
		return PlayerDataStore:SetAsync(id, saveString)
	end)

	if not success then
		warn("❌ Error saving main data for", player.Name, ":", err)
		return false
	end

	offsetByPlayer[player] = offset
	keysByPlayer[player] = nKeys
	return true
end

function Persistence.LoadData(player, gamemode)
	local id = tostring(player.UserId)

	if gamemode == 'randomizer' then
		id = id .. '_Random'
	elseif gamemode == 'spawner'then
		id = id .. '_Spawn'
	end

	local success, rawData = pcall(function()
		return PlayerDataStore:GetAsync(id)
	end)

	if not success then
		return true, "", "" 
	end

	if not rawData then
		return true, "", "" 
	end

	local offset, nKeys, saveString = rawData:match('^(%d+)%[(%d+)%](.+)$')

	if not offset or not nKeys or not saveString then
		return true, "", "" 
	end

	offset = tonumber(offset)
	nKeys = tonumber(nKeys)

	offsetByPlayer[player] = offset
	keysByPlayer[player] = nKeys

	local pcData
	for i = 1, nKeys do
		local success, part = pcall(function()
			return PCDataStore:GetAsync(id .. "_" .. (i + offset))
		end)
		if success and part then
			pcData = (pcData or "") .. part
		else
			warn("⚠️ LoadData: Failed to load PC chunk", i, "for", player.Name)
		end
	end

	return true, saveString, pcData
end

function Persistence.getPC(player)
	local id = tostring(player.UserId)
	if not keysByPlayer[player] then return "" end

	local offset = offsetByPlayer[player]
	local nKeys = keysByPlayer[player]
	local pcData = ""

	for i = 1, nKeys do
		local success, part = pcall(function()
			return PCDataStore:GetAsync(id .. "_" .. (i + offset))
		end)
		if success and part then
			pcData = pcData .. part
		else
			warn("⚠️ getPC: Failed to get chunk", i, "for", player.Name)
		end
	end

	return pcData
end
do
	local function getModeSuffix(gamemode)
		if gamemode == "randomizer" then
			return "_Random"
		elseif gamemode == "spawner" then
			return "_Spawn"
		elseif gamemode == "AdvSlot1" then
			return "_AdvSlot1"
		elseif gamemode == "AdvSlot2" then
			return "_AdvSlot2"
		end
		return "" -- adventure
	end

	function Persistence.ROPowerSave(player, action, data, gamemode)
		if player.UserId < 1 then return nil end
		local key = tostring(player.UserId) .. getModeSuffix(gamemode)

		if action == "save" then
			local ok, err = pcall(function()
				ROPowerDataStore:SetAsync(key, data)
			end)
			if not ok then
				warn("❌ ROPowerSave(save) failed for", player.Name, ":", err)
			end
			return ok

		elseif action == "load" then
			local loaded
			local ok, err = pcall(function()
				return ROPowerDataStore:GetAsync(key)
			end)

			-- NOTE: pcall returns (ok, result). Your code wasn't capturing result correctly.
			if ok then
				loaded = err
			else
				warn("⚠️ ROPowerSave(load) failed for", player.Name, ":", err)
				return nil
			end

			if type(loaded) ~= "string" or loaded == "" then
				return nil
			end
			return loaded
		end

		return nil
	end
end

-- BP Management (1 BP per battle between each player combo, per hour
do

	local TIME_BETWEEN_BP_AWARDS = 60*60
	local Battle = _f.CombatEngine
	
	function Battle:PVPBattleAwardsBP(versusId)
		local s, lastTime = pcall(function() return BattledPlayers:GetAsync(versusId) end)
		if not s then
			if self.WIN_DEBUG then
				print('Failed to get last time you\'ve battled this player:')
				print(lastTime)
				print('Defaulting to AwardBPEnabled')
			end
			return true
		end
		local now = os.time()
		if lastTime and now - tonumber(lastTime) < TIME_BETWEEN_BP_AWARDS then
			if self.WIN_DEBUG then print('You already battled this guy in the last hour.') end
			return false
		end
		pcall(function() BattledPlayers:SetAsync(versusId, tostring(now)) end)
		if self.WIN_DEBUG then print('This battle has properly been flagged to award BP.') end
		return true
	end

	function Battle:resetStreak(userId)
		local key = tostring(userId)
		pcall(function()
			BattleStreak:SetAsync(key, "0")
		end)
	end

	function Battle:incrementStreak(userId)
		local key = tostring(userId)
		local s, current = pcall(function()
			return tonumber(BattleStreak:GetAsync(key)) or 0
		end)

		if not s then
			warn("⚠️ Failed to get streak for", userId)
			current = 0
		end
		
		current += 1
		
		pcall(function()
			BattleStreak:SetAsync(key, tostring(current))
		end)
	end

	function Battle:getStreak(userId)
		local s, r = pcall(function()
			return BattleStreak:GetAsync(tostring(userId)) or 0
		end)
		return s and tonumber(r) or 0
	end
end



function Persistence.getRollbackData(player)
	local id = tostring(player.UserId)
	if not keysByPlayer[player] then return "", "" end

	local offset = offsetByPlayer[player]
	local nKeys = keysByPlayer[player]

	local success, rawData = pcall(function()
		return PlayerDataStore:GetAsync(id)
	end)

	if not success or not rawData then return "", "" end

	local _, _, mainData = rawData:match('^(%d+)%[(%d+)%](.+)$')
	if not mainData then return "", "" end

	local pcData = ""
	for i = 1, nKeys do
		local success, part = pcall(function()
			return PCDataStore:GetAsync(id .. "_" .. (i + offset))
		end)
		if success and part then
			pcData = pcData .. part
		end
	end

	return mainData, pcData
end

-- ================================
-- Apartment Save / Load (MySQL)
-- ================================

function Persistence.SaveAPRT(player, apartmentData, gamemode)
	if player.UserId < 1 then return false end

	local id = tostring(player.UserId)

	if gamemode == "randomizer" then
		id ..= "_Random"
	elseif gamemode == "spawner" then
		id ..= "_Spawn"
	end

	local success, err = pcall(function()
		return ApartmentStore:SetAsync(id, apartmentData)
	end)

	if not success then
		warn("❌ Failed to save apartment data for", player.Name, ":", err)
		return false
	end

	return true
end

function Persistence.LoadAPRT(player, gamemode)
	if player.UserId < 1 then return true, nil end


	local id = tostring(player.UserId)

	if gamemode == "randomizer" then
		id ..= "_Random"
	elseif gamemode == "spawner" then
		id ..= "_Spawn"
	end

	local success, data = pcall(function()
		return ApartmentStore:GetAsync(id)
	end)

	if not success then
		warn("⚠️ Failed to load apartment data for", player.Name)
		return true, nil
	end

	return true, data
end


return Persistence
-- 2022-01-03T16:27:18

-- 2022-01-03T19:44:50

-- 2022-01-03T11:05:29

-- 2022-01-04T22:24:35

-- 2022-01-04T21:08:35

-- 2022-01-05T19:50:49

-- 2022-01-07T12:40:37

-- 2022-01-08T13:10:31

-- 2022-01-08T12:07:16

-- 2022-01-10T22:55:23

-- 2022-01-10T13:46:23

-- 2022-01-10T15:37:29

-- 2022-01-14T10:20:38

-- 2022-01-15T22:43:21

-- 2022-01-15T15:09:04

-- 2022-01-15T15:44:45

-- 2022-01-15T17:49:10

-- 2022-01-18T10:56:06

-- 2022-01-18T21:16:10

-- 2022-01-19T15:50:39

-- 2022-01-19T09:42:21

-- 2022-01-19T09:49:08

-- 2022-01-19T18:30:15

-- 2022-01-23T22:22:44

-- 2022-01-24T09:22:59

-- 2022-01-25T18:39:33

-- 2022-01-28T21:54:34

-- 2022-01-29T13:49:00

-- 2022-01-30T19:24:57

-- 2022-01-31T14:54:56

-- 2022-01-31T09:31:27

-- 2022-01-31T10:14:56

-- 2022-02-02T09:25:24

-- 2022-02-02T10:35:45

-- 2022-02-05T11:15:25

-- 2022-02-06T17:30:23

-- 2022-02-06T21:58:39

-- 2022-02-09T11:35:02

-- 2022-02-09T19:56:13

-- 2022-02-10T12:32:28

-- 2022-02-12T13:54:04

-- 2022-02-12T12:02:48

-- 2022-02-15T16:38:35

-- 2022-02-15T12:31:06

-- 2022-02-16T12:32:46

-- 2022-02-16T13:07:51

-- 2022-02-18T14:36:37

-- 2022-02-18T11:57:54

-- 2022-02-19T11:19:37

-- 2022-02-20T11:40:41

-- 2022-02-22T15:19:38

-- 2022-02-25T22:05:45

-- 2022-02-26T15:15:18

-- 2022-02-26T13:55:04

-- 2022-03-01T22:31:03

-- 2022-03-01T12:25:07

-- 2022-03-03T22:30:59

-- 2022-03-08T14:07:59

-- 2022-03-09T21:14:19

-- 2022-03-13T18:42:14

-- 2022-03-18T13:40:36

-- 2022-03-19T14:02:58

-- 2022-03-19T14:58:30

-- 2022-03-21T17:01:36

-- 2022-03-22T21:47:52

-- 2022-03-23T10:13:48

-- 2022-03-24T09:17:09

-- 2022-03-25T20:47:48

-- 2022-03-25T14:52:51

-- 2022-03-26T19:35:58

-- 2022-03-26T12:47:57

-- 2022-03-27T22:19:15

-- 2022-03-28T17:03:34

-- 2022-03-31T11:35:07

-- 2022-04-01T13:29:26

-- 2022-04-01T10:53:36

-- 2022-04-01T11:44:46

-- 2022-04-03T20:47:26

-- 2022-04-03T09:16:09

-- 2022-04-04T11:14:46

-- 2022-04-05T20:53:28

-- 2022-04-07T19:13:35

-- 2022-04-13T18:03:17

-- 2022-04-17T12:21:53

-- 2022-04-18T19:08:42

-- 2022-04-21T10:20:14

-- 2022-04-23T12:53:26

-- 2022-04-25T16:33:47

-- 2022-04-25T09:51:25

-- 2022-04-27T11:47:55

-- 2022-04-28T20:32:34

-- 2022-05-01T09:53:34

-- 2022-05-02T10:30:23

-- 2022-05-02T21:49:59

-- 2022-05-07T20:33:49

-- 2022-05-07T15:59:40

-- 2022-05-07T10:54:13

-- 2022-05-08T22:11:26

-- 2022-05-09T14:52:34

-- 2022-05-09T19:36:00

-- 2022-05-10T20:42:28

-- 2022-05-10T20:23:53

-- 2022-05-11T14:25:40

-- 2022-05-13T09:00:09

-- 2022-05-14T11:02:09

-- 2022-05-15T17:40:52

-- 2022-05-17T17:47:49

-- 2022-05-18T22:23:01

-- 2022-05-19T18:57:48

-- 2022-05-23T11:27:25

-- 2022-05-25T20:40:44

-- 2022-05-26T14:00:20

-- 2022-05-26T18:32:36

-- 2022-05-26T17:37:39

-- 2022-05-28T10:26:26

-- 2022-05-28T10:09:45

-- 2022-05-30T12:55:52

-- 2022-06-01T16:58:08

-- 2022-06-01T19:41:20

-- 2022-06-03T18:51:49

-- 2022-06-03T17:18:51

-- 2022-06-06T12:26:11

-- 2022-06-07T13:54:33

-- 2022-06-08T18:51:24

-- 2022-06-09T17:11:25

-- 2022-06-09T09:20:46

-- 2022-06-10T18:43:35

-- 2022-06-13T19:12:29

-- 2022-06-13T11:25:52

-- 2022-06-18T18:43:31

-- 2022-06-20T17:10:46

-- 2022-06-20T18:49:25

-- 2022-06-21T18:26:32

-- 2022-06-21T19:20:57

-- 2022-06-24T12:07:01

-- 2022-06-24T16:37:06

-- 2022-06-25T16:09:15

-- 2022-06-26T22:12:48

-- 2022-06-26T09:15:21

-- 2022-06-26T16:02:48

-- 2022-06-27T16:43:14

-- 2022-06-29T22:20:08

-- 2022-07-01T15:36:27

-- 2022-07-03T15:56:47

-- 2022-07-04T11:02:08

-- 2022-07-04T18:32:32

-- 2022-07-06T15:21:58

-- 2022-07-07T14:23:22

-- 2022-07-08T17:42:09

-- 2022-07-08T18:39:07

-- 2022-07-09T13:03:02

-- 2022-07-10T20:23:01

-- 2022-07-10T22:04:13

-- 2022-07-11T12:32:53

-- 2022-07-12T12:42:53

-- 2022-07-12T16:05:26

-- 2022-07-12T09:05:37

-- 2022-07-14T19:45:34

-- 2022-07-15T19:17:21

-- 2022-07-15T20:07:24

-- 2022-07-15T22:52:48

-- 2022-07-16T19:19:39

-- 2022-07-18T11:00:34

-- 2022-07-18T13:20:07

-- 2022-07-18T09:04:42

-- 2022-07-20T21:51:26

-- 2022-07-22T12:29:57

-- 2022-07-22T22:35:58

-- 2022-07-23T10:15:12

-- 2022-07-25T17:11:02

-- 2022-07-27T17:27:00

-- 2022-07-28T09:21:05

-- 2022-07-29T19:59:13

-- 2022-07-29T15:26:22

-- 2022-07-30T21:50:51

-- 2022-07-31T21:54:34

-- 2022-08-03T09:33:55

-- 2022-08-03T10:52:10

-- 2022-08-03T13:04:56

-- 2022-08-03T22:37:41

-- 2022-08-05T18:52:58

-- 2022-08-06T14:16:05

-- 2022-08-06T18:49:26

-- 2022-08-10T21:30:38

-- 2022-08-10T09:05:08

-- 2022-08-11T19:29:10

-- 2022-08-11T21:05:01

-- 2022-08-12T21:03:03

-- 2022-08-12T15:42:12

-- 2022-08-15T21:08:50

-- 2022-08-15T19:07:28

-- 2022-08-15T16:24:38

-- 2022-08-16T12:25:10

-- 2022-08-18T12:56:25

-- 2022-08-18T17:57:53

-- 2022-08-18T13:46:27

-- 2022-08-20T18:17:04

-- 2022-08-22T18:58:01

-- 2022-08-23T19:47:31

-- 2022-08-23T19:45:59

-- 2022-08-24T15:41:14

-- 2022-08-26T15:18:07

-- 2022-08-28T15:38:01

-- 2022-08-29T22:02:12

-- 2022-09-04T09:18:56

-- 2022-09-06T18:47:09

-- 2022-09-06T14:12:10

-- 2022-09-06T11:49:53

-- 2022-09-08T12:25:04

-- 2022-09-08T09:23:26

-- 2022-09-08T09:00:02

-- 2022-09-09T18:03:57

-- 2022-09-10T19:25:02

-- 2022-09-11T17:22:56

-- 2022-09-12T20:29:15

-- 2022-09-17T10:15:50

-- 2022-09-17T09:44:31

-- 2022-09-18T15:58:21

-- 2022-09-18T16:29:38

-- 2022-09-18T17:48:50

-- 2022-09-21T09:17:11

-- 2022-09-23T15:44:09

-- 2022-09-24T10:01:57

-- 2022-09-24T14:44:44

-- 2022-09-25T17:49:29

-- 2022-09-25T17:24:07

-- 2022-09-26T12:36:40

-- 2022-09-27T18:44:43

-- 2022-09-27T11:57:18

-- 2022-09-27T18:15:51

-- 2022-09-28T19:52:10

-- 2022-09-29T12:54:47

-- 2022-09-30T14:36:10

-- 2022-09-30T12:30:06

-- 2022-10-02T22:43:45

-- 2022-10-05T10:57:17

-- 2022-10-06T12:13:11

-- 2022-10-07T20:24:05

-- 2022-10-07T16:27:06

-- 2022-10-07T12:46:05

-- 2022-10-10T17:26:14

-- 2022-10-10T17:36:44

-- 2022-10-11T17:14:16

-- 2022-10-12T14:10:10

-- 2022-10-13T09:24:34

-- 2022-10-14T21:01:58

-- 2022-10-16T11:21:07

-- 2022-10-16T22:44:21

-- 2022-10-17T14:17:18

-- 2022-10-17T14:53:58

-- 2022-10-18T12:29:55

-- 2022-10-19T14:17:06

-- 2022-10-19T12:20:04

-- 2022-10-20T13:03:17

-- 2022-10-22T21:51:05

-- 2022-10-22T10:19:06

-- 2022-10-22T18:28:52

-- 2022-10-24T17:05:25

-- 2022-10-25T20:24:09

-- 2022-10-27T17:09:13

-- 2022-10-27T14:55:39

-- 2022-10-29T15:12:56

-- 2022-10-30T17:59:06

-- 2022-10-30T17:09:31

-- 2022-10-31T09:08:25

-- 2022-11-01T15:44:47

-- 2022-11-04T11:11:57

-- 2022-11-05T10:30:16

-- 2022-11-05T12:46:40

-- 2022-11-06T22:40:57

-- 2022-11-07T22:17:30

-- 2022-11-07T11:47:38

-- 2022-11-11T16:14:34

-- 2022-11-12T15:59:32

-- 2022-11-13T14:34:42

-- 2022-11-15T20:04:07

-- 2022-11-16T16:02:03

-- 2022-11-20T10:40:05

-- 2022-11-20T13:46:26

-- 2022-11-21T16:00:59

-- 2022-11-24T12:56:40

-- 2022-11-24T13:01:40

-- 2022-11-25T22:08:12

-- 2022-11-27T22:41:42

-- 2022-11-30T22:00:14

-- 2022-11-30T20:31:25

-- 2022-12-01T19:58:55

-- 2022-12-02T20:16:37

-- 2022-12-03T12:17:13

-- 2022-12-03T12:11:19

-- 2022-12-06T11:54:12

-- 2022-12-06T12:29:13

-- 2022-12-08T14:58:38

-- 2022-12-08T19:22:02

-- 2022-12-09T15:12:17

-- 2022-12-09T11:22:42

-- 2022-12-10T12:25:22

-- 2022-12-12T19:05:31

-- 2022-12-12T18:36:23

-- 2022-12-14T20:24:18

-- 2022-12-15T18:56:56

-- 2022-12-15T13:59:37

-- 2022-12-17T13:43:20

-- 2022-12-18T10:46:42

-- 2022-12-18T19:18:43

-- 2022-12-18T18:33:44

-- 2022-12-18T15:13:32

-- 2022-12-19T12:03:04

-- 2022-12-19T13:04:48

-- 2022-12-24T19:00:10

-- 2022-12-25T11:07:15

-- 2022-12-25T15:57:43

-- 2022-12-26T14:13:30

-- 2022-12-26T14:23:32

-- 2022-12-26T16:56:42

-- 2022-12-27T20:54:03

-- 2022-12-27T16:26:42

-- 2022-12-31T11:25:38

-- 2023-01-03T16:42:36

-- 2023-01-10T22:48:13

-- 2023-01-10T18:37:33

-- 2023-01-11T17:03:24

-- 2023-01-11T13:08:32

-- 2023-01-14T19:07:32

-- 2023-01-14T18:23:51

-- 2023-01-15T11:27:53

-- 2023-01-18T21:26:46

-- 2023-01-22T19:49:37

-- 2023-01-24T14:56:10

-- 2023-01-24T13:54:24

-- 2023-01-25T21:40:56

-- 2023-01-25T11:55:24

-- 2023-01-29T20:29:48

-- 2023-01-29T10:16:07

-- 2023-02-04T22:49:42

-- 2023-02-06T19:03:46

-- 2023-02-08T15:42:00

-- 2023-02-08T22:55:45

-- 2023-02-19T10:50:38

-- 2023-02-20T17:28:47

-- 2023-02-24T20:52:59

-- 2023-03-01T17:14:52

-- 2023-03-02T16:01:23

-- 2023-03-05T22:55:37

-- 2023-03-05T11:06:45

-- 2023-03-08T14:28:14

-- 2023-03-09T16:17:27

-- 2023-03-13T20:13:30

-- 2023-03-15T17:23:12

-- 2023-03-16T10:24:39

-- 2023-03-17T18:20:24

-- 2023-03-17T14:39:46

-- 2023-03-17T22:41:33

-- 2023-03-19T21:44:40

-- 2023-03-19T12:18:29

-- 2023-03-21T16:32:37

-- 2023-03-25T18:00:01

-- 2023-03-26T11:20:19

-- 2023-03-29T17:25:50

-- 2023-03-31T14:03:41

-- 2023-04-03T18:54:43

-- 2023-04-03T15:50:01

-- 2023-04-03T11:01:24

-- 2023-04-04T13:53:47

-- 2023-04-05T16:09:55

-- 2023-04-07T20:54:30

-- 2023-04-08T10:48:06

-- 2023-04-10T09:43:27

-- 2023-04-10T11:16:45

-- 2023-04-11T16:39:12

-- 2023-04-11T11:43:51

-- 2023-04-13T12:21:51

-- 2023-04-14T14:29:15

-- 2023-04-14T11:23:31

-- 2023-04-15T19:18:15

-- 2023-04-16T17:44:49

-- 2023-04-18T09:43:51

-- 2023-04-18T14:21:06

-- 2023-04-22T19:32:42

-- 2023-04-23T16:34:34

-- 2023-04-23T12:37:38

-- 2023-04-24T12:00:58

-- 2023-04-24T14:15:10

-- 2023-04-25T17:52:53

-- 2023-04-26T22:29:31

-- 2023-04-26T22:07:31

-- 2023-04-29T13:37:10

-- 2023-04-29T22:21:45

-- 2023-05-02T15:22:25

-- 2023-05-02T14:26:17

-- 2023-05-04T21:05:24

-- 2023-05-07T20:51:01

-- 2023-05-07T13:32:31

-- 2023-05-10T12:43:13

-- 2023-05-10T09:53:07

-- 2023-05-11T20:05:55

-- 2023-05-13T19:38:00

-- 2023-05-22T22:41:27

-- 2023-05-22T13:08:32

-- 2023-05-25T12:43:12

-- 2023-05-27T19:39:22

-- 2023-05-27T11:59:21

-- 2023-05-28T10:16:50

-- 2023-05-28T15:25:02

-- 2023-05-29T21:48:49

-- 2023-05-29T09:03:08

-- 2023-05-29T20:15:29

-- 2023-05-29T17:39:58

-- 2023-05-31T18:34:24

-- 2023-05-31T14:13:44

-- 2023-06-07T12:32:43

-- 2023-06-07T13:53:05

-- 2023-06-07T22:58:44

-- 2023-06-08T09:46:32

-- 2023-06-08T19:55:43

-- 2023-06-08T15:53:20

-- 2023-06-08T16:13:08

-- 2023-06-09T19:32:27

-- 2023-06-12T19:03:15

-- 2023-06-13T12:17:29

-- 2023-06-13T11:48:25

-- 2023-06-16T13:55:34

-- 2023-06-19T13:08:03

-- 2023-06-19T12:05:51

-- 2023-06-21T12:01:32

-- 2023-06-22T19:57:36

-- 2023-06-22T22:02:17

-- 2023-06-25T22:43:49

-- 2023-06-29T17:52:02

-- 2023-07-03T17:58:24

-- 2023-07-05T11:48:07

-- 2023-07-05T18:09:14

-- 2023-07-07T15:07:19

-- 2023-07-09T09:10:33

-- 2023-07-09T21:20:23

-- 2023-07-14T12:43:53

-- 2023-07-14T11:09:46

-- 2023-07-15T18:32:10

-- 2023-07-15T22:47:29

-- 2023-07-15T12:17:46

-- 2023-07-17T16:57:40

-- 2023-07-17T16:41:13

-- 2023-07-20T22:00:23

-- 2023-07-21T15:49:04

-- 2023-07-21T15:09:02

-- 2023-07-26T09:31:51

-- 2023-07-27T16:13:10

-- 2023-07-28T15:52:58

-- 2023-07-28T22:12:37

-- 2023-07-28T14:03:17

-- 2023-07-28T14:45:56

-- 2023-07-31T10:39:29

-- 2023-07-31T16:44:49

-- 2023-07-31T15:59:03

-- 2023-07-31T21:08:17

-- 2023-08-01T14:46:33

-- 2023-08-04T15:38:24

-- 2023-08-09T15:49:27

-- 2023-08-20T22:24:02

-- 2023-08-20T14:29:39

-- 2023-08-20T14:17:08

-- 2023-08-26T12:16:58

-- 2023-08-27T18:11:32

-- 2023-08-28T20:55:16

-- 2023-09-03T17:33:57

-- 2023-09-03T14:59:38

-- 2023-09-04T18:38:29

-- 2023-09-04T09:45:48

-- 2023-09-04T09:24:21

-- 2023-09-05T18:08:51

-- 2023-09-07T09:50:24

-- 2023-09-09T16:01:42

-- 2023-09-09T19:52:27

-- 2023-09-15T14:21:19

-- 2023-09-16T20:21:16

-- 2023-09-17T22:46:42

-- 2023-09-19T12:22:20

-- 2023-09-21T14:21:06

-- 2023-09-21T10:38:11

-- 2023-09-23T15:15:02

-- 2023-09-26T10:53:27

-- 2023-09-27T14:09:16

-- 2023-09-27T13:40:45

-- 2023-10-01T21:26:42

-- 2023-10-01T16:15:22

-- 2023-10-06T19:22:00

-- 2023-10-06T22:12:26

-- 2023-10-07T18:06:59

-- 2023-10-09T14:44:05

-- 2023-10-09T15:03:32

-- 2023-10-10T15:53:51

-- 2023-10-12T10:29:28

-- 2023-10-12T11:51:10

-- 2023-10-13T13:26:50

-- 2023-10-16T10:17:16

-- 2023-10-20T14:44:54

-- 2023-10-21T19:44:49

-- 2023-10-25T22:18:33

-- 2023-10-30T13:01:27

-- 2023-10-30T22:10:02

-- 2023-10-30T11:36:43

-- 2023-10-30T21:53:37

-- 2023-10-30T18:50:17

-- 2023-11-05T15:47:47

-- 2023-11-05T15:03:05

-- 2023-11-07T15:26:06

-- 2023-11-07T16:33:40

-- 2023-11-07T20:44:17

-- 2023-11-12T12:51:11

-- 2023-11-12T12:58:01

-- 2023-11-15T22:38:54

-- 2023-11-15T13:31:30

-- 2023-11-15T16:25:47

-- 2023-11-17T18:31:32

-- 2023-11-23T11:14:58

-- 2023-11-23T20:22:30

-- 2023-11-24T18:08:47
