-- It is very important to consider all cases for arguments, as the client can send anything for arguments via exploit.
-- Pretty much just return false for requests with invalid arguments.

-- search "OVH" for overhaul notes
-- search "PDL" and also look for other potential familiars data leaks
--   todo: search all instances of Familiars:new on server, ensure PlayerData is included in call
--         destroy Familiars objects where appropriate

-- OVH  remove rc4 as much as possible on server side
local _f = require(script.Parent)
local PlayerData, PC
local PlayerDataByPlayer = {}

local function onPlayerEnter(player)
	if not player or not player:IsA("Player") or PlayerDataByPlayer[player] then return end
	local pd = PlayerData:new(player)
	PlayerDataByPlayer[player] = pd
end

local DataStoreService = game:GetService("DataStoreService")
local RTObbyStore = DataStoreService:GetDataStore("RagingThunderObby_v1")

local function getRTKey(player)
	return "Player_" .. player.UserId
end

local network = _f.Network
local context = _f.Context

local publicFns = {
	getContinueScreenInfo = true,
	continueGame          = true,
	startNewGame          = true,
	saveGame              = true,
	completeEvent         = true,
	getShopCatalog = true,
	setTradeSignText = true,
	getTradeSignText = true,
	ensureTradeSign = true,
	removeTradeSign = true,
	getPublicServers = true,
	resetRedeemedCodesForMode = true,
	HasLicense = true,
	GetSocialCode         = true,
	hoverEffect           = true,
	needsRagingThunderObby = true,
	completeRagingThunderObby = true,
	giftSpecialMon = true,
	IsVerified            = true,
	getPlaytimeReward = true,
	claimPlaytimeReward = true,
	hasBL = true,
	CheckBattleModeCompat = true,  
	getRewardHistory       = true,
	checkTaoTrio          = true,
	getStarterData        = true,
	giftCurrency = true,
	getGiftablePlayers = true,
	getWorldEvent = true,
	buyStarter            = true,
	resetForTitleScreen = true,
	getObedienceCap = true,
	IsContentCreator   = true,
	GetGroup = true,
	getCodeList           = true,
	countSeenAndOwnedFamiliars = true,
	getLevelCaps = true,
	getLevelCap = true,
	announceHatch          = true,
	buySpecialMon         = true,
	GaK                   = true,
	canBattleForBP = true,
	getContinueScreenInfoAdvSlot = true,
	continueAdvSlot = true,
	saveGameAdvSlot = true,
	claimDailyBP = true,
	roStatus              = true,
	getParty              = true,
	setFamiliarsBall = true,
	incubateEgg           = true,
	setTrainerCardBg      = true,
	getTrainerCardBg      = true,
	giftGamepass = true,
	tryBreedNow           = true,
	getPartyPokeBalls     = true,
	HasDiscordRole        = true,
	getHealing            = true,
	getPreviewEggSummary  = true,
	getChunkData = true,
	getInfoOf = true,
	getAllRegions = true,
	getSummaryFromCard    = true,
	setTrainerCardBackgroundAsset = true, 
	getDevHealing         = true,
	buyBatteriesWithMoney = true,
	purchaseStampSpin     = true,
	getBatteryCount       = true,
	getFamiliarsSummary     = true,
	checkDeoxys           = true,
	getCutter             = true,
	exchangeShardsForBP   = true,
	changeDeoxysForm      = true,
	getDigger             = true,
	getHeadbutter         = true,
	getDailyReward        = true,
	claimDailyReward      = true,
	getSmasher            = true,
	getClimber            = true,
	getHappiness          = true,
	approveNickname       = true,
	has3beasts            = true,
	ApplyEVs              = true,
	ApplyIVs              = true,
	getDex                = true,
	getDexIcons			  = true,
	getCardInfo           = true,
	CheckBanlist          = true,
	setFormat             = true,
	getFormat             = true,
	getPlayerCardInfo     = true,
	getPlayerParty        = true,
	getBagPouch           = true,
	getTMs                = true,
	getBattleBag          = true,
	useItem               = true,
	giveItem              = true,
	takeItem              = true,
	tossItem              = true,
	teachTM               = true,
	obtainItem            = true,
	getObedience          = true,
	teamLog               = true,
	deleteMove            = true,
	remindMove            = true,
	moveTutor             = true,
	getShop               = true,
	maxBuy                = true,
	buyItem               = true,
	bMaxBuy               = true,
	RevealCatacombs       = true,
	buyWithBP             = true,
	sellItem              = true,
	roPauseText 		  = true,
	roPauseStatus 		  = true,
	pauseRoPower          = true,
	resumeRoPower         = true,
	makeDecision          = true,
	openPC                = true,
	cPC                   = true,
	closePC               = true,
	weatherUpdate 	      = true,
	getAdventuresList = true,
	collectMeteorFragment = true,
	getDCPhrase           = true,
	takeEgg               = true,
	getDCInfo             = true,
	leaveDCFamiliars        = true,
	takeDCFamiliars         = true,
	getFlame              = true,
	countBatteries        = true,
	hasFossil             = true,
	reviveFossil          = true,
	dive                  = true,
	nextDig               = true,
	finishDig             = true,

	nSpins                = true,
	spinForStamp          = true,
	stampInventory        = true,
	setStamps             = true,

	hasOKS                = true,
	hasSTP                = true,
	hasTT                 = true,
	hasFlute              = true,
	hasRTM                = true,
	hasJKey               = true,
	has3birds             = true,
	has3forces            = true,
	hasdss                = true,
	has3regis             = true,
	hasSwordsOJ           = true,
	hasvolitems           = true,
	getHoneyData          = true,
	getHoney              = true,
	isDinWM               = true,
	isTinD                = true,
	isLapD                = true,
	buySushi              = true,
	getGreenhouseState    = true,
	giveEkans             = true,
	birdsitem             = true,
	buybirdsitem          = true,
	motorize              = true,
	getBattery            = true,
	compatibleFossils     = true,
	hover                 = true,
	setHoverboard         = true,
	getAllHoverboardNames = true,
	ownsHoverboard        = true,
	purchaseHoverboard    = true,
	hasbottlecaps         = true,
	trainfamiliars          = true,
	pickberry             = true,
	checkFurfrou          = true,
	changeForme           = true,
	getMovesBag           = true,
	getivs                = true,
	gethptype           = true,
	getFroster            = true,
	getStrengthen         = true,
	surf                  = true,
	getSurfer             = true,
	getMant               = true,	
	getWtrOp              = true,
	getLottoPrizes        = true,
	drawLotto             = true,
	getLottoResults       = true,
	purchaseRoPower       = true,
	roPauseRemaining = true,
	getFilteredString     = true,
	reportSlopeTime       = true,
	pdc                   = true,
	HasZMoveOn            = true,
	buyWithTix            = true,
	tMaxBuy               = true,
	ArcadeReward          = true,
	spinRouletteForfamila   = true,
	checkCode             = true,
	Spawnfamila             = true,
	ownsGamepassOrGift    = true,
	SpawnItem             = true,
	SpawnCurrency         = true,
	ShutdownServers       = true,
	GetPerms              = true,
	ServerPortal          = true,
	getCSceptileStage     = true, --// 2022 Winter Event
	moneySafari		   	 = true,
	has3ghosts            = true, --// 2023 Halloween Event
	getMarshadowBattle    = true,
	getBMode 			 = true,
	unmountMant 		 = true,
	mountMant 			 = true,
	hasZAitems           = true,
	checkMon              = true,
	getMon                = true,
	LoadTextureMon        = true,
}
local publicEvents = {
	chooseName            = true,
	completedEggCycle     = true,
	rearrangeParty        = true,
	rearrangeMoves        = true,
	keepEgg               = true,
	resetFishStreak       = true,
	slatherHoney          = true,
	unhover               = true,
	hoverboardAction      = true,
	unsurf                = true,
	TixPurchase           = true,
	setBMode 		     = true, 
	setObedience          = true,
	setLevelCaps         = true,
	ROPowers_pause 		  = true,
	ROPowers_resume 	  = true,
}
network:bindFunction('PDS', function(player, fnName, ...)
	if not publicFns[fnName] then network.GenerateReport(player, 'attempted to call PDS function "'..tostring(fnName)..'"') return end
	local pd = PlayerDataByPlayer[player]
	if not pd then
		-- uh, we should have created PlayerData for this player... what happened?
		error(player.Name .. ' has no Player Data')
	end
	return pd[fnName](pd, ...)
end)
network:bindEvent('PDS', function(player, fnName, ...)
	if not publicEvents[fnName] then network.GenerateReport(player, 'attempted to call PDS event "'..tostring(fnName)..'"') return end
	local pd = PlayerDataByPlayer[player]
	if not pd then
		-- uh, we should have created PlayerData for this player... what happened?
		error(player.Name .. ' has no Player Data')
	end
	pd[fnName](pd, ...)
end)


local storage = game:GetService('ServerStorage')
local Functions = _f.Functions
local BitBuffer = _f.BitBuffer--require(storage.ClientModules.BitBuffer)
local Region = require(storage.ClientModules.Region)
local Assets = require(storage.src.Assets) -- for game passes
local UsableItemsClient = require(storage.src.UsableItemsClient)() -- note: nothing passed for _c
local RoamingFamiliars = require(storage.Registry.Encounters).roamingEncounter
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local MAX_MONEY = 9999999
local MAX_BP = 9999999
local MAX_TIX = 9999999
local RO_POWER_EFFECT_DURATION = 60 * 60


PlayerData = Functions.class({
	className = 'ServerPlayerData',
	gameBegan = false,
	trainerName = '',
	familiarium = '',
	money = 0,
	bp = 0,
	tix = 0,
	obtainedItems = '',
	tms = '',
	hms = '',
	defeatedTrainers = '',
	expShareOn = false,
	hasEVEditorPass = false,      
	checkedEVEditorPass = false,  
	lastDrifloonEncounterWeek = 0,
	lastTrubbishEncounterWeek = 0,
	lastLaprasEncounterWeek = 0,
	lastHoneyGivenDay = 0,
	lastBatteryGivenDay = 0,
	lastBPGivenDay = 0,
	trainerCardBgAsset = "", 
	loginStreak = 0,
	lastDailyRewardDay = 0,
	fishingStreak = 0,
	starterType = '',
	lottoTries = 0,
	lastLottoTryDay = 0,
	stampSpins = 0,
	currentHoverboard = '',
	battleMode = 1,
	obedience = false,
	lastClanDaily = 0,
	levelCaps = false,
	playtime = 0,
	lastPlaytimeClaim = 0,
	playtimeRewardIndex = 1,
	playtimeRewardSeed = 0,
	playtimeRewardReadyNotified = false,
	ragingThunderObbyComplete = false,
}, function(player)
	local self = {
		player = player,
		userId = player.UserId,
		trainerName = player.Name,
		pc = PC:new(),
		party = {},
		bag = {{},{},{},{},{},{}}, -- Items, Medicine, famila Balls, Berries, Key Items, Z-Moves
		badges = {},
		completedEvents = {},
		daycare = {
			depositedFamiliars = {},
			manHasEgg = false
		},
		ownedGamePassCache = {},
		_licenseCache = false,
		_licenseCacheTime = 0,
		rtick = tick()%1,
		roPowers = {
			powerLevel = {0, 0, 0, 0, 0, 0, 0},
			lastPurchasedAt = {0, 0, 0, 0, 0, 0, 0},
			paused = {false, false, false, false, false, false, false},
			pausedRemaining = {0, 0, 0, 0, 0, 0, 0}
		},
		flags = {},
		format = 'AG',
		lastCompletedEggCycle = tick(),
		decision_data = {},
		decision_count = 0,
		starterProductStack = {},
		ashGreninjaProductStack = {},
		lottoTicketProductStack = {},
		hoverboardProductStack = {},
		pbStamps = {},
		ownedHoverboards = {},
		dailyClaimHistory = {}, -- array of { day = os.date('%j'), reward = '₱10,000' }
		SurfEnabled = false,
		gamemode = 'adventure',
		ids = {}, 
		lastCapTick = 0,
		trainerCardBgAsset = "", 
		mountedM = false,
		playtimeRewardSeed = 0,
		playtimeRewardReadyNotified = false,
		ragingThunderObbyComplete = false,

	}
	setmetatable(self, PlayerData)

	local ok, value = pcall(function()
		return RTObbyStore:GetAsync(getRTKey(player))
	end)

	if ok then
		self.ragingThunderObbyComplete = (value == true)
		print("Loaded RT flag for", player.Name, "=", self.ragingThunderObbyComplete, "raw:", value)
	else
		self.ragingThunderObbyComplete = false
		warn("Failed to load RT flag for", player.Name, value)
	end
	-- cache player save data as soon as possible
	self._saveDataCache = {}
	self._saveDataLoading = {}
	self.DataCache = {}

	Functions.fastSpawn(function()
		self:getSaveData("adventure")
	end)

	Functions.fastSpawn(function()
		self:getSaveData("randomizer")
	end)

	Functions.fastSpawn(function()
		self:getSaveData("spawner")
	end)

	Functions.fastSpawn(function()
		self:getSaveDataAdvSlot(1)
	end)

	Functions.fastSpawn(function()
		self:getSaveDataAdvSlot(2)
	end)

	-- cache owned game passes for quicker lookup
	if self.userId > 0 then
		Functions.fastSpawn(function()
			for _, passId in pairs(Assets.passId) do
				self:ownsGamePass(passId)
			end
		end)
	end
	return self
end)

function PlayerData:getSafePlaytime()
	local p = tonumber(self.playtime) or 0
	p = math.floor(p)
	if p < 0 then
		p = 0
	end
	if p > 4294967295 then
		p = 4294967295
	end
	self.playtime = p
	return p
end
-- ⏱️ PLAYTIME TRACKER
task.spawn(function()
	while true do
		task.wait(1)
		for player, pd in pairs(PlayerDataByPlayer) do
			if pd and player and player.Parent and pd.gameBegan then
				pd.playtime = pd:getSafePlaytime() + 1

				local ok, canClaim, data = pcall(function()
					return pd:getPlaytimeReward()
				end)

				if ok and canClaim and not pd.playtimeRewardReadyNotified then
					pd.playtimeRewardReadyNotified = true
					local rewardText = data and data.nextReward or "your reward"
					network:post("SystemChat", player, "[Playtime Rewards] Your reward is ready to claim: " .. tostring(rewardText) .. "!")
				end
			end
		end
	end
end)


local RARITY_ORDER = {
	{name = "Common", chance = 50, color = Color3.fromRGB(180, 180, 180)},
	{name = "Uncommon", chance = 25, color = Color3.fromRGB(120, 255, 120)},
	{name = "Rare", chance = 15, color = Color3.fromRGB(80, 180, 255)},
	{name = "Epic", chance = 7, color = Color3.fromRGB(200, 120, 255)},
	{name = "Legendary", chance = 2.5, color = Color3.fromRGB(255, 200, 80)},
	{name = "Mythic", chance = 0.5, color = Color3.fromRGB(255, 80, 80)},
}

local RARITY_MULTI = {
	Common = 1,
	Uncommon = 1.5,
	Rare = 2,
	Epic = 3,
	Legendary = 5,
	Mythic = 8
}

local ITEM_POOL = {
	"ultraball",
	"rarecandy",
	"maxrevive",
	"fullrestore",
	"bottlecap",
	"abilitypatch",
	"abilitycapsule",
	"goldbottlecap",
	"masterball"

}

local function makeRng(seed)
	seed = tonumber(seed) or 1
	seed = math.floor(seed) % 2147483647
	if seed <= 0 then
		seed = 1
	end

	return function(min, max)
		seed = (seed * 48271) % 2147483647
		local n = seed / 2147483647

		if min and max then
			return math.floor(min + n * (max - min + 1))
		elseif min then
			return math.floor(n * min) + 1
		else
			return n
		end
	end
end

local function rollRarityWithRng(rand)
	local roll = rand() * 100
	local total = 0

	for _, rarity in ipairs(RARITY_ORDER) do
		total += rarity.chance
		if roll <= total then
			return rarity.name, rarity
		end
	end

	return "Common", RARITY_ORDER[1]
end

local function getRandomItemWithRng(rand)
	if #ITEM_POOL == 0 then
		return "rarecandy"
	end
	return ITEM_POOL[rand(1, #ITEM_POOL)] or "rarecandy"
end

local BLOCKED_REWARD_FAMILIARS = {
	[132] = true,
	[144] = true, [145] = true, [146] = true, [150] = true, [151] = true,
	[243] = true, [244] = true, [245] = true, [249] = true, [250] = true, [251] = true,
	[377] = true, [378] = true, [379] = true, [380] = true, [381] = true, [382] = true, [383] = true, [384] = true, [385] = true, [386] = true,
	[480] = true, [481] = true, [482] = true, [483] = true, [484] = true, [485] = true, [486] = true, [487] = true, [488] = true, [489] = true, [490] = true, [491] = true, [492] = true, [493] = true, [494] = true,
	[640] = true, [641] = true, [642] = true, [643] = true, [644] = true, [645] = true, [646] = true, [647] = true, [648] = true, [649] = true,
	[716] = true, [717] = true, [718] = true, [719] = true, [720] = true, [721] = true,
	[772] = true, [773] = true,
	[785] = true, [786] = true, [787] = true, [788] = true, [789] = true, [790] = true, [791] = true, [792] = true,
	[800] = true, [801] = true, [807] = true, [808] = true, [809] = true,
	[888] = true, [889] = true, [890] = true, [891] = true, [892] = true, [893] = true, [894] = true, [895] = true, [896] = true, [897] = true, [898] = true,
}
local VALID_REWARD_FAMILIARS = nil

local function buildValidRewardFamiliars()
	if VALID_REWARD_FAMILIARS and #VALID_REWARD_FAMILIARS > 0 then
		return VALID_REWARD_FAMILIARS
	end

	local pool = {}

	local db = _f and _f.Database and _f.Database.FamiliarsByNumber
	if typeof(db) ~= "table" then
		return pool
	end

	for num = 1, 898 do
		if not BLOCKED_REWARD_FAMILIARS[num] then
			local data = db[num] or db[tostring(num)]
			local species = data and (data.species or data.name)

			if type(species) == "string" and species ~= "" then
				table.insert(pool, species)
			end
		end
	end

	VALID_REWARD_FAMILIARS = pool
	return pool
end

local function getRandomFamiliarsWithRng(rand)
	local pool = buildValidRewardFamiliars()
	if #pool == 0 then
		warn("Reward Familiars pool empty, defaulting to Magikarp")
		return "Magikarp"
	end
	return pool[rand(1, #pool)]
end

local function scaleAmount(base, loop)
	base = tonumber(base) or 0
	loop = tonumber(loop) or 0
	return math.max(0, math.floor(base * (1 + (loop * 0.25))))
end

local function sanitizeRewardEntry(i, entry)
	local fallbackColor = Color3.fromRGB(180, 180, 180)
	local fallbackRarity = "Common"

	if typeof(entry) ~= "table" then
		entry = {}
	end

	entry.time = tonumber(entry.time) or (i * 300)
	entry.time = math.max(1, math.floor(entry.time))

	entry.reward = typeof(entry.reward) == "table" and entry.reward or {}
	local reward = entry.reward

	reward.type = type(reward.type) == "string" and reward.type or "money"
	reward.rarity = type(reward.rarity) == "string" and reward.rarity or fallbackRarity
	reward.color = typeof(reward.color) == "Color3" and reward.color or fallbackColor

	if reward.type == "money" then
		reward.amount = math.max(1, math.floor(tonumber(reward.amount) or 5000))
		reward.display = type(reward.display) == "string" and reward.display ~= "" and reward.display or ("₱" .. reward.amount)

	elseif reward.type == "bp" then
		reward.amount = math.max(1, math.floor(tonumber(reward.amount) or 25))
		reward.display = type(reward.display) == "string" and reward.display ~= "" and reward.display or (reward.amount .. " BP")

	elseif reward.type == "tix" then
		reward.amount = math.max(1, math.floor(tonumber(reward.amount) or 5000))
		reward.display = type(reward.display) == "string" and reward.display ~= "" and reward.display or (reward.amount .. " Tix")

	elseif reward.type == "item" then
		reward.id = type(reward.id) == "string" and reward.id ~= "" and reward.id or "rarecandy"
		reward.quantity = math.max(1, math.floor(tonumber(reward.quantity) or 1))
		reward.display = type(reward.display) == "string" and reward.display ~= "" and reward.display or (reward.quantity .. " " .. reward.id)

	elseif reward.type == "familiars" then
		reward.species = type(reward.species) == "string" and reward.species ~= "" and reward.species or "Magikarp"
		reward.level = math.max(1, math.floor(tonumber(reward.level) or 5))
		reward.shiny = reward.shiny == true
		reward.hiddenAbility = reward.hiddenAbility == true

		if type(reward.display) ~= "string" or reward.display == "" then
			if reward.shiny and reward.hiddenAbility then
				reward.display = "✨ HA " .. reward.species
			elseif reward.shiny then
				reward.display = "✨ " .. reward.species
			elseif reward.hiddenAbility then
				reward.display = "HA " .. reward.species
			else
				reward.display = reward.species
			end
		end
	else
		reward.type = "money"
		reward.amount = 5000
		reward.display = "₱5000"
	end

	return entry
end

local function makeRewardForPlayer(seed, i)
	local time = i * 300
	local rand = makeRng((seed * 9973) + (i * 7919))

	local rarityName, rarityData = rollRarityWithRng(rand)
	local multi = RARITY_MULTI[rarityName] or 1
	local roll = rand(1, 100)

	local entry

	if roll <= 40 then
		local amount = math.floor((5000 + i * 500) * multi)
		entry = {
			time = time,
			reward = {
				type = "money",
				amount = amount,
				display = "₱" .. amount,
				rarity = rarityName,
				color = rarityData.color
			}
		}

	elseif roll <= 60 then
		local amount = math.floor((25 + i * 2) * multi)
		entry = {
			time = time,
			reward = {
				type = "bp",
				amount = amount,
				display = amount .. " BP",
				rarity = rarityName,
				color = rarityData.color
			}
		}

	elseif roll <= 80 then
		local amount = math.floor((5000 + i * 1000) * multi)
		entry = {
			time = time,
			reward = {
				type = "tix",
				amount = amount,
				display = amount .. " Tix",
				rarity = rarityName,
				color = rarityData.color
			}
		}

	elseif roll <= 95 then
		local item = getRandomItemWithRng(rand)
		local qty = math.max(1, math.floor(multi))
		entry = {
			time = time,
			reward = {
				type = "item",
				id = item,
				quantity = qty,
				display = qty .. " " .. item,
				rarity = rarityName,
				color = rarityData.color
			}
		}

	else
		local species = getRandomFamiliarsWithRng(rand)

		local shinyChance = 0
		local hiddenAbilityChance = 0

		if rarityName == "Epic" then
			shinyChance = 1
			hiddenAbilityChance = 6
		elseif rarityName == "Legendary" then
			shinyChance = 3
			hiddenAbilityChance = 12
		elseif rarityName == "Mythic" then
			shinyChance = 8
			hiddenAbilityChance = 20
		end

		local isShiny = rand(1, 100) <= shinyChance
		local hasHA = rand(1, 100) <= hiddenAbilityChance

		local display = species
		if isShiny and hasHA then
			display = "✨ HA " .. species
		elseif isShiny then
			display = "✨ " .. species
		elseif hasHA then
			display = "HA " .. species
		end

		entry = {
			time = time,
			reward = {
				type = "familiars",
				species = species,
				level = math.max(1, math.floor((10 + i) * multi)),
				shiny = isShiny,
				hiddenAbility = hasHA,
				display = display,
				rarity = rarityName,
				color = rarityData.color
			}
		}
	end

	return sanitizeRewardEntry(i, entry)
end

function PlayerData:getPlaytimeReward()
	self.playtimeRewardIndex = self.playtimeRewardIndex or 1
	self.playtimeRewardSeed = self.playtimeRewardSeed or 0

	if self.playtimeRewardSeed == 0 then
		self.playtimeRewardSeed = math.random(1, 2147483647)
	end

	local current = self:getSafePlaytime()
	local last = self.lastPlaytimeClaim or 0
	local elapsed = current - last

	local entry = makeRewardForPlayer(self.playtimeRewardSeed, self.playtimeRewardIndex)
	if not entry then
		return false, {
			remaining = 0,
			nextReward = "No Reward",
			progress = 1,
			color = Color3.fromRGB(67, 190, 116)
		}
	end

	if elapsed >= entry.time then
		return true, {
			rewardsReady = true,
			nextReward = entry.reward.display or ("Reward #" .. tostring(self.playtimeRewardIndex)),
			rarity = entry.reward.rarity,
			color = entry.reward.color,
			progress = 1
		}
	end

	return false, {
		remaining = entry.time - elapsed,
		nextReward = entry.reward.display or ("Reward #" .. tostring(self.playtimeRewardIndex)),
		progress = math.clamp(elapsed / entry.time, 0, 1),
		rarity = entry.reward.rarity,
		color = entry.reward.color
	}
end

function PlayerData:claimPlaytimeReward()
	self.playtimeRewardIndex = self.playtimeRewardIndex or 1
	self.playtimeRewardSeed = self.playtimeRewardSeed or 0

	if self.playtimeRewardSeed == 0 then
		self.playtimeRewardSeed = math.random(1, 2147483647)
	end

	local current = self:getSafePlaytime()
	local last = self.lastPlaytimeClaim or 0
	local elapsed = current - last

	local entry = makeRewardForPlayer(self.playtimeRewardSeed, self.playtimeRewardIndex)
	if not entry then
		return false
	end

	if elapsed < entry.time then
		return false
	end

	local reward = entry.reward
	local cycleLength = 100 * 300
	local loop = math.floor(current / cycleLength)
	local amount = reward.amount and scaleAmount(reward.amount, loop)

	if reward.type == "money" then
		self:addMoney(amount, true)

	elseif reward.type == "bp" then
		self:addBP(amount, true, true)

	elseif reward.type == "tix" then
		self:addTix(amount)

	elseif reward.type == "item" then
		self:addBagItems({
			id = reward.id,
			quantity = reward.quantity
		})

	elseif reward.type == "familiars" then
		local mon = self:newFamiliars({
			name = reward.species,
			level = reward.level + loop * 2,
			shiny = reward.shiny == true,
			hiddenAbility = reward.hiddenAbility == true,
			untradable = true
		})
		self:PC_sendToStore(mon)
	end
	self.lastPlaytimeClaim = current
	self.playtimeRewardIndex += 1
	self.playtimeRewardReadyNotified = false

	return {{
		display = reward.display,
		rarity = reward.rarity,
		color = reward.color
	}}
end
function PlayerData:getDexIcons(low, up)
	local icons = {}
	for i=low, up do
		if _f.Database.FamiliarsByNumber[i] and BitBuffer.GetBit(self.familiarium, i*2-1) then
			icons[#icons+1] = _f.Database.FamiliarsByNumber[i].icon
		else
			icons[#icons+1] = 8815447761
		end
	end
	return icons
end


function PlayerData:getBMode()
	return self.battleMode
end

function PlayerData:setBMode(i)
	if not table.find({1, 2}, i) or self:isInBattle() then return end
	self.battleMode = i
end

function PlayerData:random(x, y)
	local r = (math.random()+self.rtick)%1
	if x and y then
		return math.floor(x + (y+1-x)*r)
	elseif x then
		return math.floor(1 + x*r)
	end
	return r
end
function PlayerData:random2(x, y)
	local r = (math.random()-self.rtick+1)%1
	if x and y then
		return math.floor(x + (y+1-x)*r)
	elseif x then
		return math.floor(1 + x*r)
	end
	return r
end


function PlayerData:check() end -- OVH  todo


function PlayerData:isInBattle() 
	return _f.CombatEngine:getBattleSideForPlayer(self.player) ~= nil
end

function PlayerData:isInTrade()
	return _f.TradeManager:playerIsInTrade(self.player)

end
function PlayerData:GetSocialCode()
	local data = _f.MySqlService:GetDatabase("SocialLinks") 
	local userId = tostring(self.userId)
	local HttpService = game:GetService("HttpService") 

	-- ✅ Fetch existing entry (Keep Verification Data)
	local existingEntry = data:GetAsync(userId)
	local isVerified = false
	local discordId = nil

	if existingEntry then
		local success, parsedData = pcall(function()
			return HttpService:JSONDecode(existingEntry) 
		end)

		if success and parsedData then
			isVerified = parsedData.is_verified or false 
			discordId = parsedData.discord_id or nil 

			if isVerified then
				return parsedData.verification_code
			end
		end
	end

	local function generateCode()
		local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		local newCode = ""
		for i = 1, 6 do
			local randIndex = math.random(1, #chars)
			newCode = newCode .. chars:sub(randIndex, randIndex)
		end
		return newCode
	end

	local newCode
	local isUnique = false
	while not isUnique do
		newCode = generateCode()
		local codeCheck = data:GetAsync(newCode) 
		if not codeCheck then
			isUnique = true 
		end
	end

	local newEntry = {
		verification_code = newCode,
		is_verified = isVerified, 
		discord_id = discordId, 
		created_at = os.time()
	}

	data:SetAsync(userId, HttpService:JSONEncode(newEntry))

	data:SetAsync("code_" .. newCode, userId) 

	return newCode
end


function PlayerData:IsVerified()
	local data = _f.MySqlService:GetDatabase("SocialLinks") 
	local userId = tostring(self.userId)
	local HttpService = game:GetService("HttpService")

	local existingEntry = data:GetAsync(userId)
	if existingEntry then
		local success, parsedData = pcall(function()
			return HttpService:JSONDecode(existingEntry) 
		end)

		if success and parsedData then
			return parsedData.is_verified or false 
		end
	end

	return false 
end

function PlayerData:HasLicense()
	if self._licenseCache and os.time() - self._licenseCacheTime < 60 then
		return self._licenseCache
	end

	local HttpService = game:GetService("HttpService")
	local apiKey = "sdkjnbfllsikgnsdljkfndlkhjgbhdsjfbndjklfnisdkngsdhfjkllnbgdsljkbnflisdkn"

	local success, response = pcall(function()
		return HttpService:RequestAsync({
			Url = "http://145.223.74.141:3015/licenses/by-roblox/" .. tostring(self.userId),
			Method = "GET",
			Headers = {
				["x-api-key"] = apiKey,
				["Content-Type"] = "application/json"
			}
		})
	end)

	if not success or not response.Success then
		warn("❌ License check failed:", response and response.StatusCode)
		self._licenseCache = false
		self._licenseCacheTime = os.time()
		return false
	end

	local parsed = HttpService:JSONDecode(response.Body)
	local active = parsed.active == true

	self._licenseCache = active
	self._licenseCacheTime = os.time()

	return active
end



function PlayerData:HasDiscordRole(roleId)
	local http = game:GetService("HttpService")
	local url = "http://145.223.74.141:3015/hasRole/" .. self.userId .. "/" .. roleId
	local success, result = pcall(function()
		return http:GetAsync(url)
	end)

	if success then
		local parsed = http:JSONDecode(result)
		return parsed.hasRole == true
	else
		warn("❌ Failed to check Discord role:", result)
		return false
	end
end

function PlayerData:weatherUpdate()
	local weather = _f.Date:getDate().predictedWeather
	weather[1] = {'Forced!', weather[1][2], _f.currentWeather}
	return weather
end
function PlayerData:collectMeteorFragment(Type, nothing)
	if self.currentChunk ~= 'chunk54' then return end 
	if _f.currentWeather ~= 'meteor' then return end
	if not nothing then return end
	local items = {
		{
			'Moon Stone',
			{'Mewnium-Z', 6},
			'Iron Ball',
			'Steelixite',
			'Diancite',
			'Latiasite',
		},--White
		{
			'UMV Battery',
			'Moon Stone',
			'Heat Rock',
			'Latiosite',        
		}, --Black
		{
			'Armorite Ore',
			'Stardust',
			'Marble',
			'Big Nugget',
			'Comet Shard',
			'Hard Stone',
			'Dynite Ore',
			'Fighting Gem',
			'Fire Gem',
			'Water Gem',
			'Electric Gem',
			'Grass Gem',
			'Ice Gem',
			'Poison Gem',
			'Ground Gem',
			'Flying Gem',
			'Psychic Gem',
			'Bug Gem',
			'Rock Gem',
			'Ghost Gem',
			'Dragon Gem',
			'Dark Gem',
			'Steel Gem',
			'Normal Gem',
			'Fairy Gem',
		} --Others
	}
	local itemTable = items[Type]
	local randomItem = itemTable[math.random(1, #itemTable)]
	while true do
		if type(randomItem) == 'table' and self:getBagDataById(Functions.toId(randomItem[1]), randomItem[2]) and Type <= 2 then
			randomItem = itemTable[math.random(1, #itemTable)]
		else
			break --Breaks the loop Maybe?
		end
	end
	if math.random(1, 100) <= 75 and Type >= 3 then randomItem = 'Hard Stone' end
	if math.random(1, 500) == 2 and Type <= 3 and not self:getBagDataById(Functions.toId('Rockium-Z'), 6) then randomItem = 'Rockium-Z' end

	print(type(randomItem))
	if typeof(randomItem) == 'table' then
		randomItem = randomItem[1]
	end
	self:addBagItems({id = Functions.toId(randomItem), quantity = 1})
	return randomItem
end
function PlayerData:getParty(context)

	-- check for open battles involving this player 
	--  party order may change, hp, etc.
	local battleSide = _f.CombatEngine:getBattleSideForPlayer(self.player)
	local battleParty
	if battleSide then
		battleParty = battleSide.familiars
		-- 2v2
		if battleSide.isTwoPlayerSide and battleSide.battle.is2v2 then
			local lp = battleSide.battle.listeningPlayers
			local teamn = (lp[battleSide.id]==self.player) and 1 or 2
			--			local indexOffset = (teamn==2) and battleSide.nFamiliarsFromTeam1 or 0
			local party = {}
			for _, battleFamiliars in pairs(battleSide.familiars) do
				if battleFamiliars.teamn == teamn then
					table.insert(party, self.party[battleFamiliars.originalPartyIndex]:getPartyData(battleFamiliars, context))
				end
			end
			return party
		end
		--
	end

	local party = {0, 0, 0, 0, 0, 0} -- placeholders
	for i, familiars in ipairs(self.party) do
		if battleParty then
			local battleFamiliars
			for _, p in pairs(battleParty) do
				if p.index == i then
					battleFamiliars = p
					break
				end
			end
			if battleFamiliars then
				party[battleFamiliars.position] = familiars:getPartyData(battleFamiliars, context)
			end
		else
			party[i] = familiars:getPartyData({}, context)
		end
	end
	for i = 6, 1, -1 do
		if party[i] == 0 then
			table.remove(party, i)
		end
	end
	return party
end

local LEVEL_CAPS = {
	[0] = 15,
	[1] = 25,
	[2] = 35,
	[3] = 55,
	[4] = 65,
	[5] = 75,
	[6] = 85,
	[7] = 95,
	[8] = 100,
}

function PlayerData:getLevelCaps()
	return self.levelCaps
end

function PlayerData:setLevelCaps(enabled)
	self.levelCaps = enabled 
end

function PlayerData:getLevelCap()

	if not self.levelCaps then
		return 100
	end

	if self.gamemode == "randomizer" or self.gamemode == "spawner" then
		return 100
	end

	local badgeCount = 0

	for i = 1, 8 do
		if self.badges[i] then
			badgeCount += 1
		end
	end

	badgeCount = math.clamp(badgeCount, 0, 8)

	return LEVEL_CAPS[badgeCount] or 15
end
--// Furfrou Grooming
function PlayerData:checkFurfrou(slot)
	local familiars = self.party[slot]	
	if familiars.num ~= 676 then 
		return	{f = 1}		
	else 	
		return	{f = 2}				
	end	
end


function PlayerData:changeForme(slot, style)
	local isbeable = {
		['Dandy'] = true,
		['Debutante'] = true,
		['Diamond'] = true,
		['Kabuki'] = true,
		['Heart'] = true,
		['Star'] = true,
		['Matron'] = true,
		['Pharoah'] = true,
		['Lareine'] = true
	}
	if not isbeable[tostring(style)] then return end

	if self.party[slot] and self.party[slot].num == 676 then
		self.party[slot].forme = tostring(style)
	end
end

function PlayerData:getHealing()
	local chunkId = self.currentChunk
	local chunkData = _f.Database.ChunkData[chunkId]
	local buildings  = chunkData.buildings

	local whitelisted = {
		"chunk1",
		"chunk10",
		"chunk23",
		"Route23",
	}

	if not buildings then
		buildings = {}
	end

	if table.find(whitelisted, chunkId) or buildings["PokeCenter"] or table.find(buildings, "PokeCenter") then
		self:heal()
	else
		spawn(function()
			pcall(function()
				_f.Logs:logExploit(self.player,{
					exploit = "PokeCenter Healing",
					extra = "Tried to abuse healing anywhere without a valid whitelist."
				})
			end)
		end)
		self.player:Kick("Please avoid exploiting. Further exploitation can and will result in a permanent ban.")
	end
end


function PlayerData:getDevHealing()
	local perms = self:GetPerms()
	if perms then
		self:heal()
	else
		pcall(function()
			_f.Logs:logExploit(self.player,{
				exploit = "FN Abuse",
				extra = "Tried to abuse healing through a restricted FN without a valid whitelist."
			})
		end)
		self.player:Kick('Please avoid exploiting. Further exploitation can and will result in a permanent ban.')
	end
end

function PlayerData:GiveZekrom(slot)
	local Reshiram = self:newFamiliars {
		name = 'Zekrom',
		level = 70,
		shinyChance = 1024,
		moves = {{id = 'dragonclaw'},{id = 'roost'},{id = 'boltstrike'},{id = 'dracometeor'}}
	}
	local box, position
	if slot then
		box, position = self:PC_sendToStore(table.remove(self.party, slot), true)
	end
	table.insert(self.party, 1, Reshiram)
	self:onOwnFamiliars(643)
	self.absolMeta = {
		slot = slot, box = box, position = position,
		seen = false,
		owned = false
	}
end


function PlayerData:giveReshiram(slot)
	local Reshiram = self:newFamiliars {
		name = 'Reshiram',
		level = 70,
		shinyChance = 1024,
		moves = {{id = 'dragonpulse'},{id = 'blueflare'},{id = 'dracometeor'},{id = 'firespin'}}
	}
	local box, position
	if slot then
		box, position = self:PC_sendToStore(table.remove(self.party, slot), true)
	end
	table.insert(self.party, 1, Reshiram)
	self:onOwnFamiliars(643)
	self.absolMeta = {
		slot = slot, box = box, position = position,
		seen = false,
		owned = false
	}
end

function PlayerData:getPartyPokeBalls(noHeal)
	if not noHeal then
		local chunkId = self.currentChunk
		local chunkData = _f.Database.ChunkData[chunkId]
		local buildings = chunkData and chunkData.buildings or {}

		local whitelisted = {
			"chunk1",
		}

		local canHeal = table.find(whitelisted, chunkId)
			or buildings["PokeCenter"]
			or table.find(buildings, "PokeCenter")
			or self:GetPerms()
			or self.gamemode == 'spawner'

		if canHeal then
			local success, err = pcall(function()
				self:heal()
			end)
			if not success then
				spawn(function()
					pcall(function()
						_f.Logs:error("Error in getPartyPokeBalls: " .. tostring(err))
					end)
				end)
			end
		else
			spawn(function()
				pcall(function()
					_f.Logs:logExploit(self.player, {
						exploit = "getPartyPokeBalls",
						extra = "Tried to abuse healing anywhere without a valid whitelist."
					})
				end)
			end)
			self.player:Kick("Please avoid exploiting. Further exploitation will result in a ban.")
			return {}
		end
	end

	local balls = {}
	for _, p in pairs(self.party) do
		if not p.egg then
			table.insert(balls, p.pokeball or 1)
		end
	end

	return balls
end

function PlayerData:checkTaoTrio()
	local TaoTrio = {}
	for _, p in pairs(self.party) do
		if p.num == 643 then
			TaoTrio.r = true
		end
		if p.num == 644 then
			TaoTrio.z = true
		end
	end
	local has = TaoTrio.r and TaoTrio.z
	self.flags.checkTaoTrio = has
	return has
end

function PlayerData:getFamiliarsSummary(index)
	local battleSide = _f.CombatEngine:getBattleSideForPlayer(self.player)
	local familiars, battleFamiliars
	if battleSide then
		-- 2v2
		if battleSide.isTwoPlayerSide and battleSide.battle.is2v2 then
			local lp = battleSide.battle.listeningPlayers
			local teamn = (lp[battleSide.id]==self.player) and 1 or 2
			--			local indexOffset = (teamn==2) and battleSide.nFamiliarsFromTeam1 or 0
			for _, battleFamiliars in pairs(battleSide.familiars) do
				if battleFamiliars.teamn == teamn then
					index = index - 1
					if index == 0 then
						--					if battleFamiliars.index == index then
						return self.party[battleFamiliars.originalPartyIndex]:getSummary(battleFamiliars)
					end
				end
			end
			return nil
		end

		if battleSide.isTwoPlayerSide then
			familiars = self.party[index]
			battleFamiliars = self.party[index]
		else
			battleFamiliars = battleSide.familiars[index]
			familiars = self.party[battleFamiliars.index]
		end
	else
		familiars = self.party[index]
	end
	if not familiars then return end
	return familiars:getSummary(battleFamiliars or {})
end

function PlayerData:getMoveUser(moveId)
	for _, p in pairs(self.party) do
		if not p.egg then
			for _, m in pairs(p.moves) do
				if m.id == moveId then
					return p:getName()
				end
			end
		end
	end
end

function PlayerData:getCutter()
	if not self.badges[1] then return end
	return  self.badges[1]
end

function PlayerData:getDigger()
	return self:getMoveUser('dig')
end
function PlayerData:getFlame()
	return self:getMoveUser('flamethrower')
end
function PlayerData:getHeadbutter()
	return self:getMoveUser('headbutt')
end

local rockSmashEncounter
function PlayerData:getSmasher()
	if not self.badges[5] then return end
	local pName = self.badges[5]
	if pName then
		local model = storage.Models.BrokenRock:Clone()
		model.Parent = self.player:WaitForChild('PlayerGui')
		local enc
		if self:random2(3) == 2 then
			if not rockSmashEncounter then
				rockSmashEncounter = require(storage.Registry.Encounters).rockSmashEncounter
			end
			enc = rockSmashEncounter
		end
		return pName, model, enc
	end
end

function PlayerData:getClimber()
	if not self.badges[6] then return end
	return self:getMoveUser('rockclimb')
end

function PlayerData:getHappiness(boost)
	local p = self:getFirstNonEgg()
	if not p then return end

	if boost then
		if p.happiness >= 255 then
			return nil, 'max_happiness'
		end
		if self.money < 100000 then
			return nil, 'nm'
		end
		self.money = self.money - 100000
		p.happiness = 255
	end

	local h = p.happiness
	local n = 'Your ' .. p.name .. '...'
	if h >= 255 then
		return {n, 'It\'s extremely friendly toward you.', 'It couldn\'t possibly love you more.', 'It\'s a pleasure to see!'}
	elseif h >= 200 then
		return {n, 'It seems to be very happy.', 'It\'s obviously friendly toward you.'}
	elseif h >= 150 then
		return {n, 'It\'s quite friendly toward you.', 'It seems to want to be babied a little.'}
	elseif h >= 100 then
		return {n, 'It\'s getting used to you.', 'It seems to believe in you.'}
	elseif h >= 50 then
		return {n, 'It\'s not very used to you yet.', 'It neither loves nor hates you.'}
	elseif h > 0 then
		return {n, 'It\'s very wary.', 'It has a scary look in its eyes.', 'It doesn\'t like you much at all.'}
	end
	return {n, 'This is a little hard for me to say...', 'Your Familiars simply detests you.', 'Doesn\'t that make you uncomfortable?'}
end


function PlayerData:getDex()
	return self.familiarium
end

function PlayerData:GaK()
	local gen3 = {}
	for _, p in pairs(self.party) do
		if p.num == 382 then
			gen3.k = true
		end
		if p.num == 383 then
			gen3.g = true
		end
	end
	local has = gen3.k and gen3.g
	self.flags.has3GaK = has
	return has
end

function PlayerData:getCardInfo()
	return {
		name = self.trainerName,
		userId = self.player.UserId, 
		dex = select(2, self:countSeenAndOwnedFamiliars()),
		badges = Functions.map({1,2,3,4,5,6,7,8}, function(i) return self.badges[i] and 1 or 0 end),
		money = self.money,
		bp = self.bp,
		tix = self.tix,
		trainerCardBgAsset = self.trainerCardBgAsset or "",
		playtime = self:getSafePlaytime(),
	}
end

function PlayerData:setTradeSignText(text, context)
	if typeof(text) ~= "string" then
		return nil
	end

	context = tostring(context or "adventure")
	if context ~= "trade" then
		return nil
	end

	text = text:gsub("[%c\r\n\t]", " ")
	text = text:sub(1, 80)
	text = text:match("^%s*(.-)%s*$") or ""

	if text == "" then
		text = "Trading!"
	end

	local filtered = self:getFilteredString(text)
	if not filtered or filtered == "" then
		filtered = "Trading!"
	end

	self.tradeSignText = filtered

	local function apply(container)
		if not container then return end
		local tool = container:FindFirstChild("TradeSign")
		if not tool then return end
		local board = tool:FindFirstChild("Board")
		if not board then return end

		for _, gui in ipairs(board:GetChildren()) do
			if gui:IsA("SurfaceGui") then
				local label = gui:FindFirstChildWhichIsA("TextLabel")
				if label then
					label.Text = filtered
				end
			end
		end
	end

	apply(self.player.Character)
	apply(self.player:FindFirstChild("Backpack"))

	return filtered
end

function PlayerData:getTradeSignText()
	return self.tradeSignText or "Trading!"
end

function PlayerData:getPlayerCardInfo(otherplayer)

	if otherplayer and otherplayer ~= "" then
		otherplayer = game:GetService("Players"):FindFirstChild(otherplayer)
		if not otherplayer then
			return nil
		end
	else
		otherplayer = self.player
	end

	local targetPlayerData = PlayerDataByPlayer[otherplayer]
	if not targetPlayerData then
		return nil
	end

	return {
		name = targetPlayerData.trainerName,
		userId = otherplayer.UserId,
		dex = select(2, targetPlayerData:countSeenAndOwnedFamiliars()),
		badges = Functions.map({1,2,3,4,5,6,7,8}, function(i)
			return targetPlayerData.badges[i] and 1 or 0
		end),
		money = targetPlayerData.money,
		bp = targetPlayerData.bp,
		tix = targetPlayerData.tix,
		trainerCardBgAsset = targetPlayerData.trainerCardBgAsset or ""
	}

end

function PlayerData:getPlayerParty(userId)
	local Players = game:GetService("Players")
	local targetPlayer = Players:GetPlayerByUserId(userId)
	if not targetPlayer then return nil end

	local targetData = PlayerDataByPlayer[targetPlayer]
	if not targetData then return nil end

	return targetData:getParty()
end

function PlayerData:getSummaryFromCard(index, targetUserId)
	local Players = game:GetService("Players")

	if targetUserId and targetUserId ~= self.player.UserId then
		local targetPlayer = Players:GetPlayerByUserId(targetUserId)
		if not targetPlayer then return nil end

		local targetPDS = PlayerDataByPlayer[targetPlayer]
		if not targetPDS then return nil end

		local mon = targetPDS.party[index]
		if not mon then return nil end

		return mon:getSummary({})
	else
		local mon = self.party[index]
		if not mon then return nil end
		return mon:getSummary({})
	end
end


function PlayerData:setTrainerCardBackgroundAsset(assetId)
	assetId = tostring(assetId or "")
	if not assetId:match("^%d+$") then
		return false, "Invalid assetId"
	end

	self.trainerCardBgAsset = assetId
	return true
end

function PlayerData:getTrainerCardBg()
	return self.trainerCardBgAsset or ""
end



function PlayerData:getFilteredString(text)
	if not text or text:match("^%s*$") then
		return nil
	end

	local TextService = game:GetService("TextService")
	local success, result = pcall(function()
		local filterResult = TextService:FilterStringAsync(text, self.player.UserId)
		return filterResult:GetNonChatStringForBroadcastAsync()
	end)

	if success and typeof(result) == "string" and #result > 0 then
		return result
	end

	return nil 
end


function PlayerData:chooseName(tName)
	local fname = self:getFilteredString(tName)
	if fname then
		self.trainerName = fname
	end
end

function PlayerData:approveNickname(nickname)
	local filtered = self:getFilteredString(nickname)
	if not filtered or filtered:match("^%s*$") then
		return nil
	end
	return filtered
end

local DAILY_REWARDS = {
	normal = {
		{ type = 'money', amount = 5000, display = "₱5,000 PokéDollars" },
		{ type = 'money', amount = 10000, display = "₱10,000 PokéDollars" },
		{ type = 'bp', amount = 20, display = "20 Battle Points" },
		{ type = 'bp', amount = 50, display = "50 Battle Points" },
		{ type = 'tix', amount = 5000, display = "5,000 Tix" },
		{ type = 'item', id = 'ultraball', quantity = 5, display = "5 Ultra Balls" },
		{ type = 'item', id = 'rarecandy', quantity = 1, display = "1 Rare Candy" },
		{ type = 'item', id = 'bottlecap', quantity = 1, display = "1 Bottle Cap" },
		{ type = 'item', id = 'maxrevive', quantity = 3, display = "3 Max Revives" },
	},

	weekly = {
		{ type = 'familiars', species = 'Rotom', level = 20, display = "✨ Rotom (Level 20)" },
		{ type = 'familiars', species = 'Beldum', level = 15, display = "✨ Beldum (Level 15)" },
		{ type = 'item', id = 'abilitypatch', quantity = 1, display = "1 Ability Patch" },
		{ type = 'item', id = 'heartscale', quantity = 5, display = "5 Heart Scales" },
		{ type = 'bp', amount = 100, display = "💎 100 BP!" },
		{ type = 'tix', amount = 10000, display = "🎫 10,000 Tix!" }
	}
}

function PlayerData:getDailyReward()
	local today = tonumber(os.date('%j'))
	if self.lastDailyRewardDay == today then return true end

	-- Use cached reward if it exists
	if self.pendingDailyReward then
		return false, self.pendingDailyReward
	end

	local streak = self.loginStreak or 0
	local last = self.lastDailyRewardDay or 0

	local yesterday = today - 1
	if yesterday == 0 then yesterday = 365 end
	if last == yesterday then
		streak += 1
	else
		streak = 1
	end


	local rewardPool = (streak % 7 == 0) and DAILY_REWARDS.weekly or DAILY_REWARDS.normal
	local reward = rewardPool[math.random(1, #rewardPool)]

	-- Cache today's reward
	self.pendingDailyReward = {
		streak = streak,
		type = reward.type,
		display = reward.display,
		data = reward
	}

	return false, self.pendingDailyReward
end


function PlayerData:claimDailyReward()
	local today = tonumber(os.date('%j'))
	if self.lastDailyRewardDay == today then return false end

	local already, info = self:getDailyReward()
	if already then return false end

	self.lastDailyRewardDay = today
	self.loginStreak = info.streak

	local reward = info.data
	local msg = reward.display

	if reward.type == 'money' then
		self:addMoney(reward.amount)
	elseif reward.type == 'bp' then
		self:addBP(reward.amount)
	elseif reward.type == 'tix' then
		self:addTix(reward.amount)
	elseif reward.type == 'item' then
		self:addBagItems({ id = reward.id, quantity = reward.quantity })
	elseif reward.type == 'familiars' then
		local mon = self:newFamiliars {
			name = reward.species,
			level = reward.level,
			shinyChance = 1024
		}
		self:PC_sendToStore(mon)
	end

	self.pendingDailyReward = nil

	-- Track claim history
	self.dailyClaimHistory = self.dailyClaimHistory or {}

	-- Insert most recent at top
	table.insert(self.dailyClaimHistory, 1, {
		day = self.loginStreak,
		reward = reward.display,
		streak = self.loginStreak
	})


	-- Keep only last 7 entries
	if #self.dailyClaimHistory > 7 then
		table.remove(self.dailyClaimHistory, 8)
	end


	-- Optional Discord Logging
	pcall(function()
		_f.Logs:logDailyReward(self.player, {
			streak = self.loginStreak,
			type = reward.type,
			display = reward.display,
			userId = self.userId
		})
	end)

	return reward.display
end

function PlayerData:getRewardHistory()
	return self.dailyClaimHistory or {}
end

local LICENSE_GAMEPASSES = {
	Assets.passId.genecapsule,
	Assets.passId.hoverboards,
	Assets.passId.evEditor,
	Assets.passId.naturereshaper,
}

function PlayerData:ownsGamepassOrGift(gamepassId)
	if typeof(gamepassId) ~= "number" then
		return false
	end

	if self:HasLicense() then
		for _, id in ipairs(LICENSE_GAMEPASSES) do
			if id == gamepassId then
				return true
			end
		end
	end

	local ok, owns = pcall(function()
		return game:GetService("MarketplaceService"):UserOwnsGamePassAsync(self.userId, gamepassId)
	end)
	if ok and owns then
		return true
	end

	if self.ownedGamePassCache and self.ownedGamePassCache[gamepassId] then
		return true
	end

	local row = _f.MySqlService:SelectRow(
		"GiftedGamepasses",
		{
			user_id = self.userId,
			gamepass_id = gamepassId
		}
	)

	return row ~= nil
end
function PlayerData:getWorldEvent()

	local names = {}

	if _f.WorldEvent.active then

		local events = {}

		local first = _f.WorldEvent.events[1]
		if first then
			table.insert(events, first)
		end

		local second = _f.WorldEvent.events[2]
		if second and self:HasLicense() then
			table.insert(events, second)
		end

		for _, e in ipairs(events) do
			if e and e.name then
				table.insert(names, e.name)
			end
		end
	end

	return {
		active = _f.WorldEvent.active or false,
		names = names,
		startedAt = _f.WorldEvent.startedAt or 0,
		duration = _f.WorldEvent.duration or 0
	}
end


function PlayerData:getBattleTeam(ignoreHPState, teamPreviewOrder) -- todo: connect team preview
	if ignoreHPState and teamPreviewOrder then
		local team = {}
		for teamIndex, partyIndex in pairs(teamPreviewOrder) do
			team[teamIndex] = self.party[partyIndex]:getCombatInfo(true)
		end
		return team
	end

	local team = {}
	local fainted = {}
	for _, p in pairs(self.party) do
		local d = p:getCombatInfo(ignoreHPState)
		if (ignoreHPState or p.hp > 0) and not p.egg then
			table.insert(team, d)
		else
			table.insert(fainted, d)
		end
	end
	assert(#team > 0, 'No healthy Familiars')
	for _, d in pairs(fainted) do
		table.insert(team, d)
	end
	return team
end

function PlayerData:ServerPortal()
	local do_debug = true
	local portalSpawns = {
		'chunk91992',  --// Lagoona Lake
		'chunk91993', --// Route 9
		'chunk91994', --// Route 10 
		'chunk91995', --// Route 11
		'chunk91996', --// Route 12 
		'chunk91997', --// Route 15
		'chunk91998', --// Cosmeos Valley 
	}
	local min = game:GetService('Lighting'):GetMinutesAfterMidnight()
	local isDay = (min > 6.5*60 and min < (17+5/6)*60 and true or false)
	if not _f.portalLocation then --10mins per new location
		local rng = portalSpawns[math.random(1, #portalSpawns)]
		local sTime = os.time()
		_f.portalLocation = {location=rng,sTime=sTime}
	end
	if _f.currentWeather == 'meteor' or _f.currentWeather == 'aurora' then
		isDay = false
	end
	if isDay then _f.portalLocation = false end --reset at night (server)
	--check time of day
	if do_debug then
		return {location = 'chunk9'}
	else
		return _f.portalLocation
	end
end

function PlayerData:getMarshadowBattle()
	if not table.find(_f.PortalLocations, self.currentChunk) then return false end
	return require(storage.Registry.Encounters).MarshEnc
end

function PlayerData:newFamiliars(data)
	return _f.ServerMon:new(data, self)
end

function PlayerData:startNewGame(gamemode)
	if self.gameBegan then
		return false
	end

	--self:resetLoadedSaveState()

	self.gameBegan = true
	self.gamemode = gamemode or "adventure"
	self.noData = nil
	self.playtime = 0
	self.lastPlaytimeClaim = 0
	self.playtimeRewardIndex = 1
	self.playtimeRewardSeed = math.random(1, 2147483647)
	self.playtimeRewardReadyNotified = false
	self:resetRedeemedCodesForMode(self.gamemode)

	local Objective = _f.Database.Objectives.Default
	_f.Network:post('newObjective', self.player, Objective.Texts, Objective.Mark)
	self:onGameBegin(self.gamemode)

	return true
end
function PlayerData:continueGame(gamemode)
	if self.gameBegan then
		warn("⚠️ Attempted to continue game, but game already began for:", self.player.Name)
		return false
	end

	local k = gamemode or "adventure"
	self.noData = self.noData or {}

	if self.noData[k] then
		return false
	end

	local data, pcData
	if k == "AdvSlot1" then
		data, pcData = self:getSaveDataAdvSlot(1)
	elseif k == "AdvSlot2" then
		data, pcData = self:getSaveDataAdvSlot(2)
	else
		data, pcData = self:getSaveData(k)
	end

	if data == nil then
		return false
	end

	if data == "" then
		self.noData[k] = true
		return false
	end

--	self:resetLoadedSaveState()

	self.gameBegan = true
	self.loadedData = nil
	self.gamemode = k

	local etc = self:deserialize(data)
	
	self.playtime = self:getSafePlaytime()
	if (self.lastPlaytimeClaim or 0) > self.playtime then
		self.lastPlaytimeClaim = self.playtime
	end
	
	if pcData and pcData ~= '' then
		self:PC_deserialize(pcData)
	end

	pcall(function()
		if self:ownsGamePass('MoreBoxes', true) and self.pc.maxBoxes < 100 then
			self.pc.maxBoxes = 100
		end
		if self:ownsGamePass('PondPass', true) then
			self.flags.PondPass = true
			_f.Network:post('PondPassPassPurchased', self.player)
		end
	end)

	if k == "AdvSlot1" then
		_f.APS[self.player]:loadAPRT("AdvSlot1")
	elseif k == "AdvSlot2" then
		_f.APS[self.player]:loadAPRT("AdvSlot2")
	else
		_f.APS[self.player]:loadAPRT(k)
	end

	self:onGameBegin(k)

	etc.SpecialDate = false
	local mnth = _f.Date:getDate().MonthName
	local date = _f.Date:getDate().DayOfMonth
	if mnth == 'April' and date == 1 then
		etc.SpecialDate = 'aprilfools'
	elseif mnth == 'October' and date <= 30 then
		etc.SpecialDate = 'halloween'
	elseif (mnth == 'December' and date == 25) or (mnth == 'January' and date == 1) then
		etc.SpecialDate = 'christmas'
	end

	return true, etc
end


function PlayerData:resetLoadedSaveState()
	for _, p in pairs(self.party or {}) do
		pcall(function() p:destroy() end)
	end
	self.party = {}

	if self.daycare and self.daycare.depositedFamiliars then
		for _, p in pairs(self.daycare.depositedFamiliars) do
			pcall(function() p:destroy() end)
		end
	end
	self.daycare = {
		depositedFamiliars = {},
		manHasEgg = false,
	}

	self.pc = PC:new()
	self.bag = {{},{},{},{},{},{}}
	self.badges = {}
	self.completedEvents = {}
	self.flags = {}
	self.ids = {}

	self.money = 0
	self.bp = 0
	self.tix = 0

	self.trainerName = self.player.Name
	self.familiarium = ""
	self.obtainedItems = ""
	self.tms = ""
	self.hms = ""
	self.defeatedTrainers = ""

	self.loadedData = nil
	self.currentChunk = nil
	self.decisiondata = {}
	self.decisioncount = 0
	self.SurfEnabled = false
	self.mountedM = false
	self.pendingDailyReward = nil
	self.honey = nil
	self.pcSession = nil
	self.mineSession = nil
	self.gameBeganExtras = nil
end

function PlayerData:onGameBegin(gamemode)
	if self.gameBeganExtras then return end -- dispatch once
	self.gameBeganExtras = true
	-- cache game passes that may have been deleted (but the player has the key item for them still)
	-- or, if they own the pass but not the key item, give them the key item
	for _, passName in pairs({'ShinyCharm', 'AbilityCharm', 'OvalCharm', 'genecapsule'}) do
		local itemId = passName:lower()
		if self:getBagDataById(itemId, 5) then
			self.ownedGamePassCache[Assets.passId[passName] ] = true
		elseif self.ownedGamePassCache[Assets.passId[passName] ] then
			self:addBagItems({id = itemId, quantity = 1})
		end
	end

	-- the following passes have a special function to run when purchased, activate them
	for _, passName in pairs({'ExpShare', 'MoreBoxes', 'PondPass', 'genecapsule', 'evEditor', 'naturereshaper'}) do
		local passId = Assets.passId[passName]
		if self.ownedGamePassCache[passId] then
			self:onAssetPurchased(passId)
		end
	end

	for _, passId in pairs(Assets.passId) do
		if self:ownsGamepassOrGift(passId) then
			self:onAssetPurchased(passId)
			self.ownedGamePassCache[passId] = true
		end
	end


	pcall(function()
		if self:ownsGamePass('MoreBoxes', true) then
			if self.pc.maxBoxes == 8 then
				self.pc.maxBoxes = 100
			end
		end
		if self:ownsGamePass('PondPass', true) then
			self.flags.PondPass = true
			_f.Network:post('PondPassPassPurchased', self.player)
		end
	end)
	-- let the player know what these initial values are
	local firstNonEgg = self:getFirstNonEgg()
	if firstNonEgg then
		_f.Network:post('PDChanged', self.player,
			'firstNonEggLevel', firstNonEgg.level,
			'firstNonEggAbility', firstNonEgg:getAbilityName(),
			'money', self.money,
			'bp', self.bp,
			'tix', self.tix)
	end
	-- etc.
	self.gamemode = gamemode
	self:checkForHatchables(true)
	self:updatePlayerListEntry()
	if tonumber(os.date('%j')) ~= self.lastLottoTryDay then 
		self.lottoTries = 0
	end
end

local shopProducts = {
	[Assets.productId.MasterBall] = {id = 'masterball', icon = 8820446373},
	[Assets.productId.MewtwoniteShadowX] = {id = 'mewtwoniteshadowx', icon = 126179829501343},
	[Assets.productId.MewtwoniteShadowY] = {id = 'mewtwoniteshadowy', icon = 94440935279517},
}


local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local SPECIAL_FAMILIARS_DEFS = {
	ashgreninja = {
		displayName = "Ash-Greninja",
		description = "Special battle-ready Greninja form.",
		productId = Assets.productId.AshGreninja,
		icon = "ashgreninja",
		-- Familiars creation data (for buySpecialMon)
		name = "Greninja",
		forme = "bb",
		level = 36,
		shinyChance = 2048,
		ot = 6112783,
		moves = {
			{id = "watershuriken"},
			{id = "aerialace"},
			{id = "doubleteam"},
			{id = "nightslash"},
		},
	},
	lugiashadow = {
		displayName = "Shadow Lugia",
		description = "A dark legendary variant.",
		productId = Assets.productId.LugiaShadow,
		icon = "lugiashadow",
		name = "Lugia",
		forme = "Shadow",
		level = 36,
		shinyChance = 2048,
		ot = 6112783,
	},
	hoohdarkice = {
		displayName = "Dark-Ice Ho-Oh",
		description = "A special themed Ho-Oh form.",
		productId = Assets.productId.HoohDarkice,
		icon = "hoohdarkice",
		name = "Ho-Oh",
		forme = "darkice",
		level = 36,
		shinyChance = 2048,
		ot = 6112783,
	},
	lucariothief = {
		displayName = "Thief Lucario",
		description = "Exclusive Lucario form.",
		productId = Assets.productId.LucarioThief,
		icon = "lucariothief",
		name = "Lucario",
		forme = "Thief",
		level = 36,
		shinyChance = false,
		ot = 6112783,
	},
	electiviredraco = {
		displayName = "Draco Electivire",
		description = "Exclusive Electivire form.",
		productId = Assets.productId.DracoElectivire,
		icon = "electiviredraco",
		name = "Electivire",
		forme = "draco",
		level = 36,
		shinyChance = false,
		ot = 6112783,
	},
	shadowmewtwo = {
		displayName = "Shadow Mewtwo",
		description = "A dark legendary variant.",
		productId = Assets.productId.ShadowMewtwo,
		icon = "shadowmewtwo",
		name = "Mewtwo",
		forme = "Shadow",
		level = 36,
		shinyChance = false,
		ot = 6112783,
	},
}

local DEV_PRODUCT_DEFS = {
	{
		key = "_10kP",
		productId = Assets.productId._10kP,
		displayName = "10,000 Cash",
		description = "Quick cash for items and travel.",
		rewardText = "10,000 Cash",
		icon = "cash",
		giftable = true,
		giftType = "currency",
		rewardType = "money",
		amount = 10000,
	},
	{
		key = "_50kP",
		productId = Assets.productId._50kP,
		displayName = "50,000 Cash",
		description = "A solid currency boost.",
		rewardText = "50,000 Cash",
		icon = "cash",
		giftable = true,
		giftType = "currency",
		rewardType = "money",
		amount = 50000,
	},
	{
		key = "_100kP",
		productId = Assets.productId._100kP,
		displayName = "100,000 Cash",
		description = "A large progression boost.",
		rewardText = "100,000 Cash",
		icon = "cash",
		giftable = true,
		giftType = "currency",
		rewardType = "money",
		amount = 100000,
	},
	{
		key = "_200kP",
		productId = Assets.productId._200kP,
		displayName = "200,000 Cash",
		description = "A premium cash bundle.",
		rewardText = "200,000 Cash",
		icon = "cash",
		giftable = true,
		giftType = "currency",
		rewardType = "money",
		amount = 200000,
	},
	{
		key = "TenBP",
		productId = Assets.productId.TenBP,
		displayName = "10 BP",
		description = "A small Battle Point pack.",
		rewardText = "10 BP",
		icon = "bp",
		giftable = true,
		giftType = "currency",
		rewardType = "bp",
		amount = 10,
	},
	{
		key = "FiftyBP",
		productId = Assets.productId.FiftyBP,
		displayName = "50 BP",
		description = "A medium Battle Point pack.",
		rewardText = "50 BP",
		icon = "bp",
		giftable = true,
		giftType = "currency",
		rewardType = "bp",
		amount = 50,
	},
	{
		key = "TwoHundredBP",
		productId = Assets.productId.TwoHundredBP,
		displayName = "200 BP",
		description = "A large Battle Point pack.",
		rewardText = "200 BP",
		icon = "bp",
		giftable = true,
		giftType = "currency",
		rewardType = "bp",
		amount = 200,
	},
	{
		key = "TwoThousandBP",
		productId = Assets.productId.TwoThousandBP,
		displayName = "2,000 BP",
		description = "A premium Battle Point pack.",
		rewardText = "2,000 BP",
		icon = "bp",
		giftable = true,
		giftType = "currency",
		rewardType = "bp",
		amount = 2000,
	},
	{
		key = "TixPurchase",
		productId = Assets.productId.TixPurchase,
		displayName = "5,000 Tix",
		description = "Premium Tix purchase.",
		rewardText = "5,000 Tix",
		icon = "tix",
		giftable = true,
		giftType = "currency",
		rewardType = "tix",
		amount = 5000,
	},
	{
		key = "RandomShiny",
		productId = Assets.productId.RandomShiny,
		displayName = "Random Shiny",
		description = "Receive 1 random shiny Familiars.",
		rewardText = "Random Shiny Familiars",
		icon = "shiny",
		giftable = true,
		giftType = "currency",
		rewardType = "familiars",
		familiarsReward = "RandomShiny",
	},
	{
		key = "Random6x31",
		productId = Assets.productId.Random6x31,
		displayName = "Random 6x31",
		description = "Receive 1 random 6x31 Familiars.",
		rewardText = "Random 6x31 Familiars",
		icon = "iv",
		giftable = true,
		giftType = "currency",
		rewardType = "familiars",
		familiarsReward = "Random6x31",
	},
	{
		key = "RandomShiny6x31",
		productId = Assets.productId.RandomShiny6x31,
		displayName = "Random Shiny 6x31",
		description = "Receive 1 random shiny 6x31 Familiars.",
		rewardText = "Random Shiny 6x31 Familiars",
		icon = "shiny",
		giftable = true,
		giftType = "currency",
		rewardType = "familiars",
		familiarsReward = "RandomShiny6x31",
	},
}

local PRODUCT_KEY_LOOKUP = {}
local PRODUCT_ID_LOOKUP = {}

for _, def in ipairs(DEV_PRODUCT_DEFS) do
	PRODUCT_KEY_LOOKUP[def.key] = def
	PRODUCT_ID_LOOKUP[def.productId] = def
end
-- **FIXED: Add giftProductId for each pass** (you need to create these DevProducts)
local GAMEPASS_DEFS = {
	{
		key = "evEditor",
		passId = Assets.passId.evEditor, -- 1240063957
		giftProductId = 3504981585, -- **CREATE THIS DEVPRODUCT**
		displayName = "Stats Editor",
		description = "Edit EVs and IVs for your Familiars.",
		icon = "stats",
	},
	{
		key = "hoverboards",
		passId = Assets.passId.hoverboards, -- 1338663499
		giftProductId = 3504981145, -- **CREATE THIS DEVPRODUCT**
		displayName = "Hoverboard Access",
		description = "Unlock hoverboard access.",
		icon = "hoverboard",
	},
	{
		key = "genecapsule",
		passId = Assets.passId.genecapsule, -- 1650076172
		giftProductId = 3504980006, -- **CREATE THIS DEVPRODUCT**
		displayName = "Gene Capsule",
		description = "Permanent gene capsule access.",
		icon = "gene",
	},
	{
		key = "naturereshaper",
		passId = Assets.passId.naturereshaper, -- 1728417133
		giftProductId = 3545104700, -- **CREATE THIS DEVPRODUCT**
		displayName = "Nature Reshaper",
		description = "Permanent nature-changing access.",
		icon = "nature",
	},
}

function PlayerData:giveRandomRewardFamiliars(options)
	local i = math.random(1, 898)

	if i == 132 or i == 144 or i == 145 or i == 146 or i == 150 or i == 151
		or i == 243 or i == 244 or i == 245 or i == 249 or i == 250 or i == 251
		or i == 377 or i == 378 or i == 379 or i == 380 or i == 381 or i == 382 or i == 383 or i == 384 or i == 385 or i == 386
		or i == 480 or i == 481 or i == 482 or i == 483 or i == 484 or i == 485 or i == 486 or i == 487 or i == 488 or i == 489 or i == 490 or i == 491 or i == 492 or i == 493 or i == 494
		or i == 640 or i == 641 or i == 642 or i == 643 or i == 644 or i == 645 or i == 646 or i == 647 or i == 648 or i == 649
		or i == 716 or i == 717 or i == 718 or i == 719 or i == 720 or i == 721
		or i == 772 or i == 773 or i == 785 or i == 786 or i == 787 or i == 788 or i == 789 or i == 790 or i == 791 or i == 792 or i == 800 or i == 801 or i == 807 or i == 808 or i == 809
		or i == 888 or i == 889 or i == 890 or i == 891 or i == 892 or i == 893 or i == 894 or i == 895 or i == 896 or i == 897 or i == 898
	then
		i = 872
	end

	local ivs
	if options.perfect then
		ivs = {31, 31, 31, 31, 31, 31}
	else
		ivs = {
			math.random(15, 31),
			math.random(15, 31),
			math.random(15, 31),
			math.random(15, 31),
			math.random(15, 31),
			math.random(15, 31),
		}
	end

	local mon = self:newFamiliars({
		num = i,
		level = 10,
		ot = 599807,
		ivs = ivs,
		shiny = options.shiny == true,
		untradable = true,
	})

	self:PC_sendToStore(mon)
	return mon
end

function PlayerData:onDevProductPurchased(id)
	if not id then return end

	local attemptAutosave = false
	local function getRewardLabel(isShiny, isPerfect)
		if isShiny and isPerfect then
			return "Shiny Perfect IV"
		elseif isShiny then
			return "Shiny"
		elseif isPerfect then
			return "Perfect IV"
		else
			return "Special"
		end
	end
	
	if self.pendingGift then
		local gift = self.pendingGift
		self.pendingGift = nil

		local targetPlayer = game:GetService("Players"):GetPlayerByUserId(gift.targetUserId)
		if not targetPlayer then
			return "Gift failed: target left server"
		end

		local targetPDS = PlayerDataByPlayer[targetPlayer]
		if not targetPDS then
			return "Gift failed"
		end

		local gifterName = (gift.gifterPlayer and gift.gifterPlayer.Name) or self.player.Name

		local function giftMessage(itemName, receiverName)
			return string.format(
				'<b><font color="#9B59B6">🎁 %s gifted <font color="#F1C40F">%s</font> to <font color="#1ABC9C">%s</font>!</font></b>',
				gifterName,
				itemName,
				receiverName
			)
		end

		if gift.type == "gamepass" then
			targetPDS:ownsGamepassOrGift(gift.gamepassId)

			_f.Network:postAll("SystemChat", giftMessage(gift.passName, targetPlayer.Name))
			return "Gifted " .. gift.passName .. " to " .. targetPlayer.Name .. "!"
		end

		if gift.type == "currency" then
			local def = PRODUCT_ID_LOOKUP[id]

			if def then
				self.pendingGift = nil

				if def.rewardType == "money" then
					targetPDS:addMoney(def.amount, true)

				elseif def.rewardType == "bp" then
					targetPDS:addBP(def.amount, true, true)

				elseif def.rewardType == "tix" then
					targetPDS:addTix(def.amount)

				elseif def.rewardType == "familiars" then
					if def.familiarsReward == "RandomShiny" then
						targetPDS:giveRandomRewardFamiliars({
							shiny = true,
							perfect = false,
							gifterPlayer = gift.gifterPlayer,
						})
					elseif def.familiarsReward == "Random6x31" then
						targetPDS:giveRandomRewardFamiliars({
							shiny = false,
							perfect = true,
							gifterPlayer = gift.gifterPlayer,
						})
					elseif def.familiarsReward == "RandomShiny6x31" then
						targetPDS:giveRandomRewardFamiliars({
							shiny = true,
							perfect = true,
							gifterPlayer = gift.gifterPlayer,
						})
					end
				end

				_f.Network:postAll("SystemChat",
					giftMessage(def.displayName, targetPlayer.Name)
				)

				return true
			end
		end

		if gift.type == "specialmon" then
			return targetPDS:buySpecialMon(gift.monId, true, gift.gifterPlayer)
		end
	end

	if id == Assets.productId.Starter then
		local s = self.starterProductStack
		if #s > 0 then table.remove(s)() end

	elseif id == Assets.productId.AshGreninja
		or id == Assets.productId.DracoElectivire
		or id == Assets.productId.LucarioThief
		or id == Assets.productId.LugiaShadow
		or id == Assets.productId.HoohDarkice
		or id == Assets.productId.ShadowMewtwo then

		local s = self.ashGreninjaProductStack
		if #s > 0 then table.remove(s)() end

	elseif id == Assets.productId.Hoverboard then
		local s = self.hoverboardProductStack
		if #s > 0 then table.remove(s)() end

	elseif id == Assets.productId.LottoTicket then
		self.ticket = math.random(1, 99999)
		attemptAutosave = true
		local s = self.lottoTicketProductStack
		if #s > 0 then table.remove(s)() end

	elseif id == Assets.productId.TenBP then
		self:addBP(10, true, true)

	elseif id == Assets.productId.FiftyBP then
		self:addBP(50, true, true)

	elseif id == Assets.productId.TwoHundredBP then
		self:addBP(200, true, true)

	elseif id == Assets.productId.TwoThousandBP then
		self:addBP(2000, true, true)

	elseif id == Assets.productId._10kP then
		self:addMoney(10000, true)

	elseif id == Assets.productId._50kP then
		self:addMoney(50000, true)

	elseif id == Assets.productId._100kP then
		self:addMoney(100000, true)

	elseif id == Assets.productId._200kP then
		self:addMoney(200000, true)

	elseif id == Assets.productId.RandomShiny then
		local isShiny = true
		local isPerfect = false
		local familiars = self:giveRandomRewardFamiliars({
			shiny = isShiny,
			perfect = isPerfect,
		})
		if familiars then
			_f.Network:postAll("SystemChat", string.format(
				'<b><font color="#F1C40F">%s</font> received a <font color="#9B59B6">%s</font> <font color="#1ABC9C">%s</font>!</b>',
				self.player.Name,
				getRewardLabel(isShiny, isPerfect),
				familiars:getName()
				))
		end

	elseif id == Assets.productId.Random6x31 then
		local isShiny = false
		local isPerfect = true
		local familiars = self:giveRandomRewardFamiliars({
			shiny = isShiny,
			perfect = isPerfect,
		})
		if familiars then
			_f.Network:postAll("SystemChat", string.format(
				'<b><font color="#F1C40F">%s</font> received a <font color="#9B59B6">%s</font> <font color="#1ABC9C">%s</font>!</b>',
				self.player.Name,
				getRewardLabel(isShiny, isPerfect),
				familiars:getName()
				))
		end

	elseif id == Assets.productId.RandomShiny6x31 then
		local isShiny = true
		local isPerfect = true
		local familiars = self:giveRandomRewardFamiliars({
			shiny = isShiny,
			perfect = isPerfect,
		})
		if familiars then
			_f.Network:postAll("SystemChat", string.format(
				'<b><font color="#F1C40F">%s</font> received a <font color="#9B59B6">%s</font> <font color="#1ABC9C">%s</font>!</b>',
				self.player.Name,
				getRewardLabel(isShiny, isPerfect),
				familiars:getName()
				))
		end
	elseif id == Assets.productId.TixPurchase then
		self:addTix(5000)

	elseif id == Assets.productId.PBSpins1 then
		self.stampSpins = math.min(999, self.stampSpins + 1)
		_f.Network:post("uPBSpins", self.player, self.stampSpins)
		attemptAutosave = true

	elseif id == Assets.productId.PBSpins5 then
		self.stampSpins = math.min(999, self.stampSpins + 5)
		_f.Network:post("uPBSpins", self.player, self.stampSpins)
		attemptAutosave = true

	elseif id == Assets.productId.PBSpins10 then
		self.stampSpins = math.min(999, self.stampSpins + 10)
		_f.Network:post("uPBSpins", self.player, self.stampSpins)
		attemptAutosave = true

	elseif id == Assets.productId.RouletteSpinBasic
		or id == Assets.productId.RouletteSpinBronze
		or id == Assets.productId.RouletteSpinSilver
		or id == Assets.productId.RouletteSpinGold
		or id == Assets.productId.RouletteSpinDiamond then
		self.rouletteSpins = 1
		self.currentRouletteTier = id
		_f.Network:post('doBoughtSpin', self.player)

	else
		local shopItem = shopProducts[id]
		if shopItem then
			local item = _f.Database.ItemById[shopItem.id]
			self:addBagItems({num = item.num, quantity = shopItem.qty or 1})
			_f.Network:post('ItemProductPurchased', self.player, item.name, shopItem.icon)
		else
			for g, list in pairs(Assets.productId.RoPowers) do
				for l, pId in pairs(list) do
					if pId == id then
						_f.Network:post('rpActivate', self.player, g, l, RO_POWER_EFFECT_DURATION)
						self:ROPowers_setTimePurchasedAndLevelForPower(g, os.time(), l)
						self:ROPowers_save()
						break
					end
				end
			end
		end
	end

	if attemptAutosave then
		spawn(function()
			if self.lastSaveEtc then
				self:saveGame(self.lastSaveEtc)
			end
		end)
	end
end

function PlayerData:onAssetPurchased(id) -- keep in mind this will be called at least once every session after the pass is purchased (protect it from multi-awarding)
	if id == Assets.passId.ExpShare then
		if not self:getBagDataById('expshare', 5) then
			self:addBagItems({id = 'expshare', quantity = 1})
			_f.Network:post('PDChanged', self.player, 'expShareOn', true) -- when initially given, automatically turn it on
		end
	elseif  id == Assets.passId.genecapsule then
		if not self:getBagDataById('genecapsule', 5) then
			self:addBagItems({id = 'genecapsule', quantity = 1})
		end
	elseif  id == Assets.passId.naturereshaper then
		if not self:getBagDataById('naturereshaper', 5) then
			self:addBagItems({id = 'naturereshaper', quantity = 1})
		end
	elseif id == Assets.passId.MoreBoxes then
		if self.pc.maxBoxes == 8 then
			self.pc.maxBoxes = 100
			_f.Network:post('PCPassPurchased', self.player)
		end
	elseif id == Assets.passId.PondPass then
		self.flags.PondPass = true
		_f.Network:post('PondPassPassPurchased', self.player)
	end
end

function PlayerData:announceHatch(familiarsName)
	if typeof(familiarsName) ~= "string" then return end

	_f.Network:postAll(
		"SystemChat",
		"🥚 " .. self.player.Name .. " hatched a ✨ SHINY ✨ " .. familiarsName .. "!"
	)
end

function PlayerData:completeEvent(eventName, ...)
	if self.completedEvents[eventName] then print("Event already completed") return false end
	local event = _f.PlayerEvents[eventName]
	if event == nil then print("Event doesn't exist") return false end
	local function logEventCompleted(missing)
		_f.Logs:logExploit(self.player,{
			exploit = "Complete Event",
			extra = 'Tried to complete "'..eventName..'" without having "'..missing..'" completed.'
		})
		self.player:Kick("Please avoid exploiting. Further exploitation can and will result in a permanent ban.")
	end
	local r = event
	local pseudo = false -- pseudo-events do not store to PlayerData
	if type(event) == 'function' then
		r = event(self, ...)
	elseif type(event) == 'table' then
		if event.manual then return false end
		if event.pseudo then pseudo = true end
		if event.callback then
			r = event.callback(self, ...)
		end
		if event.DependsOn and not self.completedEvents[event.DependsOn] then
			logEventCompleted(event.DependsOn)
			return
		end
	elseif type(event) == "string" then
		if not self.completedEvents[event] then
			logEventCompleted(event)
			return
		end
		-- todo: continue to fill cases
	end
	if r ~= false and not pseudo then
		self.completedEvents[eventName] = true
		if _f.Database.Objectives.Events[eventName] then
			local Objective = _f.Database.Objectives.Events[eventName]
			_f.Network:post('newObjective', self.player, Objective.Texts, Objective.Mark)
		end
	end
	return r
	end


function PlayerData:completeEventServer(eventName, ...)
	if self.completedEvents[eventName] then return false end
	local event = _f.PlayerEvents[eventName]
	if event == nil then return false end
	local r = event
	if type(event) == 'function' then
		r = event(self, ...)
	elseif type(event) == 'table' then
		-- todo: other cases where server is concerned with the data in the table
		if type(event.pseudo) == 'function' and event.pseudo(self) then return false end
		if event.callback then
			r = event.callback(self, ...)
		end
	elseif r == false then
		r = nil
	end
	if r ~= false then
		self.completedEvents[eventName] = true
		_f.Network:post('eventCompleted', self.player, eventName) -- notify client
		if _f.Database.Objectives.Events[eventName] then
			local Objective = _f.Database.Objectives.Events[eventName]
			_f.Network:post('newObjective', self.player, Objective.Texts, Objective.Mark)
		end
	end
	return r
end



function PlayerData:giveStoryAbsol(slot)
	local hadSeenAbsol  = self:hasSeenFamiliars(359)
	local hadOwnedAbsol = self:hasOwnedFamiliars(359)
	local absol = self:newFamiliars {
		name = 'Absol',
		level = 50,
		shinyChance = 2048,
		item = 534,
		moves = {{id = 'nightslash'},{id = 'psychocut'},{id = 'megahorn'},{id = 'detect'}}
	}
	local box, position
	if slot then
		box, position = self:PC_sendToStore(table.remove(self.party, slot), true)
	end
	table.insert(self.party, 1, absol)
	self:onOwnFamiliars(359)
	self.absolMeta = {
		slot = slot, box = box, position = position,
		seen = hadSeenAbsol,
		owned = hadOwnedAbsol
	}
end

function PlayerData:undoGiveStoryAbsol()
	self:incrementBagItem('megakeystone', -1)
	self.flags.gotAbsol = nil
	if self.party[1].name == 'Absol' then
		table.remove(self.party, 1)
	end
	local meta = self.absolMeta
	if not meta then return end
	self.absolMeta = nil
	local slot, box, position = meta.slot, meta.box, meta.position
	if slot and box and position then
		table.insert(self.party, slot, _f.ServerMon:deserialize(self.pc.boxes[box][position][3], self))
		self.pc.boxes[box][position] = nil
	end
	if not meta.seen  then self:unseeFamiliars(359) end
	if not meta.owned then self:unownFamiliars(359) end
end
function PlayerData:getStarterData()
	local starters = {}
	local randomized = { 
		'Bulbasaur',  'Charmander', 'Squirtle',
		'Chikorita',  'Cyndaquil',  'Totodile',
		'Treecko',    'Torchic',    'Mudkip',
		'Turtwig',    'Chimchar',   'Piplup',
		'Snivy',      'Tepig',      'Oshawott',
		'Chespin',    'Fennekin',   'Froakie',
		'Rowlet',     'Litten',     'Popplio',
		'Grookey',    'Scorbunny',  'Sobble',
		'Sprigatito', 'Fuecoco',    'Quaxly',
	}
	if self.gamemode == 'randomizer' then
		local rngTbl = _f.randomizefamila(#randomized)
		randomized = {}
		for i=1, #rngTbl do
			local famila = rngTbl[i]
			if famila[2] then
				randomized[i] = famila[1]..'-'..famila[2]
			else
				randomized[i] = famila[1]
			end
		end
	end
	for i, v in pairs(randomized) do
		if _f.Database.GifData._FRONT[v] then --Should be checked for anyways
			starters[i] = {v, _f.Database.GifData._FRONT[v]}
		end
	end
	return starters
end


local function getProductPriceInRobux(productId)
	if typeof(productId) ~= "number" then return nil end
	local ok, info = pcall(function()
		return MarketplaceService:GetProductInfo(productId, Enum.InfoType.Product)
	end)
	if ok and info then return info.PriceInRobux end
	return nil
end

local function getGamePassPriceInRobux(passId)
	if typeof(passId) ~= "number" then return nil end
	local ok, info = pcall(function()
		return MarketplaceService:GetProductInfo(passId, Enum.InfoType.GamePass)
	end)
	if ok and info then return info.PriceInRobux end
	return nil
end

function PlayerData:getGiftablePlayers()
	local list = {}
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= self.player then
			table.insert(list, {
				userId = plr.UserId,
				name = plr.Name,
			})
		end
	end
	table.sort(list, function(a, b) return a.name:lower() < b.name:lower() end)
	return list
end

-- **FIXED: Added gifterPlayer tracking**
function PlayerData:giftGamepass(targetUserId, gamepassId, productId, passName)
	if typeof(targetUserId) ~= "number" then return false, "invalid_target" end
	if typeof(gamepassId) ~= "number" then return false, "missing_gamepass_id" end
	if typeof(productId) ~= "number" then return false, "missing_product_id" end
	if self.userId == targetUserId then return false, "cannot_gift_self" end

	local targetPlayer = Players:GetPlayerByUserId(targetUserId)
	if not targetPlayer then return false, "player_left_server" end

	local targetPDS = PlayerDataByPlayer[targetPlayer]
	if targetPDS and targetPDS:ownsGamepassOrGift(gamepassId) then
		return false, targetPlayer.Name .. " already owns this pass"
	end

	self.pendingGift = {
		type = "gamepass",
		targetUserId = targetUserId,
		gamepassId = gamepassId,
		productId = productId,
		passName = passName or "a gamepass",
		gifterPlayer = self.player  -- **FIX: Track gifter**
	}

	MarketplaceService:PromptProductPurchase(self.player, productId)
	return true, "prompt_opened"
end

function PlayerData:giftCurrency(targetUserId, productKey, displayName)
	if typeof(targetUserId) ~= "number" then return false, "invalid_target" end
	if typeof(productKey) ~= "string" then return false, "invalid_product_key" end
	if self.userId == targetUserId then return false, "cannot_gift_self" end

	local def = PRODUCT_KEY_LOOKUP[productKey]
	if not def then return false, "invalid_product" end

	local targetPlayer = Players:GetPlayerByUserId(targetUserId)
	if not targetPlayer then return false, "player_left_server" end

	self.pendingGift = {
		type = "currency",
		targetUserId = targetUserId,
		productId = def.productId, -- ✅ ALWAYS correct now
		displayName = def.displayName,
		gifterPlayer = self.player
	}

	MarketplaceService:PromptProductPurchase(self.player, def.productId)
	return true, "prompt_opened"
end
-- **FIXED: Added gifterPlayer tracking + uses SPECIAL_FAMILIARS_DEFS**
function PlayerData:giftSpecialMon(targetUserId, monId)
	if typeof(targetUserId) ~= "number" then return false, "invalid_target" end
	if typeof(monId) ~= "string" then return false, "invalid_mon_id" end
	if self.userId == targetUserId then return false, "cannot_gift_self" end

	local targetPlayer = Players:GetPlayerByUserId(targetUserId)
	if not targetPlayer then return false, "player_left_server" end

	local def = SPECIAL_FAMILIARS_DEFS[monId]
	if not def or not def.productId then return false, "invalid_special_mon" end

	self.pendingGift = {
		type = "specialmon",
		targetUserId = targetUserId,
		monId = monId,
		gifterPlayer = self.player  -- **FIX: Track gifter**
	}

	MarketplaceService:PromptProductPurchase(self.player, def.productId)
	return true, "prompt_opened"
end

function PlayerData:getShopCatalog(tabName, shopId)
	if typeof(tabName) ~= "string" then return {} end

	-- ... your existing Items/BP/Tix code unchanged ...

	if tabName == "Familiars" then
		local catalog = {}
		for key, def in pairs(SPECIAL_FAMILIARS_DEFS) do
			local robuxPrice = getProductPriceInRobux(def.productId)
			table.insert(catalog, {
				id = key,
				displayName = def.displayName,
				description = def.description,
				icon = def.icon,
				productId = def.productId,
				priceText = robuxPrice and (tostring(robuxPrice).." R$") or "Robux",
				productType = "SpecialFamiliars",
				giftable = true,  -- **FIX: Enable gifting**
				giftType = "specialmon",
				owned = false,
			})
		end
		return catalog
	end

	if tabName == "Products" then
		local catalog = {}
		for _, def in ipairs(DEV_PRODUCT_DEFS) do
			local robuxPrice = getProductPriceInRobux(def.productId)
			table.insert(catalog, {
				id = def.key,
				productKey = def.key,
				productId = def.productId,
				displayName = def.displayName,
				description = def.description,
				icon = def.icon,
				priceText = robuxPrice and (tostring(robuxPrice).." R$") or "Robux",
				productType = "DevProduct",
				giftable = def.giftable,
				giftType = def.giftType,
				owned = false,
			})
		end
		return catalog
	end

	-- **FIXED: Passes now return giftProductId (like your working UI)**
	if tabName == "Passes" then
		local catalog = {}
		for _, def in ipairs(GAMEPASS_DEFS) do
			local passPrice = getGamePassPriceInRobux(def.passId)
			local giftPrice = def.giftProductId and getProductPriceInRobux(def.giftProductId)
			local owned = self:ownsGamepassOrGift(def.passId)

			table.insert(catalog, {
				id = def.key,
				passId = def.passId,
				giftProductId = def.giftProductId,  -- **CRITICAL: Your UI expects this**
				displayName = def.displayName,
				description = def.description,
				icon = def.icon,
				image = def.image,
				priceText = owned and "Owned" or (giftPrice and (tostring(giftPrice).." R$") or passPrice and (tostring(passPrice).." R$") or "Robux"),
				productType = "Gamepass",
				owned = owned,
				giftable = def.giftProductId ~= nil,  -- Only if gift product exists
				giftType = "gamepass",
				passName = def.displayName,  -- **Your UI uses this**
			})
		end
		return catalog
	end

	return {}
end


function PlayerData:buyStarter(species)
	if not species then return false end
	if self.gamemode ~= 'randomizer' and self.gamemode ~= 'spawner' then
		local valid = {
			Bulbasaur = true, Charmander = true, Squirtle = true,
			Chikorita = true, Cyndaquil  = true, Totodile = true,
			Treecko   = true, Torchic    = true, Mudkip   = true,
			Turtwig   = true, Chimchar   = true, Piplup   = true,
			Snivy     = true, Tepig      = true, Oshawott = true,
			Chespin   = true, Fennekin   = true, Froakie  = true,
			Rowlet    = true, Litten     = true, Popplio  = true,
			Grookey   = true, Scorbunny  = true, Sobble   = true,
			Sprigatito   = true, Fuecoco = true, Quaxly  = true,
		}
		if not valid[species] then return false end
	end

	local sendToPC = false
	local processed = false
	local familiars
	table.insert(self.starterProductStack, function()
		if string.find(species, '-') and not (_f.validSpecies[string.lower(species)]) then
			species = string.split(species, '-')
		else
			species = {species, nil}
		end
		if processed then return end
		familiars = self:newFamiliars {
			name = species[1],
			forme  = species[2],
			level = 5,
			shinyChance = 2048,
		}
		if sendToPC then
			self:PC_sendToStore(familiars)
			return
		end
		processed = true
		-- defer storage until after nickname
	end)
	game:GetService('MarketplaceService'):PromptProductPurchase(self.player, Assets.productId.Starter)
	for i = 1, 40 do
		wait(.5)
		if processed then break end
	end
	if not processed then
		-- timed out
		sendToPC = true
		return 'to'
	end
	if familiars then
		return {
			d = self:createDecision {
				callback = function(_, nickname)
					if type(nickname) == 'string' then
						familiars:giveNickname(nickname)
					end
					local box = self:caughtFamiliars(familiars)
					if box then
						return familiars:getName() .. ' has been transferred to Box ' .. box .. '!'
					end
				end
			},
			i = familiars:getIcon(),
			s = familiars.shiny
		}
	end
	-- is there a condition that reaches here?
end
function PlayerData:buySpecialMon(monType, giftMode, gifter)
	if #self.party > 5 and not giftMode then
		return "fp"
	end

	local familiars
	local processed = false
	local sendToPC = false

	-- Special Familiars definitions
	local defs = {
		ashgreninja = {
			name = "Greninja",
			forme = "bb",
			level = 36,
			shinyChance = 2048,
			ot = 6112783,
			moves = {
				{id = "watershuriken"},
				{id = "aerialace"},
				{id = "doubleteam"},
				{id = "nightslash"},
			},
			productId = Assets.productId.AshGreninja,
		},
		lugiashadow = {
			name = "Lugia",
			forme = "Shadow",
			level = 36,
			shinyChance = 2048,
			ot = 6112783,
			productId = Assets.productId.LugiaShadow,
		},
		hoohdarkice = {
			name = "Ho-Oh",
			forme = "darkice",
			level = 36,
			shinyChance = 2048,
			ot = 6112783,
			productId = Assets.productId.HoohDarkice,
		},
		lucariothief = {
			name = "Lucario",
			forme = "Thief",
			level = 36,
			shinyChance = false,
			ot = 6112783,
			productId = Assets.productId.LucarioThief,
		},
		electiviredraco = {
			name = "Electivire",
			forme = "draco",
			level = 36,
			shinyChance = false,
			ot = 6112783,
			productId = Assets.productId.DracoElectivire,
		},
		shadowmewtwo = {
			name = "Mewtwo",
			forme = "Shadow",
			level = 36,
			shinyChance = false,
			ot = 6112783,
			productId = Assets.productId.ShadowMewtwo,
		},
	}

	-- Validate
	local def = defs[monType]
	if not def then
		return false, "invalid_mon"
	end

	if giftMode then
		familiars = self:newFamiliars(def)
		local familaName = familiars:getName()

		local gifterName = (gifter and gifter.Name) or "Someone"

		local sentToPC = false
		local box

		if #self.party >= 6 then
			box = self:PC_sendToStore(familiars)
			sentToPC = true
		else
			table.insert(self.party, familiars)
		end

		local message = string.format(
			"<b><font color=\"#9B59B6\">🎁 %s gifted <font color=\"#F1C40F\">%s</font> to <font color=\"#1ABC9C\">%s</font>!</font></b>",
			gifterName,
			familaName,
			self.player.Name
		)

		_f.Network:postAll("SystemChat", message)

		return {
			n = familaName,
			i = familiars:getIcon(),
			s = familiars.shiny,
			d = nil,
			gift = true,
			toPC = sentToPC,
			box = box
		}
	end

	table.insert(self.ashGreninjaProductStack, function()
		if processed then return end

		familiars = self:newFamiliars(def)

		if #self.party >= 6 then
			sendToPC = true
			self:PC_sendToStore(familiars)
		end

		processed = true
	end)

	game:GetService("MarketplaceService"):PromptProductPurchase(self.player, def.productId)

	for i = 1, 40 do
		task.wait(0.5)
		if processed then break end
	end

	if not processed then
		return "to"
	end

	if not familiars then
		return false, "failed"
	end

	return {
		d = self:createDecision {
			callback = function(_, nickname)
				if typeof(nickname) == "string" then
					familiars:giveNickname(nickname)
				end

				local box = self:caughtFamiliars(familiars)
				if box then
					return familiars:getName() .. " has been transferred to Box " .. box .. "!"
				end
			end
		},
		i = familiars:getIcon(),
		s = familiars.shiny,
		n = familiars:getName(),
	}
end

function PlayerData:completedEggCycle()
	local now = tick()
	local duration = tick()-self.lastCompletedEggCycle
	local maxStepTime = (self.currentHoverboard~='' and self.hoverboardModel) and (self.currentHoverboard:sub(1,6)=='Basic ' and 20 or 15) or 30
	if duration < maxStepTime then--30 then
		-- TODO
		return
	end
	self.lastCompletedEggCycle = now

	local party = self.party
	self:Daycare_tryBreed()
	local reduceBy = 1
	for _, p in pairs(party) do
		local a = p:getAbilityName()
		if not p.egg and (a == 'Flame Body' or a == 'Magma Armor') then
			reduceBy = 2
			break
		end
	end
	reduceBy = reduceBy * (1 + self:ROPowers_getPowerLevel(2, true))
	for _, p in pairs(party) do
		if p.egg then
			if not p.fossilEgg then
				p.eggCycles = p.eggCycles - reduceBy
			end
		else
			p:addHappiness(2, 2, 1)
		end
	end
	self:checkForHatchables()
	-- add 256 Exp. to Familiars in the Day Care
	for _, p in pairs(self.daycare.depositedFamiliars) do
		p.experience = p.experience + 256
	end
end

function PlayerData:setFamiliarsBall(partyIndex, ballId)
	local familiars = self.party[partyIndex]
	if not familiars then return false end

	if familiars.egg then return false end

	if ballId < 1 or ballId > 31 then 
		return false 
	end

	familiars.pokeball = ballId

	return true
end



function PlayerData:rearrangeMoves(familiarsIndex, arrangedMoves)
	if type(familiarsIndex) ~= 'number' then return end    
	if familiarsIndex < 1 then return end
	if self:isInBattle() then return end
	if not self.party[familiarsIndex] then return end
	if self.party[familiarsIndex].egg then return end

	local famila = self.party[familiarsIndex]

	local newMoves = {}
	local valid = 1

	for _, oldmove in pairs(famila.moves) do
		if not table.find(arrangedMoves, oldmove.id) then 
			warn("Cannot find", oldmove.id, 'in new index') 
			valid = nil
			return
		end    
		newMoves[table.find(arrangedMoves, oldmove.id)] = Functions.deepcopy(oldmove)
		valid = valid + 1
	end

	if valid == 5 then
		famila.moves = newMoves
	else
		return
	end
end

function PlayerData:rearrangeParty(indices)
	if self:isInBattle() then return end
	local nParty = #self.party
	if #indices ~= nParty then return end
	local ii = {}
	local vv = {}
	for i, v in pairs(indices) do
		if type(i) ~= 'number' or i > nParty or type(v) ~= 'number' or v > nParty then return end
		if ii[i] or vv[v] then return end -- clone attempt
		ii[i] = true
		vv[v] = true
	end
	for i = 1, nParty do if not ii[i] or not vv[i] then return end end
	local party = {}
	for i = 1, nParty do
		party[i] = self.party[indices[i]]
	end
	self.party = party
	local firstNonEgg = self:getFirstNonEgg()
	_f.Network:post('PDChanged', self.player, 'firstNonEggLevel', firstNonEgg.level,
		'firstNonEggAbility', firstNonEgg:getAbilityName())
end
local battleBagTypes = {
	normal = {
		pouches = {1, 2, 3, 4},
	},
	safari = {
		pouches = {4},
		modify = function(item)    
			if item.isBerry and item.isSafari then
				item.battleCategory = 1
			end

			return item
		end,    
	},
}

function PlayerData:getBattleBag()
	if not self:isInBattle() then return end

	local side, battle = _f.CombatEngine:getBattleSideForPlayer(self.player)
	local bags = {{},{},{}}
	local Type = "normal"

	if battle.isSafari then  
		Type = "safari"
	end

	local bagTypeData = battleBagTypes[Type]

	for i, n in pairs(bagTypeData.pouches) do
		for _, bd in pairs(self.bag[n]) do
			local item = Functions.deepcopy(_f.Database.ItemByNumber[bd.num])

			if bagTypeData.modify then
				item = bagTypeData.modify(item)
			end    

			if item and item.battleCategory then
				table.insert(bags[item.battleCategory], {
					id = item.id,
					name = item.name,
					icon = item.icon or item.num,
					qty = bd.quantity,
					desc = item.desc,
					isBerry = item.isBerry,
					bUse = item.isPokeball or type(item.onUse) == 'function',
					bCat = item.battleCategory
				})
			end
		end
	end

	return bags, Type
end

function PlayerData:getBagDataForTransfer(item, bd, context) -- helper function
	local itemId = item.id
	local canUse
	local usableItemClient = UsableItemsClient[itemId]
	if not usableItemClient or not usableItemClient.canUse then
		local usableItemServer = _f.UsableItems[itemId]
		if usableItemServer then
			local s_canUse = usableItemServer.canUse
			if s_canUse then
				if type(s_canUse) == 'function' then
					canUse = {}
					for i, p in pairs(self.party) do
						canUse[tostring(i)] = s_canUse(p) -- stupid table limitations...
					end
				else
					canUse = s_canUse
				end
			end
		end
	end
	return {
		id = itemId,
		name = item.name,
		icon = item.icon or item.num,
		qty = (item.bagCategory~=5 or item.showsQuantity) and bd.quantity or nil,
		desc = item.desc,
		canUse = canUse, -- true or false or a table of true/false (1 for each familiars in party)
		-- ^ exists when UsableItemsServer has a canUse function but UsableItemsClient doesn't

		sell = (context=='sell' and item.sellPrice or nil),
	}
end

function PlayerData:getBagPouch(n, context)
	-- Ensure self.bag exists and pouch n is a table
	local bdList = nil
	if type(self.bag) == "table" then
		bdList = self.bag[n]
	end
	if type(bdList) ~= "table" then
		-- No items in this pouch (or pouch index invalid); return empty
		return {}
	end

	local pouch = {}
	local count = 0
	for _, bd in pairs(bdList) do
		-- bd should be a bag data entry with bd.num etc.
		local item = _f.Database.ItemByNumber[bd.num]
		count = count + 1
		pouch[count] = self:getBagDataForTransfer(item, bd, context)
	end
	return pouch
end


function PlayerData:getTMs()
	local list = {}

	local partyKnownMoves = {}
	local partyLearnedMachines = {}
	for i, p in pairs(self.party) do
		local k = {}
		local l = {}
		if not p.egg then
			for _, move in pairs(p:getMoves()) do
				k[move.num] = true
			end
			pcall(function()
				for _, num in pairs(p:getLearnedMoves().machine) do
					l[num] = true
				end
			end)
		end
		partyKnownMoves[i] = k
		partyLearnedMachines[i] = l
	end

	local buffer = BitBuffer.Create()
	local function add(str, isHMs)
		buffer:FromBase64(str)
		local data = _f.Database.Machines[isHMs and 'hms' or 'tms']
		for m = 1, str:len()*6 do
			if buffer:ReadBool() then
				local moveId = data[m]
				local move = _f.Database.MoveById[moveId]
				local moveNum = move.num
				local canLearn = {}
				for i, p in pairs(self.party) do
					canLearn[i] = (partyKnownMoves[i][moveNum] and 2) or (partyLearnedMachines[i][moveNum] and 1) or 0
				end
				list[#list+1] = {
					mName = move.name,
					num = m,
					hm = isHMs,
					type = move.type,
					desc = move.category..', '..move.type..'-type, '..(move.basePower or 0)..' Power,\n'..(move.accuracy==true and '--' or ((move.accuracy or 0)..'%'))..' Accuracy'..((move.desc and move.desc~='') and ('. Effect: '..move.desc) or ''),
					learn = canLearn
				}
			end
		end
	end
	add(self.tms)
	add(self.hms, true)

	return list
end

function PlayerData:teachTM(familiarsIndex, tmNum, isHM)
	-- verify arguments
	local moveId;  pcall(function() moveId  = _f.Database.Machines[isHM and 'hms' or 'tms'][tmNum] end)
	local familiars; pcall(function() familiars = self.party[familiarsIndex] end)
	if not moveId or not familiars or familiars.egg then return false end
	-- verify player owns TM/HM
	if not BitBuffer.GetBit(isHM and self.hms or self.tms, tmNum) then return false end
	-- verify familiars can learn TM/HM
	local canLearn = false
	pcall(function()
		local moveNum = _f.Database.MoveById[moveId].num
		for _, num in pairs(familiars:getLearnedMoves().machine) do
			if num == moveNum then
				canLearn = true
				break
			end
		end
	end)
	if not canLearn then return false end
	-- verify familiars doesn't already know the move
	for _, move in pairs(familiars.moves) do
		if move.id == moveId then
			return false
		end
	end
	-- learn immediately if there is space
	if #familiars.moves < 4 then
		familiars.moves[#familiars.moves+1] = {id = moveId}
		return true
	end
	-- gather data about known moves and the move to learn
	local moves = {}
	local function add(move)
		moves[#moves+1] = {
			name = move.name,
			category = move.category,
			type = move.type,
			power = move.basePower,
			accuracy = move.accuracy,
			pp = move.pp,
			desc = move.desc
		}
	end
	for _, move in pairs(familiars.moves) do
		if move.id == moveId then return false end -- make sure move is not already known
		add(_f.Database.MoveById[move.id])
	end
	add(_f.Database.MoveById[moveId])
	-- send data & new decision id to player
	return moves, self:createDecision {
		callback = function(_, moveSlot)
			if type(moveSlot) ~= 'number' or moveSlot < 1 or moveSlot > 4 then return end
			familiars.moves[math.floor(moveSlot)] = {id = moveId}
		end
	}
end

function PlayerData:ReturnMoves(moves)
	local Moves = {}		
	for _,v in pairs(moves) do
		for i,m in pairs(v) do
			if typeof(m) == 'string' then
				table.insert(Moves,m)
			end
		end
	end	
	return Moves
end
function PlayerData:CheckBanlist(Tier)
	self.format = Tier

	if Tier == "AG" then
		return true
	end

	local seenSpecies = {}

	-- 🔹 Global Move Bans
	local MoveBans = {
		doubleteam = true,
		batonpass = true,
		dragonascent = true,
		minimize = true,
		shedtail = true,
		fissure = true,
		sheercold = true,
		guillotine = true,
		horndrill = true,
		lastrespects = true,
		terablast = true,
		assist = true,
	}

	-- 🔹 Global Item Bans
	local ItemBans = {
		brightpowder = true,
		kingsrock = true,
		razorfang = true,
		quickclaw = true,
		alakazite = true,
		blastoisinite = true,
		blazikenite = true,
		gengarite = true,
		kangaskhanite = true,
		lucarionite = true,
		metagrossite = true,
		salamencite = true,
		magearnite = true,
		zygardeite = true,
		baxcalibrite = true,
		lucarionitez = true,
		garchompitez = true,
	--	golisopodite = true,
		raichitey    = true,
		clefablite   = true,
		sawsbuckcoffee   = true,
		souldew   = true,
		zeraorite  = true
	}

	-- 🔹 Global Ability Bans
	local AbilityBans = {
		shadowtag = true,
		arenatrap = true,
		moody = true,
		powerconstruct = true,
	}

	-- 🔹 Tier Adjustments
	if Tier == "UU" then
		ItemBans["lightclay"] = true
		AbilityBans["drizzle"] = true
	end

	if Tier == "Ubers" then
		AbilityBans["shadowtag"] = nil
		AbilityBans["arenatrap"] = nil
		MoveBans["shedtail"] = nil
	end

	if Tier == "UUbers" then
		MoveBans["shedtail"] = nil
	end

	-- 🔹 Load Tier Banlists
	local tierOrder = {"Ubers", "UUbers", "OU", "UU"}
	local banlists = {}

	for _, format in ipairs(tierOrder) do
		banlists[format] = require(game.ServerStorage.Registry.ColoBanlist[format])
	end

	-- 🔹 Validate Party
	for _, famila in pairs(self.party) do

		local species = string.lower(famila.name)
		local form = (famila.forme and famila.forme ~= "" and famila.forme) or "Base"
		local speciesKey = species .. ":" .. form

		-- Species Clause
		if seenSpecies[speciesKey] then
			return false, "You cannot use more than one Familiars with the same name and form."
		end
		seenSpecies[speciesKey] = true

		-- Moves
		local moves = self:ReturnMoves(famila.moves)
		for _, move in pairs(moves) do
			local moveId = string.lower(move)
			if MoveBans[moveId] then
				return false,
					famila.name .. " with the move " ..
					(_f.Database.MoveToName[moveId] or move) ..
					" is banned in this format."
			end
		end

		-- Ability
		local abilityName = famila:getAbilityName()
		if abilityName then
			local abilityId = string.lower(abilityName:gsub("%s+", ""))
			if AbilityBans[abilityId] then
				return false,
					famila.name .. " with the ability " ..
					abilityName ..
					" is banned in this format."
			end
		end

		-- Item
		local heldItem = famila:getHeldItem()
		if heldItem and typeof(heldItem.id) == "string" then
			local itemId = string.lower(heldItem.id)
			if ItemBans[itemId] then
				return false,
					"The item " .. (heldItem.name or itemId) ..
					" is banned in this format."
			end
		end

		-- Familiars-Specific Bans
		for _, format in ipairs(tierOrder) do
			local bn = banlists[format]

			for _, entry in pairs(bn) do
				if string.lower(entry.name) == species then

					-- 🔹 Banned moves
					if entry.moves then
						for _, move in pairs(moves) do
							if string.lower(entry.moves) == string.lower(move) then
								return false,
									famila.name .. " with the move " ..
									(_f.Database.MoveToName[move] or move) ..
									" is banned in this format."
							end
						end
					end

					-- 🔹 Banned items
					if entry.item and heldItem and heldItem.id and typeof(heldItem.id) == "string" then
						if string.lower(entry.item) == string.lower(heldItem.id) then
							return false,
								famila.name ..
								" is holding an item that is banned in this format."
						end
					end


					local familaForme = (famila.forme and famila.forme ~= "" and famila.forme) or "Base"

					if entry.forme and entry.forme ~= "" then
						if entry.forme == familaForme then
							return false,
								famila.name .. " in its " ..
								familaForme ..
								" form is banned in this format."
						end
					else
						if entry.tier == "ALL" then
							return false,
								famila.name ..
								" is banned in this format."
						end
					end
				end
			end

			if format == Tier then break end
		end
	end

	return true
end

function PlayerData:hasBL()
	return false
end
function PlayerData:teamLog()
	local mon
	local team = {}

	local eligible = self:CheckBanlist(self.format)

	local function capitalizeFirst(str)
		return string.upper(string.sub(str, 1, 1)) .. string.sub(str, 2)
	end

	if self.format == 'Ubers' or self.format == 'AG' or not eligible then
		return
	else
		for num, famila in pairs(self.party) do
			local monString = ''
			local moveString = '{'
			local evString = ''
			local ivString = ''
			mon = {
				name = famila.name,
				ability = famila:getAbilityName(),
				item = famila:getHeldItem().name or "None",
				nature = famila:getNature().name,
				evs = famila.evs,
				ivs = famila.ivs,
				moves = self:ReturnMoves(famila.moves)
			}
			for i in ipairs(mon.moves) do
				moveString ..= mon.moves[i] .. ", "
			end
			moveString ..= "}"
			for i in ipairs(mon.evs) do
				if i == 1 then
					evString ..= "{"
				end
				if i == 6 then
					evString ..= mon.evs[i] .. "}"
					break
				end
				evString ..= mon.evs[i] .. ", "
			end
			for i in ipairs(mon.ivs) do
				if i == 1 then
					ivString ..= "{"
				end
				if i == 6 then
					ivString ..= mon.ivs[i] .. "}"
					break
				end
				ivString ..= mon.ivs[i] .. ", "
			end
			if famila.forme and famila.forme ~= '' then
				mon.name = famila.name .. '-' .. famila.forme 
			end
			if famila:getHeldItem().megaStone and string.find(famila:getHeldItem().megaStone, mon.name) then
				mon.name = famila:getHeldItem().megaStone
			end
			if famila.forme == 'bb' then
				mon.name = 'Greninja-Ash'
			end
			local orderedKeys = {'name', 'item', 'ability', 'nature', 'evs', 'ivs', 'moves'}
			for _, key in ipairs(orderedKeys) do
				local value = mon[key]
				if key == 'moves' then
					monString ..= 'Moves: ' .. moveString .. "\n"
				elseif key == 'evs' then
					monString ..= 'EVs: ' .. evString .. "\n"
				elseif key == 'ivs' then
					monString ..= 'IVs: ' .. ivString .. "\n"
				else
					monString ..= capitalizeFirst(tostring(key)) .. ": " .. tostring(value) .. "\n"
				end
			end
			team[mon.name] = monString
		end
	end
	_f.Logs:logBattle(self.player, team, self.format)
	return team
end

function PlayerData:setFormat(format)
	if format then self.format = format end
	return self.format or 'AG'
end

function PlayerData:getFormat()
	return self.format or 'AG'
end
function PlayerData:useItem(itemId, targetIndex, _index)
	if not itemId or type(itemId) ~= 'string' then return false end

	local usableItemServer = _f.UsableItems[itemId]
	local usableItemClient = UsableItemsClient[itemId]

	local hasTarget = not ((usableItemServer and usableItemServer.noTarget) or (usableItemClient and usableItemClient.noTarget))
	local consume = not ((usableItemServer and usableItemServer.nonConsumable) or (usableItemClient and usableItemClient.nonConsumable))

	if (targetIndex ~= nil) ~= (hasTarget and true or false) then return false end

	local target
	if hasTarget then
		target = self.party[targetIndex]
		if not target then return false end
	end

	local item = _f.Database.ItemById[itemId]
	if not item then return false end

	local bd = self:getBagDataByNum(item.num)
	if not bd or not bd.quantity or bd.quantity < 1 then return false end

	if usableItemServer and usableItemServer.canUse then
		local allowed
		if usableItemServer.canUse == true then
			allowed = true
		elseif type(usableItemServer.canUse) == 'function' then
			allowed = usableItemServer.canUse(target, _index)
		end
		if not allowed then
			return false
		end
	end

	local used
	if usableItemServer and usableItemServer.onUse then
		used = usableItemServer.onUse(target, _index)
		if used == false then return false end
	end

	if consume then
		local _, bd = self:incrementBagItem(item.num, -1)
		if itemId:match('repel$') then
			return (bd and bd.quantity and bd.quantity > 0) and 1 or 0
		end
	end

	if usableItemServer and usableItemServer.fuseInfo then
		return used
	end

	return used, (target and target:getPartyData({}))
end

function PlayerData:isAdventure()
	return game.PlaceId == Assets.placeId.Main
end
function PlayerData:getPublicServers(placeId, cursor)
	local HttpService = game:GetService("HttpService")

	if typeof(placeId) ~= "number" then
		return false, "Invalid placeId.", "", {}
	end

	local allowed = {
		[Assets.placeId.Main] = true,
		[Assets.placeId.Battle] = true,
		[Assets.placeId.Trade] = true,
	}

	if not allowed[placeId] then
		return false, "Place not allowed.", "", {}
	end

	cursor = tostring(cursor or "")


	local url = "http://145.223.74.141:3015/roblox/servers?placeId=" .. tostring(placeId)
	if cursor ~= "" then
		url = url .. "&cursor=" .. HttpService:UrlEncode(cursor)
	end

	local ok, response = pcall(function()
		return HttpService:RequestAsync({
			Url = url,
			Method = "GET",
			Headers = {
				["Content-Type"] = "application/json",
				["x-api-key"] = "sdkjnbfllsikgnsdljkfndlkhjgbhdsjfbndjklfnisdkngsdhfjkllnbgdsljkbnflisdkn",
			},
		})
	end)

	if not ok then
		warn("[getPublicServers] request threw:", response)
		return false, "Server list is unavailable right now.", "", {}
	end

	if typeof(response) ~= "table" then
		warn("[getPublicServers] invalid response object")
		return false, "Server list is unavailable right now.", "", {}
	end

	if not response.Success then
		warn(
			"[getPublicServers] proxy http error:",
			response.StatusCode,
			response.StatusMessage,
			response.Body
		)

		if response.StatusCode == 429 then
			return false, "Server list is cooling down. Try again in a few seconds.", "", {}
		end

		if response.StatusCode == 502 or response.StatusCode == 503 or response.StatusCode == 504 then
			return false, "Server list is temporarily unavailable.", "", {}
		end

		if response.StatusCode == 403 then
			return false, "Server browser authorization failed.", "", {}
		end

		return false, "Failed to fetch servers.", "", {}
	end

	if typeof(response.Body) ~= "string" or response.Body == "" then
		warn("[getPublicServers] empty body")
		return false, "Invalid server response.", "", {}
	end

	local decodedOk, body = pcall(function()
		return HttpService:JSONDecode(response.Body)
	end)

	if not decodedOk or typeof(body) ~= "table" then
		warn("[getPublicServers] bad json:", response.Body)
		return false, "Invalid server response.", "", {}
	end

	if not body.ok then
		local err = tostring(body.error or "Server query failed.")

		if err:lower():find("rate") then
			err = "Server list is cooling down. Try again in a few seconds."
		end

		return false, err, "", {}
	end

	local servers = {}
	for _, server in ipairs(body.servers or {}) do
		if typeof(server) == "table" and server.jobId then
			servers[#servers + 1] = {
				jobId = tostring(server.jobId),
				playing = tonumber(server.playing) or 0,
				maxPlayers = tonumber(server.maxPlayers) or 0,
				ping = tonumber(server.ping) or 0,
				fps = tonumber(server.fps) or 0,
				placeId = tonumber(server.placeId) or placeId,
			}
		end
	end

	if body.rateLimited and body.stale then
		warn("[getPublicServers] using stale cached servers due to rate limit for placeId", placeId)
	elseif body.stale then
		warn("[getPublicServers] using stale cached servers for placeId", placeId)
	end

	return true, "", tostring(body.nextCursor or ""), servers
end

function PlayerData:giveItem(itemId, familiarsIndex)
	if not itemId or type(itemId) ~= 'string' or not familiarsIndex or type(familiarsIndex) ~= 'number' then print('err 1') return false end

	if itemId == "safariball" then 
		if require(storage.Registry.Encounters)[self.currentChunk].isSafari or not self:isAdventure() then
			return false, "sf" 
		end	
	end

	local item = _f.Database.ItemById[itemId]
	local familiars = self.party[familiarsIndex]
	if not item or not familiars or familiars.egg then print('no item no familiars') return false end
	if item.bagCategory == 6 then  --zmove
		local mon = self.party[familiarsIndex]
		if not mon:canUseZCrystal(itemId) then 
			return false, 'nocrystal'
		end
	end
	if not item.bagCategory or (item.bagCategory == 5) then print('invalid bagcategory') return false end -- check whether it can even be held
	if not item.zMove then
		if not self:incrementBagItem(item.num, -1) then print('no increment') return false end
	end
	local taking = familiars:getHeldItem()
	local takenBD
	if taking.num then
		local s, r = self:incrementBagItem(taking.num, 1)
		if s then takenBD = r end
	end
	familiars.item = item.num
	return true, (takenBD and self:getBagDataForTransfer(taking, takenBD)), (takenBD and taking.bagCategory)
end
function PlayerData:ensureTradeSign(context)
	context = tostring(context or "adventure")
	if context ~= "trade" then
		return false
	end

	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local template = ReplicatedStorage:FindFirstChild("TradeSign")
	if not template or not template:IsA("Tool") then
		return false
	end

	local backpack = self.player:FindFirstChild("Backpack")
	if not backpack then
		return false
	end

	local char = self.player.Character
	if backpack:FindFirstChild("TradeSign") or (char and char:FindFirstChild("TradeSign")) then
		return true
	end

	local tool = template:Clone()
	tool.Parent = backpack

	local savedText = self.tradeSignText or "Trading!"

	local board = tool:FindFirstChild("Board")
	if board then
		for _, gui in ipairs(board:GetChildren()) do
			if gui:IsA("SurfaceGui") then
				local label = gui:FindFirstChildWhichIsA("TextLabel")
				if label then
					label.Text = savedText
				end
			end
		end
	end

	return true
end

function PlayerData:removeTradeSign()
	local backpack = self.player:FindFirstChild("Backpack")
	if backpack then
		local tool = backpack:FindFirstChild("TradeSign")
		if tool then
			tool:Destroy()
		end
	end

	local char = self.player.Character
	if char then
		local tool = char:FindFirstChild("TradeSign")
		if tool then
			tool:Destroy()
		end
	end

	return true
end

function PlayerData:takeItem(familiarsIndex)
	if not familiarsIndex or type(familiarsIndex) ~= 'number' then return false end
	local familiars = self.party[familiarsIndex]
	if not familiars or familiars.egg then return false end
	local item = familiars:getHeldItem()
	if not item.num then return false end
	if item.zMove then
		familiars.item = nil
		return true
	else
		local s, bd = self:incrementBagItem(item.num, 1)
		if not s then return false end
		familiars.item = nil
		return true, self:getBagDataForTransfer(item, bd), item.bagCategory
	end
end

function PlayerData:tossItem(itemId, amount) 
	if not itemId or type(itemId) ~= 'string' or not amount or type(amount) ~= 'number' or amount < 1 then return false end
	local item = _f.Database.ItemById[itemId]
	if not item or not item.bagCategory or item.bagCategory > 4 or itemId == 'masterball' or item.zMove then return false end -- check whether it can be tossed
	if not self:incrementBagItem(item.num, -amount) then return false end
	return true
end

function PlayerData:deleteMove(familiarsIndex)
	if not familiarsIndex or not self.party[familiarsIndex] then return end
	local familiars = self.party[familiarsIndex]
	if familiars.egg then return 0, 'eg' end
	if #familiars.moves == 0 then return 0, '0m' end
	if #familiars.moves == 1 then return familiars.name, '1m' end
	return familiars.name, {
		moves = familiars:getCurrentMovesData(),
		d = self:createDecision {
			callback = function(_, moveslot)
				if not moveslot or not familiars.moves[moveslot] then return end
				table.remove(familiars.moves, moveslot)
			end
		}
	}
end

function PlayerData:remindMove()
	local heartscale = _f.Database.ItemById.heartscale
	local nHeartScales = 0
	pcall(function() nHeartScales = self:getBagDataByNum(heartscale.num, 1).quantity end)
	return {
		hsi = heartscale.icon or heartscale.num,
		nhs = nHeartScales,
		money = self.money,
		d = self:createDecision {
			callback = function(_, familiarsIndex)
				if not familiarsIndex or not self.party[familiarsIndex] then return end
				local familiars = self.party[familiarsIndex]
				if familiars.egg then return 0, 'eg' end

				local learnedMoves
				pcall(function() learnedMoves = familiars:getLearnedMoves() end)

				local moves = {}
				local eggLookup = {}

				if learnedMoves then

					if learnedMoves.levelUp then
						local level = familiars.level
						for _, d in pairs(learnedMoves.levelUp) do
							if level < d[1] then break end
							for i = 2, #d do
								table.insert(moves, d[i])
							end
						end
					end

					if learnedMoves.egg and familiars.eggGroup ~= "Undiscovered" then
						for _, moveNum in pairs(learnedMoves.egg) do
							table.insert(moves, moveNum)
							eggLookup[moveNum] = true
						end
					end


					-- remove duplicate moves
					for i, move in pairs(moves) do
						for j = #moves, i+1, -1 do
							if move == moves[j] then
								table.remove(moves, j)
							end
						end
					end
					-- remove currently known moves
					for _, move in pairs(familiars:getMoves()) do
						for j = #moves, 1, -1 do
							if move.num == moves[j] then
								table.remove(moves, j)
								break
							end
						end
					end
				end
				if #moves == 0 then return familiars.name, 'nm' end
				local validMovesNumToId = {}
				for i, moveNum in pairs(moves) do
					local move = _f.Database.MoveByNumber[moveNum]
					moves[i] = {
						num = move.num,
						name = move.name,
						category = move.category,
						type = move.type,
						power = move.basePower,
						accuracy = move.accuracy,
						pp = move.pp,
						desc = move.desc
					}
					validMovesNumToId[moveNum] = move.id
				end

				return familiars.name, {
					nn = familiars:getName(),
					known = familiars:getCurrentMovesData(),
					moves = moves,
					d = self:createDecision {
						callback = function(_, paymentMethod, moveNum, moveSlot)
							if (paymentMethod ~= 1 and paymentMethod ~= 2)
								or (moveSlot ~= 1 and moveSlot ~= 2 and moveSlot ~= 3 and moveSlot ~= 4) then
								return
							end
							local moveId = validMovesNumToId[moveNum]
							if not moveId then return end
							if paymentMethod == 1 then
								if not (self:incrementBagItem(heartscale.num, -1)) then return end
							else
								if not (self:addMoney(-5000)) then return end
							end
							familiars.moves[moveSlot] = {id = moveId}
						end
					}
				}
			end
		}
	}
end


function PlayerData:moveTutor()

	return {
		d = self:createDecision {
			callback = function(_, familiarsIndex)
				if not familiarsIndex or not self.party[familiarsIndex] then return end
				local familiars = self.party[familiarsIndex]
				if familiars.egg then return 0, 'eg' end

				local learnedMoves
				pcall(function() learnedMoves = familiars:getLearnedMoves() end)
				local moves = {}
				if learnedMoves then

					if learnedMoves.levelUp then
						for _, entry in pairs(learnedMoves.levelUp) do
							for i = 2, #entry do
								table.insert(moves, entry[i])
							end
						end
					end

					if learnedMoves.machine then
						for _, moveNum in pairs(learnedMoves.machine) do
							table.insert(moves, moveNum)
						end
					end

					if learnedMoves.egg then
						local eggGroup = familiars.eggGroup
						if eggGroup ~= "Undiscovered" then
							for _, moveNum in pairs(learnedMoves.egg) do
								table.insert(moves, moveNum)
							end
						end
					end


					-- Evolution moves
					if learnedMoves.evolve then
						table.insert(moves, learnedMoves.evolve)
					end

					-- remove duplicate moves
					for i, move in pairs(moves) do
						for j = #moves, i+1, -1 do
							if move == moves[j] then
								table.remove(moves, j)
							end
						end
					end
					-- remove currently known moves
					for _, move in pairs(familiars:getMoves()) do
						for j = #moves, 1, -1 do
							if move.num == moves[j] then
								table.remove(moves, j)
								break
							end
						end
					end
				end
				if #moves == 0 then return familiars.name, 'nm' end
				local validMovesNumToId = {}
				for i, moveNum in pairs(moves) do
					if type(moveNum) == 'number' then
						local move = _f.Database.MoveByNumber[moveNum]
						if move then
							moves[i] = {
								num = move.num,
								name = move.name,
								category = move.category,
								type = move.type,
								power = move.basePower,
								accuracy = move.accuracy,
								pp = move.pp,
								desc = move.desc
							}
							validMovesNumToId[moveNum] = move.id
						else
							warn("[MoveTutor] Move number not found: " .. tostring(moveNum))
							moves[i] = nil
						end
					elseif type(moveNum) == 'table' and moveNum.id then
						validMovesNumToId[moveNum] = moveNum.id
					else
						moves[i] = nil
					end
				end

				local function getMoveData(id)
					if not id then
						warn("[getMoveData] Called with nil id")
						return nil
					end

					if type(id) == "number" then
						return _f.Database.MoveByNumber[id]
					elseif type(id) == "string" then
						return _f.Database.MoveById[id]
					else
						warn("[getMoveData] Invalid id type: " .. typeof(id))
						return nil
					end
				end

				return familiars.name, {
					nn = familiars:getName(),
					known = familiars:getCurrentMovesData(),
					moves = moves,
					d = self:createDecision {
						callback = function(_, moveNum, moveSlot)
							if (moveSlot ~= 1 and moveSlot ~= 2 and moveSlot ~= 3 and moveSlot ~= 4) then return end

							local moveId = validMovesNumToId[moveNum]
							if not moveId or type(moveId) ~= "string" then
								warn("[MoveTutor] Invalid moveId at slot " .. tostring(moveSlot) .. ": " .. tostring(moveId))
								return
							end

							local moveData = getMoveData(moveId)
							if not moveData or not moveData.pp then
								warn("[MoveTutor] Tried to teach invalid move: " .. tostring(moveId))
								return
							end
							familiars.moves[moveSlot] = {
								id = moveId,
								pp = moveData.pp,
								ppup = 0
							}
						end
					}
				}
			end
		}
	}
end


local getShop = require(script.GetShop)
function PlayerData:getShop(shopId)
	local items, other = getShop(self, shopId)
	if not items then return false end
	self.currentShop = items
	return items, other
end


function PlayerData:maxBuyInternal(itemId)
	if not self.currentShop then return false end
	pcall(function() itemId = Functions.rc4(itemId) end)
	if type(itemId) ~= 'string' then return false end
	local item = _f.Database.ItemById[itemId]
	if not item then return false end
	local price
	for _, l in pairs(self.currentShop) do
		if Functions.rc4(l[1]) == itemId then
			price = l[2]
			break
		end
	end
	if not price then return false end
	local currentQty = 0
	local bd = self:getBagDataByNum(item.num)
	if bd then
		currentQty = bd.quantity or 0
	end
	if currentQty >= 999   then return 'fb' end -- full bag
	if self.money < price then return 'nm' end -- not enough money
	return math.min(999-currentQty, math.floor(self.money/price)), item, price
end
function PlayerData:maxBuy(itemId) -- rc4'd (from client)
	return (self:maxBuyInternal(itemId)) -- return single value to client
end

function PlayerData:buyItem(itemId, qty) -- rc4'd
	local max, item, price = self:maxBuyInternal(itemId)
	if type(max) ~= 'number' or not item or not price or qty > max or qty < 1 then return false end
	qty = math.floor(qty)
	if not self:addMoney(-price*qty) then return false end
	self:addBagItems{num = item.num, quantity = qty}
	local givePremierBall = false
	if item.isPokeball and qty > 9 then
		self:addBagItems{id = 'premierball', quantity = 1}
		givePremierBall = true
	end
	return true, givePremierBall
end

function PlayerData:needsRagingThunderObby()
	return self.ragingThunderObbyComplete ~= true
end

function PlayerData:completeRagingThunderObby()
	local player = self.player
	if not player then
		return false
	end

	local success, err = pcall(function()
		RTObbyStore:UpdateAsync(getRTKey(player), function(oldValue)
			return true
		end)
	end)

	if success then
		self.ragingThunderObbyComplete = true
		return true
	else
		warn("Failed to save RT Obby completion:", err)
		return false
	end
end

function PlayerData:bMaxBuyInternal(shopIndex)
	if not self.currentShop then return false end
	local itemIdPricePair = self.currentShop[shopIndex]
	if type(itemIdPricePair) ~= 'table' then return false end
	local itemId = itemIdPricePair[1]
	if type(itemId) ~= 'string' then return false end
	local price = itemIdPricePair[2]
	if type(price) ~= 'number' then return false end
	if itemId:sub(1, 2) == 'BP' then return false end -- assumption: no items sold here later will start with "BP"
	local tmNum = itemId:match('^TM(%d+)')
	if tmNum then
		tmNum = tonumber(tmNum)
		if BitBuffer.GetBit(self.tms, tmNum) then return 'ao' end -- already own
		if self.bp < price then return 'nm' end
		return 'tm', tonumber(tmNum), price
	end
	local item = _f.Database.ItemById[itemId]
	if not item then return false end
	local currentQty = 0
	local bd = self:getBagDataByNum(item.num)
	if bd then
		currentQty = bd.quantity or 0
	end
	if currentQty >= 999 then return 'fb' end -- full bag
	if self.bp < price  then return 'nm' end -- not enough money
	return math.min(999-currentQty, math.floor(self.bp/price)), item, price
end
function PlayerData:bMaxBuy(shopIndex)
	return (self:bMaxBuyInternal(shopIndex))
end

function PlayerData:buyWithBP(shopIndex, qty)
	local max, item, price = self:bMaxBuyInternal(shopIndex)
	if max == 'tm' then
		self:obtainTM(item)
		self.bp = self.bp - price
		return true, self.bp
	end
	if not item or type(max) ~= 'number' or type(qty) ~= 'number' or max < qty or qty < 1 then return false end
	qty = math.floor(qty)
	self.bp = self.bp - price*qty
	self:addBagItems{num = item.num, quantity = qty}
	return true, self.bp
end
local function getEffectiveSellPrice(self, item)
	if not item or type(item.sellPrice) ~= "number" then
		return 0
	end

	local price = item.sellPrice
	if self:HasLicense() then
		price = math.floor(price * 0.8)
	end

	return math.max(0, price)
end
function PlayerData:sellItem(itemId, qty)
if type(itemId) ~= 'string' or type(qty) ~= 'number' or qty < 1 then return false end

local item = _f.Database.ItemById[itemId]
if not item or type(item.sellPrice) ~= 'number' then return false end

local bd = self:getBagDataByNum(item.num)
qty = math.floor(qty)
if not bd or not bd.quantity or bd.quantity < 1 or qty > bd.quantity then return false end

local sellPrice = getEffectiveSellPrice(self, item)
if not self:addMoney(qty * sellPrice) then return 'fw' end

self:incrementBagItem(item.num, -qty)
return self.money
end

function PlayerData:resetForTitleScreen()
	if self:isInBattle() or self:isInTrade() then
		return false
	end

	self:resetLoadedSaveState()

	self.gameBegan = false
	self.noData = nil
	self.DataCache = nil
	self.gamemode = "adventure"

	self.starterProductStack = {}
	self.ashGreninjaProductStack = {}
	self.lottoTicketProductStack = {}
	self.hoverboardProductStack = {}

	return true
end


function PlayerData:obtainItem(id)
	if not self.currentObtainableItems then return end
	local item = self.currentObtainableItems[id]
	if not item then return end
	self.currentObtainableItems[id] = nil -- no repeat obtains
	if type(item) == 'number' then
		-- TM
		self:obtainTM(item)
		return 'TM'..(item<10 and '0' or '')..item
	elseif type(item) == 'table' then
		-- item
		local oin = item[2]
		item = _f.Database.ItemById[item[1] ]
		if not item then return end
		self.obtainedItems = BitBuffer.SetBit(self.obtainedItems, oin, true)
		self:addBagItems({num = item.num, quantity = 1})
		return item.name
	end
end

function PlayerData:makeDecision(id, ...)
	if not id or type(id) ~= 'number' then return false end
	local data = self.decision_data[id]
	if not data then return false end
	local ret = {data.callback(data, ...)}
	if ret[1] == false then return false end
	self.decision_data[id] = false
	return unpack(ret)
end

function PlayerData:openPC()
	if self.pcSession then
		self.pcSession:close()
	end
	if self:isInBattle() then return end
	local newSession = _f.PCService:new(self)
	self.pcSession = newSession
	return newSession:getStartPacket()
end

function PlayerData:cPC(fn, ...)
	if type(fn) ~= 'string' then return end
	local pc = self.pcSession
	if not pc or not pc.public[fn] then return end
	return pc[fn](pc, ...)
end

function PlayerData:closePC(id, ch)
	local pc = self.pcSession
	if not pc then return end
	if id and pc.id ~= id then return end
	local ret = pc:close(ch)
	self.pcSession = nil
	return ret
end

function PlayerData:createDecision(data)
	assert(data.callback ~= nil, 'decision must include a callback')
	local id = self.decision_count + 1
	self.decision_count = id
	self.decision_data[id] = data
	return id
end
function PlayerData:checkForHatchables(forceClear)
	for i, d in pairs(self.decision_data) do
		if d and d.hatch then
			if forceClear then
				self.decision_data[i] = false
			else
				return
			end
		end
	end

	-- Find next hatchable egg
	local nextEgg
	for _, p in ipairs(self.party) do
		if p.egg and not p.fossilEgg and p.eggCycles <= 0 then
			nextEgg = p
			break
		end
	end

	if not nextEgg then return end

	local id = self:createDecision {
		hatch = true,
		callback = function(_, nickname)
			self:onOwnFamiliars(nextEgg.num)
			nextEgg.egg = nil
			nextEgg.ot = self.userId
			if nickname and type(nickname) == "string" then
				nextEgg:giveNickname(nickname)
			end
			self:checkForHatchables(true) -- ✅ check next egg after current
		end
	}

	_f.Network:post('hatch', self.player, {
		d_id = id,
		eggIcon = nextEgg:getIcon(),
		pSprite = nextEgg:getSprite(true),
		pName = nextEgg.data.baseSpecies or nextEgg.data.species,
		pIcon = nextEgg:getIcon(true),
		pShiny = nextEgg.shiny and true or false
	})
end

function PlayerData:resetFishStreak()
	self.fishingStreak = 0
end

function PlayerData:getRegion()
	-- not perfect, just gives a best guess (can only be depended on when player is assumed to be outdoors)
	if not self.currentChunk then return end
	local chunkData = _f.Database.ChunkData[self.currentChunk]
	if chunkData then
		local onlyRegion
		for name in pairs(chunkData.regions) do
			if not onlyRegion then
				onlyRegion = name
			else
				onlyRegion = nil
				break
			end
		end
		if onlyRegion then return onlyRegion end
	end
	local map = storage.Maps:FindFirstChild(self.currentChunk)
	if not map then return end
	local regions = map:FindFirstChild('Regions')
	if not regions then return end
	local pos; pcall(function() pos = self.player.Character.HumanoidRootPart.Position end)
	if not pos then return end
	for _, part in pairs(regions:GetChildren()) do
		if part:IsA('BasePart') then
			if Region.FromPart(part):CastPoint(pos) then
				return part.Name
			end
		end
	end
end


function PlayerData:addMoney(amount)
	if amount < 0 and self.money+amount < 0 then return false end
	if amount > 0 and self.money > MAX_MONEY then return false end
	self.money = math.min(self.money + amount, MAX_MONEY)
	_f.Network:post('PDChanged', self.player, 'money', self.money)
	return true
end

function PlayerData:addBP(amount, showGui)
	self.bp = math.min(self.bp + amount, MAX_BP)
	if showGui then
		_f.Network:post('bpAwarded', self.player, amount, self.bp)
	end
end

function PlayerData:ownsGamePass(passId, mustReturnInstantly)
	if self.userId < 1 then return false end

	if type(passId) == 'string' then
		passId = Assets.passId[passId]
	end

	local evEditorPassId = Assets.passId.evEditor
	local hoverboardPassId = Assets.passId.hoverboards
	local genecapsuleId = Assets.passId.genecapsule
	local naturereshaperId = Assets.passId.naturereshaper

	local inGroup = self:GetGroup()
	local isSpecial = (passId == evEditorPassId or passId == hoverboardPassId or passId == genecapsuleId or passId == naturereshaperId)

	-- ✅ Verified users or group get all passes EXCEPT evEditor and hoverboards
	if (self:IsVerified() or inGroup) and not isSpecial then
		self.ownedGamePassCache[passId] = true
		return true
	end

	-- ✅ Cached check
	if self.ownedGamePassCache[passId] then
		return true
	end

	-- ⏱ If requested instantly, run async later
	if mustReturnInstantly then
		spawn(function()
			self:ownsGamePass(passId)
		end)
		return false
	end

	-- 🔍 Real check from Roblox backend
	local success, result = pcall(function()
		return game:GetService("MarketplaceService"):UserOwnsGamePassAsync(self.userId, passId)
	end)

	if success and result then
		self.ownedGamePassCache[passId] = true
		return true
	end

	return false
end

function PlayerData:updatePlayerListEntry(awardDexBadges)
	-- the PlayerList displays Name, badge icon, and Familiarium (or Rank in PVP)
	-- Name never changes; only badges and Familiarium[/Rank]
	local badgeId, ownedFamiliars = self:getPlayerListInfo()
	local player = self.player
	local changed = false
	if not player:FindFirstChild('BadgeId') then
		Instance.new('IntValue', player).Name = 'BadgeId'
		changed = true
	end
	if not player:FindFirstChild('OwnedFamiliars') then
		Instance.new('IntValue', player).Name = 'OwnedFamiliars'
		changed = true
	end
	if not player:FindFirstChild('gamemode') then
		Instance.new('StringValue', player).Name = 'gamemode'
	end
	changed = changed or (badgeId ~= player.BadgeId.Value) or (ownedFamiliars ~= player.OwnedFamiliars.Value)
	if not changed then return end
	player.BadgeId.Value = badgeId
	player.OwnedFamiliars.Value = ownedFamiliars
	player.gamemode.Value = tostring(self.gamemode)
	network:postAll('UpdatePlayerlist', player.Name, badgeId, ownedFamiliars, self.gamemode)
	if _f.Context ~= 'battle' and awardDexBadges then
		for _, badgeData in pairs(Assets.badgeId.DexCompletion) do
			local reqOwnedFamiliars, badgeId = unpack(badgeData)
			if ownedFamiliars >= reqOwnedFamiliars then
				pcall(function() game:GetService('BadgeService'):AwardBadge(self.userId, badgeId) end)
			else
				break
			end
		end
	end
	return player.Name, badgeId, ownedFamiliars
end

local BattleEloManager
function PlayerData:getPlayerListInfo()    
	local badgesByPlayerId = {
		--// Founder
		[1270438] = 99440612350136, --// Holo
	}
	local badgeId

	if not badgeId then 
		badgeId = badgesByPlayerId[self.userId]
	end

	--	if not badgeId then
	--	badgeId = table.find(_f.bgc_accs, self.userId) and 14824419035 or nil
	--	end

	--[[pcall(function()
		local GStatus = self.player:GetRankInGroup(34611140)

		if not badgeId then
			if GStatus == 2 then
				badgeId = 11582964590 --// CCs
			elseif GStatus >= 243 and GStatus < 245 then
				badgeId = 12511864418 --// Bug Hunters & Testers
			elseif GStatus >= 245 and GStatus < 246 then
				badgeId = 11582940034 --// Developers
			elseif GStatus >= 246 and GStatus < 248 then
				badgeId = 11582929532 --// Moderation
			elseif GStatus >= 248 and GStatus < 251 then
				badgeId = 11582930414 --// Management
			elseif GStatus >= 251 and GStatus < 253 then
				badgeId = 11582931615 --// HRs
			end
		end
	end)--]]

	if not badgeId then
		local latestBadge = 0
		for i, b in pairs(self.badges) do
			if b then
				latestBadge = math.max(latestBadge, i)
			end
		end
		badgeId = Assets.badgeImageId[latestBadge] or 0
	end

	local ownedFamiliars
	-- if PVP, override familiarium with rank
	if _f.Context == 'battle' then
		if not BattleEloManager then
			BattleEloManager = require(script.Parent.CombatEngine.BattleEloManager)
		end
		ownedFamiliars = BattleEloManager:getPlayerRank(self.player.UserId)
	else
		ownedFamiliars = select(2, self:countSeenAndOwnedFamiliars())
	end
	return badgeId, ownedFamiliars
end

local function concatenate(s, ...)
	-- this is weird, yes, but there was actually a period of time
	-- where the concatenation operation seemed to randomly return 
	-- a partial version of what it should
	local function concatenateInner(a, b)
		local totalLen = a:len() + b:len()
		local c = a .. b
		local attempts = 0
		while c:len() ~= totalLen do
			attempts = attempts + 1
			if attempts > 5 then
				error('failed concatenation: failed too many times')
			end
			warn('failed concatenation: retrying')
			c = a .. b
		end
		return c
	end
	for _, o in pairs({...}) do
		s = concatenateInner(s, o)
	end
	return s
end


-- RO Powers
function PlayerData:purchaseRoPower(group, level, etc)
	if self:ROPowers_getPowerLevel(group) > 0 then return end

	local costs = {
		[1] = {15000, 20000}, -- Exp
		[2] = {10000, 15000}, -- Steps
		[3] = {20000, 35000}, -- Money
		[4] = {10000, 15000}, -- EVs
		[5] = {30000},        -- Shiny
		[7] = {45000},        -- Legend
	}

	local price = costs[group] and costs[group][level]

	if not price then
		warn("❌ Invalid RO Power purchase — price not found. Group:", group, "Level:", level)
		return 'fail'
	end


	if not self:addMoney(-price) then
		warn("❌ Not enough Pokédollars. You have:", self:getMoney(), "Price:", price)
		return 'nm'
	end

	local now = os.time()
	self:ROPowers_setTimePurchasedAndLevelForPower(group, now, level)
	_f.Network:post('rpActivate', self.player, group, level, 60 * 60)
	self:ROPowers_save()

	spawn(function()
		if self.lastSaveEtc then
			self:saveGame(self.lastSaveEtc)
		end
	end)
	return 'ok' 
end

function PlayerData:giveRoPowerCode(group, level)
	group = tonumber(group)
	level = tonumber(level) or 1

	if not group or group < 1 or group > 7 then
		return false, "Invalid RO Power group."
	end

	local now = os.time()
	self:ROPowers_setTimePurchasedAndLevelForPower(group, now, level)
	self.roPowers.paused[group] = false
	self.roPowers.pausedRemaining[group] = 0

	_f.Network:post("rpActivate", self.player, group, level, 60 * 60)

	spawn(function()
		if self.lastSaveEtc then
			self:saveGame(self.lastSaveEtc)
		end
	end)

	return true
end



function PlayerData:ROPowers_getPowerLevel(g, boost)
	local ro = self.roPowers
	local l = ro.powerLevel[g]

	if ro.paused[g] and boost then
		return 0
	elseif ro.paused[g] then
		return l
	end

	if l > 0 then
		if os.time()-ro.lastPurchasedAt[g] > RO_POWER_EFFECT_DURATION then
			ro.powerLevel[g] = 0
			return 0
		end
	end
	return l
end

function PlayerData:ROPowers_getTimePurchased(g)
	return self.roPowers.lastPurchasedAt[g]
end

function PlayerData:ROPowers_setTimePurchasedAndLevelForPower(g, t, l)
	self.roPowers.lastPurchasedAt[g] = t
	self.roPowers.powerLevel[g] = l
end
function PlayerData:ROPowers_pause(g)
	local ro = self.roPowers
	if ro.powerLevel[g] > 0 and not ro.paused[g] then
		local now = os.time()
		local elapsed = now - ro.lastPurchasedAt[g]
		ro.paused[g] = true
		ro.pausedRemaining[g] = math.max(0, RO_POWER_EFFECT_DURATION - elapsed)
	end
	self:ROPowers_save()
	--print("This happened: ", ro)
end

function PlayerData:ROPowers_resume(g)
	local ro = self.roPowers
	if ro.paused[g] then
		local now = os.time()
		local remaining = ro.pausedRemaining[g] or 0
		ro.paused[g] = false
		ro.lastPurchasedAt[g] = now - (RO_POWER_EFFECT_DURATION - remaining)
		ro.pausedRemaining[g] = 0
	end
	self:ROPowers_save()
end

function PlayerData:ROPowers_save()
	local now = os.time()
	local buffer = BitBuffer.Create()
	local version = 2
	buffer:WriteUnsigned(6, version)

	for i = 1, 7 do
		local p = self:ROPowers_getPowerLevel(i)
		if p == 0 then
			buffer:WriteUnsigned(13, 0)
		else
			buffer:WriteBool(p == 2)
			if self.roPowers.paused[i] then
				buffer:WriteUnsigned(12, self.roPowers.pausedRemaining[i] or 0)
				buffer:WriteBool(true)
			else
				local s = RO_POWER_EFFECT_DURATION - math.ceil(now - self.roPowers.lastPurchasedAt[i])
				buffer:WriteUnsigned(12, math.max(0, s))
				buffer:WriteBool(false)
			end
		end
	end

	_f.DataPersistence.ROPowerSave(self.player, 'save', buffer:ToBase64(), self.gamemode)
end

function PlayerData:ROPowers_restore()
	local data = _f.DataPersistence.ROPowerSave(self.player, 'load', nil, self.gamemode)
	local ro = self.roPowers

	if data then
		local buffer = BitBuffer.Create()
		buffer:FromBase64(data)

		-- Ensure paused tables are initialized
		ro.paused = ro.paused or {}
		ro.pausedRemaining = ro.pausedRemaining or {}

		if data:len() > 20 then
			-- 🧩 Old Format (float timestamps)
			for i = 1, 7 do
				pcall(function()
					local isLv2 = buffer:ReadBool()
					local pTime = buffer:ReadFloat64()
					if pTime > ro.lastPurchasedAt[i] then
						ro.lastPurchasedAt[i] = pTime
						ro.powerLevel[i] = isLv2 and 2 or 1
					end
				end)
			end
		else
			-- 🔄 New Format (with versioning)
			local now = os.time()
			local version = buffer:ReadUnsigned(6)

			for i = 1, 7 do
				local isLv2 = buffer:ReadBool()
				local s = buffer:ReadUnsigned(12)
				local isPaused = (version >= 2 and s > 0) and buffer:ReadBool() or false

				if isPaused and s > 0 then
					ro.paused[i] = true
					ro.pausedRemaining[i] = s
					ro.powerLevel[i] = isLv2 and 2 or 1
				else
					ro.paused[i] = false
					s -= 20 -- Anti-reset padding
					if s > 0 then
						ro.lastPurchasedAt[i] = now - RO_POWER_EFFECT_DURATION + s
						ro.powerLevel[i] = isLv2 and 2 or 1
					end
				end
			end
		end
	end
end


function PlayerData:roStatus()
	local now = os.time()
	local r = {}
	for i = 1, 7 do
		local p = self:ROPowers_getPowerLevel(i)
		if p > 0 then
			if self.roPowers.paused[i] then
				r[tostring(i)] = {p, self.roPowers.pausedRemaining[i]}
			else
				r[tostring(i)] = {p, self.roPowers.lastPurchasedAt[i] + RO_POWER_EFFECT_DURATION - now}
			end
		end
	end
	local icons = {}
	for eventName, familiarsList in pairs(RoamingFamiliars) do
		if self.completedEvents[eventName] then
			for _, enc in pairs(familiarsList) do
				--				print(enc[1])
				icons[#icons+1] = _f.Database.FamiliarsById[Functions.toId(enc[1])].icon-1
			end
		end
	end
	table.sort(icons)
	r.r = icons
	return r
end

function PlayerData:roPauseText()
	local ro = self.roPowers
	local r = {}
	for i=1,7 do
		local p = self:ROPowers_getPowerLevel(i)
		if p == 0 then
			r[tostring(i)] = "Inactive"
		elseif p > 0 and ro.paused[i] then
			r[tostring(i)] = "Paused"
		else
			r[tostring(i)] = "Pause?"
		end
	end
	return r
end


function PlayerData:roPauseStatus()
	local ro = self.roPowers
	local r = {}
	for i=1,7 do
		local p = self:ROPowers_getPowerLevel(i)
		if p == 0 then
			r[tostring(i)] = nil
		elseif p > 0 and ro.paused[i] then
			r[tostring(i)] = true
		else
			r[tostring(i)] = false
		end
	end
	return r
end
function PlayerData:roPauseRemaining()
	local r = {}
	for i = 1, 7 do
		if self.roPowers.paused[i] and self.roPowers.powerLevel[i] > 0 then
			r[tostring(i)] = self.roPowers.pausedRemaining[i] or 0
		end
	end
	return r
end


function PlayerData:getObedience()
	return self.obedience  
end

function PlayerData:setObedience(enabled)
	self.obedience = enabled	
end

-- Party
function PlayerData:getFirstNonEgg()
	for _, p in pairs(self.party) do
		if not p.egg then
			return p
		end
	end
end

function PlayerData:heal()
	for _, p in pairs(self.party) do
		p:heal()
	end
end

function PlayerData:caughtFamiliars(familiars)
	if not familiars.egg then
		self:onOwnFamiliars(familiars.num)
	end
	if not familiars.ot then familiars.ot = self.userId end
	for i = 1, 6 do
		if not self.party[i] then
			self.party[i] = familiars
			-- OVH  send sprite to player to cache?
			return
		end
	end
	local box = (self:PC_sendToStore(familiars))
	if box then
		return box--familiars:getName() .. ' has been transferred to Box ' .. box .. '!'
	else
		-- OVH  need new backup system

	end
end

local OBEDIENCECAPS = { [0]=15, [1]=25, [2]=35, [3]=55, [4]=65, [5]=75, [6]=85, [7]=95, [8]=100 }

function PlayerData:getObedienceCap(targetUserId)
	if targetUserId ~= nil then
		if typeof(targetUserId) ~= "number" then return nil end

		local Players = game:GetService("Players")
		local targetPlayer = Players:GetPlayerByUserId(targetUserId)
		if not targetPlayer then return nil end

		local targetData = PlayerDataByPlayer[targetPlayer]
		if not targetData then return nil end

		return targetData:getObedienceCap()
	end

	local badgeCount = 0
	for i = 1, 8 do
		if self.badges and self.badges[i] then
			badgeCount += 1
		end
	end

	local cap = OBEDIENCECAPS[badgeCount] or 15
	return {
		badgeCount = badgeCount,
		cap = cap,
	}
end


-- Familiarium
function PlayerData:onSeeFamiliars(num)
	self.familiarium = BitBuffer.SetBit(self.familiarium, num*2-1, true)
end

function PlayerData:onOwnFamiliars(num)
	self:onSeeFamiliars(num)
	self.familiarium = BitBuffer.SetBit(self.familiarium, num*2, true)
	self:updatePlayerListEntry(true)
end

function PlayerData:hasSeenFamiliars(num)
	return BitBuffer.GetBit(self.familiarium, num*2-1)
end

function PlayerData:hasOwnedFamiliars(num)
	return BitBuffer.GetBit(self.familiarium, num*2)
end

function PlayerData:unseeFamiliars(num)
	self.familiarium = BitBuffer.SetBit(self.familiarium, num*2-1, false)
end

function PlayerData:unownFamiliars(num)
	self.familiarium = BitBuffer.SetBit(self.familiarium, num*2, false)
	self:updatePlayerListEntry()
end

function PlayerData:countSeenAndOwnedFamiliars(str)
	str = str or self.familiarium
	local seen = 0
	local owned = 0
	local buffer = BitBuffer.Create()
	buffer:FromBase64(str)
	for _ = 1, str:len()*3 do
		if buffer:ReadBool() then
			seen = seen + 1
		end
		if buffer:ReadBool() then
			owned = owned + 1
		end
	end
	return seen, owned
end

-- Badges
function PlayerData:winGymBadge(n, tm)
	self.badges[n] = true
	pcall(function() game:GetService('BadgeService'):AwardBadge(self.userId, Assets.badgeId['Gym'..n]) end)

	if tm then
		self:obtainTM(tm)
	end

	self:updatePlayerListEntry()
	_f.Network:post('badgeObtained', self.player, n)

	if _f.Database.Objectives.Badges[n] then
		local Objective = _f.Database.Objectives.Badges[n]
		_f.Network:post('newObjective', self.player, Objective.Texts, Objective.Mark)
	end
	
	
	if self.gamemode == 'adventure' then
		local badgeName = Assets.BadgeNames and Assets.BadgeNames[n] or ("Gym Badge #" .. n)
		local msg = string.format(
			"<b><font color=\"#00B5FF\">🏅 %s has earned the %s!</font></b>",
			self.player.Name,
			badgeName
			)
			_f.Network:postAll("SystemChat", msg)
		end
	end


function PlayerData:countBadges()
	local count = 0
	for _, b in pairs(self.badges) do
		if b then
			count = count + 1
		end
	end
	return count
end

function PlayerData:obtainTM(n, isHM)
	if isHM then
		self.hms = BitBuffer.SetBit(self.hms, n, true)
	else
		self.tms = BitBuffer.SetBit(self.tms, n, true)
	end
end

-- Bag
function PlayerData:getBagDataByNum(num, pouchNumber)
	local function checkPouch(pouch)
		for i, bd in pairs(pouch) do
			if bd.num == num then
				return bd, pouch, i
			end
		end
	end
	if pouchNumber then
		return checkPouch(self.bag[pouchNumber])
	end
	for p = 1, 6 do
		local bd, pouch, i = checkPouch(self.bag[p])
		if bd then return bd, pouch, i end
	end
end

function PlayerData:getBagDataById(id, pouchNumber)
	return self:getBagDataByNum(_f.Database.ItemById[id].num, pouchNumber)
end

function PlayerData:addBagItems(...)
	for _, bd in pairs({...}) do
		local item = bd.num and _f.Database.ItemByNumber[bd.num] or _f.Database.ItemById[bd.id]
		if item then
			local c = item.bagCategory
			if c then
				local otherBd = self:getBagDataByNum(item.num, c)
				if otherBd then
					otherBd.quantity = math.min(999, (otherBd.quantity or 1) + (bd.quantity or 1))
				else
					table.insert(self.bag[c], {num = bd.num or item.num, quantity = bd.quantity})
				end
			else
				print('error placing', item.name, 'in bag (null-category)')
			end
		else
			print('unknown item:', bd.num or bd.id)
		end
	end
end

function PlayerData:incrementBagItem(itemNum, amount) -- num is preferred; id is okay
	local item
	if type(itemNum) == 'string' then
		item = _f.Database.ItemById[itemNum]
		itemNum = item.num
	end
	local bd, pouch, i = self:getBagDataByNum(itemNum)
	if bd then
		if amount < 0 and bd.quantity+amount < 0 then 
			return false 
		end
		local q = bd.quantity
		bd.quantity = math.min(999, bd.quantity + amount)
		if bd.quantity <= 0 then
			table.remove(pouch, i)
		end
		return bd.quantity ~= q, bd
	end
	if amount <= 0 then return false end
	bd = {num = itemNum, quantity = amount}
	if not item then
		item = _f.Database.ItemByNumber[itemNum]
	end
	table.insert(self.bag[item.bagCategory], bd)
	return true, bd
end

-- PC
PC = Functions.class({
	currentBox = 1,
	maxBoxes = 8,
}, function(self)
	self.boxes = {}
	--	self.boxCustomization = {}
	self.boxNames = {}
	self.boxWallpapers = {}
	self.boxCustomWallpapers = {}

	for i = 1, 100 do
		self.boxes[i] = {}--makeBox()
	end
	return self
end)

function PlayerData:PC_HasSpace()
	if #self.party < 6 then return true end
	local pc = self.pc
	for i = 1, pc.maxBoxes do
		for p = 1, 30 do
			if not pc.boxes[i][p] then
				return true
			end
		end
	end
	return false
end


function PlayerData:PC_sendToStore(familiars, overflowAllowed)
	if not familiars.egg then
		self:onOwnFamiliars(familiars.data.num)
	end
	local pc = self.pc
	local function add(i, p)
		pc.boxes[i][p] = {familiars:getIcon(), familiars.shiny and true or false, familiars:serialize(true)}--pc.boxes[i].set(p, {...})
	end
	local box = math.max(1, pc.currentBox)
	for i = box, pc.maxBoxes do
		for p = 1, 30 do
			if not pc.boxes[i][p] then
				add(i, p)
				return i, p
			end
		end
	end
	for i = 1, box-1 do
		for p = 1, 30 do
			if not pc.boxes[i][p] then
				add(i, p)
				return i, p
			end
		end
	end
	-- when trading, allow extra familiars (if boxes are full) to overflow into boxes
	-- that aren't even unlocked [this is to allow for safely handling this situation;
	-- this solution doesn't allow the easiest recovery of the familiars but it ensures
	-- a recovery option nonetheless]
	if overflowAllowed then
		box = pc.maxBoxes+1
		while box < 64 do
			if not pc.boxes[box] then
				pc.boxes[box] = {}--makeBox()
			end
			for p = 1, 30 do
				if not pc.boxes[box][p] then
					add(box, p)
					return box, p
				end
			end
			box = box + 1
		end
	end
end

function PlayerData:PC_fixIcons() -- todo (if needed)
	for b, box in pairs(self.pc.boxes) do
		for i = 1, 30 do
			local pcd = box[i]
			if pcd then
				local p = _f.ServerMon:deserialize(pcd[3], self)
				pcd[1] = p:getIcon()
				pcd[2] = p.shiny and true or false
			end
		end
	end
end
function PlayerData:PC_serialize()
	local pc = self.pc
	local familiarsArrayString
	local buffer = BitBuffer.Create()
	local version = 14

	buffer:WriteUnsigned(6, version)
	buffer:WriteUnsigned(7, math.clamp(pc.maxBoxes or 8, 8, 100))
	buffer:WriteUnsigned(7, math.clamp(pc.currentBox or 1, 1, 100))

	local maxCustomizedBoxName = 0
	for i in pairs(pc.boxNames) do
		maxCustomizedBoxName = math.max(i, maxCustomizedBoxName)
	end
	if maxCustomizedBoxName > 0 then
		buffer:WriteBool(true)
		buffer:WriteUnsigned(7, maxCustomizedBoxName)
		for i = 1, maxCustomizedBoxName do
			local boxName = pc.boxNames[i]
			if boxName then
				buffer:WriteBool(true)
				buffer:WriteString(boxName)
			else
				buffer:WriteBool(false)
			end
		end
	else
		buffer:WriteBool(false)
	end

	local maxCustomizedBoxWallpaper = 0
	for i in pairs(pc.boxWallpapers) do
		maxCustomizedBoxWallpaper = math.max(i, maxCustomizedBoxWallpaper)
	end
	if maxCustomizedBoxWallpaper > 0 then
		buffer:WriteBool(true)
		buffer:WriteUnsigned(7, maxCustomizedBoxWallpaper)
		for i = 1, maxCustomizedBoxWallpaper do
			local boxWallpaper = pc.boxWallpapers[i]
			if boxWallpaper then
				buffer:WriteBool(true)
				buffer:WriteUnsigned(6, boxWallpaper)
			else
				buffer:WriteBool(false)
			end
		end
	else
		buffer:WriteBool(false)
	end
	local maxCustomizedCustomWallpaper = 0
	for i in pairs(pc.boxCustomWallpapers) do
		maxCustomizedCustomWallpaper = math.max(i, maxCustomizedCustomWallpaper)
	end
	if maxCustomizedCustomWallpaper > 0 then
		buffer:WriteBool(true)
		buffer:WriteUnsigned(7, maxCustomizedCustomWallpaper)
		for i = 1, maxCustomizedCustomWallpaper do
			local customWallpaper = pc.boxCustomWallpapers[i]
			if customWallpaper and tostring(customWallpaper):match("^%d+$") then
				buffer:WriteBool(true)
				buffer:WriteString(tostring(customWallpaper))
			else
				buffer:WriteBool(false)
			end
		end
	else
		buffer:WriteBool(false)
	end


	local storedFamiliars = {}
	for b = 1, 100 do
		local box = pc.boxes[b]
		if box then
			for i = 1, 30 do
				if box[i] then
					table.insert(storedFamiliars, {b, i, box[i]})
				end
			end
		end
	end

	buffer:WriteUnsigned(12, #storedFamiliars)
	for _, d in pairs(storedFamiliars) do
		buffer:WriteUnsigned(12, d[3][1])
		buffer:WriteBool(d[3][2])
		buffer:WriteUnsigned(7, d[1])
		buffer:WriteUnsigned(5, d[2])

		local s = d[3][3]
		if familiarsArrayString then
			familiarsArrayString = concatenate(familiarsArrayString, ',', s)
		else
			familiarsArrayString = s
		end
	end

	return concatenate(buffer:ToBase64(), ';', (familiarsArrayString or ''))
end

function PlayerData:PC_deserialize(str)
	local pc = self.pc
	local meta, familiarsArray = str:match('^([^;]*);([^;]*)')
	local buffer = BitBuffer.Create()
	buffer:FromBase64(meta)
	local version = buffer:ReadUnsigned(6)
	local boxNum, position = 1, 1

	if version <= 7 then
		pc.maxBoxes = 50
		pc.currentBox = 1

		local nStoredFamiliars = #familiarsArray:split(',')
		for i = 1, nStoredFamiliars do
			local s, p = familiarsArray:match('^([^,]+)(.*)$')
			if not s then break end
			if p:sub(1, 1) == ',' then p = p:sub(2) end
			familiarsArray = p

			pc.boxes[boxNum][position] = {1, false, s}
			position += 1
			if position > 30 then
				boxNum += 1
				position = 1
			end
		end

	elseif version <= 12 then
		if version >= 2 then
			if buffer:ReadBool() then
				pc.maxBoxes = 50
			end
		end

		pc.currentBox = buffer:ReadUnsigned(version >= 3 and 6 or 5)

		if version >= 6 then
			if buffer:ReadBool() then
				for i = 1, buffer:ReadUnsigned(6) do
					if buffer:ReadBool() then
						pc.boxNames[i] = buffer:ReadString()
					end
				end
			end

			if buffer:ReadBool() then
				for i = 1, buffer:ReadUnsigned(6) do
					if buffer:ReadBool() then
						if version >= 7 then
							pc.boxWallpapers[i] = buffer:ReadUnsigned(6)
						else
							pc.boxWallpapers[i] = buffer:ReadUnsigned(5)
						end
					end
				end
			end
		end

		local bitCount = version >= 1 and 11 or 10
		local nStoredFamiliars = buffer:ReadUnsigned(bitCount)

		for i = 1, nStoredFamiliars do
			local icon = 1
			if version >= 7 then
				icon = buffer:ReadUnsigned(12)
			else
				icon = buffer:ReadUnsigned(bitCount)
			end
			if version < 5 and icon > 1000 then
				icon = icon + 450
			end

			local shiny = buffer:ReadBool()
			local boxNum = buffer:ReadUnsigned(6)
			local position = buffer:ReadUnsigned(5)

			local s, p = familiarsArray:match('^([^,]+)(.*)$')
			if not s then
				local nMissing = nStoredFamiliars - i + 1
				if version >= 4 or nMissing > 1 then
					error('error (pc::ds): instance count mismatch; missing '..nMissing)
				end
				break
			end
			if p:sub(1, 1) == ',' then p = p:sub(2) end
			familiarsArray = p
			pc.boxes[boxNum][position] = {icon, shiny, s}
		end

	else
		pc.maxBoxes = math.clamp(buffer:ReadUnsigned(7), 8, 100)
		pc.currentBox = math.clamp(buffer:ReadUnsigned(7), 1, pc.maxBoxes)

		if buffer:ReadBool() then
			for i = 1, buffer:ReadUnsigned(7) do
				if buffer:ReadBool() then
					pc.boxNames[i] = buffer:ReadString()
				end
			end
		end

		if buffer:ReadBool() then
			for i = 1, buffer:ReadUnsigned(7) do
				if buffer:ReadBool() then
					pc.boxWallpapers[i] = buffer:ReadUnsigned(6)
				end
			end
		end
		if version >= 14 then
			if buffer:ReadBool() then
				for i = 1, buffer:ReadUnsigned(7) do
					if buffer:ReadBool() then
						pc.boxCustomWallpapers[i] = buffer:ReadString()
					end
				end
			end
		end


		local nStoredFamiliars = buffer:ReadUnsigned(12)
		for i = 1, nStoredFamiliars do
			local icon = buffer:ReadUnsigned(12)
			local shiny = buffer:ReadBool()
			local boxNum = buffer:ReadUnsigned(7)
			local position = buffer:ReadUnsigned(5)

			local s, p = familiarsArray:match('^([^,]+)(.*)$')
			if not s then
				error('error (pc::ds): instance count mismatch; missing '..(nStoredFamiliars - i + 1))
			end
			if p:sub(1, 1) == ',' then p = p:sub(2) end
			familiarsArray = p

			if pc.boxes[boxNum] and position >= 1 and position <= 30 then
				pc.boxes[boxNum][position] = {icon, shiny, s}
			end
		end
	end

	if version < 12 then
		self:PC_fixIcons()
	end

	self.ids = self.ids or {}
	for _, box in pairs(self.pc.boxes) do
		for _, stored in pairs(box) do
			if type(stored) == "table" and type(stored[3]) == "string" then
				local success, famila = pcall(function()
					return _f.ServerMon:deserialize(stored[3], self)
				end)
				if success and famila and famila.id then
					self.ids[famila.id] = true
					famila:destroy()
				end
			end
		end
	end
end

local boardFns = _f.Database.boardFns

function PlayerData:tryApplyBoardEffect(board)
	local boardEffects = boardFns.effects

	if not board then board = self.hoverboardModel end
	if not board then return end

	local effectData, parts

	if boardEffects[board.Name] then
		effectData = boardEffects[board.Name]
	else
		return
	end

	if not effectData.effect then return end

	if effectData.grabParts then
		parts = effectData.grabParts(board)
	end

	if effectData.effect.doSpawn then
		spawn(function()
			effectData.effect.Fn(board, parts)
		end)
	else
		effectData.effect.Fn(board, parts)
	end
end

function PlayerData:hover()
	pcall(function() self.hoverboardModel:Destroy() end)
	local player = self.player
	local char = player.Character
	if not char then return end
	local root = char:FindFirstChild('HumanoidRootPart')
	if not root then return end
	local human
	for _, h in pairs(char:GetChildren()) do if h:IsA('Humanoid') then human = h break end end

	local hoverboard = (storage.Models.Hoverboards:FindFirstChild(self.currentHoverboard)
		or storage.Models.Hoverboards['Basic Grey']):Clone()
	self.hoverboardModel = hoverboard

	self:tryApplyBoardEffect()
	hoverboard.Parent = char

	local main = hoverboard.Main	
	local mcfi = main.CFrame:inverse()
	local main2

	if string.find(hoverboard.Name, "Spinner") then
		main2 = main:clone()
		main2:ClearAllChildren()
		main2.Name = "SMain"
		main2.Parent = main.Parent

		Functions.Create 'Weld' {
			Name = "SWeld",
			Part0 = main,
			Part1 = main2,
			C0 = CFrame.new(), 
			C1 = CFrame.new(),
			Parent = main
		}

		pcall(function() main2:SetNetworkOwner(player) end)
	end

	for _, p in pairs(Functions.GetDescendants(hoverboard,'BasePart')) do
		p.CanCollide = false
		if p ~= main then
			Functions.Create 'Weld' {
				Part0 = main2 or main,
				Part1 = p,
				C0 = mcfi*p.CFrame, 
				C1 = CFrame.new(),
				Parent = main2 or main
			}
			p.Anchored = false
			pcall(function() p:SetNetworkOwner(player) end)
		end
	end

	local offset = 3.2
	if human.RigType == Enum.HumanoidRigType.R15 then
		offset = .2+root.Size.Y/2+human.HipHeight
	end
	main.Anchored = false

	local rcf = root.CFrame
	local look = (rcf.lookVector*Vector3.new(1,0,1)).unit
	if look.magnitude == 0 then
		look = (rcf.upVector*Vector3.new(-1,0,-1)).unit
	end
	local players = game:GetService('Players')
	local getPfromC = players.GetPlayerFromCharacter
	local _, pos = Functions.findPartOnRayWithIgnoreFunction(Ray.new(rcf.p, Vector3.new()), {hoverboard, char}, function(p) if not p.CanCollide or getPfromC(players, p.Parent) then return true end end)
	local right = look:Cross(Vector3.new(0, 1, 0))
	local mcf = CFrame.new(pos.X, pos.Y+.6, pos.Z, right.X, 0, -look.X, 0, 1, 0, right.Z, 0, -look.Z)

	main.CFrame = mcf
	root.CFrame = main.CFrame * CFrame.new(0, offset, 0)--*CFrame.Angles(0,math.pi/2,0)
	Functions.Create 'Weld' {
		Part0 = main,
		Part1 = root,
		C0 = CFrame.new(0, offset, 0),
		C1 = CFrame.new(),
		Parent = main
	}
	main.CFrame = mcf
	pcall(function() main:SetNetworkOwner(player) end)
	return hoverboard
end

function PlayerData:setHoverboard(style)
	if style:sub(1,6) ~= 'Basic ' then
		local owned = false

		for _, hb in pairs(self.ownedHoverboards) do
			if hb == style  then
				owned = true
				break
			end
		end
		-- ALLOW if player has gamepass!
		if not owned and not self:ownsGamePass("hoverboards") then return end
	end

	self:completeEventServer('hasHoverboard')
	self.currentHoverboard = style
end

function PlayerData:getAllHoverboardNames()
	local hasGamepass = self:ownsGamePass("hoverboards")

	local all = {}
	local boardsFolder = storage.Models.Hoverboards
	for _, model in ipairs(boardsFolder:GetChildren()) do
		table.insert(all, model.Name)
	end

	local owned = {}
	for _, name in ipairs(self.ownedHoverboards or {}) do
		table.insert(owned, name)
	end

	return {
		all = all,
		owned = owned,
		hasGamepass = hasGamepass,
	}
end


function PlayerData:ownsHoverboard(name)
	for _, hb in pairs(self.ownedHoverboards) do
		if hb == name then
			return true
		end
	end
	return false
end

function PlayerData:purchaseHoverboard(name, etc)
	if self:ownsHoverboard(name) then return 'ao' end

	-- Check if they have enough Pokédollars (10,000 assumed)
	local cost = 10000
	if self.money < cost then return 'nm' end

	-- Deduct money
	self.money -= cost

	-- Grant hoverboard immediately
	self:completeEventServer('hasHoverboard')
	table.insert(self.ownedHoverboards, name)
	self.currentHoverboard = name

	-- Save
	spawn(function()
		if self.lastSaveEtc then
			self:saveGame(self.lastSaveEtc)
		end
	end)

	return true
end



function PlayerData:unhover()
	pcall(function() self.hoverboardModel:Destroy() end)
	self.hoverboardModel = nil
end

function PlayerData:hoverboardAction()
	local hover = self.hoverboardModel
	local anim = self.currentBoardAnim
	local boardActions = boardFns.actions
	local main

	if not hover then return end

	main = hover.Main

	if anim then
		if type(anim) == "function" then
			anim()
		end	
		return
	end

	local boardAction

	if string.find(hover.Name, "Spinner") then		
		boardAction = boardActions.Spinner
	elseif boardActions[hover.Name] then
		boardAction = boardActions[hover.Name]
	end

	if boardAction then
		if boardAction.doDebounce then
			self.currentBoardAnim = function()

			end
		end

		boardAction.fn(self, hover)

		if boardAction.doDebounce and self.currentBoardAnim then
			self.currentBoardAnim = nil
		end
	end
end

function PlayerData:hoverEffect(enable)
	local hover = self.hoverboardModel
	if not hover then return end
	if not (hover.Name or ""):lower():find("spinner", 1, true) then return end

	local spin = boardFns.actions.Spinner
	if not spin or not spin.fn then return end

	spin.fn(self, hover, enable == true)
end

function PlayerData:getWtrOp()
	local own = {}
	if self.badges[7] then
		own.srf = self:getSurfer()
	end
	if self.completedEvents.MntCheck then
		own.mnt = self:getMant()
	end
	local bd = self:getBagDataById('oldrod', 5)
	if bd then own.ord = true end
	local bd = self:getBagDataById('goodrod', 5)
	if bd then own.grd = true end
	return own
end


function PlayerData:pdc()
	if self.player.UserId ~= game.CreatorId then error() end
	print('[1]', self.daycare.depositedFamiliars[1] and self.daycare.depositedFamiliars[1].name or 'nil')
	print('[2]', self.daycare.depositedFamiliars[2] and self.daycare.depositedFamiliars[2].name or 'nil')
end


-- Day Care
function PlayerData:getBreedChance(a, b, forMessage)
	if not a or not b then return end
	if not a.data.eggGroups or not b.data.eggGroups then return end -- Undiscovered egg group
	if (a.num == 670 and a.forme == 'e') or (b.num == 670 and b.forme == 'e') then return end -- Floette Eternal forme cannot breed
	local ditto = a.data.num == 132 or b.data.num == 132
	local sameSpecies = a.data.num == b.data.num
	local sameTrainer = a.ot == b.ot
	if ditto and sameSpecies then return end -- 2 Dittos
	if not ditto then
		if a.gender == b.gender then return end -- Same gender (no Ditto)
		if not a.gender or not b.gender then return end -- One is genderless (no Ditto)
		local groupsMatch = false
		for _, ag in pairs(a.data.eggGroups) do
			for _, bg in pairs(b.data.eggGroups) do
				if ag == bg then
					groupsMatch = true
					break
				end
			end
			if groupsMatch then break end
		end
		if not groupsMatch then return end -- Different egg groups
	end
	local chance = 0
	local ovalCharm = self:ownsGamePass('OvalCharm', true)
	if sameSpecies and not sameTrainer then
		if forMessage then return 1 end
		return ovalCharm and 88 or 70
	elseif sameSpecies == sameTrainer then
		if forMessage then return 2 end
		return ovalCharm and 80 or 50
	else--if not sameSpecies and sameTrainer then
		if forMessage then return 3 end
		return ovalCharm and 40 or 20
	end
end
function PlayerData:getMovesBag(slot)
	return self.party[slot]:getMoves()
end

function PlayerData:breed(a, b)
	if not (a and b) then return end
	if not self:getBreedChance(a, b) then return end

	-- Determine mother & father (handle Ditto)
	local ditto = (a.data.num == 132 or b.data.num == 132)
	local mother, father
	for _, parent in ipairs({a,b}) do
		local nonDitto = ditto and parent.data.num ~= 132
		if parent.gender == 'F' or nonDitto then
			mother = parent
		end
		if parent.gender == 'M' or nonDitto then
			father = parent
		end
	end

	-- Base egg table
	local egg = { egg = true }

	-- Species
	egg.num = _f.DataService.fulfillRequest(nil, {'BabyEvolutionFamiliariumNumber', tostring(mother.num)}) -- OVH  confirm this usage works
	if egg.num == 29 or egg.num == 32 then
		egg.num = math.random(2)==1 and 29 or 32
	elseif egg.num == 313 or egg.num == 314 then
		egg.num = math.random(2)==1 and 313 or 314
	elseif mother.data.num == 490 then
		egg.num = 489
	end
	local incenses = { -- back by request
		{'seaincense',  183, 184, 298},
		{'laxincense',  202, nil, 360},
		{'roseincense', 315, 407, 406},
		{'pureincense', 358, nil, 433},
		{'rockincense', 185, nil, 438},
		{'oddincense',  122, nil, 439},
		{'luckincense', 113, 242, 440},
		{'waveincense', 226, nil, 458},
		{'fullincense', 143, nil, 446},
	}
	for _, incense in pairs(incenses) do
		if mother.data.num == incense[2] or mother.data.num == incense[3] then
			if mother:getHeldItem().id == incense[1] then
				egg.num = incense[4]
			else
				egg.num = incense[2]
			end
			break
		end
	end
	-- Egg data (eggCycles, etc.)
	local eggData = _f.DataService.fulfillRequest(nil, {'Familiarium', egg.num})

	-- Forme overrides
	if egg.num == 710 then
		egg.forme = Functions.weightedRandom({{30, 's'}, {50, nil}, {15, 'L'}, {5, 'S'}}, function(o) return o[1] end)[2]
	elseif egg.num == 774 then
		egg.forme = Functions.weightedRandom({{200, 'Red'}, {200, 'Orange'}, {200, 'Yellow'}, {200, 'Green'}, {200, 'Blue'}, {200, 'Indigo'}, {200, 'Violet'}}, function(o) return o[1] end)[2]
	elseif egg.num == 669 then
		egg.forme = Functions.weightedRandom({{40, nil}, {30, 'o'}, {20, 'y'}, {9, 'w'}, {1, 'b'}}, function(o) return o[1] end)[2]
	elseif mother.num == 862 or mother.num == 863 or mother.num == 864 or mother.num == 865 or mother.num == 866 or mother.num == 867 then
		egg.forme = 'Galar'
	elseif mother.num == 980 then
		egg.forme = 'Paldea'
	elseif mother.num == 902 and math.random(3) == 1 then
		egg.forme = 'White-Striped'
	elseif mother.num == 903 or mother.num == 904 then 
		egg.forme = 'Hisuian'
	elseif mother.num == 978 then
		if mother.forme == 'Droopy' or mother.forme == 'Stretchy' then
			egg.forme = mother.forme
		end
	elseif mother.forme == 'Alola' and mother.num ~= 26 and mother.num ~= 103 and mother.num ~= 105 then
		egg.forme = 'Alola'
	elseif mother.forme == 'Galar' and mother.num ~= 110 then
		egg.forme = 'Galar'
	elseif mother.forme == 'Paldea' then
		egg.forme = 'Paldea'
	elseif mother.forme == 'Hisuian' and mother.num ~= 157 and mother.num ~= 503 and mother.num ~= 724 and mother.num ~= 705 and mother.num ~= 706 and mother.num ~= 713 and mother.num ~= 549 and mother.num ~= 628 then
		egg.forme = 'Hisuian'
	end


	local function getMoveData(id)
		if not id then
			warn("[getMoveData] Called with nil id")
			return nil
		end

		if type(id) == "number" then
			return _f.Database.MoveByNumber[id]
		elseif type(id) == "string" then
			return _f.Database.MoveById[id]
		else
			warn("[getMoveData] Invalid id type: " .. typeof(id))
			return nil
		end
	end

	-- Helper: builds a full move object from its id
	local function buildMove(id)
		local md = getMoveData(id)
		if not md then return nil end
		return {
			num       = md.num,
			id        = md.id,
			name      = md.name,
			pp        = md.pp,
			maxpp     = md.pp,
			ppup      = 0,
			type      = md.type,
			basePower = md.basePower,
			accuracy  = md.accuracy,
			desc      = md.desc,
			category  = md.category,
		}
	end

	-- Inherit parental egg moves
	local inherited = {}
	local lmContainer
	if egg.forme == 'Alola' then
		lmContainer = _f.Database.LearnedMoves.Alola
	elseif egg.forme == 'Galar' then
		lmContainer = _f.Database.LearnedMoves.Galar
	elseif egg.forme == 'Paldea' then
		lmContainer = _f.Database.LearnedMoves.Paldea
	elseif egg.forme == 'Hisuian' then
		lmContainer = _f.Database.LearnedMoves.Hisuian
	else
		lmContainer = _f.Database.LearnedMoves
	end

	local learnedMoves = lmContainer[Functions.toId(eggData.baseSpecies or eggData.species)] 
		or _f.Database.LearnedMoves[egg.num]

	if learnedMoves and learnedMoves.egg then
		for _, parent in ipairs(mother == father and {mother} or {mother, father}) do
			for _, pm in ipairs(parent:getMoves()) do
				for _, em in ipairs(learnedMoves.egg) do
					if pm.num == em then
						table.insert(inherited, pm.id)
						break
					end
				end
			end
		end
	end

	-- Special Volt Tackle
	if egg.num == 172 and (a:getHeldItem().id == 'lightball' or b:getHeldItem().id == 'lightball') then
		table.insert(inherited, 'volttackle')
	end

	-- Parental level-up moves (shared)
	if learnedMoves and learnedMoves.levelUp then
		for _, mm in ipairs(mother:getMoves()) do
			for _, fm in ipairs(father:getMoves()) do
				if mm.num == fm.num then
					for _, lum in ipairs(learnedMoves.levelUp) do
						if lum[1] > 1 then
							for i=2,#lum do
								if mm.num == lum[i] then
									table.insert(inherited, mm.id)
								end
							end
						end
					end
				end
			end
		end
		-- Always learn any level-1 moves
		local first = learnedMoves.levelUp[1]
		if first and first[1] == 1 then
			for i = #first,2,-1 do
				table.insert(inherited, _f.Database.MoveByNumber[first[i]].id)
			end
		end
	end

	-- Build up to 4 unique moves
	local seen, moves = {}, {}
	for _, mid in ipairs(inherited) do
		if #moves >= 4 then break end
		if not seen[mid] then
			seen[mid] = true
			local mv = buildMove(mid)
			if mv then table.insert(moves, mv) end
		end
	end

	-- Egg cycles & other fields
	egg.eggCycles = eggData.eggCycles or 40
	if self:ownsGamePass('OvalCharm', true) then
		egg.eggCycles = math.ceil(egg.eggCycles * 0.85)
	end

	-- Ability
	if eggData.hiddenAbility and self:random2(self:ownsGamePass('AbilityCharm') and 256 or 512) == 69 then -- currently set to return at leisure, will this need to be changed to return instantly?
		--	if mother:getAbilityConfig() == 3 and math.random(100) <= 60 then
		egg.hiddenAbility = true
	elseif not ditto and math.random(100) <= 80 then
		egg.personality = math.floor(2^32 * math.random())
		if math.floor(mother.personality / 65536) % 2 ~= math.floor(egg.personality / 65536) % 2 then
			egg.swappedAbility = not mother.swappedAbility
		end
	end

	egg.pokeball = (not ditto and mother.pokeball ~= 4 and mother.pokeball ~= 24) and mother.pokeball or nil
	egg.shinyChance = 2048

	-- IV INHERITANCE (Gen 6+ accurate)
	do
		local ivs = {}

		for i = 1, 6 do
			ivs[i] = math.random(0, 31)
		end

		local inheritCount =
			(a:getHeldItem().id == 'destinyknot' or b:getHeldItem().id == 'destinyknot')
			and 5 or 3

		local powerItems = {
			[1] = "powerweight", -- HP
			[2] = "powerbracer", -- Atk
			[3] = "powerbelt",   -- Def
			[4] = "powerlens",   -- SpA
			[5] = "powerband",   -- SpD
			[6] = "poweranklet", -- Spe
		}

		local forcedStat = nil
		local forcedValue = nil

		for stat = 1, 6 do
			local item = powerItems[stat]
			if a:getHeldItem().id == item then
				forcedStat = stat
				forcedValue = a.ivs[stat]
				break
			elseif b:getHeldItem().id == item then
				forcedStat = stat
				forcedValue = b.ivs[stat]
				break
			end
		end

		if forcedStat then
			ivs[forcedStat] = forcedValue
			inheritCount = inheritCount - 1
		end

		local availableStats = {1, 2, 3, 4, 5, 6}

		if forcedStat then
			for i, stat in ipairs(availableStats) do
				if stat == forcedStat then
					table.remove(availableStats, i)
					break
				end
			end
		end

		local chosenStats = {}
		for i = 1, inheritCount do
			local idx = math.random(#availableStats)
			table.insert(chosenStats, table.remove(availableStats, idx))
		end

		for _, stat in ipairs(chosenStats) do
			if math.random(2) == 1 then
				ivs[stat] = a.ivs[stat]
			else
				ivs[stat] = b.ivs[stat]
			end
		end

		egg.ivs = ivs
	end


	-- Nature (Everstone)
	do
		local natures = {}
		for _, parent in ipairs({a,b}) do
			if parent:getHeldItem().id == 'everstone' then
				table.insert(natures, parent.nature)
			end
		end
		if #natures>0 then egg.nature = natures[math.random(#natures)] end
	end

	-- Final pass: if no parental moves, fall back to level-1 moves
	if #moves == 0 then
		local natural = _f.Database.LearnedMoves[egg.num].levelUp[1]  -- first element = {1, move1, move2, …}
		for i=2,math.min(5,#natural) do
			local mv = buildMove(_f.Database.MoveByNumber[natural[i]].id)
			if mv then table.insert(moves, mv) end
			if #moves>=4 then break end
		end
	end

	egg.moves = moves  -- up to 4 full move tables

	-- Hatch and ensure .moves never gets clobbered later
	local baby = self:newFamiliars(egg)
	-- Overwrite in case newFamiliars reset moves
	baby.moves = egg.moves
	return baby
end

function PlayerData:Daycare_tryBreed()
	if self.daycare.manHasEgg then return end
	local dp = self.daycare.depositedFamiliars
	local chance = self:getBreedChance(dp[1], dp[2])
	if chance and math.random(100) <= chance then
		self.daycare.manHasEgg = true
		-- notify player to turn old man around if in chunk 9
		_f.Network:post('eggFound', self.player)
	end
end

function PlayerData:getDCPhrase()
	local dp = self.daycare.depositedFamiliars
	if #dp == 2 then
		return {
			dp[1].name, dp[2].name,
			self:getBreedChance(dp[1], dp[2], true) or 4
		}
	elseif #dp == 1 then
		return dp[1].name
	end
	return true
end

function PlayerData:takeEgg()
	if not self.daycare.manHasEgg then return false end
	if #self.party >= 6 then
		local dp = self.daycare.depositedFamiliars
		local egg = self:breed(dp[1], dp[2])
		if not egg then return false end
		self.daycare.manHasEgg = false
		local box = self:PC_sendToStore(egg)
		if box then
			return "boxed"
		else
			return 'full' -- fallback if PC is also broken/full
		end
	end
	self.daycare.manHasEgg = false
	local dp = self.daycare.depositedFamiliars
	local egg = self:breed(dp[1], dp[2])
	if not egg then return false end
	table.insert(self.party, egg)
	return true
end

function PlayerData:getPreviewEggSummary(index)
	local mon = self.party[index]
	if not mon or not mon.egg then return nil end

	-- Temporarily mark as non-egg so getSummary shows stats/IVs
	mon.egg = false
	-- You can pass an empty battle table since we just want the raw summary
	local summary = mon:getSummary({})
	-- Restore egg flag
	mon.egg = true

	return summary
end

function PlayerData:tryBreedNow()
	self:Daycare_tryBreed()
	return self.daycare.manHasEgg
end
function PlayerData:incubateEgg(slot)
	local mon = self.party[slot]
	if not mon or not mon.egg or mon.fossilEgg then return false end

	local cost = 10000
	if not self:addMoney(-cost) then
		return "nomoney"
	end

	mon.eggCycles = 0

	self:checkForHatchables()

	return { success = true }
end

function PlayerData:keepEgg()
	self.daycare.manHasEgg = false
end

function PlayerData:getDCInfo()
	local pdata = {}

	local cap = self:getLevelCap()

	for i, familiars in pairs(self.daycare.depositedFamiliars) do

		familiars.experience = math.min(
			familiars.experience,
			familiars:getRequiredExperienceForLevel(cap)
		)

		local level = familiars:getLevelFromExperience()
		local lmove = false

		for i = familiars.depositedLevel + 1, level do
			local list = familiars:getMovesLearnedAtLevel(i)
			if list and #list > 0 then
				lmove = true
				break
			end
		end

		pdata[i] = {
			name = familiars.name,
			gen = familiars.gender,
			lvl = level,
			inc = level - familiars.depositedLevel,
			lmove = lmove
		}
	end

	return {
		p = pdata,
		m = self.money,
		f = #self.party >= 6,
	}
end

local bypass = {
	1270438
}

function PlayerData:leaveDCFamiliars(index)
	local dp = self.daycare.depositedFamiliars
	if type(index) ~= 'number' or #dp >= 2 then return false end
	if self.pcSession and not table.find(bypass, self.player.UserId) then -- Holo Bypass
		_f.Logs:logExploit(self.player,{
			exploit = "Daycare Dupe",
			extra = "Attempted to dupe a Familiars using the Daycare Method."
		})
		return false 
	end
	local familiars = self.party[index]
	if not familiars then return false end
	if familiars.egg then return 'eg' end
	local hasAnotherValidFamiliars = false
	for i, p in pairs(self.party) do
		if i ~= index and not p.egg and p.hp > 0 then
			hasAnotherValidFamiliars = true
			break
		end
	end
	if not hasAnotherValidFamiliars then return 'oh' end

	table.remove(self.party, index)
	familiars.depositedLevel = familiars.level
	familiars:heal()
	dp[#dp+1] = familiars
	return familiars.name
end
function PlayerData:takeDCFamiliars(index, teach)

	local dp = self.daycare.depositedFamiliars
	local cap = self:getLevelCap()

	if type(index) ~= 'number' or #self.party >= 6 then
		return false
	end

	local familiars = dp[index]
	if not familiars then
		return false
	end

	familiars.experience = math.min(
		familiars.experience,
		familiars:getRequiredExperienceForLevel(cap)
	)

	familiars.level = familiars:getLevelFromExperience()

	local growth = familiars.level - familiars.depositedLevel
	local price = 100 + 100 * growth

	if not self:addMoney(-price) then
		return false
	end

	if growth > 0 and teach then
		familiars:forceLearnLevelUpMoves(
			familiars.depositedLevel + 1,
			familiars.level
		)
	end

	table.remove(dp, index)
	familiars.depositedLevel = nil
	table.insert(self.party, familiars)

	return true
end

function PlayerData:CheckBattleModeCompat(targetPlayer)
	if not targetPlayer or not targetPlayer.Parent then
		return false, "Target player not found"
	end

	local targetPD = PlayerDataByPlayer[targetPlayer]
	if not targetPD then
		return false, "Target has no data"
	end

	local allowedModes = {'randomizer', 'spawner'}
	local mySpecial = false
	local targetSpecial = false

	for _, mode in pairs(allowedModes) do
		if self.gamemode == mode then mySpecial = true end
		if targetPD.gamemode == mode then targetSpecial = true end
	end

	if mySpecial ~= targetSpecial then
		return false, "Cannot battle across game modes"
	end

	return true, ""
end


-- BATTLE
function PlayerData:getTeamPreviewIcons()
	local icons = {}
	for i, p in pairs(self.party) do
		icons[i] = {p:getIcon(), (not p.egg and p.shiny) and true or false}
	end
	return icons
end
-- TRADE
function PlayerData:getPartyDataForTrade()
	local icons = {}
	local serialization = {}
	for i, p in pairs(self.party) do
		icons[i] = {
			p:getIcon(), -- 1
			p.shiny and true or false, -- 2 
			p.untradable and true or false, -- 3
			p.egg and p:getIcon(true) or false, -- 4
			p.item, -- 5
			p.hiddenAbility and true or false -- 6
		}
		serialization[i] = p:serialize(true)
	end
	return icons, serialization
end
function PlayerData:performTrade(myOffer, theirOffer, myEtc, theirSerializedParty)
	--    self.tradeCancelData = nil
	local cancel = {}
	self.tradeCancelData = cancel

	local oldParty = self.party
	local newParty = Functions.shallowcopy(oldParty)

	local placeholder = {}
	local receive = {}

	-- things for client
	local evolutions = {}
	local evoIds = {}

	for i = 1, 4 do
		if myOffer[i] then -- replace offers with placeholder
			newParty[myOffer[i] ] = placeholder

			-- remove OUR stamps
			local familiars = oldParty[myOffer[i] ]
			local stamps = familiars.stamps
			evoIds[i] = familiars.num
			familiars.stamps = nil

			if stamps then
				table.insert(cancel, function() familiars.stamps = stamps end)
				for _, stamp in pairs(stamps) do
					self:addStampToInventory(stamp)
					local stampId = _f.PBStamps:getStampId(stamp)
					table.insert(cancel, function()
						for i = #self.pbStamps, 1, -1 do
							local stamp = self.pbStamps[i]
							if stamp.id == stampId then
								stamp.quantity = stamp.quantity - 1
								if stamp.quantity < 1 then
									table.remove(self.pbStamps, i)
								end
							end
						end
					end)
				end
			end
			--
		end
		if theirOffer[i] then -- just collect receives for now
			table.insert(receive, theirSerializedParty[theirOffer[i] ])
		end
	end
	local checkParty = true
	for _, s in pairs(receive) do
		local inparty = false
		if checkParty then
			for i = 1, 6 do
				if newParty[i] == placeholder or newParty[i] == nil then
					local familiars = _f.ServerMon:deserialize(s, self)
					familiars.nickname = nil -- remove nicknames when trading
					familiars.stamps = nil-- remove THEIR stamps
					if familiars:getHeldItem().zMove then familiars.item = nil end -- remove THEIR zmoves

					newParty[i] = familiars
					local num = familiars.num
					if not familiars.egg and not self:hasOwnedFamiliars(num) then
						if not self:hasSeenFamiliars(num) then
							table.insert(cancel, function() self:unseeFamiliars(num) end)
						end
						table.insert(cancel, function() self:unownFamiliars(num) end)
						self:onOwnFamiliars(num)
					end
					-- evolution
					local evoData = familiars:generateEvolutionDecision(2, nil, nil, evoIds)
					if evoData then
						evolutions[#evolutions+1] = {
							familaName = familiars:getName(),
							known = (evoData.moves and familiars:getCurrentMovesData()),
							evo = evoData
						}
					end
					--
					inparty = true
					break
				end
			end
		end
		if not inparty then
			checkParty = false
			-- need to send to pc
			local familiars = _f.ServerMon:deserialize(s, self)
			familiars.nickname = nil -- remove nicknames when trading
			local box, pos = self:PC_sendToStore(familiars, true)
			table.insert(cancel, function()
				self.pc.boxes[box][pos] = nil
			end)
		end
	end
	for i = 6, 1, -1 do
		if newParty[i] == placeholder then
			table.remove(newParty, i)
		end
	end
	table.insert(cancel, function() self.party = oldParty end)
	self.party = newParty
	return self:serialize(myEtc), self:PC_serialize(), evolutions
end
function PlayerData:sealTrade()
	self.tradeCancelData = nil
end
function PlayerData:cancelTrade()
	local cancel = self.tradeCancelData
	if not cancel then return end
	for _, fn in pairs(cancel) do
		pcall(fn)
	end
end


-- UW Mining
function PlayerData:countBatteries()
	local bd = self:getBagDataById('umvbattery', 5)
	return bd and bd.quantity or 0
end

function PlayerData:buyBatteriesWithMoney(count, price, etc)
	if self.money < price then return 'fail' end
	if not self:addMoney(-price) then return 'fail' end

	self:addBagItems({id = 'umvbattery', quantity = count})
	spawn(function()
		if self.lastSaveEtc then
			self:saveGame(self.lastSaveEtc)
		end
	end)
	return 'ok', self:getBatteryCount()
end

function PlayerData:getBatteryCount()
	local bd = self:getBagDataById('umvbattery', 5)
	return (bd and bd.quantity) or 0
end

do
	local fossils = {
		helixfossil = 'Omanyte',
		domefossil  = 'Kabuto',
		oldamber    = 'Aerodactyl',
		rootfossil  = 'Lileep',
		clawfossil  = 'Anorith',
		skullfossil = 'Cranidos',
		armorfossil = 'Shieldon',
		coverfossil = 'Tirtouga',
		plumefossil = 'Archen',
		jawfossil   = 'Tyrunt',
		sailfossil  = 'Amaura',		
	}

	local Galarfossils = {
		"fossilizedbird", 
		"fossilizeddrake",
		"fossilizeddino",
		"fossilizedfish",
	}


	function PlayerData:hasFossil()
		local hasFossil, hasFossilEgg = false, false

		for fossil in pairs(fossils) do
			local bd = self:getBagDataById(fossil, 1)
			if bd and bd.quantity and bd.quantity > 0 then
				hasFossil = true
				break
			end
		end

		for i, fossil in pairs(Galarfossils) do
			local bd = self:getBagDataById(fossil, 1)
			if bd and bd.quantity and bd.quantity > 0 then
				hasFossil = true
				break
			end
		end

		for _, p in pairs(self.party) do
			if p.egg and p.fossilEgg then
				hasFossilEgg = true
				break
			end
		end
		return hasFossil, hasFossilEgg
	end


	function PlayerData:compatibleFossils(Fossil, secondFossil)
		local FossilId = _f.Database.ItemById[Fossil]
		local secondFossilId = _f.Database.ItemById[secondFossil]

		local fossilDetails = {
			["Fossilized Fish"] = {compatible = {
				["Fossilized Drake"] = "Dracovish", ["Fossilized Dino"] = "Arctovish"}},
			["Fossilized Drake"] = {compatible = {
				["Fossilized Fish"] = "Dracovish", ["Fossilized Bird"] = "Dracozolt"}},
			["Fossilized Dino"] = {compatible = {
				["Fossilized Fish"] = "Arctovish", ["Fossilized Bird"] = "Arctozolt"}},
			["Fossilized Bird"] = {compatible = {
				["Fossilized Drake"] = "Dracozolt", ["Fossilized Dino"] = "Arctozolt"}}
		}

		if not self:getBagDataByNum(FossilId.num) then return end -- exploit
		if not self:getBagDataByNum(secondFossilId.num) then return end -- exploit
		if FossilId.num == secondFossilId.num then return end -- trying to combine the same fossil
		if not fossilDetails[FossilId.name] then 
			warn("Failed check.") 
			return 
		end -- not a galar fossil?

		if fossilDetails[FossilId.name].compatible[secondFossilId.name] then

			return {
				FossilId.name,
				secondFossilId.name,
				fossilDetails[FossilId.name].compatible[secondFossilId.name],

				self:createDecision {
					callback = function(_, confirm)
						if not confirm then return end
						if not self:incrementBagItem(FossilId.num, -1) then return false end
						if not self:incrementBagItem(secondFossilId.num, -1) then return false end

						local familiars = self:newFamiliars {
							name = fossilDetails[FossilId.name].compatible[secondFossilId.name],
							level = 10,
							shinyChance = 1024,
						}
						return {
							familiars:getIcon(),
							(familiars.shiny and true or false),
							self:createDecision {
								callback = function(_, nickname)
									if type(nickname) == 'string' then
										familiars:giveNickname(nickname)
									end
									if #self.party < 6 then
										self:caughtFamiliars(familiars)
										return true
									else
										local box = (self:PC_sendToStore(familiars))
										return familiars:getName() .. ' was sent to Box ' .. box .. '!'
									end
								end
							}
						}
					end
				}
			}
		else
			warn("Not compatible")
			return
		end
	end


	function PlayerData:reviveFossil(fossilIdOrPartyIndex)
		if type(fossilIdOrPartyIndex) == 'string' then
			local familiarsName = fossils[fossilIdOrPartyIndex]

			if table.find(Galarfossils,fossilIdOrPartyIndex) then 
				return "GalarFossil"
			end

			if not familiarsName then
				return
			end

			local fossilItem = _f.Database.ItemById[fossilIdOrPartyIndex]
			if not self:getBagDataByNum(fossilItem.num) then return end

			return {
				fossilItem.name,
				familiarsName,
				self:createDecision {
					callback = function(_, confirm)
						if not confirm then return end
						if not self:incrementBagItem(fossilItem.num, -1) then return false end
						local familiars = self:newFamiliars {
							name = familiarsName,
							level = 10,
							createdBy = 'gf',
							shinyChance = 1024,
						}
						return {
							familiars:getIcon(),
							(familiars.shiny and true or false),
							self:createDecision {
								callback = function(_, nickname)
									if type(nickname) == 'string' then
										familiars:giveNickname(nickname)
									end
									if #self.party < 6 then
										self:caughtFamiliars(familiars)
										return true
									else
										local box = (self:PC_sendToStore(familiars))
										return familiars:getName() .. ' was sent to Box ' .. box .. '!'
									end
								end
							}
						}
					end
				}
			}
		elseif type(fossilIdOrPartyIndex) == 'number' then
			-- fossil egg
			local familiars = self.party[fossilIdOrPartyIndex]
			if not familiars or not familiars.fossilEgg then return end
			familiars.fossilEgg = nil
			return true
		end
	end
end
function PlayerData:diveInternal()
	if self.mineSession then pcall(function() self.mineSession:Destroy() end) end
	local ms = _f.MiningService:new(self)
	self.mineSession = ms
	return ms:next()
end

function PlayerData:dive()
	if _f.Context ~= 'adventure' or not self.completedEvents.DamBusted then return end
	if not self:incrementBagItem('umvbattery', -1) then return end
	return self:diveInternal()
end

function PlayerData:nextDig()
	if not self.mineSession then return end
	return self.mineSession:next()
end

function PlayerData:finishDig(...)
	if not self.mineSession or not self.mineSession.mGrid then return end
	return self.mineSession.mGrid:Finish(self, ...)
end


function PlayerData:nSpins()
	return self.stampSpins
end

function PlayerData:addStampToInventory(stamp)
	local stampId = _f.PBStamps:getStampId(stamp)
	for _, s in pairs(self.pbStamps) do
		if s.id == stampId then
			s.quantity = math.min(99, (s.quantity or 1) + (stamp.quantity or 1))
			return
		end
	end
	table.insert(self.pbStamps, {
		sheet = stamp.sheet,
		n = stamp.n,
		color = stamp.color,
		style = stamp.style,
		quantity = stamp.quantity or 1,
		id = stampId
	})
end

function PlayerData:spinForStamp()
	if self.stampSpins < 1 then return end

	-- use a spin
	self.stampSpins = self.stampSpins - 1
	-- get a random stamp
	local stamp = _f.PBStamps.getRandomStamp(function(...) return self:random2(...) end)
	-- add stamp to inventory
	self:addStampToInventory(stamp)
	-- attempt an autosave of the received stamp & used spin
	spawn(function()
		if self.lastSaveEtc then
			self:saveGame(self.lastSaveEtc)
		end
	end)

	return stamp
end

function PlayerData:familiarsInfoForStampSystem(familiars)
	local forme
	if familiars.forme then
		local id = familiars.name .. '-' .. familiars.forme
		if _f.Database.GifData._FRONT[id] then
			forme = familiars.forme
		end
	end
	return {
		species = familiars.name,
		shiny = familiars.shiny,
		gender = familiars.gender,
		pokeball = familiars.pokeball,
		forme = forme
	}
end

function PlayerData:stampInventory(familiarsSlot)
	local familiars = self.party[familiarsSlot]
	if not familiars or familiars.egg then return end

	local PBStamps = _f.PBStamps
	local getStampId = PBStamps.getStampId
	local getExtendedStampData = PBStamps.getExtendedStampData

	local pData = self:familiarsInfoForStampSystem(familiars)
	local pStamps = {}
	pData.stamps = pStamps
	local unaccountedFor = {}
	if familiars.stamps then
		for i, stamp in pairs(familiars.stamps) do
			unaccountedFor[getStampId(PBStamps, stamp)] = stamp
			pStamps[i] = getExtendedStampData(PBStamps, stamp)
		end
	end
	local inventory = {}
	for i, stamp in pairs(self.pbStamps) do
		inventory[i] = getExtendedStampData(PBStamps, stamp)
		unaccountedFor[stamp.id] = nil
	end
	for _, stamp in pairs(unaccountedFor) do
		local ed = getExtendedStampData(PBStamps, stamp)
		ed.quantity = 0
		inventory[#inventory+1] = ed
	end
	table.sort(inventory, function(a, b)
		--		if not a.tier or not b.tier then
		--			print(type(a), a)
		--			if type(a) == 'table' then
		--				Functions.print_r(a)
		--			end
		--			print(type(b), b)
		--			if type(b) == 'table' then
		--				Functions.print_r(b)
		--			end
		--		end
		if a.tier  ~= b.tier  then return a.tier  > b.tier  end
		if a.sheet ~= b.sheet then return a.sheet < b.sheet end
		if a.n     ~= b.n     then return a.n     < b.n     end
		if a.color ~= b.color then return a.color < b.color end
		return a.style < b.style
	end)
	return inventory, pData, self:ownsGamePass('ThreeStamps', true)
end

function PlayerData:setStamps(familiarsSlot, stampIds)
	local maxStamps = self:ownsGamePass('ThreeStamps', true) and 3 or 1
	if type(stampIds) ~= 'table' or #stampIds > maxStamps then return end
	local familiars = self.party[familiarsSlot]
	if not familiars then return end
	local updatedQuantities = {}
	local function getStampWithId(id)
		for i, stamp in pairs(self.pbStamps) do
			if stamp.id == id then
				return stamp, i
			end
		end
	end
	for i, id in pairs(stampIds) do
		if type(i) ~= 'number' then return end
		local q = updatedQuantities[id]
		if q then
			updatedQuantities[id] = q - 1
		else
			local stamp = getStampWithId(id)
			if stamp then
				updatedQuantities[id] = stamp.quantity - 1
			else
				updatedQuantities[id] = -1
			end
		end
	end
	if familiars.stamps then
		for i, stamp in pairs(familiars.stamps) do
			local id = stamp.id or _f.PBStamps:getStampId(stamp)
			local q = updatedQuantities[id]
			if q then
				updatedQuantities[id] = q + 1
			else
				local stamp = getStampWithId(id)
				if stamp then
					updatedQuantities[id] = stamp.quantity + 1
				else
					updatedQuantities[id] = 1
				end
			end
		end
	end
	for _, q in pairs(updatedQuantities) do
		if q < 0 then return end -- bad ending stamp count
	end
	for id, q in pairs(updatedQuantities) do
		local stamp, i = getStampWithId(id)
		if stamp then
			stamp.quantity = q
		else
			local sheet, n, color, style = id:match('(%d+),(%d+),(%d+),(%d+)')
			sheet, n, color, style = tonumber(sheet), tonumber(n), tonumber(color), tonumber(style)
			if sheet and n and color and style then
				stamp = {
					sheet = sheet,
					n = n,
					color = color,
					style = style,
					quantity = q,
					id = id
				}
				table.insert(self.pbStamps, stamp)
			else
				print('bad stamp id: could not convert "'..id..'" back to stamp (unequip)')
			end
		end
	end
	local pStamps = {}
	for i, id in pairs(stampIds) do
		local sheet, n, color, style = id:match('(%d+),(%d+),(%d+),(%d+)')
		sheet, n, color, style = tonumber(sheet), tonumber(n), tonumber(color), tonumber(style)
		if sheet and n and color and style then
			table.insert(pStamps, {
				sheet = sheet,
				n = n,
				color = color,
				style = style
			})
		else
			print('bad stamp id: could not convert "'..id..'" back to stamp (equip)')
		end
	end
	familiars.stamps = pStamps
end

function PlayerData:purchaseStampSpin(count, etc)
	local price = ({ [1] = 5000, [5] = 23000, [10] = 45000 })[count]
	if not price then return 'fail' end
	if not self:addMoney(-price) then return 'nm' end
	self.stampSpins = (self.stampSpins or 0) + count
	spawn(function()
		if self.lastSaveEtc then
			self:saveGame(self.lastSaveEtc)
		end
	end)
	return self.stampSpins -- ✅ return actual new total
end




function PlayerData:hasOKS()
	return self:getBagDataById('oddkeystone', 1) and true or false
end

function PlayerData:hasTT()
	return self:getBagDataById('tropicsticket', 5) and true or false
end

function PlayerData:hasSTP()
	return self:getBagDataById('skytrainpass', 5) and true or false
end

function PlayerData:hasFlute()
	return self:getBagDataById('familaflute', 5) and true or false
end

function PlayerData:hasRTM()
	local n = 0
	for _, p in pairs(self.party) do
		if not p.egg and p.name == 'Rotom' then
			n = n + 1
			if n > 1 then return n end
		end
	end
	return n
end

function PlayerData:hasJKey()
	local unowns = {}
	for _, p in pairs(self.party) do
		if p.num == 201 then
			unowns[p.forme or 'a'] = true
		end
	end
	local has = unowns.o and unowns.p and unowns.e and unowns.n
	self.flags.hasjkey = has
	return has
end

function PlayerData:getBatteryData ()
	return _f.Date:getDayId () > self.lastBatteryGivenDay
end

function PlayerData:getBPData()
	return _f.Date:getDayId () > self.lastBPGivenDay
end

function PlayerData:canBattleForBP()
	return self:getBPData()
end

function PlayerData:claimDailyBP(amount)
	if not self:getBPData() then return false end

	amount = tonumber(amount)
	if not amount or amount <= 0 then return false end

	self.lastBPGivenDay = _f.Date:getDayId()
	self:addBP(amount, true)

	return true
end


function PlayerData:getBattery()
	if not self:getBatteryData () then return false end
	self.lastBatteryGivenDay = _f.Date:getDayId()
	self:addBagItems({id = 'umvbattery', quantity = 1})
	return true
end

function PlayerData:getHoneyData()
	local honeyStatus = 0
	if self.honey then
		local now = os.time()
		if now > self.honey.slatheredAt + 60*60*24 then
			-- honey expires after 24 hours
			self.honey = nil
		elseif now >= self.honey.slatheredAt + 60*60 then
			-- honey attracts a familiars after 1 hour
			honeyStatus = self.honey.foe.num==216 and 2 or 3
		else
			-- still waiting for familiars, show honey on tree
			honeyStatus = 1
		end
	end
	return {
		canget = self:canGetHoney(),
		status = honeyStatus,
		has = (self:getBagDataById('honey', 1) and true or false)
	}
end
function PlayerData:canGetHoney()
	return _f.Date:getDayId() > self.lastHoneyGivenDay
end
function PlayerData:getHoney()
	if not self:canGetHoney() then return end
	self.lastHoneyGivenDay = _f.Date:getDayId()
	self:addBagItems({id = 'honey', quantity = 1})
end
function PlayerData:slatherHoney()
	if self.honey and os.time() < self.honey.slatheredAt + 60*60*24 then return false end
	if not self:incrementBagItem('honey', -1) then return false end

	local chunkData = _f.Database.ChunkData
	local encId = chunkData.chunk15.regions['Route 10'].HoneyTree.id
	local encList = chunkData.encounterLists[encId].list

	local foe = Functions.weightedRandom(encList, function(p) return p[4] end)
	local familiars = self:newFamiliars {
		name = foe[1],
		level = math.random(foe[2], foe[3]),
		shinyChance = 2048,
	}
	if self:ownsGamePass('AbilityCharm', true) and familiars.data.hiddenAbility and self:random2(512) == 69 then
		familiars.hiddenAbility = true
	end
	self.honey = {
		slatheredAt = os.time(),
		foe = familiars
	}
end

function PlayerData:isDinWM()
	local is = _f.Date:getWeekId() > self.lastDrifloonEncounterWeek and _f.Date:getWeekdayName() == 'Friday'
	if is then self.flags.DinWM = true end
	return is
end

function PlayerData:isTinD()
	local is = _f.Date:getWeekId() > self.lastTrubbishEncounterWeek and _f.Date:getWeekdayName() == 'Tuesday'
	if is then self.flags.TinD = true end
	return is
end

function PlayerData:isLapD()
	local is = _f.Date:getWeekId() > self.lastLaprasEncounterWeek and _f.Date:getWeekdayName() == 'Monday'
	if is then self.flags.LapD = true end
	return is
end

function PlayerData:buySushi()
	if not self:addMoney(-5000) then return 'nm' end
	local fortunes = {
		{'cheriberry', 10},
		{'chestoberry',10},
		{'rawstberry', 10},
		{'pechaberry', 10},
		{'aspearberry',10},
		{'prismscale',  5},
	}

	local itemId = Functions.weightedRandom(fortunes, function(o) return o[2] end)[1]
	local item = _f.Database.ItemById[itemId]
	self:addBagItems({num = item.num, quantity = 1})
	return item.name
end

-- bgc: Safari Zone

local cost, ballAmount = 500, 20

function PlayerData:moneySafari()
	return self.money < cost
end

local safariball = _f.Database.ItemById['safariball']

function PlayerData:enterSafari()
	self:addMoney(-cost)
	self:addBagItems({num = safariball.num, quantity = ballAmount})
end

function PlayerData:leaveSafari()
	local has = self:getBagDataByNum(safariball.num, 3).quantity
	if has > 0 then
		self:incrementBagItem(safariball.num, -has)
	end    
end

function PlayerData:getGreenhouseState()
	if self:getBagDataById('gracidea', 5) then return {f = 3} end -- already has flower
	local atLeastOneIsEvolved = false
	local uniqueFormes = 0
	local alreadyShown = {}
	for _, p in pairs(self.party) do
		if p.num == 669 or p.num == 670 or p.num == 671 then
			local forme = p.forme or 'r'
			if forme ~= 'e' then
				if not alreadyShown[forme] then
					uniqueFormes = uniqueFormes + 1
					alreadyShown[forme] = true
				end
				if p.num > 669 then
					atLeastOneIsEvolved = true
				end
			end
		end
	end
	if uniqueFormes < 5 then return {f = 1} end -- does not have all 5 formes
	return {
		f = 2,
		e = atLeastOneIsEvolved,
		d = self:createDecision {
			callback = function()
				self:addBagItems{id = 'gracidea', quantity = 1}
			end
		}
	}
end

function PlayerData:checkDeoxys(slot)
	local familiars = self.party[slot]
	if not familiars then
		return {f = 0} -- no familiars found
	end
	if familiars.num ~= 386 then
		return {f = 1} -- not Deoxys
	else
		return {f = 2} -- is Deoxys
	end
end

function PlayerData:changeDeoxysForm(slot, forme)
	local isbeable = {
		['Attack'] = true,
		['Defense'] = true,
		['Speed'] = true,
		['Normal'] = true
	}

	if not isbeable[tostring(forme)] then
		return false, "Invalid form."
	end

	local famila = self.party[slot]
	if not famila or famila.num ~= 386 then
		return false, "This can only be used on Deoxys."
	end

	famila.forme = tostring(forme)

	-- For example:
	if forme == nil or forme == "Normal" then
		famila.forme = nil
		famila.data = _f.Database.FamiliarsById.deoxys -- base form data
	else
		famila.forme = tostring(forme)
		if forme == "Attack" then
			famila.data = _f.Database.FamiliarsById.deoxysattack
		elseif forme == "Defense" then
			famila.data = _f.Database.FamiliarsById.deoxysdefense
		elseif forme == "Speed" then
			famila.data = _f.Database.FamiliarsById.deoxysspeed
		end
	end

	famila:calculateStats()

	return true, famila:getName() .. " changed to " .. forme .. " form!"
end

-- Birds
function PlayerData:birdsitem()
	local items = {}
	items.vt = self:getBagDataById('voltaicticket', 5) and true or false
	items.ft = self:getBagDataById('frigidticket', 5) and true or false
	items.ot = self:getBagDataById('obsidianticket', 5) and true or false
	return items
end

function PlayerData:buybirdsitem(item)
	if not self.completedEvents.vPortDecca then return false end
	if self:hasdss() == 0 then return false end

	local itemid
	if item == 'Voltaic Ticket' then itemid = 'voltaicticket' end
	if item == 'Frigid Ticket' then itemid = 'frigidticket' end
	if item == 'Obsidian Ticket' then itemid = 'obsidianticket' end

	self:incrementBagItem('deepseascale', -1)
	self:addBagItems{id = itemid, quantity = 1}
end

function PlayerData:hasdss()
	local deepseascale = _f.Database.ItemById.deepseascale
	local ndeepseascale = 0
	pcall(function() ndeepseascale = self:getBagDataByNum(deepseascale.num, 1).quantity end)
	return ndeepseascale
end

function PlayerData:getFroster()
	if not self.completedEvents.vPortDecca then return end
	return self:getMoveUser('frostbreath')
end

function PlayerData:getStrengthen()
	if not self.badges[7] then return end
	return  self.badges[7]
end


--// Slope
function PlayerData:reportSlopeTime(dur)
	if self.slopeRecord then
		if self.slopeRecord > dur then
			self.slopeRecord = dur
			return true
		end
	else
		self.slopeRecord = dur
		return true
	end
	return false
end

function PlayerData:giveEkans(slot)
	if type(slot) ~= 'number' or self.completedEvents.GiveEkans then return end
	local familiars = self.party[slot]
	if not familiars or familiars.num ~= 23 then return end
	return self:createDecision {
		callback = function(_, accept)
			if not accept or self.party[slot] ~= familiars then return end
			table.remove(self.party, slot)
			self:completeEventServer('GiveEkans')
			if familiars.shiny then self:completeEventServer('gsEkans') end
			self:addBagItems({id = 'familaflute', quantity = 1})
			pcall(function() familiars:destroy() end)
		end
	}
end



function PlayerData:motorize(forme, slot)
	if not forme then return end
	local rotom
	if type(slot) == 'number' then
		rotom = self.party[slot]
		if not rotom or rotom.name ~= 'Rotom' then return end
	else
		for _, p in pairs(self.party) do
			if p.name == 'Rotom' then
				if rotom then return end
				rotom = p
			end
		end
	end
	local forgot, learned, tryLearn, decision
	if forme == rotom.forme then
		forme = nil
	end
	local function setforme()
		rotom.forme = forme
		rotom.data = _f.Database.FamiliarsById['rotom'..(forme or '')]
	end
	local formeMoves = {
		fan = 'airslash',
		frost = 'blizzard',
		heat = 'overheat',
		mow = 'leafstorm',
		wash = 'hydropump'
	}
	local knownMoves = rotom:getMoves()
	for _, moveId in pairs(formeMoves) do
		for i = #knownMoves, 1, -1 do
			if knownMoves[i].id == moveId then
				forgot = knownMoves[i].name
				table.remove(rotom.moves, i)
				table.remove(knownMoves, i)
				break
			end
		end
	end
	local formeMove = forme and formeMoves[forme]
	if formeMove then
		local move = _f.Database.MoveById[formeMove]
		if #rotom.moves < 4 then
			learned = move.name
			table.insert(rotom.moves, {id = formeMove})
			setforme()
		else
			local d = rotom:generateDecisionsForMoves({move.num})
			local dd = self.decision_data[d[1].id]
			local cb = dd.callback
			dd.callback = function(...)
				local r = cb(...)
				if r == true then
					setforme() -- if not resetting forme, it is required to learn the move to complete the change
				end
				return r
			end
			tryLearn = d
		end
	end
	if not forme then
		setforme()
		if #rotom.moves == 0 then
			rotom.moves[1] = {id = 'thundershock'}
		end
	end
	return {
		f = forgot,
		l = learned,
		t = tryLearn,
		k = tryLearn and rotom:getCurrentMovesData() or nil,
		n = rotom:getName(),
		r = forme==nil and true or false,
	}
end

--// Roulette
local rouletteIDToTier = {
	[Assets.productId.RouletteSpinBasic] = 1,
	[Assets.productId.RouletteSpinBronze] = 2,
	[Assets.productId.RouletteSpinSilver] = 3,
	[Assets.productId.RouletteSpinGold] = 4,
	[Assets.productId.RouletteSpinDiamond] = 5
}

local status

local TierIdToName = {
	"Basic",
	"Bronze",
	"Silver",
	"Gold",
	"Diamond",
}
function PlayerData:spinRouletteForfamila()
	if self.rouletteSpins < 1 then return end
	self.rouletteSpins = self.rouletteSpins - 1

	local rouletteId = rouletteIDToTier[self.currentRouletteTier]
	local famila       = _f.RouletteSpinner.getRandomFamiliars(function(...) return self:random2(...) end, rouletteId)
	local tierName   = TierIdToName[rouletteId]

	-- build the chat message
	local msg = string.format(
		"<b><font color=\"#E74C3C\">%s just won %s from the %s Roulette!</font></b>",
		self.player.Name,
		famila.species,
		tierName
	)

	-- broadcast to all players in system-chat
	_f.Network:postAll("SystemChat", msg)

	-- give the prize & save
	self:addSpinWinToInventory(famila, rouletteId)
	spawn(function()
		if self.lastSaveEtc then
			self:saveGame(self.lastSaveEtc)
		end
	end)

	self.currentRouletteTier = nil
	return famila
end

local rouletteTierToProductId = {
	[1] = Assets.productId.RouletteSpinBasic,
	[2] = Assets.productId.RouletteSpinBronze,
	[3] = Assets.productId.RouletteSpinSilver,
	[4] = Assets.productId.RouletteSpinGold,
	[5] = Assets.productId.RouletteSpinDiamond,
}

function PlayerData:giveRouletteCodeSpin(tier)
	tier = tonumber(tier) or 1
	tier = math.clamp(tier, 1, 5)

	local productId = rouletteTierToProductId[tier]
	if not productId then
		return false
	end

	self.rouletteSpins = 1
	self.currentRouletteTier = productId

	_f.Network:post("OpenRouletteAndSpin", self.player, tier)

	spawn(function()
		if self.lastSaveEtc then
			self:saveGame(self.lastSaveEtc)
		end
	end)

	return true
end


function PlayerData:checkMon(Id, forme)
	print("[DEBUG] checkMon called with Id:", Id, "forme:", forme)

	local badWifi = false 
	local hasMon = false
	local src = storage.Models.File
	local Model = src.Models:FindFirstChild(Id)
	local Animation = src.Animations:FindFirstChild(Id)

	print("[DEBUG] Initial Model:", Model, "Initial Animation:", Animation)

	if forme then
		local Directory = src.Forme:FindFirstChild(Id)
		if not Directory then
			print("[DEBUG] Directory not found for Id:", Id)
		end

		local Forme = Directory and Directory:FindFirstChild(forme)
		if not Forme then
			print("Forme not found for forme:", forme)
		end

		if Directory and Forme then
			Model = Forme[Id]
			Animation = Forme.Animation
			print("Model and Animation updated for forme. Model:", Model, "Animation:", Animation)
		end
	end

	if Model and Animation then
		hasMon = true
		print("hasMon set to true")
	else
		print("Model or Animation missing. hasMon remains false")
	end

	return hasMon
end

function PlayerData:getMon(remove, Id, forme, look, customName)
	if remove then
		local folder = self.player.PlayerGui:FindFirstChild(self.player.UserId)
		if folder then folder:Destroy() end
		return
	end

	local src = storage.Models.File
	local modelSrc = src.Models:FindFirstChild(Id)
	local animSrc = src.Animations:FindFirstChild(Id)

	if type(forme) == "string" then
		local dir = src.Forme:FindFirstChild(Id)
		local formeData = dir and dir:FindFirstChild(forme)
		if formeData then
			modelSrc = formeData[Id]
			animSrc = formeData.Animation
		end
	end

	if not modelSrc or not animSrc then
		error("Missing model or animation for: " .. tostring(Id))
	end

	local Model = modelSrc:Clone()
	local Animation = animSrc:Clone()
	Animation.Parent = Model

	if customName then
		Model.Name = customName
	end

	if look then
		Model.Parent = workspace
		return {Model, Animation}
	end

	local folder = self.player.PlayerGui:FindFirstChild(self.player.UserId)
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = self.player.UserId
		folder.Parent = self.player.PlayerGui
	end

	Model.Parent = folder
	return {Model, Animation}
end



function PlayerData:savePrompt(remoteEvent: remoteEvent)
	remoteEvent:FireAllClients(self.player)
end

function PlayerData:LoadTextureMon(model, shiny, MMData)
	if not model or not MMData then return end

	local directory = shiny and MMData.Shiny or MMData.Normal

	if typeof(directory) ~= "table" then return end

	for _, part in ipairs(model:GetChildren()) do
		if part:IsA("MeshPart") and directory[part.Name] then
			part.TextureID = "rbxassetid://" .. directory[part.Name]
		end
	end
end


function PlayerData:addSpinWinToInventory(famila, rouletteId)
	if famila.species then
		local wonfamila = self:newFamiliars {
			name = famila.species,
			level = 15,
			shinyChance = 2048,

		}

		spawn(function()
			pcall(function()
				_f.Logs:logRoulette(self.player, {
					won = {
						name = wonfamila.name,
						shiny = wonfamila.shiny,
						hiddenAbility = wonfamila.hiddenAbility,
					}, 
					tier = TierIdToName[rouletteId]
				})
			end)
		end)

		local box = self:caughtFamiliars(wonfamila)
		if box then
			return
		end
	end
end

--// Surf
function PlayerData:getSurfer()
	local pName = self.badges[7]
	if pName then 
		return true 
	end
	return false
end

function PlayerData:getMant()
	local pName = self.badges[7]
	if pName then 
		return true 
	end
	return false
end

function PlayerData:surf(setPos)	
	self.SurfEnabled = true
	local char = self.player.Character
	local root = char.HumanoidRootPart

	local part = game.ReplicatedStorage.Models.GenericSurf:Clone()
	part.Parent = char

	if setPos then
		part.CFrame = CFrame.new(root.Position + root.CFrame.LookVector*10)
	end

	local weld = Functions.Create('Weld') {Parent = part, Part0 = part, Part1 = root}

	part.Position = part.Position - Vector3.new(0, 4, 0) 

	return part, weld
end 

function PlayerData:unsurf()
	self.SurfEnabled = false
	local player = self.player
	local char = player.Character
	if not char then return end
	local root = char:FindFirstChild('HumanoidRootPart')
	if not root then return end

	if char:FindFirstChild('GenericSurf') then
		char.GenericSurf.Weld:Destroy()
		char:FindFirstChild('GenericSurf'):Destroy()	
	end
end
function PlayerData:mountMant(setPos)
	self.mountedM = true
	local char = self.player.Character
	local root = char.HumanoidRootPart

	local mant = game.ReplicatedStorage.Models.MantineS:Clone()
	local part = mant.sad
	mant.Parent = char

	if setPos then
		mant.CFrame = CFrame.new(root.Position + root.CFrame.LookVector*10)
	end

	mant.RootPart.Position = mant.RootPart.Position - Vector3.new(0, 4, 0) 
	local weld = Functions.Create('Weld') {Parent = part, Part0 = part, Part1 = root}

	return part, weld, mant
end 
function PlayerData:unmountMant()
	self.mountedM = false
	local player = self.player
	local char = player.Character
	if not char then return end
	local root = char.HumanoidRootPart
	if not root then return end

	if char:FindFirstChild('MantineS') then
		char.MantineS.Weld.Part1 = nil
		char.MantineS:Destroy()	
	end
end

function PlayerData:RevealCatacombs()
	local mons = {}
	mons.g = self.party[1] and self.party[1].num == 203
	mons.d = self.party[6] and self.party[6].num == 206
	local has = mons.g and mons.d
	self.flags.RevealCatacombs = has
	return has
end

function PlayerData:has3birds()
	local birds = {}
	for _, p in pairs(self.party) do
		if p.num == 144 then -- Articuno
			birds.a = true
		end
		if p.num == 145 then -- Zapdos
			birds.z = true
		end
		if p.num == 146 then -- Moltres
			birds.m = true
		end
	end
	local has = birds.a and birds.z and birds.m
	self.flags.has3birds = has
	return has
end


function PlayerData:has3beasts ()
	local beasts = {}

	for _,p in pairs(self.party) do 
		if p.num == 243 then 
			beasts.r = true
		end
		if p.num == 244 then 
			beasts.e = true
		end
		if p.num == 245 then 
			beasts.s = true
		end
	end
	local has = beasts.r and beasts.e and beasts.s
	self.flags.has3beasts = has
	return has
end


function PlayerData:has3regis()
	local regis = {}
	for _, p in pairs(self.party) do
		if p.num == 377 then -- Regirock
			regis.r = true 
		end
		if p.num == 378 then -- Regice
			regis.i = true
		end
		if p.num == 379 then -- Registeel
			regis.s = true
		end
	end
	local reg = regis.r and regis.i and regis.s
	self.flags.has3regis = reg
	return reg
end

function PlayerData:has3ghosts()
	local ghosts = {}
	for _, p in pairs(self.party) do
		if p.num == 93 then -- Haunter
			ghosts.g = true 
		end
		if p.num == 200 then -- Misdreavus
			ghosts.m = true 
		end
		if p.num == 679 then -- Honedge
			ghosts.h = true 
		end
	end
	local has = ghosts.g and ghosts.m and ghosts.h
	self.flags.has3ghosts = has
	return has
end

function PlayerData:hasSwordsOJ()
	local SwordsOJ = {}
	for _, p in pairs(self.party) do
		if p.num == 638 then -- Coballion
			SwordsOJ.c = true
		end
		if p.num == 639 then -- Terrakion 
			SwordsOJ.t = true
		end
		if p.num == 640 then -- Virizion
			SwordsOJ.v = true
		end
	end
	local has = SwordsOJ.c and SwordsOJ.t and SwordsOJ.v
	self.flags.hasSwordsOJ = has
	return has
end

function PlayerData:has3forces()
	local forces = {}
	for _, p in pairs(self.party) do
		if p.num == 641 then -- Tornadus
			forces.t = true 
		end
		if p.num == 642 then -- Thundurus
			forces.h = true
		end
		if p.num == 645 then -- Landorus
			forces.l = true
		end
	end
	local has = forces.t and forces.h and forces.l
	self.flags.has3forces = has
	return has
end

function PlayerData:getChunkData()
	return table.clone(_f.Database.ChunkData)
end

function PlayerData:getInfoOf(speciesid, forme)
	local familiarsId = speciesid .. forme
	local familaData = _f.Database.FamiliarsById[familiarsId:gsub("%W", "")] or _f.Database.FamiliarsById[speciesid:gsub("%W", "")]
	if not familaData then
		return
	end

	local tbl = {
		number = familaData.num,
		hasSeen = self:hasSeenFamiliars(familaData.num),
		icon = familaData.icon
	}

	return tbl
end

function PlayerData:getAllRegions()
	local chunkData = _f.Database.ChunkData
	local orderedChunks = {}
	for chunkId, _ in pairs(chunkData) do
		table.insert(orderedChunks, chunkId)
	end
	table.sort(orderedChunks, function(a, b)
		local numA = tonumber(a:match("%d+"))
		local numB = tonumber(b:match("%d+"))
		if numA and numB then
			return numA < numB
		end
		return a < b
	end)
	local regionList = {}
	local seenRegions = {}
	for _, chunkId in ipairs(orderedChunks) do
		local data = chunkData[chunkId]
		if data.regions then
			for regionName, _ in pairs(data.regions) do
				if not seenRegions[regionName] then
					seenRegions[regionName] = true
					table.insert(regionList, regionName)
				end
			end
		end
	end
	return regionList
end

function PlayerData:hasvolitems(item, dotake4)
	if self.completedEvents.RevealSteamChamber then return false end

	local items = {
		bigmushroom = false,
		chilanberry = false,
		stardust = false,
		epineshroom = false
	}
	if self:getBagDataById('bigmushroom', 1) then items.bigmushroom = true end
	if self:getBagDataById('chilanberry', 4) then items.chilanberry = true end
	if self:getBagDataById('stardust', 1) then items.stardust = true end
	if self:getBagDataById('epineshroom', 5) then items.epineshroom = true end

	if not self.completedEvents.vPortDecca then return items end -- down here bc rock guy

	if items[item] then
		if item == 'bigmushroom' then
			if not self.completedEvents.VolItem1 then
				self:completeEventServer('VolItem1')
				self:incrementBagItem(item, -1)
			end
		elseif item == 'chilanberry' then
			if not self.completedEvents.VolItem2 then
				if not self.completedEvents.VolItem1 then return false end
				self:completeEventServer('VolItem2')
				self:incrementBagItem(item, -1)
			end
		elseif item == 'stardust' then
			if not self.completedEvents.VolItem3 then
				if not self.completedEvents.VolItem2 then return false end
				self:completeEventServer('VolItem3')
				self:incrementBagItem(item, -1)
				self:addBagItems{id = 'epineshroom', quantity = 1}
			end
		elseif item == 'epineshroom' then
			if not self.completedEvents.RevealSteamChamber then
				if not dotake4 then return items end
				if not self.completedEvents.VolItem3 then return false end -- WHAT (PROB A BUG OR SERVER SIDE EXPLOIT)
				self:completeEventServer('RevealSteamChamber')
				self:incrementBagItem(item, -1)
			end
		end
	end
	return items
end

function PlayerData:hasZAitems(item, dotake4)
	if self.completedEvents.MegaMagearna then return false end

	local items = {
		bigmushroom = false,
		chilanberry = false,
		stardust = false,
		epineshroom = false,
		shucaberry = false,
	}
	if self:getBagDataById('bigmushroom', 1) then items.bigmushroom = true end
	if self:getBagDataById('chilanberry', 4) then items.chilanberry = true end
	if self:getBagDataById('shucaberry', 4) then items.shucaberry = true end
	if self:getBagDataById('stardust', 1) then items.stardust = true end
	if self:getBagDataById('epineshroom', 5) then items.epineshroom = true end

	if not self.badges[8] then return items end

	if items[item] then
		if item == 'bigmushroom' then
			if not self.completedEvents.VolItem1 then
				self:completeEventServer('VolItem1')
				self:incrementBagItem(item, -1)
			end
		elseif item == 'chilanberry' then
			if not self.completedEvents.VolItem2 then
				self:completeEventServer('VolItem2')
				self:incrementBagItem(item, -1)
			end
		elseif item == 'stardust' then
			if not self.completedEvents.VolItem3 then
				self:completeEventServer('VolItem3')
				self:incrementBagItem(item, -1)
				self:addBagItems{id = 'epineshroom', quantity = 1}
			end
		elseif item == 'shucaberry' then
			if not self.completedEvents.MegaMeganium then
				self:completeEventServer('MegaMeganium')
				self:incrementBagItem(item, -1)
			end
		elseif item == 'epineshroom' then
			if not dotake4 then return items end
			if not self.completedEvents.VolItem3 then return false end -- WHAT (PROB A BUG OR SERVER SIDE EXPLOIT)
			self:completeEventServer('RevealSteamChamber')
			self:incrementBagItem(item, -1)
		end
	end
	return items
end

function PlayerData:GetGroup()
	return self.player:IsInGroup(35693690)
end


--// Spawner
function createspawnfamila(dat, player, self)
	if player ~= self.player then
		player = PlayerDataByPlayer[player]
	else
		player = self
	end

	local mon = player:newFamiliars(dat)

	player:PC_sendToStore(mon)
end

function getplayerstring(otherplayer)
	if otherplayer then
		return ' for '..otherplayer.Name
	else
		return ''
	end
end
function PlayerData:Spawnfamila(dat, otherplayer)
	local perms = self:GetPerms()

	-- Allow access if gamemode is 'spawner', or if player has perms
	if self.gamemode ~= 'spawner' and not perms then
		self.player:Kick('Please avoid exploiting. Further exploitation can and will result in a permanent ban.')
		return
	end

	if otherplayer ~= '' then 
		otherplayer = game:GetService('Players'):FindFirstChild(otherplayer) or false
		if not otherplayer then
			return 'Player not found.'
		end
	else
		otherplayer = false 
		if not perms then
			dat.untradable = true 
		end
	end

	-- Spawn the Familiars
	local receiver = otherplayer or self.player
	createspawnfamila(dat, receiver, self)

	-- Log
	_f.Logs:logPanel(self.player,{
		spawner = "Familiars",
		forPlr = otherplayer,
		details = dat
	})

	-- Generate summary message
	local name     = dat.name or "Familiars"
	local level    = dat.level or "?"
	local natureId = tonumber(dat.nature) or _f.Functions.GetNatureId(dat.nature)
	if not natureId then
		natureId = math.random(1, 25)
	end
	local nature = _f.Functions.getNatureById(natureId) or "Unknown"
	local item     = dat.item and dat.item ~= "" and dat.item or "None"

	local tags = {}
	if dat.shiny then table.insert(tags, "✨ Shiny") end
	if dat.hiddenAbility then table.insert(tags, "HA") end
	if dat.egg then table.insert(tags, "🥚 Egg") end
	if dat.untradable then table.insert(tags, "🔒 Untradable") end

	local tagStr = #tags > 0 and (" ["..table.concat(tags, ", ").."]") or ""
	local forPlayer = otherplayer and (" for "..otherplayer.Name) or ""

	local summary = string.format("✅ Spawned %s (Lv%s) with Nature %s, Item: %s%s%s.",
		name, level, nature, item, tagStr, forPlayer
	)
	-- Format IVs and EVs for display
	local function formatStatList(list)
		return table.concat(list or {}, "/")
	end

	local ivsStr = "IVs: " .. formatStatList(dat.ivs)
	local evsStr = "EVs: " .. formatStatList(dat.evs)

	summary = summary .. "\n" .. ivsStr .. "\n" .. evsStr

	return summary
end


function createspawnitem(dat, player, self)
	if player ~= self.player then
		player = PlayerDataByPlayer[player]
	else
		player = self
	end

	player:addBagItems({
		id = dat.itemid,
		quantity = dat.quantity
	})
end
function PlayerData:SpawnItem(dat, otherplayer)
	local perms = self:GetPerms()

	-- Allow item spawning if gamemode is 'spawner', or if player has perms
	if self.gamemode ~= 'spawner' and not perms then
		self.player:Kick('Please avoid exploiting. Further exploitation can and will result in a permanent ban.')
		return
	end

	if otherplayer ~= '' then
		otherplayer = game:GetService('Players'):FindFirstChild(otherplayer) or false
		if not otherplayer then
			return 'Player not found.'
		end
	else
		otherplayer = false
	end

	local receiver = otherplayer or self.player
	local itemInfo = _f.Database.ItemById[dat.itemid]
	local itemName = itemInfo and itemInfo.name or "Unknown Item"

	_f.Logs:logPanel(self.player, {
		spawner = "Item",
		forPlr = otherplayer,
		item = itemName,
		amount = dat.quantity,
	})

	createspawnitem(dat, receiver, self)

	return string.format("✅ Spawned %d %s%s.",
		dat.quantity or 1,
		itemName,
		otherplayer and (" for " .. otherplayer.Name) or ""
	)
end

function createspawncurrency(dat, player, self)
	if player ~= self.player then
		player = PlayerDataByPlayer[player]
	else
		player = self
	end

	if dat.currency == 'Stamp' then
		player.stampSpins = math.min(99, (player.stampSpins or 0) + dat.quantity)
		_f.Network:post('uPBSpins', player.player, player.stampSpins)
	else
		local method = player['add' .. dat.currency]
		if typeof(method) == "function" then
			method(player, dat.quantity)
		end
	end
end

function PlayerData:SpawnCurrency(dat, otherplayer)
	local perms = self:GetPerms()

	-- Allow currency spawning if gamemode is 'spawner', or if player has perms
	if self.gamemode ~= 'spawner' and not perms then
		self.player:Kick('Please avoid exploiting. Further exploitation can and will result in a permanent ban.')
		return
	end


	if otherplayer ~= '' then
		otherplayer = game:GetService('Players'):FindFirstChild(otherplayer) or false
		if not otherplayer then
			return 'Player not found.'
		end
	else
		otherplayer = false
	end

	local receiver = otherplayer or self.player
	_f.Logs:logPanel(self.player, {
		spawner = "Currency",
		forPlr = otherplayer,
		cur = dat.currency,
		qty = dat.quantity
	})

	createspawncurrency(dat, receiver, self)

	return string.format("✅ Spawned %d %s%s.",
		dat.quantity or 1,
		dat.currency,
		otherplayer and (" for " .. otherplayer.Name) or ""
	)
end


function PlayerData:ShutdownServers(dat)

	local perms = self:GetPerms()

	if perms then
		local data = {
			dat
		}
		game:GetService("MessagingService"):PublishAsync('Inbox', data)
	else
		self.player:Kick('I\'m shocked, you actually thought you\'d somehow go through all of this to find our remote, just to get kicked regardless.')
	end
end
function PlayerData:GetPerms()
	-- Hard-coded perm list
	local plr = {
		1599477633,
		1270438,
		193285149,
		5821414015,
		1577356661,
		93351630,
		449545310,
		7096933672,
		4907770549,
		322963092,
		5616133508,
		91326207
	}

	if table.find(plr, self.userId) then
		return true
	end
	
	return self:IsContentCreator()
end


local GROUP_ID = 35693690
local CONTENT_CREATOR_RANK = 2

function PlayerData:IsContentCreator()
	local success, rankId = pcall(function()
		return self.player:GetRankInGroup(GROUP_ID)
	end)

	if not success then
		return false
	end

	return rankId == CONTENT_CREATOR_RANK
end

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local codes = {}
local lastFetchTime = 0
local FETCH_COOLDOWN = 300 -- 5 minutes
local hasRefreshedOnce = false

-- Fetch codes from VPS
local function fetchCodesFromVPS()
	local apiKey = "sdkjnbfllsikgnsdljkfndlkhjgbhdsjfbndjklfnisdkngsdhfjkllnbgdsljkbnflisdkn"
	local url = "http://145.223.74.141:3015/codes?key=" .. apiKey
	local success, response = pcall(function()
		return HttpService:GetAsync(url)
	end)

	if success and response then
		--	print("✅ VPS response received")
		return response
	else
		warn("❌ Failed to fetch codes from VPS:", response)
		return nil
	end
end

-- Refresh codes
function refreshCodes(force)
	force = force or false
	if not force and hasRefreshedOnce and os.time() - lastFetchTime < FETCH_COOLDOWN then
		--	print("🧠 Using cached codes. Last fetch:", os.date("%X", lastFetchTime))
		return codes
	end

	--	print("🌐 Fetching codes from VPS…")
	local src = fetchCodesFromVPS()
	if not src then
		warn("⚠ No response from VPS, using cached codes")
		return codes
	end

	local success, func = pcall(loadstring, src)
	if not success or not func then
		warn("❌ Invalid Lua code received from VPS")
		return codes
	end

	local result, loadedCodes = pcall(func)
	if not result or type(loadedCodes) ~= "table" then
		warn("❌ Failed to execute or parse codes from Lua script")
		return codes
	end

	codes = loadedCodes
	lastFetchTime = os.time()
	hasRefreshedOnce = true
	--	print("✅ Codes refreshed at", os.date("%X"))
	return codes
end

-- Auto-refresh loop (works in Studio or live)
task.spawn(function()
	while true do
		--	print("🔄 Auto-refreshing codes loop")
		refreshCodes(false)
		task.wait(60) -- test interval: 1 minute
	end
end)

-- PlayerData checkCode
function PlayerData:checkCode(codeplayer, gamemode, etc)
	local data = _f.MySqlService:GetDatabase("Codes")
	local message = "Invalid Code."
	self.gamemode = gamemode or "adventure"

	for _, code in pairs(codes) do
		if code.Name == codeplayer then
			local codeKey = code.Name .. "_" .. tostring(self.player.UserId) .. "_" .. self.gamemode

			-- Already redeemed
			if data:GetAsync(codeKey) then
				return "You've already redeemed this code in " .. self.gamemode .. " mode!"
			end

			-- Expired
			if code.Date and code.Date <= os.time() then
				return "This code has expired."
			end

			-- License-only check
			if code.LicenseOnly then
				if not self:HasLicense() then
					return "This code is only available to premium players."
				end
			end

			-- Limit check
			local currentUses = tonumber(data:GetAsync(code.Name)) or 0
			if code.Limit and currentUses >= code.Limit then
				return tostring(code.Limit) .. " people already used this code."
			end

			-- Badge requirement
			if code.RequireBadge and not self.badges[code.RequireBadge] then
				local badgeName = _f.BadgeNames and _f.BadgeNames[code.RequireBadge] or "required badge"
				return "You need the " .. badgeName .. " to redeem this code."
			end

			-- Redeem code
			local result = code.Function(self)
			data:SetAsync(codeKey, "true")
			if code.Limit then
				data:SetAsync(code.Name, tostring(currentUses + 1))
			end

			return result or "Code redeemed!"
		end
	end

	return message
end





function PlayerData:getCodeList()
	refreshCodes(false)

	local data = _f.MySqlService:GetDatabase("Codes")
	local result = {}

	for _, code in ipairs(codes) do
		local redeemed = false
		local expired = false
		local reachedLimit = false

		local codeKey = code.Name .. "_" .. tostring(self.player.UserId) .. "_" .. (self.gamemode or "adventure")

		-- Redeemed check
		if data:GetAsync(codeKey) then
			redeemed = true
		end

		-- Expiry check
		if code.Date and code.Date <= os.time() then
			expired = true
		end

		-- Limit check
		if code.Limit then
			local currentUses = tonumber(data:GetAsync(code.Name)) or 0
			if currentUses >= code.Limit then
				reachedLimit = true
			end
		end

		-- Description
		local desc = ""
		if code.RewardText then
			desc = code.RewardText
		elseif code.Function and debug.getinfo then
			-- fallback (optional): auto-label
			desc = "Mystery Reward"
		end

		table.insert(result, {
			name = code.Name,
			reward = desc,
			redeemed = redeemed,
			expired = expired,
			limited = reachedLimit
		})
	end

	return result
end

function PlayerData:resetRedeemedCodesForMode(mode)
	local data = _f.MySqlService:GetDatabase("Codes")
	local userId = tostring(self.player.UserId)

	for _, code in pairs(codes) do
		local key = code.Name .. "_" .. userId .. "_" .. mode
		data:SetAsync(key, nil)
	end
end



--// Hidden Power
function PlayerData:gethptype(familiarsIndex)
	if not familiarsIndex or not self.party[familiarsIndex] then return end
	local familiars = self.party[familiarsIndex]
	if familiars.egg then return nil end

	local stattable = {'hp', 'atk', 'def', 'spa', 'spd', 'spe'}
	local ivtable = {}
	for i, v in pairs(familiars.ivs) do
		local ivname = stattable[i]
		ivtable[ivname] = familiars.ivs[i]
	end

	local function getLSB(iv)
		return iv % 2
	end

	local a = getLSB(ivtable['hp'])
	local b = getLSB(ivtable['atk'])
	local c = getLSB(ivtable['def'])
	local d = getLSB(ivtable['spe'])
	local e = getLSB(ivtable['spa'])
	local f = getLSB(ivtable['spd'])

	local sum = a + 2 * b + 4 * c + 8 * d + 16 * e + 32 * f
	local hpTypeIndex = math.floor((sum * 15) / 63)

	local hpTypes = {'Fighting', 'Flying', 'Poison', 'Ground', 'Rock', 'Bug', 'Ghost', 'Steel', 'Fire', 'Water', 'Grass', 'Electric', 'Psychic', 'Ice', 'Dragon', 'Dark'}

	return hpTypes[hpTypeIndex + 1]
end
--// Lotto
function PlayerData:drawLotto(etc)
	if self.lottoTries == 4 then return end 
	self.ticket = nil 
	if tonumber(os.date('%j')) ~= self.lastLottoTryDay then 
		self.lottoTries = 0 
	end
	if self.lottoTries >= 1 then 
		local processed = false 
		table.insert(self.lottoTicketProductStack, function()
			if processed then return end
			warn("processed")
			processed = true
		end)
		game:GetService('MarketplaceService'):PromptProductPurchase(self.player, Assets.productId.LottoTicket)
		for i = 1, 40 do
			wait(.5)
			if processed then break end
		end
		if self.ticket then 
			self.lottoTries = self.lottoTries + 1 
			self.lastLottoTryDay = tonumber(os.date('%j'))
		end
	else
		self.lottoTries = self.lottoTries + 1 
		self.ticket = math.random(99999)
		self.lastLottoTryDay = tonumber(os.date('%j'))
	end
	spawn(function()
		if self.lastSaveEtc then
			self:saveGame(self.lastSaveEtc)
		end
	end)
	return self.ticket 
end

function PlayerData:getLottoPrizes()
	local Prizes = {

	}
	local triesToday = 0
	local today = tonumber(os.date('%j'))
	local tomorrow = (today + 1) % 365
	local nPrizeSections = 3 
	local prizes = {
		[1] = {[5] = 'Moomoo Milk', [4] = 'Rare Candy', [3] = 'Lemonade', [2] = 'Max Revive', [1] = 'Bottle Cap'},
		[2] = {[5] = '$5000', [4] = '$15000', [3] = '$30000', [2] = '$75000', [1] = '$500000'},
		[3] = {[5] = 'UMV Battery', [4] = 'Steelixite', [3] = 'Diancite', [2] = 'Latiasite/Latiosite', [1] = 'Salamencite'},
		--[4] = {[5] = 'Magikarp', [4] = 'Bidoof', [3] = 'Ditto', [2] = 'Gible', [1] = 'Lugia'},
	}
	local todaysPrizes = prizes[today % nPrizeSections + 1]
	local tomorrowsPrizes = prizes[tomorrow % nPrizeSections + 1]
	Prizes[1] = todaysPrizes
	Prizes[2] = tomorrowsPrizes
	triesToday = self.lottoTries or 0 
	return Prizes, triesToday 
end

function PlayerData:getLottoResults() 
	if not self.ticket then 
		return false 
	end
	local results = {}
	local MAX_CONSECUTIVE_DIGITS = 5 
	local todaysPrizes = self:getLottoPrizes()[1]
	local ticket = self.ticket 
	local collectiveDigitsMatched = 0 
	local largestConsecutiveDigits = 0 
	local largestConsecutiveDigitsData = {}
	local prizeWon = nil
	local matchedFamiliars = nil 
	local function getMatchingDigits(id)
		local matchedDigits = 0 
		local sid = tostring(id)
		local tid = tostring(ticket)
		local consecutiveDigits = 0 
		for i = 0, 4 do 
			local currentDigit = sid:sub(#sid-i, #sid-i)
			local tCurrentDigit = tid:sub(#tid-i, #tid-i)
			if tonumber(currentDigit) == tonumber(tCurrentDigit) then 
				consecutiveDigits = consecutiveDigits + 1 
			else
				consecutiveDigits = 0 
			end
		end
		return consecutiveDigits
	end
	for i = 1, #self.party do 
		local familaSummary = self.party[i]:getSummary({})
		local matchingDigits = getMatchingDigits(familaSummary.id)
		if matchingDigits > largestConsecutiveDigits and matchingDigits <= MAX_CONSECUTIVE_DIGITS then 
			largestConsecutiveDigits = matchingDigits
			matchedFamiliars = familaSummary.species or familaSummary.name
			largestConsecutiveDigitsData = {'Party', {i}, familaSummary.id}
		end
	end
	for box = 1, #self.pc.boxes do 
		for p = 1, 30 do 
			if not self.pc.boxes[box][p] then break end 
			local familaSummary = _f.ServerMon:deserialize(self.pc.boxes[box][p][3], self):getSummary({})
			local matchingDigits = getMatchingDigits(familaSummary.id)
			if matchingDigits > largestConsecutiveDigits and matchingDigits <= MAX_CONSECUTIVE_DIGITS then 
				largestConsecutiveDigits = matchingDigits
				matchedFamiliars = familaSummary.species or familaSummary.name
				largestConsecutiveDigitsData = {{'Box', box}, {box, p}, familaSummary.id}
			end
		end
	end
	for i = 1, #self.daycare.depositedFamiliars do
		local daycareDepositedFamiliars = self.daycare.depositedFamiliars[i]:getSummary({})
		local familaSummary = daycareDepositedFamiliars--:getSummary()
		local matchingDigits = getMatchingDigits(daycareDepositedFamiliars.id)
		if matchingDigits > largestConsecutiveDigits and matchingDigits <= MAX_CONSECUTIVE_DIGITS then 
			largestConsecutiveDigits = matchingDigits
			matchedFamiliars = familaSummary.species or familaSummary.name
			largestConsecutiveDigitsData = {'Daycare', {i}, daycareDepositedFamiliars.id}
		end
	end
	local matchLocationFormat = {
		Party = 1,
		Daycare = 2,
		Box = 3
	}
	local prizeData = {}
	local matchLocation = largestConsecutiveDigitsData[1] 
	local extraneousArgument = nil 
	if typeof(matchLocation) == 'table' then
		extraneousArgument = matchLocation[2]
		matchLocation = matchLocation[1]
	end
	local formattedMatchLocation = matchLocationFormat[matchLocation]
	local matchData = {matchedFamiliars, formattedMatchLocation}
	if extraneousArgument then 
		table.insert(matchData, extraneousArgument)
	end
	prizeWon = todaysPrizes[6-largestConsecutiveDigits]
	prizeData[1] = prizeWon 
	if not prizeWon then 
		return largestConsecutiveDigits, matchData, prizeData
	end
	local prizeData1, prizeData2 = string.match(prizeData[1], "([%w%s]+)/([%w%s]+)")
	if prizeData1 and prizeData2 then 
		local validPrizeData = {
			[1] = _f.Database.ItemById[Functions.toId(prizeData1)],
			[2] = _f.Database.ItemById[Functions.toId(prizeData2)]
		}
		if not validPrizeData[2] then --Mewtwonite Y
			local firstItem = prizeData[1]:match("([%w%s]+)/-")
			validPrizeData[2] = _f.Database.ItemById[Functions.toId(string.format(firstItem:match("[%w]+")..'%s%s', ' ', prizeData2))]
		end
		if validPrizeData[1] and validPrizeData[2] then 
			local prizeWonName = validPrizeData[math.random(#validPrizeData)].name
			prizeWon = Functions.toId(prizeWonName)
			prizeData[1] = prizeWonName
		end
	end
	local s, familiariumData = pcall(function()
		_f.DataService.fulfillRequest(nil, {'Familiarium', Functions.toId(prizeWon)})
	end)
	if _f.Database.ItemById[Functions.toId(prizeWon)] then 
		prizeData[2] = true 
	end
	local isItem = prizeData[2] == true 
	local numericMoneyValue = prizeData[1]:match("^%$([%d]+)")
	if isItem then
		self:addBagItems({id = Functions.toId(prizeWon), quantity = 1})
	elseif numericMoneyValue then 
		if tonumber(numericMoneyValue) and typeof(tonumber(numericMoneyValue)) == 'number' then 
			self:addMoney(tonumber(numericMoneyValue))
		end
	elseif familiariumData then
		prizeData[3] = true 
		local familiars = self:newFamiliars({
			name = prizeWon,
			level = 6,
			shinyChance = 2048
		})
		self:PC_sendToStore(familiars)
	end
	self.ticket = nil 
	return largestConsecutiveDigits, matchData, prizeData
end


function PlayerData:pickberry(berrytype)
	if self.currentChunk ~= 'chunk76' then return false end

	local vaildberries = {
		['nanabberry'] = true,
		['razzberry'] = true,
		['blukberry'] = true,
		['wepearberry'] = true,
		['pinapberry'] = true
	}
	if not vaildberries[berrytype] then return false end

	local amount = self:random(3, 6)

	self:addBagItems({id = berrytype, quantity = amount})

	return amount
end

function PlayerData:hasbottlecaps()
	local bc = _f.Database.ItemById.bottlecap
	local gbc = _f.Database.ItemById.goldbottlecap

	local n1, n2 = 0, 0
	pcall(function() n1 = self:getBagDataByNum(bc.num, 1).quantity end)
	pcall(function() n2 = self:getBagDataByNum(gbc.num, 1).quantity end)

	return n1 + n2
end

function PlayerData:trainfamiliars(familiarsIndex, stat, value, capType)
	if not familiarsIndex or not self.party[familiarsIndex] then return end
	local familiars = self.party[familiarsIndex]

	local bottlecap = _f.Database.ItemById.bottlecap
	local goldcap   = _f.Database.ItemById.goldbottlecap

	local nBottle, nGold = 0, 0
	pcall(function() nBottle = self:getBagDataByNum(bottlecap.num, 1).quantity end)
	pcall(function() nGold   = self:getBagDataByNum(goldcap.num,   1).quantity end)

	local used
	if capType == "goldbottlecap" then
		if nGold <= 0 then return end
		self:incrementBagItem(goldcap.num, -1)
		used = "goldbottlecap"
	elseif capType == "bottlecap" then
		if nBottle <= 0 then return end
		self:incrementBagItem(bottlecap.num, -1)
		used = "bottlecap"
	else
		if (nBottle + nGold) <= 0 then return end
		if nBottle > 0 then
			self:incrementBagItem(bottlecap.num, -1)
			used = "bottlecap"
		else
			self:incrementBagItem(goldcap.num, -1)
			used = "goldbottlecap"
		end
	end

	familiars.ivs = familiars.ivs or {0,0,0,0,0,0}

	if used == "goldbottlecap" then
		for i = 1, 6 do
			familiars.ivs[i] = 31
		end
	else
		local stattable = {
			['HP'] = 1,
			['Attack'] = 2,
			['Defense'] = 3,
			['Sp Atk'] = 4,
			['Sp Def'] = 5,
			['Speed'] = 6,
		}
		local ivindex = stattable[stat]
		if not ivindex then return end

		value = tonumber(value) or 31
		value = math.max(0, math.min(31, value))
		familiars.ivs[ivindex] = value
	end

	self.party[familiarsIndex] = familiars
	return used
end



function PlayerData:getivs(familiarsIndex, stat)
	if not familiarsIndex or not self.party[familiarsIndex] then return end
	local familiars = self.party[familiarsIndex]
	local stattable = {
		['HP'] = 1,
		['Attack'] = 2,
		['Defense'] = 3,
		['Sp Atk'] = 4,
		['Sp Def'] = 5,
		['Speed'] = 6,
	}
	local ivindex = stattable[stat]
	for i,v in pairs(familiars.ivs) do
		if i == ivindex then
			return familiars.ivs[i]
		end
	end
end
-- END OF BOTTLE CAP

function PlayerData:exchangeShardsForBP(shardType, shardCost, bpGain)
	local itemId = string.lower(shardType) .. "shard"
	local shardItem = _f.Database.ItemById[itemId]
	if not shardItem then
		return false, "Invalid shard type"
	end

	local bagData = self:getBagDataByNum(shardItem.num, 1)
	if not bagData or bagData.quantity < shardCost then
		return false, "Not enough shards"
	end

	local success = self:incrementBagItem(shardItem.num, -shardCost)
	if not success then
		return false, "Failed to remove shards"
	end
	self:addBP(bpGain, true)

	return true  -- success
end
function PlayerData:ApplyEVs(partyIndex, newEVs)
	local mon = self.party[partyIndex]
	if not mon then return "Invalid Mon." end

	local EV_EDITOR_PASS_ID = Assets.passId.evEditor
	if not self:ownsGamePass(EV_EDITOR_PASS_ID) then
		return "You do not own the Stats Editing Gamepass."
	end

	local total = 0
	for statId, ev in pairs(newEVs) do 
		if type(ev) ~= "number" or ev < 0 or ev > 252 or math.floor(ev) ~= ev then
			return "Invalid EV value: " .. tostring(ev) .. " for " .. tostring(statId)
		end
		total += ev
	end
	if total > 510 then
		return "Total EVs exceed 510."
	end

	for i = 1, 6 do
		mon.evs[i] = math.clamp(newEVs[i] or 0, 0, 252)
	end
	return "EVs updated successfully!"
end

function PlayerData:ApplyIVs(index, newIVs)
	local familiars = self.party[index]
	if not familiars then return "Invalid Familiars" end

	local EV_EDITOR_PASS_ID = Assets.passId.evEditor

	if not self:ownsGamePass(EV_EDITOR_PASS_ID) then
		return "Stats Editor gamepass required."
	end

	for stat, value in pairs(newIVs) do
		familiars.ivs[stat] = math.clamp(value, 0, 31)
	end

	self.party[index] = familiars
	return "IVs updated successfully!"
end



--// Z-Moves
function PlayerData:HasZMoveOn(familiarsIndex, itemId)
	local item = _f.Database.ItemById[itemId]
	local mon = self.party[familiarsIndex]

	if mon:getHeldItem() and mon:getHeldItem().zMove and mon:getHeldItem().num == item.num then
		return "Holding", Color3.fromRGB(85,145,211,255)
	elseif mon:canUseZCrystal(itemId) then 
		return "Compatible", Color3.fromRGB(255, 255, 255)
	else
		return "Incompatible", Color3.fromRGB(222, 99, 91, 255)
	end
end

function PlayerData:getCSceptileStage(stage) --// 2022 Winter Event
	local disabled = true
	if disabled then return false end
	local things = {}
	things.Minior = false
	things.Comfey = false
	things.Stardust = false

	local formeoverlap = false
	local miniorcount = 0
	local lastforme
	for _, p in pairs(self.party) do
		if p.num == 774 then
			miniorcount = miniorcount + 1
		end
	end
	for _, p in pairs(self.party) do
		if p.forme == lastforme then
			formeoverlap = true
		end
		lastforme = p.forme
	end
	if miniorcount == 6 and not formeoverlap then
		things.Minior = true
	end

	for _, p in pairs(self.party) do
		if p.num == 764 then
			things.Comfey = true
		end
	end

	if self:getBagDataById('stardust', 1) and self:getBagDataById('starpiece', 1) then
		if self:getBagDataById('stardust', 1).quantity >= 3 and self:getBagDataById('starpiece', 1).quantity >= 1 then
			things.Stardust = true
		end
	end

	if stage == 'check' then
		return things
	end

	if stage == 1 and things.Minior and not self.completedEvents.CollectMiniors then
		self:completeEventServer('CollectMiniors')
		return true
	end

	if stage == 2 and self.completedEvents.CollectMiniors and things.Comfey and not self.completedEvents.CollectComfeys then
		self:completeEventServer('CollectComfeys')
		return true
	end

	if stage == 3 and self.completedEvents.CollectComfeys and things.Stardust and not self.completedEvents.CollectStarItems then
		self:completeEventServer('CollectStarItems')

		self:incrementBagItem('stardust', -3)
		self:incrementBagItem('starpiece', -1)

		self:addBagItems({id = 'sceptilitec', quantity = 1})
		return true
	end
	return false
end

--// Arcade
function PlayerData:TixPurchase()
	game:GetService('MarketplaceService'):PromptProductPurchase(self.player, Assets.productId.TixPurchase)
end

function PlayerData:buyWithTix(shopIndex, qty)
	local max, item, price = self:tMaxBuyInternal(shopIndex)
	if max == 'tm' then
		self:obtainTM(item)
		self.tix = self.tix - price
		return true, self.tix
	elseif type(max) == 'string' and max:sub(1,2) == 'pk' then
		qty = math.floor(qty)
		self.tix = self.tix - price*qty
		for i = 1,qty do
			-- Party
			local putmoninpc
			if #self.party >= 6 then
				putmoninpc = true
			end

			local pnum = 0
			if item == 'Ditto' then
				pnum = 132
			elseif item == 'Chansey' then
				pnum = 113
			elseif item == 'Audino' then
				pnum = 531
			end
			if not self:hasOwnedFamiliars(pnum) then
				self:onOwnFamiliars(pnum)	
			end

			local familiars = self:newFamiliars {
				name = item,
				level = 30,
				shinyChance = 2048,
			}
			if putmoninpc then
				self:PC_sendToStore(familiars)
			else
				self.party[#self.party + 1] = familiars
			end
		end
		return true, self.tix
	elseif max == 'hb' then
		self:completeEventServer('hasHoverboard')
		table.insert(self.ownedHoverboards, item)
		self.tix = self.tix - price
		return true, self.tix
	end

	if not item or type(max) ~= 'number' or type(qty) ~= 'number' or max < qty or qty < 1 then return false end
	qty = math.floor(qty)
	self.tix = self.tix - price*qty
	self:addBagItems{num = item.num, quantity = qty}
	return true, self.tix
end

function PlayerData:tMaxBuyInternal(shopIndex)
	if not self.currentShop then return false end
	local itemIdPricePair = self.currentShop[shopIndex]
	if type(itemIdPricePair) ~= 'table' then return false end
	local itemId = itemIdPricePair[1]
	if type(itemId) ~= 'string' then return false end
	local price = itemIdPricePair[2]
	if type(price) ~= 'number' then return false end
	if itemId:sub(1, 2) == 'Tix' then return false end -- assumption: no items sold here later will start with "Tix"
	local tmNum = itemId:match('^TM(%d+)')
	local pkmn = itemId:sub(1, 4) == 'PKMN'
	local hover = itemId:sub(1, 5) == 'HOVER'
	local currentQty = 0
	if tmNum then
		tmNum = tonumber(tmNum)
		if BitBuffer.GetBit(self.tms, tmNum) then return 'ao' end -- already own
		if self.tix < price then return 'nm' end
		return 'tm', tonumber(tmNum), price
	elseif pkmn then
		local mon = string.split(itemId, ' ')[2]
		if not mon then return false end
		if self.tix < price  then return 'nm' end -- not enough money
		return 'pk-'..tostring(math.min(999-currentQty, math.floor(self.tix/price))), mon, price
	elseif hover then
		local hb = itemId:sub(7,#itemId)
		if not hb then return false end
		if self:ownsHoverboard(hb) then return 'aoh' end
		if self.tix < price  then return 'nm' end -- not enough money
		return 'hb', hb, price
	end

	local item = _f.Database.ItemById[itemId]
	if not item then return false end
	local bd = self:getBagDataByNum(item.num)
	if bd then
		currentQty = bd.quantity or 0
	end
	if currentQty >= 999 then return 'fb' end -- full bag
	if self.tix < price  then return 'nm' end -- not enough money
	return math.min(999-currentQty, math.floor(self.tix/price)), item, price
end

local MAX_RATE = 1
local CHECK_TIME = 10

function PlayerData:TixCheck(score, maxscore)
	if not self.tixcheck then
		self.tixcheck = { ['Rate'] = 0 }
	end

	if not self.completedEvents.BlimpwJT then
		return 0
	end

	spawn(function()
		if score > 0 then
			self.tixcheck.Rate += 1
			task.wait(CHECK_TIME)
			self.tixcheck.Rate -= 1
		end
	end)
	task.wait(0.5)
	return score
end


function PlayerData:getArcadeRewardInfo(minigame)
	local minigameInfo = {
		alolan = {
			500,
			function(score)
				return score * 20
			end,
		},
		whack = {
			10000,
			function(score)
				return score / 20
			end,
		},
		skeeball = {
			800,
			function(score)
				return score / 1.2
			end,
		},
		hammer = {
			300,
			function(score)
				return score * 5
			end,
		},
	}

	local data = minigameInfo[minigame]
	if not data then
		warn("Unknown minigame: " .. tostring(minigame))
		return 0, function() return 0 end
	end
	return unpack(data)
end


function PlayerData:ArcadeReward(minigame, score)
	if minigame == "alolan" and score >= 50 then
		self.flags.AA50 = true
	end

	local max, fn = self:getArcadeRewardInfo(minigame)
	score = self:TixCheck(score, max)
	local reward = fn(score)

	reward = math.max(reward, 25)

	self:addTix(math.floor(reward + 0.5))
end


function PlayerData:addTix(amount)
	if amount < 0 and self.tix + amount < 0 then return false end
	if amount > 0 and self.tix > MAX_TIX then return false end
	self.tix = math.min(math.floor(self.tix + amount), MAX_TIX)
	_f.Network:post('PDChanged', self.player, 'tix', self.tix)
	return true
end


function PlayerData:tMaxBuy(shopIndex)
	return (self:tMaxBuyInternal(shopIndex))
end

-- Save/Load Data
do
	local indexToEvent = {
		'MeetJake',
		'MeetParents',
		'ChooseFirstFamiliars',
		'JakeBattle',
		'ParentsKidnappedScene',
		'BronzeBrickStolen',
		'JakeTracksLinda',
		'BronzeBrickRecovered',
		'PCPorygonEncountered',
		'EeveeAwarded',
		'IntroducedToGym1',		
		'GivenSawsbuckCoffee',
		'ReceivedRTD',
		'RunningShoesGiven',
		'GroudonScene',
		'JakeBattle2',
		'TalkToJakeAndSebastian',
		'IntroToUMV',
		'TestDriveUMV',
		'ReceivedBWEgg',			
		'DamBusted',
		'JakeStartFollow',
		'JakeEndFollow',
		'GivenSnover',
		'KingsRockGiven',
		'RosecoveWelcome',
		'LighthouseScene',
		'ProfAfterGym3',
		'JakeAndTessDepart',
		'RotomBit0',			
		'RotomBit1',
		'RotomBit2',
		'JTBattlesR9',
		'GivenLeftovers',
		'Jirachi',
		'Shaymin',
		'MeetAbsol',
		'ReachCliffPC',
		'BlimpwJT',
		'MeetGerald',
		'hasHoverboard',
		'G4FoundTape',			
		'G4GaveTape',
		'G4FoundWrench',
		'G4GaveWrench',
		'G4FoundHammer',
		'G4GaveHammer',
		'SeeTEship',
		'GeraldKey',
		'TessStartFollow',
		'TessEndFollow',
		'DefeatTEinAC',	
		'EnteredPast',
		'LearnAboutSanta',
		'BeatSanta',
		'NiceListReward',
		'vAredia',	
		'GiveEkans',
		'gsEkans',
		'Snorlax',			
		'TEinCastle',
		'G5Shovel',
		'G5Pickaxe',
		'RNatureForces',
		'Landorus',
		'RJO', 
		'RJP',
		'GJO',
		'GJP',
		'PJO',
		'PJP',
		'BJO',
		'BJP',
		'Victini',
		'vFluoruma',
		'PBSIntro',
		'FluoDebriefing',
		'OpenJDoor',
		'Diancie',
		'RBeastTrio',
		'Heatran',
		'TERt14',  
		'EonDuo',
		'vFrostveil',
		'TessBattle',
		'RevealCatacombs',
		'LightPuzzle',
		'SmashRockDoor',
		'CompletedCatacombs',
		'Regirock',
		'Registeel',
		'Regice',
		'OpenRDoor',
		'Regigigas',
		'GetSootheBell',
		'DefeatTinbell',
		'SwordsOJ',
		'Keldeo',
		'vPortDecca',
		'TalkToCap',
		'MeetScaleBuyer',
		'AdoptAifesShelter',
		'PushBarrels',
		'UnlockMewLab',
		'Mew',
		'VolItem1',
		'VolItem2',
		'VolItem3',
		'RevealSteamChamber',
		'Volcanion',
		'ObtainedZPouch',
		'FindZGrass',
		'FindZFire',
		'FindZWater',
		'FindZBug',
		'FindZIce',
		'FindZDragon',
		'BreakIceDoor',
		'WaterStone',
		'GrassStone',
		'OpenDDoor',
		'Articuno',
		'Zapdos',
		'Moltres',
		'GetSWing',
		'GetRevealGlass',
		'Lugia',
		'MeetTessBeach',
		'GRGiven',
		'SebastianRebattle',
		'Groudon',
		'MarshadowBattle',
		'LearnAboutSceptile',
		'CollectMiniors',
		'CollectComfeys',
		'CollectStarItems',
		'ZeldaSword',
		'vCrescent',
		'MeetFisherman',
		'EclipseBaseReveal',
		'ExposeSecurity',
		'PressSecurityButton',
		'FindCardKey',
		'UnlockGenDoor',
		'burndrive',
		'chilldrive',
		'dousedrive',
		'shockdrive',
		'Genesect',
		'ParentalSightings',
		'DefeatEclipseBase',
		'OpenEclipseGate',
		'DefeatHoopa',
		'ParentalReunion',
		'GrimReaper',
		'MarshBattle',
		'GSBall',
		'Celebi',
		'GetBlueOrb',
		'getKyogre',
		'getGroudon',
		'CresseliaBattle',
		'DeoxysBattle',
		'Meltan',
		'GetRWing',
		'Hooh',
		'Magearna',
		'DefeatHoopaAgain',
		'Darkrai',
		'RayEvent',
		'Meloetta',
		'MntCheck',
		--Familiarium Rewards
		'Dex100',
		'Dex200',
		'Dex350',
		'Dex500',
		'Dex750',
		--ZA Megas
		'MegaMeganium',
		'MegaEmboar',
		'MegaFeraligatr',
		'MegaBarbaracle',
		'MegaStarmie',
		'MegaPyroar',
		'MegaClefable',
		'MegaScolipede',
		'MegaVictreebel',
		'MegaExcadrill',
		'MegaEelektross',
		'MegaDragonite',
		'MegaMalamar',
		'MegaDragalge',
		'MegaFroslass',
		'MegaHawlucha',
		'MegaScrafty',
		'MegaChandelure',
		'MegaGreninja',
		'MegaFalinks',
		'MegaChesnaught',
		'MegaSkarmory',
		'MegaDelphox',
		'MegaDrampa',
		'MegaFloette',
		'MegaAbsolZ',
		'MegaStaraptor',
		'MegaHeatran',
		'MegaDarkrai',
		'MegaChimecho',
		'MegaCrabominable',
		'MegaGlimmora',
		'MegaGolisopod',
		'MegaGolurk',
		'MegaRaichuX',
		'MegaRaichuY',
		'MegaLucarioZ',
		'MegaMagearna',
		'MegaZeraora',
		'MegaBaxcalibur',
		'MegaScovillain',
		'DARKCHECK',
		'enemyfight',
		'newenefight',
		'evildakrai',
		'FindZElectric',
		'FindZPoison',
		'FindZGhost',
		'FindZPsychic',
		'FindZRock',
		'FindZNormal',
		'FindZGround',
		'FindZFly',
		'FindZSteel',
		"ResAndZek",
		"Reshiram",
		"Zekrom",
		"GetZekrom",
		"GetReshiram",
		'Kyurem',
		'KyuremBattle',
		'KyuremBattle2',
		'Tapu1Fini',
		'Tapu1Lele',
		'Tapu1Bulu',
		'Tapu1Koko',
		'Mew2',
		'TessRLEntrance',
		'RLTessBattle',
		--// Roria League
		'E4Fighting',
		'E4Dark',
		'E4Psychic',
		'E4Ghost',
		'Stairs',
		'Champion',
		'IntroducedToGym8',		
	}
	local div = ';'
	local div2 = '-'
	local familiarsDiv = ','

	local TextService = game:GetService("TextService")
	
	local ENABLED_GAMEMODES = {
		adventure   = true,
		randomizer = true,
		spawner    = true,
	}

	local ALL_ADVENTURES = {
		{
			name = 'Adventure',
			id = 'adventure',
			placeId = 7483824578,
			color = Color3.fromRGB(255, 255, 255),
			description = 'Vanilla PBB with some fun new features!',
		},
		{
			name = 'Randomizer',
			id = 'randomizer',
			placeId = 7483697416,
			color = Color3.fromRGB(0, 0, 255),
			description = '[No Data will be deleted for other gamemodes] You cannot trade or battle. This gamemode lets you obtain any familiars currently ingame including both events and legal alternative formes.',
		},
		{
			name = 'Spawner',
			id = 'spawner',
			placeId = 7788160039,
			color = Color3.fromRGB(255, 0, 0),
			description = 'This gamemode lets you spawn any familiars, items, bp, money, etc to your hearts content!',
		},
	}

	function PlayerData:getAdventuresList(currentGamemode)
		local AdventureList = {}

		for _, mode in ipairs(ALL_ADVENTURES) do
			if mode.id ~= currentGamemode then
				local locked = not ENABLED_GAMEMODES[mode.id]

				AdventureList[#AdventureList + 1] = {
					mode.name,
					mode.id,
					mode.placeId,
					mode.color,
					locked,
					mode.description,
				}
			end
		end

		return AdventureList
	end

	function PlayerData:getContinueScreenInfo(gamemode)
		if not self.DataCache then
			self.DataCache = {}
		end

		local k = gamemode or "adventure"

		if self.DataCache[k] then
			return unpack(self.DataCache[k])
		end

		local str = select(1, self:getSaveData(k))

		if str == nil then
			return false
		end

		if str == "" then
			self.DataCache[k] = {false}
			return false
		end

		local ndiv = '([^'..div..']*)'
		local basic = str:match('^'..ndiv..div) or ""
		local familiarium = ""

		local s = basic:find(div2, 1, true)
		if s then
			familiarium = basic:sub(s+1)
			basic = basic:sub(1, s-1)
			s = familiarium:find(div2, 1, true)
			if s then
				familiarium = familiarium:sub(1, s-1)
			end
		end

		local buffer = BitBuffer.Create()
		local ok = pcall(function()
			buffer:FromBase64(basic)
		end)

		if not ok then
			return false
		end

		local version = buffer:ReadUnsigned(6)
		local player = self.player
		local trainerName = buffer:ReadString()

		pcall(function()
			trainerName = TextService:FilterStringAsync(trainerName, player.UserId):GetNonChatStringForBroadcastAsync()
		end)

		if trainerName == "" then
			trainerName = player.Name
		end

		local badges = 0
		for i = 1, 8 do
			if buffer:ReadBool() then
				badges += 1
			end
		end

		local owned = 0
		pcall(function()
			buffer:FromBase64(familiarium)
			for _ = 1, familiarium:len() * 3 do
				buffer:ReadBool()
				if buffer:ReadBool() then
					owned += 1
				end
			end
		end)

		self.DataCache[k] = {true, trainerName, badges, owned}
		return true, trainerName, badges, owned
	end

	-- Keep these for continue screen slot buttons
	function PlayerData:saveGameAdvSlot(slotNum, etc)
		return self:saveGame(etc)  -- Now uses updated saveGame() above
	end

	function PlayerData:continueAdvSlot(slotNum)
		self.gamemode = "AdvSlot" .. slotNum  -- Set gamemode FIRST
		return self:continueGame(self.gamemode)  -- Uses existing continueGame!
	end
	
	function PlayerData:getSaveDataAdvSlot(slotNum)
		self._saveDataCache = self._saveDataCache or {}
		self._saveDataLoading = self._saveDataLoading or {}

		local k = "AdvSlot" .. tostring(slotNum)

		if self._saveDataCache[k] then
			return self._saveDataCache[k][1], self._saveDataCache[k][2]
		end

		if self._saveDataLoading[k] then
			local timeout = tick() + 10
			repeat task.wait(0.1) until self._saveDataCache[k] or tick() > timeout

			if self._saveDataCache[k] then
				return self._saveDataCache[k][1], self._saveDataCache[k][2]
			end

			return nil, nil
		end

		self._saveDataLoading[k] = true

		local loaded = false
		local data, pcData

		for attempt = 1, 5 do
			local ok, success, d, p = pcall(function()
				if slotNum == 1 then
					return _f.DataPersistence.LoadAdventureSlot1(self.player)
				elseif slotNum == 2 then
					return _f.DataPersistence.LoadAdventureSlot2(self.player)
				end
			end)

			if ok and success then
				data = d
				pcData = p
				loaded = true
				break
			end

			task.wait(1.5)
		end

		self._saveDataLoading[k] = nil

		if loaded then
			self._saveDataCache[k] = {data, pcData}
			return data, pcData
		end

		return nil, nil
	end

	function PlayerData:getContinueScreenInfoAdvSlot(slotNum)
		if not self.DataCache then
			self.DataCache = {}
		end
		
		
		local div = ";"   
		local div2 = "-"  

		local k = "AdvSlot" .. slotNum

		if self.DataCache[k] then
			return unpack(self.DataCache[k])
		end
		local str = select(1, self:getSaveDataAdvSlot(slotNum))

		if str == nil then
			return false
		end

		if str == "" then
			self.DataCache[k] = {false}
			return false
		end

		local ndiv = '([^'..div..']*)'
		local basic = str:match('^'..ndiv..div) or ""
		local familiarium = ""

		local s = basic:find(div2, 1, true)
		if s then
			familiarium = basic:sub(s+1)
			basic = basic:sub(1, s-1)

			local s2 = familiarium:find(div2, 1, true)
			if s2 then
				familiarium = familiarium:sub(1, s2-1)
			end
		end

		local buffer = BitBuffer.Create()
		pcall(function() buffer:FromBase64(basic) end)
		local version = buffer:ReadUnsigned(6)
		local player = self.player
		local trainerName = ""
		pcall(function()
			trainerName = buffer:ReadString() or ""
		end)

		pcall(function()
			if trainerName ~= "" then
				trainerName = TextService:FilterStringAsync(trainerName, player.UserId)
					:GetNonChatStringForBroadcastAsync()
			end
		end)
		if trainerName == "" then
			trainerName = player.Name
		end

		local badges = 0
		for i = 1, 8 do
			local ok, val = pcall(function() return buffer:ReadBool() end)
			if ok and val then
				badges = badges + 1
			end
		end

		local owned = 0
		pcall(function()
			buffer:FromBase64(familiarium)
			for _ = 1, math.max(1, #familiarium * 3) do
				buffer:ReadBool()
				if buffer:ReadBool() then
					owned = owned + 1
				end
			end
		end)

		self.DataCache[k] = {true, trainerName, badges, owned}
		return true, trainerName, badges, owned
	end




	function PlayerData:serialize(etc)
		if not self.gameBegan then error('Attempted to save before game file was created.') end

		--// Basic Data Layout
		local saveString
		local buffer = BitBuffer.Create()

		local version = 39 -- Playtime reward index added
		buffer:WriteUnsigned(6, version)

		--// Name
		buffer:WriteString(self.trainerName)

		--// Badges
		local badgeCount = version >= 39 and 9 or 8
		for i = 1, badgeCount do
			buffer:WriteBool(self.badges[i] and true or false)
		end

		--// Events
		local maxEventIndex = 0
		for i = #indexToEvent, 1, -1 do
			if self.completedEvents[indexToEvent[i]] then
				maxEventIndex = i
				break
			end
		end
		buffer:WriteUnsigned(10, maxEventIndex)
		for i = 1, maxEventIndex do
			buffer:WriteBool(self.completedEvents[indexToEvent[i]] and true or false)
		end

		--// Currencies
		buffer:WriteUnsigned(24, math.min(self.money, MAX_MONEY))
		if version >= 23 then
			buffer:WriteUnsigned(24, math.min(self.bp, MAX_BP))
		else
			buffer:WriteUnsigned(14, math.min(self.bp, MAX_BP)) -- legacy
		end
		buffer:WriteUnsigned(24, math.min(self.tix, MAX_TIX))
		-- Version 34: Clan Daily Reward
		if version >= 34 then
			buffer:WriteUnsigned(32, self.lastClanDaily or 0)
		end
		--// Startables
		buffer:WriteBool(etc.expShareOn and true or false)
		buffer:WriteBool(self.flags.AA50 and true or false)
		buffer:WriteString(self.starterType or '')

		--// Repels
		if etc.repel and etc.repel.steps and etc.repel.steps > 0 then
			buffer:WriteBool(true)
			buffer:WriteUnsigned(2, etc.repel.kind)
			buffer:WriteUnsigned(8, math.ceil(etc.repel.steps/2))
		else
			buffer:WriteBool(false)
		end

		--// Honey & Encounters
		buffer:WriteUnsigned(12, math.min(4095, self.lastDrifloonEncounterWeek))
		buffer:WriteUnsigned(12, math.min(4095, self.lastTrubbishEncounterWeek))
		buffer:WriteUnsigned(12, math.min(4095, self.lastLaprasEncounterWeek))
		buffer:WriteUnsigned(15, math.min(32767, self.lastHoneyGivenDay))
		if self.honey then
			buffer:WriteBool(true)
			buffer:WriteFloat64(self.honey.slatheredAt)
			buffer:WriteString(self.honey.foe:serialize(true))
		else
			buffer:WriteBool(false)
		end

		--// Daycare
		buffer:WriteBool(self.daycare.manHasEgg and true or false)
		for i = 1, 2 do
			local famila = self.daycare.depositedFamiliars[i]
			if famila then
				buffer:WriteBool(true)
				buffer:WriteString(famila:serialize(true))
				buffer:WriteUnsigned(7, famila.depositedLevel or famila.level)
			else
				buffer:WriteBool(false)
				break
			end
		end

		--// Options

		local function WriteOptBool(name, t)
			buffer:WriteBool((t or etc.options)[name] and true or false)
		end

		for i, v in pairs({"autosaveEnabled", "reduceGraphics"}) do
			WriteOptBool(v)
		end 

		buffer:WriteUnsigned(7, etc.options.cSpeed)

		for i, v in pairs({"tSkip", "IconSFX", "pkmnIcon", "itemIcon", "sprite", "cHints"}) do
			WriteOptBool(v, table.find({3, 4, 5}, i) and etc.options.pxSetting or nil)
		end 

		buffer:WriteUnsigned(7, etc.options.page)
		buffer:WriteUnsigned(7, self.battleMode)
		buffer:WriteFloat64(etc.options.lastUnstuckTick or 0.0)
		buffer:WriteUnsigned(2, etc.options.objectiveDisplayMode or 0)
		buffer:WriteBool(etc.options.weatherEnabled and true or false)
		buffer:WriteBool(etc.options.noMusic and true or false)
		-- Version 26: Battle Speed
		buffer:WriteUnsigned(2, etc.options.battleSpeed or 1)
		-- Version 27: Day/Night Mode
		buffer:WriteUnsigned(2, etc.options.dayNightMode or 0)
		-- Version 28: DBattle
		buffer:WriteBool(etc.options.dbattle and true or false)
		
		buffer:WriteString(etc.options.trainerMusic or "Random")
		buffer:WriteString(etc.options.colosseumMusic or "Random")
		if version >= 32 then
			buffer:WriteBool(self.obedience)  
		end
		if version >= 35 then
			buffer:WriteBool(self.levelCaps)
		end
		 if version >= 33 then
			buffer:WriteBool(etc.options.oldmenu and true or false)
		 end

		--// Stamps
		buffer:WriteUnsigned(10, math.min(999, self.stampSpins))
		buffer:WriteUnsigned(10, #self.pbStamps)
		for _, stamp in pairs(self.pbStamps) do
			buffer:WriteUnsigned(4, stamp.sheet)
			buffer:WriteUnsigned(5, stamp.n)
			buffer:WriteUnsigned(5, stamp.color)
			buffer:WriteUnsigned(3, stamp.style)
			buffer:WriteUnsigned(7, math.min(99, stamp.quantity or 1))
		end

		--// Lotto
		if self.lottoTries and self.lastLottoTryDay then 
			buffer:WriteBool(true)
			buffer:WriteFloat64(self.lottoTries)
			buffer:WriteFloat64(self.lastLottoTryDay)
		else
			buffer:WriteBool(false)
		end

		--// Hoverboards
		buffer:WriteString(self.currentHoverboard)
		buffer:WriteUnsigned(5, #self.ownedHoverboards)
		for _, h in ipairs(self.ownedHoverboards) do
			buffer:WriteString(h)
		end

		--// Surf
		buffer:WriteBool(self.SurfEnabled and true or false)

		--// Slope
		if self.slopeRecord then
			buffer:WriteBool(true)
			buffer:WriteFloat64(self.slopeRecord)
		else
			buffer:WriteBool(false)
		end
		-- Version 17: Battery event
		buffer:WriteUnsigned(15, math.min(32767, self.lastBatteryGivenDay or 0))
		
		-- Version 30: BP event
		buffer:WriteUnsigned(15, math.min(32767, self.lastBPGivenDay or 0))

		buffer:WriteFloat64(self.lastCapTick or 0.0)
		-- Version 20: Daily Reward Streaks
		buffer:WriteUnsigned(10, self.loginStreak or 0)
		buffer:WriteUnsigned(9, self.lastDailyRewardDay or 0)

		-- DailyClaimHistory (write only the last 7 entries)
		local history = self.dailyClaimHistory or {}
		buffer:WriteUnsigned(4, math.min(#history, 7))
		for i = 1, math.min(#history, 7) do
			local h = history[i]
			buffer:WriteUnsigned(9, h.day or 0)
			buffer:WriteString(h.reward or "")
		end

		-- Version 24: Trainer Card Background Asset
		if version >= 24 then
			buffer:WriteString(self.trainerCardBgAsset or "")
		end


		-- Version 25: Mounted state
		if version >= 25 then
			buffer:WriteBool(self.mountedM and true or false)
		end
		
		-- Version 38: Playtime reward state
		if version >= 38 then
			buffer:WriteUnsigned(32, math.min(self:getSafePlaytime(), 4294967295))
			buffer:WriteUnsigned(32, math.min(self.lastPlaytimeClaim or 0, 4294967295))
			buffer:WriteUnsigned(16, math.max(1, math.min(self.playtimeRewardIndex or 1, 65535)))

			local seed = tonumber(self.playtimeRewardSeed) or 0
			seed = math.floor(seed)
			if seed < 1 then
				seed = 1
			end
			if seed > 2147483647 then
				seed = 2147483647
			end
			buffer:WriteUnsigned(31, seed)
		end

		saveString = buffer:ToBase64()

		--// Familiarium
		saveString = concatenate(saveString, div2, self.familiarium)

		--// Trainers
		saveString = concatenate(saveString, div2, self.defeatedTrainers, div2, self.tms, div2, self.hms)

		--// Party
		saveString = concatenate(saveString, div)
		for i = 1, 6 do
			if self.party[i] then
				if i ~= 1 then saveString = concatenate(saveString, familiarsDiv) end
				saveString = concatenate(saveString, self.party[i]:serialize())
			end
		end

		--// Bag
		saveString = concatenate(saveString, div, self.obtainedItems, div2)
		buffer:Reset()

		local stuff = {}
		for i = 1, 6 do
			for _, bd in pairs(self.bag[i]) do
				if bd.quantity > 0 then
					table.insert(stuff, { bd.num, bd.quantity or 1 })
				end
			end
		end

		-- count
		if version >= 29 then
			buffer:WriteUnsigned(14, #stuff)
		else
			buffer:WriteUnsigned(10, #stuff)
		end

		-- items
		for _, item in pairs(stuff) do
			buffer:WriteUnsigned(12, item[1])                 -- id
			buffer:WriteUnsigned(10, math.min(999, item[2]))  -- quantity
		end



		saveString = concatenate(saveString, buffer:ToBase64())

		--// Location
		saveString = concatenate(saveString, div)
		if context == 'adventure' then
			saveString = concatenate(saveString, etc.location)
		else
			saveString = concatenate(saveString, self.adventureLocationData)
		end
		return saveString
	end

	function PlayerData:deserialize(str)
		if select(2, str:gsub(div, div)) ~= 3 then
			error('error (pd::ds): div count mismatch')
		end
		local etc = {}
		local ndiv = '([^'..div..']*)'
		local basic, party, bag, location = str:match('^'..string.rep(ndiv..div, 3)..ndiv)
		local s = basic:find(div2, 1, true)
		if s then
			self.familiarium = basic:sub(s+1)
			basic = basic:sub(1, s-1)
			s = self.familiarium:find(div2, 1, true)
			if s then
				self.defeatedTrainers = self.familiarium:sub(s+1)
				self.familiarium = self.familiarium:sub(1, s-1)
				s = self.defeatedTrainers:find(div2, 1, true)
				if s then
					self.tms = self.defeatedTrainers:sub(s+1)
					self.defeatedTrainers = self.defeatedTrainers:sub(1, s-1)
					s = self.tms:find(div2, 1, true)
					if s then
						self.hms = self.tms:sub(s+1)
						self.tms = self.tms:sub(1, s-1)
					end
				end
			end
		else
			print(basic, 'No familiarium data found')
		end
		etc.dTrainers = self.defeatedTrainers

		--// Basic Data Layout
		local buffer = BitBuffer.Create()
		buffer:FromBase64(basic)
		local version = buffer:ReadUnsigned(6)

		--// Name
		local player = self.player
		local rawName = buffer:ReadString()
		local filteredName

		local success, result = pcall(function()
			return TextService:FilterStringAsync(rawName, player.UserId):GetNonChatStringForBroadcastAsync()
		end)

		if success and result and result ~= "" then
			filteredName = result
		elseif player and player.Name then
			filteredName = player.Name
		end

		self.trainerName = filteredName
		etc.tName = filteredName



		--// Badges
		local eb = {}
		local badgeCount = version >= 39 and 9 or 8
		for i = 1, badgeCount do
			if buffer:ReadBool() then
				self.badges[i] = true
				eb[tostring(i)] = true
			end
		end
		etc.badges = eb

		--// Events
		local maxEventIndex = buffer:ReadUnsigned(10)
		for i = 1, maxEventIndex do
			if buffer:ReadBool() then
				self.completedEvents[indexToEvent[i]] = true
			end
		end
		etc.completedEvents = Functions.shallowcopy(self.completedEvents)

		--// Currencies
		self.money = buffer:ReadUnsigned(24)

		if version >= 23 then
			self.bp = buffer:ReadUnsigned(24)
		elseif version >= 1 then
			self.bp = buffer:ReadUnsigned(14)
		end

		if version >= 2 then
			self.tix = buffer:ReadUnsigned(24)
		end

		-- Version 34: Clan Daily Reward
		if version >= 34 then
			self.lastClanDaily = buffer:ReadUnsigned(32)
		else
			self.lastClanDaily = 0
		end
		
		--// Startables
		if version >= 3 then
			etc.expShareOn = buffer:ReadBool()
			self.flags.AA50 = buffer:ReadBool()
			self.starterType = buffer:ReadString()
		end

		--// Repels
		if version >= 4 and buffer:ReadBool() then
			etc.repel = {}
			etc.repel.kind = buffer:ReadUnsigned(2)
			etc.repel.steps = buffer:ReadUnsigned(8) * 2
			local id = ({'repel', 'superrepel', 'maxrepel'})[etc.repel.kind]
			local more = self:getBagDataById(id, 1)
			if more and more.quantity and more.quantity > 0 then
				etc.repel.more = true
			end
		end

		--// Encounters
		if version >= 5 then
			self.lastDrifloonEncounterWeek = buffer:ReadUnsigned(12)
			self.lastTrubbishEncounterWeek = buffer:ReadUnsigned(12)
			self.lastLaprasEncounterWeek = buffer:ReadUnsigned(12)
			self.lastHoneyGivenDay = buffer:ReadUnsigned(15)
			if buffer:ReadBool() then
				local honey = {}
				honey.slatheredAt = buffer:ReadFloat64()
				honey.foe = _f.ServerMon:deserialize(buffer:ReadString(), self)
				self.honey = honey
			end
		end

		--// Daycare
		if version >= 6 then
			self.daycare.manHasEgg = buffer:ReadBool()
			if self.daycare.manHasEgg then
				etc.dcEgg = true
			end
			for i = 1, 2 do
				if not buffer:ReadBool() then break end
				local famila = _f.ServerMon:deserialize(buffer:ReadString(), self)
				famila.depositedLevel = buffer:ReadUnsigned(7)
				self.daycare.depositedFamiliars[i] = famila
			end
		end

		--// Options
		if version >= 7 then
			etc.options = {}

			local function ReadOptBool(name)
				if buffer:ReadBool() then
					etc.options[name] = true
				end
			end

			for i, v in pairs({"autosaveEnabled", "reduceGraphics"}) do
				ReadOptBool(v)
			end 

			if version >= 15 then
				etc.options.cSpeed = buffer:ReadUnsigned(7)

				for i, v in pairs({"tSkip", "IconSFX", "pkmnIcon", "itemIcon", "sprite", "cHints"}) do
					if v then
						ReadOptBool(v)
					end
				end 

				etc.options.page = buffer:ReadUnsigned(7)
				self.battleMode = buffer:ReadUnsigned(7)
			else
				etc.options.cSpeed = buffer:ReadBool() and 9 or 4
				etc.options.tSkip = false
				etc.options.IconSFX = false
				etc.options.pxIcon = true
				etc.options.pxSprite = true
				etc.options.cHints = true
				etc.options.page = 1
			end

			pcall(function()
				etc.options.lastUnstuckTick = buffer:ReadFloat64()
			end)
			if version >= 21 then
				etc.options.objectiveDisplayMode = buffer:ReadUnsigned(2)
			else
				etc.options.objectiveDisplayMode = 0
			end
			if version >= 22 then
				etc.options.weatherEnabled = buffer:ReadBool()
			else
				etc.options.weatherEnabled = true 
			end
			if version >= 23 then
				etc.options.noMusic = buffer:ReadBool()
			else
				etc.options.noMusic = false
			end
			if version >= 26 then
				local bs = buffer:ReadUnsigned(2)
				if typeof(bs) ~= "number" or bs < 1 or bs > 3 then
					bs = 1
				end
				etc.options.battleSpeed = bs
			else
				etc.options.battleSpeed = 1
			end
			-- Version 27: Day/Night Mode
			if version >= 27 then
				local dnm = buffer:ReadUnsigned(2)
				if typeof(dnm) ~= "number" or dnm < 0 or dnm > 2 then
					dnm = 0
				end
				etc.options.dayNightMode = dnm
			else
				etc.options.dayNightMode = 0 
			end
			
			if version >= 28 then
					etc.options.dbattle = buffer:ReadBool()
			else
				etc.options.dbattle = false
			end
			if version >= 31 then
					etc.options.trainerMusic = buffer:ReadString()
					etc.options.colosseumMusic = buffer:ReadString()
			else
					etc.options.trainerMusic = "Random"
					etc.options.colosseumMusic = "Random"
			end
				if version >= 32 then
					self.obedience = buffer:ReadBool()
				else
					self.obedience = false
				end
				if version >= 35 then
				   self.levelCaps = buffer:ReadBool()
				else
				   self.levelCaps = false
				end
				if version >= 33 then
					etc.options.oldmenu = buffer:ReadBool()
				else
			     	etc.options.oldmenu = true
				end
		end
		
		--// Stamps
		if version >= 8 then
			self.stampSpins = buffer:ReadUnsigned(10)
			local pbStamps = {}
			for i = 1, buffer:ReadUnsigned(10) do
				local stamp = {}
				stamp.sheet = buffer:ReadUnsigned(4)
				stamp.n     = buffer:ReadUnsigned(5)
				stamp.color = buffer:ReadUnsigned(5)
				stamp.style = buffer:ReadUnsigned(3)
				stamp.quantity = buffer:ReadUnsigned(7)
				stamp.id    = _f.PBStamps:getStampId(stamp)
				pbStamps[i] = stamp
			end
			self.pbStamps = pbStamps
		end


		--// Lotto
		if version >= 9 then 
			if buffer:ReadBool() then 
				self.lottoTries = buffer:ReadFloat64()
				self.lastLottoTryDay = buffer:ReadFloat64()
			end
		end

		--// Hoverboards
		if version >= 10 then
			local function tryFixSpinnerBoard(board)
				if not board then return "" end

				local l = string.len(board)
				local res, n = string.gsub(board, " ", ".")

				if string.find(board, "Spinner") and n == 1 then
					return string.sub(board, 1, l-8).. " Fidget Spinner"
				end 

				return board
			end

			self.currentHoverboard = tryFixSpinnerBoard(buffer:ReadString())

			local oh = {}

			for i = 1, buffer:ReadUnsigned(5) do
				oh[i] = tryFixSpinnerBoard(buffer:ReadString())
			end

			self.ownedHoverboards = oh
		end

		--// Surf
		if version >= 11 then
			self.SurfEnabled = buffer:ReadBool()
			etc.Surfing = self.SurfEnabled
		end

		--// Slope
		if version >= 12 then
			if buffer:ReadBool() then
				self.slopeRecord = buffer:ReadFloat64()
				etc.slopeRecord = self.slopeRecord
			end
		end

		-- Version 17: Battery event
		if version >= 17 then
			self.lastBatteryGivenDay = buffer:ReadUnsigned(15)
		else
			self.lastBatteryGivenDay = 0 -- default value for old saves
		end

		-- Version 30: BP event
		if version >= 30 then
			self.lastBPGivenDay = buffer:ReadUnsigned(15)
		else
			self.lastBPGivenDay = 0 -- default value for old saves
		end
	
		
		if version >= 19 then
			self.lastCapTick = buffer:ReadFloat64()
		else
			self.lastCapTick = 0 -- default fallback
		end

		if version >= 20 then
			self.loginStreak = buffer:ReadUnsigned(10)
			self.lastDailyRewardDay = buffer:ReadUnsigned(9)

			self.dailyClaimHistory = {}
			local n = buffer:ReadUnsigned(4)
			for i = 1, n do
				local day = buffer:ReadUnsigned(9)
				local reward = buffer:ReadString()
				table.insert(self.dailyClaimHistory, {
					day = day,
					reward = reward
				})
			end
		else
			self.loginStreak = 0
			self.lastDailyRewardDay = 0
			self.dailyClaimHistory = {}
		end

		-- Version 24: Trainer Card Background Asset
		if version >= 24 then
			self.trainerCardBgAsset = buffer:ReadString()
		else
			self.trainerCardBgAsset = nil
		end


		-- Version 25: Mounted state
		if version >= 25 then
			self.mountedM = buffer:ReadBool()
			if self.mountedM then
				etc.mounted = true
			end
		else
			self.mountedM = false
		end
		
		-- Version 38: Playtime reward state
		if version >= 38 then
			self.playtime = buffer:ReadUnsigned(32)
			self.lastPlaytimeClaim = buffer:ReadUnsigned(32)
			self.playtimeRewardIndex = buffer:ReadUnsigned(16)
			self.playtimeRewardSeed = buffer:ReadUnsigned(31)
			self.playtime = math.max(0, math.floor(tonumber(self.playtime) or 0))
			self.lastPlaytimeClaim = math.max(0, math.floor(tonumber(self.lastPlaytimeClaim) or 0))

			if self.lastPlaytimeClaim > self.playtime then
				self.lastPlaytimeClaim = self.playtime
			end

			if typeof(self.playtimeRewardIndex) ~= "number" or self.playtimeRewardIndex < 1 then
				self.playtimeRewardIndex = 1
			end

			if typeof(self.playtimeRewardSeed) ~= "number" or self.playtimeRewardSeed < 1 then
				self.playtimeRewardSeed = math.random(1, 2147483647)
			end
		else
			self.playtime = 0
			self.lastPlaytimeClaim = 0
			self.playtimeRewardIndex = 1
			self.playtimeRewardSeed = math.random(1, 2147483647)
		end
		--// Party
		local p = 1
		for s in party:gmatch('[^'..familiarsDiv..']+') do
			if s and s ~= '' then
				local famila = _f.ServerMon:deserialize(s, self)
				self.party[p] = famila
				if famila.id then
					self.ids[famila.id] = true -- ✅ Track this Familiars's ID
				end
				p = p + 1
			end
		end

		---// Bag
		if bag and bag ~= '' then
			local s = bag:find(div2, 1, true)
			if s then
				self.obtainedItems = bag:sub(1, s-1)
				bag = bag:sub(s+1)

				buffer:FromBase64(bag)

				-- Item count
				local itemCount
				if version >= 29 then
					itemCount = buffer:ReadUnsigned(14)
				else
					itemCount = buffer:ReadUnsigned(10)
				end

				-- Items
				for _ = 1, itemCount do
					-- Item ID
					local num
					if version >= 18 then
						num = buffer:ReadUnsigned(12)
					else
						num = buffer:ReadUnsigned(10)
					end
					local qty
					if version >= 16 then
						qty = buffer:ReadUnsigned(10)
					else
						qty = buffer:ReadUnsigned(7)
					end

					self:addBagItems({ num = num, quantity = qty })
				end
			end
		end


		--// Location
		if context == 'adventure' then
			etc.location = location
		else
			self.adventureLocationData = location
		end
		if #self.daycare.depositedFamiliars > 0 then
			etc.daycareHasFamiliars = true
		end

		-- Restore RO Powers
		self:ROPowers_restore()

		-- Absol Failsafe (Familiarium & Mega Keystone)
		if self.completedEvents.EnteredPast then
			if not self:getBagDataById('megakeystone', 5) then
				self:addBagItems{id = 'megakeystone', quantity = 1}
				self:onOwnFamiliars(359)
			else
				self:onOwnFamiliars(359)
			end
		end

		--// Lugia Failsafe
		if self.completedEvents.Lugia then
			if not self.completedEvents.GetSWing then
				self.completedEvents.Lugia = nil
			else
			end
		end
		--// Reveal Glass Failsafe
		if self.completedEvents.GetRevealGlass then
			if not self:getBagDataById('revealglass', 5) then
				self:addBagItems{ id = 'revealglass', quantity = 1 }
			end
		end
		--// Prison Bottle Failsafe
		if self.completedEvents.DefeatHoopa or self.completedEvents.DefeatHoopaAgain then
			if not self:getBagDataById('prisonbottle', 5) then
				self:addBagItems{ id = 'prisonbottle', quantity = 1 }
			end
		end
		--// Meteorite reward for Deoxys Battle
		if self.completedEvents.DeoxysBattle then
			if not self:getBagDataById('meteorite', 1) then
				self:addBagItems{ id = 'meteorite', quantity = 1 }
			end
		end

		-- Update Player Lists (and get dex count)
		self:updatePlayerListEntry(true)

		-- Pseudo-events / Server-events
		if BitBuffer.GetBit(self.hms, 1) then
			etc.completedEvents.GetCut = true
		end
		if self:getBagDataById('oldrod', 5) then
			etc.completedEvents.GetOldRod = true
		end

		if self.completedEvents.DefeatHoopaAgain then
			etc.completedEvents.DefeatHoopa = true
		end

		if self.completedEvents.DefeatHoopa then
			etc.completedEvents.DefeatHoopaAgain = true
		end

		for k, v in pairs(_f.PlayerEvents) do
			if type(v) == 'table' and v.server then
				etc.completedEvents[k] = nil
			end
		end

		etc.rotom = self:getRotomEventLevel()

		--Objectives
		local l_event
		for i=1, #indexToEvent do
			local Objectives = _f.Database.Objectives.Events
			local Event = indexToEvent[i]

			local v = self.completedEvents
			if self.completedEvents[Event] then
				if Objectives[Event] then
					l_event = Event
				end
			end
		end
		local BagesObjectives = {
			'BronzeBrickRecovered',
			'GroudonScene',
			'LighthouseScene',
			'MeetGerald',
			'TEinCastle',
			'vFluoruma',
			'vFrostveil',
			'vCrescent'
		}

		-- Find last completed event that has an objective
		local lastEvent
		for i = 1, #indexToEvent do
			local event = indexToEvent[i]
			if self.completedEvents[event] and _f.Database.Objectives.Events[event] then
				lastEvent = event
			end
		end

		local Objective = lastEvent and _f.Database.Objectives.Events[lastEvent] or nil

		local badgeIdx = lastEvent and table.find(BagesObjectives, lastEvent)
		if badgeIdx and self.badges[badgeIdx] then
			Objective = _f.Database.Objectives.Badges[badgeIdx]
		end
		-- If player has all 8 badges, force badge 8 objective
		if self.badges[8] then
			Objective = _f.Database.Objectives.Badges[8]
		end

		if not Objective or not Objective.Texts then
			-- If literally no events and no badges, show Default objective
			local hasAnyEvent = false
			for _, v in pairs(self.completedEvents) do
				if v then hasAnyEvent = true break end
			end
			local hasAnyBadge = false
			for i = 1, 8 do
				if self.badges[i] then hasAnyBadge = true break end
			end

			if not hasAnyEvent and not hasAnyBadge then
				Objective = _f.Database.Objectives.Default
			else
				Objective = {Texts = {'Please Report this and how it showed up', 'Join the discord and report this in #bug-reports'}}
			end
		end


		_f.Network:post('newObjective', self.player, Objective.Texts, Objective.Mark)
		return etc
	end
end
function PlayerData:getSaveData(gamemode)
	local k = gamemode or "adventure"

	self._saveDataCache = self._saveDataCache or {}
	self._saveDataLoading = self._saveDataLoading or {}

	if self._saveDataCache[k] then
		return self._saveDataCache[k][1], self._saveDataCache[k][2]
	end

	if self._saveDataLoading[k] then
		local timeout = tick() + 10
		repeat task.wait(0.1) until self._saveDataCache[k] or tick() > timeout

		if self._saveDataCache[k] then
			return self._saveDataCache[k][1], self._saveDataCache[k][2]
		end

		return nil, nil
	end

	self._saveDataLoading[k] = true

	local data, pcData
	local loaded = false

	for attempt = 1, 5 do
		local ok, s, d, p = pcall(function()
			return _f.DataPersistence.LoadData(self.player, k)
		end)

		if ok and s then
			data = d
			pcData = p
			loaded = true
			break
		end

		task.wait(1.5)
	end

	self._saveDataLoading[k] = nil

	if loaded then
		self._saveDataCache[k] = {data, pcData}
		return data, pcData
	end

	return nil, nil
end


function PlayerData:saveGame(etc)
	if not self.gameBegan or self.userId < 1 then return false end

	if not etc or type(etc) ~= "table" or type(etc.options) ~= "table" then
		warn("❌ Invalid ETC Data!")
		return false
	end

	local success, saveString = pcall(function()
		return self:serialize(etc)
	end)
	if not success then
		warn("Main serialize failed:", saveString)
		return false
	end

	local successPC, pcString = pcall(function()
		return self:PC_serialize()
	end)
	if not successPC then
		warn("PC serialize failed:", pcString)
		return false
	end


	local saved
	if self.gamemode == "AdvSlot1" then
		saved = _f.DataPersistence.SaveAdventureSlot1(self.player, saveString, pcString)
		if self.badges[3] and self.completedEvents.BlimpwJT then
			_f.APS[self.player]:saveAPRT("AdvSlot1")
		end
	elseif self.gamemode == "AdvSlot2" then
		saved = _f.DataPersistence.SaveAdventureSlot2(self.player, saveString, pcString)
		if self.badges[3] and self.completedEvents.BlimpwJT then
			_f.APS[self.player]:saveAPRT("AdvSlot2")
		end
	else
		saved = _f.DataPersistence.SaveData(self.player, saveString, pcString, self.gamemode)
		if self.badges[3] and self.completedEvents.BlimpwJT then
			_f.APS[self.player]:saveAPRT()
		end
	end

	for _ = 1, 3 do
		if saved then
			self.lastSaveEtc = etc
			return true
		end
		wait(0.1)
	end

	warn("❌ Failed to Save Data for", self.player.Name)
	return false
end


function PlayerData:getRotomEventLevel()
	local v = 0
	for i = 0, 2 do
		if self.completedEvents['RotomBit'..i] then
			v = v + 2^i
		end
	end
	return v
end
function PlayerData:setRotomEventLevel(v)
	for i = 2, 0, -1 do
		local p = 2^i
		if v >= p then
			v = v - p
			self.completedEvents['RotomBit'..i] = true
		else
			self.completedEvents['RotomBit'..i] = false
		end
	end
end

-- important for preventing data leaks
function PlayerData:destroy()
	for _, p in pairs(self.party) do
		p:destroy()
	end
	self.party = nil
	for _, p in pairs(self.daycare.depositedFamiliars) do
		p:destroy()
	end
	self.daycare = nil
	if self.honey and self.hony.foe then
		self.honey.foe:destroy()
	end
	self.honey = nil
	pcall(function() self.pcSession:destroy() end)
	self.pcSession = nil
	pcall(function() self.mineSession:destroy() end)
	self.mineSession = nil
end

--// enter/leave connections //--
local players = game:GetService('Players')

players.ChildAdded:Connect(function(player)
	refreshCodes(true) -- always force for first join
	onPlayerEnter(player)
end)



for _, p in pairs(players:GetPlayers()) do
	onPlayerEnter(p)
end


players.ChildRemoved:Connect(function(player)
	for player, data in pairs(PlayerDataByPlayer) do
		if not player or not player.Parent then
			PlayerDataByPlayer[player] = nil
			pcall(function()
				if data.gameBegan then 
					data:ROPowers_save()
				end
			end)
			pcall(function()
				data:Destroy()
			end)
		end
	end
end)




return PlayerDataByPlayer--PlayerData -- OVH  is this what we want?
-- 2022-01-01T10:43:35

-- 2022-01-03T10:43:16

-- 2022-01-04T16:14:17

-- 2022-01-04T12:54:41

-- 2022-01-05T13:52:02

-- 2022-01-05T10:54:41

-- 2022-01-05T10:41:14

-- 2022-01-05T21:57:56

-- 2022-01-12T11:49:04

-- 2022-01-14T16:46:41

-- 2022-01-14T11:49:20

-- 2022-01-15T12:45:20

-- 2022-01-15T20:31:55

-- 2022-01-16T11:42:35

-- 2022-01-17T20:49:05

-- 2022-01-18T12:52:35

-- 2022-01-19T22:14:10

-- 2022-01-19T20:03:14

-- 2022-01-22T16:46:36

-- 2022-01-22T21:12:23

-- 2022-01-22T12:01:19

-- 2022-01-24T18:47:47

-- 2022-01-25T17:02:05

-- 2022-01-26T22:18:06

-- 2022-01-26T16:46:41

-- 2022-01-28T16:34:20

-- 2022-01-28T18:03:50

-- 2022-01-28T16:05:21

-- 2022-01-30T11:51:14

-- 2022-01-31T09:46:21

-- 2022-01-31T10:16:01

-- 2022-02-05T12:07:13

-- 2022-02-05T15:37:17

-- 2022-02-06T19:45:21

-- 2022-02-07T22:55:18

-- 2022-02-07T20:58:05

-- 2022-02-09T10:07:12

-- 2022-02-09T15:37:51

-- 2022-02-13T18:49:25

-- 2022-02-13T09:29:15

-- 2022-02-13T16:16:26

-- 2022-02-15T16:59:21

-- 2022-02-16T10:26:41

-- 2022-02-16T14:33:12

-- 2022-02-16T11:07:42

-- 2022-02-18T11:25:32

-- 2022-02-19T20:01:11

-- 2022-02-19T12:20:45

-- 2022-02-19T16:23:39

-- 2022-02-19T19:32:29

-- 2022-02-19T13:55:54

-- 2022-02-21T22:22:42

-- 2022-02-22T14:05:46

-- 2022-02-22T20:38:58

-- 2022-02-22T12:30:24

-- 2022-02-23T18:04:04

-- 2022-02-27T21:36:50

-- 2022-02-27T17:41:38

-- 2022-02-27T21:50:21

-- 2022-02-28T09:43:06

-- 2022-02-28T10:10:04

-- 2022-02-28T13:30:39

-- 2022-03-03T12:06:24

-- 2022-03-03T11:36:43

-- 2022-03-03T11:11:39

-- 2022-03-03T21:49:58

-- 2022-03-05T09:12:24

-- 2022-03-05T18:45:26

-- 2022-03-06T15:55:01

-- 2022-03-07T19:39:51

-- 2022-03-08T11:28:23

-- 2022-03-08T21:35:30

-- 2022-03-08T14:39:51

-- 2022-03-09T17:38:30

-- 2022-03-09T20:56:31

-- 2022-03-12T10:52:26

-- 2022-03-12T19:48:18

-- 2022-03-13T19:04:11

-- 2022-03-17T12:17:16

-- 2022-03-18T19:37:26

-- 2022-03-18T14:36:30

-- 2022-03-18T09:21:16

-- 2022-03-18T20:09:36

-- 2022-03-19T10:35:01

-- 2022-03-19T09:07:05

-- 2022-03-21T22:37:52

-- 2022-03-22T15:54:28

-- 2022-03-22T10:47:24

-- 2022-03-25T14:37:31

-- 2022-03-25T15:48:41

-- 2022-03-25T14:25:28

-- 2022-03-26T19:26:10

-- 2022-03-26T22:46:20

-- 2022-03-26T15:40:34

-- 2022-03-27T21:06:49

-- 2022-03-27T20:01:13

-- 2022-03-28T22:41:19

-- 2022-03-29T14:03:57
