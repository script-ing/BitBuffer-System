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
