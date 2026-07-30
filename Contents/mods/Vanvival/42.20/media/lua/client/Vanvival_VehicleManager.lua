--[[
 _____  _    _  _   _ ______  _____  _   _      _    _   ___   _____      _   _  _____ ______  _____ 
|_   _|| |  | || | | || ___ \|  ___|| \ | |    | |  | | / _ \ /  ___|    | | | ||  ___|| ___ \|  ___|
  | |  | |  | || | | || |_/ /| |__  |  \| |    | |  | |/ /_\ \\ `--.     | |_| || |__  | |_/ /| |__  
  | |  | |/\| || | | || ___ \|  __| | . ` |    | |/\| ||  _  | `--. \    |  _  ||  __| |    / |  __| 
  | |  \  /\  /| |_| || |_/ /| |___ | |\  |    \  /\  /| | | |/\__/ /    | | | || |___ | |\ \ | |___ 
  \_/   \/  \/  \___/ \____/ \____/ \_| \_/     \/  \/ \_| |_/\____/     \_| |_/\____/ \_| \_|\____/ 
                                                                                                     
         			Thanks Monkey for being really influential with their code                                                                                             
--]]

--[[


						Integrated KrizKovIcePops 42.19 Fix! - Twuben
						
						
    Build 42.19 compatibility fix (overrides Vanvival's Vanvival_VehicleManager.lua
    by identical relative path, loaded after Vanvival).

    Vanvival's original used three Build 41 APIs that were removed in Build 42 and
    crashed onPlayerCreated / spawnVehicle ("Object tried to call nil"):
        - player:HasTrait("Name")        -> removed; B42 is player:hasTrait(CharacterTrait)
        - desc:getProfession() (String)  -> removed; B42 is desc:getCharacterProfession() (CharacterProfession)
        - profession == "Trucker"        -> now compares CharacterProfession objects
    The custom traits/professions are registered (in the mod's twbVanvival namespace)
    by this patch's Vanvival_B42TraitProfShim.lua. Only the broken calls below are
    changed; the rest of the file is Vanvival's, verbatim.
--]]

--Requires
local vehicles_list = require "VehiclesList"
local VanRegistries = require('VanRegistries')

local VanTraitsRegistry = VanRegistries.traits
local VanProfessionsRegistry = VanRegistries.professions


-- ============================================================================
-- B42 AUTO-DISCOVERY (VanvivalB42Fix add-on)
-- Vanvival only spawns vehicles from a hardcoded whitelist (VehiclesList.lua),
-- so most installed van/RV mods are ignored and you fall back to a vanilla van.
-- The block below scans EVERY loaded vehicle script and unions any van/RV-type
-- vehicle into the spawn pool automatically -- no per-mod whitelist needed.
-- It is purely additive: the original whitelist still works.
-- ============================================================================

-- Distinctive RV/motorhome name tokens (plain substring match is safe for these).
local VNV_RV_TOKENS  = { "winnebago", "bounder", "motorhome", "motor_home",
                         "camper", "campervan", "caravan", "rvlife", "rvinterior",
                         "econolinerv", "econoline_rv", "westfalia", "vanlife" }
-- Van name tokens.
local VNV_VAN_TOKENS = { "van", "econoline", "transit", "e150", "e-150",
                         "b700", "f700", "type2", "multivan", "minivan", "stepvan" }
-- Never spawn these wreck/utility variants.
local VNV_EXCLUDE    = { "burnt", "smashed", "wreck", "crashed", "destroyed" }

local function VNV_matchAny(s, tokens)
    for _, t in ipairs(tokens) do
        if string.find(s, t, 1, true) then return true end
    end
    return false
end

-- Match "rv" only at a word boundary so we catch FranklinTruckRV / econoline_rv
-- but NOT cars like Corvette ("co-rv-ette").
local function VNV_hasRVword(s)
    return string.find(s, "rv$") ~= nil
        or string.find(s, "_rv") ~= nil
        or string.find(s, "rv_") ~= nil
        or string.find(s, " rv") ~= nil
end

local function VNV_isRV(s)  return VNV_matchAny(s, VNV_RV_TOKENS) or VNV_hasRVword(s) end
local function VNV_isVan(s) return VNV_matchAny(s, VNV_VAN_TOKENS) end

-- Scan all vehicle scripts. Returns sets keyed by full name ("Base.73Winnebago").
local function VNV_discover()
    local vehicles, rvs, trailers = {}, {}, {}
    local ok, scripts = pcall(function() return getScriptManager():getAllVehicleScripts() end)
    if not ok or not scripts then return vehicles, rvs, trailers end

    for i = 1, scripts:size() do
        local script = scripts:get(i - 1)
        if script then
            local full  = script:getFullName()                 -- "Base.73Winnebago"
            local nameL = full and string.lower(script:getName() or "") or ""
            local fullL = full and string.lower(full) or ""
            if full and not VNV_matchAny(fullL, VNV_EXCLUDE) and not VNV_matchAny(nameL, VNV_EXCLUDE) then
                local engineForce = 0
                local okE, ef = pcall(function() return script:getEngineForce() end)
                if okE and ef then engineForce = ef end
                local isTrailer = (engineForce == 0) or string.find(fullL, "trailer", 1, true) ~= nil

                if isTrailer then
                    -- only auto-add camper/home style trailers (what RV players want)
                    if VNV_isRV(nameL) or VNV_isRV(fullL)
                       or string.find(fullL, "camp", 1, true) or string.find(fullL, "home", 1, true) then
                        trailers[full] = true
                    end
                elseif engineForce > 0 and (VNV_isRV(nameL) or VNV_isRV(fullL)) then
                    rvs[full]      = true   -- driveable RV / motorhome (has an engine)
                    vehicles[full] = true
                elseif engineForce > 0 and (VNV_isVan(nameL) or VNV_isVan(fullL)) then
                    vehicles[full] = true   -- driveable van (has an engine)
                end
            end
        end
    end
    return vehicles, rvs, trailers
end


local Vanvival_VehicleManager = {}
Vanvival_VehicleManager.__index = Vanvival_VehicleManager

local validVehicles = {}

local validVans = {}
local validStepVans = {}
local validCamperRVs = {}
local validBigRVs = {}
local validBoxTrucks = {}
local validSemiTrucks = {}
local validBuses = {}
local validUtility = {}
local currentRVmod = nil

local validUtilityTrailers = {}
local validSemiTrailers = {}
local validCamperTrailers = {}


function VNV_SayLater(player, msg, delayTicks)
    local ticks = delayTicks or 100
    local function delayedSay()
        ticks = ticks - 1
        if ticks <= 0 then
            player:Say(msg)
            Events.OnTick.Remove(delayedSay)
        end
    end
    Events.OnTick.Add(delayedSay)
end


local function addCategory(source, destination)
    if not source then return end

    for _, vehicle in ipairs(source) do
        table.insert(destination, vehicle)
        table.insert(validVehicles, vehicle)
    end
end

local function addTrailerCategory(source, destination)
	if not source then return end

	for _, trailer in ipairs(source) do
		table.insert(destination, trailer)
	end
end

function Vanvival_VehicleManager.populateValidVehicles()
validVehicles = {}

validVans = {}
validStepVans = {}
validCamperRVs = {}
validBigRVs = {}
validBoxTrucks = {}
validSemiTrucks = {}
validBuses = {}
validUtility = {}

validUtilityTrailers = {}
validSemiTrailers = {}
validCamperTrailers = {}

currentRVmod = nil





	if getActivatedMods():contains("PROJECTRVInterior42") then
		currentRVmod = "PRI"
	elseif getActivatedMods():contains("RVLife") then
		currentRVmod = "RVL"
	end

	--Vehicles Modded
	for mod_name, vehicle_table in pairs(vehicles_list.vehicles.mods) do
        if getActivatedMods():contains(mod_name) then
			if vehicle_table.rvSupport == "both" or vehicle_table.rvSupport == currentRVmod then
				local v = vehicle_table.vehicles

				addCategory(v.vans,        validVans)
				addCategory(v.stepVans,    validStepVans)
				addCategory(v.camperRVs,   validCamperRVs)
				addCategory(v.bigRVs,      validBigRVs)
				addCategory(v.boxTrucks,   validBoxTrucks)
				addCategory(v.semiTrucks,  validSemiTrucks)
				addCategory(v.buses,       validBuses)
				addCategory(v.utility,     validUtility)
			end
        end
    end

	-- Vanilla vehicles
	local v = vehicles_list.vehicles.vanilla

	addCategory(v.vans,       validVans)
	addCategory(v.stepVans,   validStepVans)
	addCategory(v.camperRVs,  validCamperRVs)
	addCategory(v.bigRVs,     validBigRVs)
	addCategory(v.boxTrucks,  validBoxTrucks)
	addCategory(v.semiTrucks, validSemiTrucks)
	addCategory(v.buses,      validBuses)
	addCategory(v.utility,    validUtility)

	-- Modded trailers
	for mod_name, trailer_table in pairs(vehicles_list.trailers.mods) do
		if getActivatedMods():contains(mod_name) then
			if trailer_table.rvSupport == "both" or trailer_table.rvSupport == currentRVmod then
				local t = trailer_table.trailers

				addTrailerCategory(t.utility,         validUtilityTrailers)
				addTrailerCategory(t.semi,            validSemiTrailers)
				addTrailerCategory(t.camperTrailers,  validCamperTrailers)
			end
		end
	end

	-- Vanilla trailers
	local t = vehicles_list.trailers.vanilla

	addTrailerCategory(t.utility,         validUtilityTrailers)
	addTrailerCategory(t.semi,            validSemiTrailers)
	addTrailerCategory(t.camperTrailers,  validCamperTrailers)

	-- B42 AUTO-DISCOVERY: union every installed DRIVEABLE van/RV vehicle script on
	-- top of the whitelist above (dedup by full name). This is what makes ALL your
	-- van and RV mods usable, not just the few listed in VehiclesList.lua.
	local haveVehicle = {}
	for _, v in ipairs(validVehicles) do haveVehicle[v] = true end

	local dVehicles, _, dTrailers = VNV_discover()
	for full in pairs(dVehicles) do
		if not haveVehicle[full] then
			haveVehicle[full] = true
			table.insert(validVehicles, full)
		end
	end

	-- NOTE: discovered towable trailers (camper / RV caravan living-quarters) are
	-- intentionally NOT added to the spawn pool. They have no engine, so spawning
	-- one as your starting vehicle would leave you stranded; and auto-attaching a
	-- livable RV-trailer to a driveable vehicle is far too strong for a fresh start.
	-- Only the mod's own utility trailers (whitelist / vanilla, set above) can ever
	-- spawn, via the normal random trailer chance.
	local _ = dTrailers  -- detected but deliberately unused

print(
    "[Vanvival] Vehicles: " .. #validVehicles ..
    " | Utility trailers: " .. #validUtilityTrailers ..
    " | Semi trailers: " .. #validSemiTrailers ..
    " | Camper trailers: " .. #validCamperTrailers
)

print("Vans:", #validVans)
print("Step Vans:", #validStepVans)
print("Camper RVs:", #validCamperRVs)
print("Big RVs:", #validBigRVs)
print("Box Trucks:", #validBoxTrucks)
print("Semi Trucks:", #validSemiTrucks)
print("Buses:", #validBuses)
print("Utility:", #validUtility)

print("Utility Trailers:", #validUtilityTrailers)
print("Semi Trailers:", #validSemiTrailers)
print("Camper Trailers:", #validCamperTrailers)



end

local function findBuildingNearSquare(square)
    local cell = getCell()
    for dx = -5,5 do
        for dy = -5,5 do
            local sq = cell:getGridSquare(square:getX() + dx, square:getY() + dy, square:getZ())
            if sq then
                local b = sq:getBuilding()
                if b then
                    return b
                end
            end
        end
    end
    return nil
end


local function chooseVehicleDirection(square, maxCheckDistance)
	maxCheckDistance = maxCheckDistance or 10
	local building = square:getBuilding() or findBuildingNearSquare(square)

	local directions = {
        {name = "N", dx = 0, dy = -1, enum = IsoDirections.N},
        {name = "S", dx = 0, dy = 1, enum = IsoDirections.S},
        {name = "E", dx = 1, dy = 0, enum = IsoDirections.E},
        {name = "W", dx = -1, dy = 0, enum = IsoDirections.W},
    }

	local bestDir = directions[1]
	local maxFree = -1
	

	if not building then
		bestDir.enum = IsoDirections.E
		return bestDir.enum
	else
		for _, dir in ipairs(directions) do
			local freeCount = 0
			for i = 1, maxCheckDistance do
				local checkX = square:getX() + dir.dx * i
				local checkY = square:getY() + dir.dy * i
				local checkSquare = getCell():getGridSquare(checkX, checkY, square:getZ())
				if checkSquare and checkSquare:isOutside() and checkSquare:isFree(false) and not checkSquare:isVehicleIntersecting() then
					freeCount = freeCount + 1
				else
					break  -- stop counting in this direction
				end
			end

			if freeCount > maxFree then
				maxFree = freeCount
				bestDir = dir
			end
		end
    	return bestDir.enum
	end
end


local function getVehicleSpawnNearPlayer(player)

    local square = player:getCurrentSquare()
	if not square then return end

    local building = square:getBuilding() or findBuildingNearSquare(square)

    local world = getWorld()
    if not world then
        return square
    end

    local metaGrid = world:getMetaGrid()
    if not metaGrid then
        return square
    end


    local vehicleSquares = {}
    local z = player:getZ()

    local radius = 20
    local minDistance = 5  -- minimum distance from player spawn


	if not building then
		local playersquare = player:getCurrentSquare()
		if not playersquare then return end
		local sq = getCell():getGridSquare(playersquare:getX(), playersquare:getY() - 2, playersquare:getZ())
		return sq
	else
		---Fallbacks to new car location
		for dx = -radius, radius do
			for dy = -radius, radius do
				local x, y = square:getX() + dx, square:getY() + dy
				local zone = metaGrid:getVehicleZoneAt(x, y, z)
				if zone then
					local sq = getCell():getGridSquare(x, y, z)
					if sq and sq:isOutside() and sq:isFree(false) and not sq:isVehicleIntersecting() then
						local dist = math.sqrt((sq:getX() - square:getX())^2 + (sq:getY() - square:getY())^2)
						if dist >= minDistance then
							table.insert(vehicleSquares, sq)
							print("Valid vehicle zone at:", x, y, z, "dist from player:", dist)
						else
							print("Skipping zone too close to player:", x, y, z, "dist:", dist)
						end
					else
						print("Grid square at", x, y, z, "is nil or not outside")
					end
				end
			end
		end
			if #vehicleSquares > 0 then
				local closestSq = vehicleSquares[1]
				local minDist = math.huge
				local px, py = square:getX(), square:getY()

				for _, vsq in ipairs(vehicleSquares) do
					local dist = (vsq:getX() - px)^2 + (vsq:getY() - py)^2
					if dist < minDist then
						minDist = dist
						closestSq = vsq
					end
				end

				print("Chosen vehicle spawn square:", closestSq:getX(), closestSq:getY(), closestSq:getZ())
				return closestSq
			end

			print("No vehicle zones found, fallback to player square")
			return square
	end
end


local function findTrailerSquare(square, vehicleDir, minDistance, maxDistance)
	maxDistance = maxDistance or 8
	minDistance = minDistance or 4
	local x, y, z = square:getX(), square:getY(), square:getZ()

	local dx, dy = 0, 0
	if vehicleDir == IsoDirections.N then dy = 1
    elseif vehicleDir == IsoDirections.S then dy = -1
    elseif vehicleDir == IsoDirections.E then dx = -1
    elseif vehicleDir == IsoDirections.W then dx = 1
    end

	local cell = getCell()
	for i = minDistance, maxDistance do
        local checkSquare = cell:getGridSquare(x + dx * i, y + dy * i, z)
        if checkSquare and checkSquare:isOutside() and checkSquare:isFree(false) and not checkSquare:isVehicleIntersecting() then
            print("Found trailer square at:", checkSquare:getX(), checkSquare:getY(), checkSquare:getZ())
            return checkSquare
        end
    end
	print("No free trailer square found, using vehicle square")
    return square
end

-- Function to clear Custom Traits vehicle inventory
local function ClearVehicleInventory(vehicle)
	local partCount = vehicle:getPartCount()

	for i = 0, partCount -1 do
		local part = vehicle:getPartByIndex(i)
		if part then
			local container = part:getItemContainer()
			if container then
				container:clear()
			end
		end
	end
end

--Get random vehicle

function Vanvival_VehicleManager.getRandVehicle()
    return validVehicles[ZombRand(#validVehicles) + 1]
end

function Vanvival_VehicleManager.getRandTrailer()
    return validUtilityTrailers[ZombRand(#validUtilityTrailers) + 1]
end




-- Spawn vehicle
function Vanvival_VehicleManager.spawnVehicle(player)
	if not player then return end
	local playersquare = player:getCurrentSquare()
	if not playersquare then return end

	local square = getVehicleSpawnNearPlayer(player)
	if not square then return end

		local inv = player:getInventory();
		local vehicleType, trailerType
		local trailerChance = SandboxVars.Vanvival.TrailerSpawnChance or 25
		local vehicleDir = chooseVehicleDirection(square)

	
		------------------RVOwner Priority---------------------------
		if player:hasTrait(VanTraitsRegistry.RV_Owner) then
			-- 75% chance for a full-size RV if available
			if #validBigRVs > 0 and ZombRand(100) < 75 then
				vehicleType = validBigRVs[ZombRand(#validBigRVs) + 1]

			-- Otherwise use a camper RV
			elseif #validCamperRVs > 0 then
				vehicleType = validCamperRVs[ZombRand(#validCamperRVs) + 1]

			-- Fallback to a big RV if that's all we have
			elseif #validBigRVs > 0 then
				vehicleType = validBigRVs[ZombRand(#validBigRVs) + 1]

			-- Final fallback
			else
				VNV_SayLater(player, "RVOwner trait detected but no compatible RVs found!")
				VNV_SayLater(player, "Check your enabled vehicle mods.")
				vehicleType = Vanvival_VehicleManager.getRandVehicle()			
		end

		------------------Trucker Profession Logic---------------------------
		elseif player:getDescriptor():getCharacterProfession() == VanProfessionsRegistry.TRUCKER then

				if #validSemiTrucks == 0 or #validSemiTrailers == 0 then
					VNV_SayLater(player, "Trucker profession detected but no compatible truck/trailer mods found!")
					VNV_SayLater(player, "Check Vanvival's Description")
					vehicleType = Vanvival_VehicleManager.getRandVehicle()
				else
				if not playersquare:isOutside() then
					VNV_SayLater(player, "Can't spawn Truck -> Spawn using the Nomad/Vanvival Start option")
					VNV_SayLater(player, "Can't spawn Truck -> Spawn using the Nomad/Vanvival Start option")
					vehicleType = Vanvival_VehicleManager.getRandVehicle()
					return
				end

				vehicleType = validSemiTrucks[ZombRand(#validSemiTrucks) + 1]

				if SandboxVars.Vanvival.TrailerSpawnToggle and #validSemiTrailers > 0 then
					trailerType = validSemiTrailers[ZombRand(#validSemiTrailers) + 1]
				end
			end
			-------- Default Random Vehicle--------------
		else
			vehicleType = Vanvival_VehicleManager.getRandVehicle()
		end

		------ Vehicle Spawning-----------
		local vehicle = addVehicleDebug(vehicleType, vehicleDir, nil, square)

		if vehicle then
			vehicle:repair()
			vehicle:setGeneralPartCondition(1,100);

			local gasvalue = vehicle:getPartById("GasTank"):getContainerCapacity() * (0.25 + (ZombRand(100)+1)/100);
			vehicle:getPartById("GasTank"):setContainerContentAmount(gasvalue);

			inv:AddItem(vehicle:createVehicleKey())

			--Spawn trailer if defined or random chance
			if trailerType and SandboxVars.Vanvival.TrailerSpawnToggle then
				local trailerSquare = findTrailerSquare(square, vehicleDir, 10, 16)
				local trailer = addVehicleDebug(trailerType, vehicleDir, nil, trailerSquare)
				if trailer then
					trailer:repair()
					trailer:setGeneralPartCondition(1, 100)
					inv:AddItem(trailer:createVehicleKey())
				end				
			elseif ZombRand(100) < trailerChance and SandboxVars.Vanvival.TrailerSpawnToggle then
				trailerType = Vanvival_VehicleManager.getRandTrailer()
				local trailerSquare = findTrailerSquare(square, vehicleDir, 8,12)
				local trailer = addVehicleDebug(trailerType, vehicleDir, nil, trailerSquare)				
				if trailer then
					trailer:repair()
					trailer:setGeneralPartCondition(1, 100)
					inv:AddItem(trailer:createVehicleKey())
				end
			end

			if player:hasTrait(VanTraitsRegistry.VAN_SURVIVOR) then
				ClearVehicleInventory(vehicle)
				local trunk = vehicle:getPartById("TruckBed") or vehicle:getPartById("Trunk")
				if trunk then
					local container = trunk:getItemContainer()
					container:AddItem("Base.HandAxe")
					container:AddItem("Base.TirePump")
					container:AddItem("Base.Wrench")
					container:AddItem("Base.LugWrench")
					container:AddItem("Base.Saw")
					container:AddItem("Base.Lighter")
					container:AddItem("Base.PetrolCan")
					container:AddItem("Base.CampingTentKit2")
					container:AddItem("Base.WaterBottle")
					container:AddItem("Base.CannedChili")
					container:AddItem("Base.CannedChili")
				end
			end
			Vanvival_ZombieDecimator:StartPurge();
		end
	end




-- Hook for when player is created 

local function onPlayerCreated(playerIndex, player)
	if not player then return end
	local modData = player:getModData()

	if not SandboxVars.Vanvival.VehicleSpawnToggle then
		return
	end

	if player:hasTrait(VanTraitsRegistry.BicycleOwner) and getActivatedMods():contains("\\BicycleMod") and not modData.carSpawned then
		player:getInventory():AddItem("Bicycle.Bicycle")
		modData.carSpawned = true
	end

	if not modData.carSpawned then
		Vanvival_VehicleManager.populateValidVehicles()
		Vanvival_VehicleManager.spawnVehicle(player)
		modData.carSpawned = true
	end

end

Events.OnCreatePlayer.Add(onPlayerCreated)