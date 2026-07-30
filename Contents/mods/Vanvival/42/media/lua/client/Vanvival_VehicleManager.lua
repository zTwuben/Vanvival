--[[
 _____  _    _  _   _ ______  _____  _   _      _    _   ___   _____      _   _  _____ ______  _____ 
|_   _|| |  | || | | || ___ \|  ___|| \ | |    | |  | | / _ \ /  ___|    | | | ||  ___|| ___ \|  ___|
  | |  | |  | || | | || |_/ /| |__  |  \| |    | |  | |/ /_\ \\ `--.     | |_| || |__  | |_/ /| |__  
  | |  | |/\| || | | || ___ \|  __| | . ` |    | |/\| ||  _  | `--. \    |  _  ||  __| |    / |  __| 
  | |  \  /\  /| |_| || |_/ /| |___ | |\  |    \  /\  /| | | |/\__/ /    | | | || |___ | |\ \ | |___ 
  \_/   \/  \/  \___/ \____/ \____/ \_| \_/     \/  \/ \_| |_/\____/     \_| |_/\____/ \_| \_|\____/ 
                                                                                                     
         			Thanks Monkey for being really influential with their code                                                                                              
--]]

--Requires
local vehicles_list = require "VehiclesList"


local Vanvival_VehicleManager = {}
Vanvival_VehicleManager.__index = Vanvival_VehicleManager

local validVehicles = {}
local validTrailers = {}
local currentRVmod = nil

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

function Vanvival_VehicleManager.populateValidVehicles()
	validVehicles = {}
	validTrailers = {}
	currentRVmod = nil

	if getActivatedMods():contains("\\PROJECTRVInterior42") then
		currentRVmod = "PRI"
	elseif getActivatedMods():contains("\\RVLife") then
		currentRVmod = "RVL"
	end

	--Vehicles Modded
	for mod_name, vehicle_table in pairs(vehicles_list.vehicles.mods) do
        if getActivatedMods():contains(mod_name) then
			if vehicle_table.rvSupport == "both" or vehicle_table.rvSupport == currentRVmod then
				for _, v in ipairs(vehicle_table.vehicles) do
                	table.insert(validVehicles, v)
            	end
			end
        end
    end

	-- Vanilla vehicles
     for _, v in ipairs(vehicles_list.vehicles.vanilla) do
        table.insert(validVehicles, v)
    end

	--Traillers Modded
    for mod_name, trailer_table in pairs(vehicles_list.trailers.mods) do
        if getActivatedMods():contains(mod_name) then
			if trailer_table.rvSupport == "both" or trailer_table.rvSupport == currentRVmod then
				for _, t in ipairs(trailer_table) do
					table.insert(validTrailers, t)
				end				
			end
        end
    end

	-- Only add vanilla trailers if no modded trailers exist
    if #validTrailers == 0 then
        for _, t in ipairs(vehicles_list.trailers.vanilla) do
            table.insert(validTrailers, t)
        end
    end
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
    return validTrailers[ZombRand(#validTrailers) + 1]
end




-- Spawn vehicle
function Vanvival_VehicleManager.spawnVehicle(player)
	if not player then return end
	local playersquare = player:getCurrentSquare()
	if not playersquare then return end

	local square = getVehicleSpawnNearPlayer(player)
	if not square then return end

		local inv = player:getInventory();
		local profession = player:getDescriptor():getProfession()
		local vehicleType, trailerType
		local trailerChance = SandboxVars.Vanvival.TrailerSpawnChance or 25
		local vehicleDir = chooseVehicleDirection(square)

		
		
		------------------RVOwner Priority---------------------------
		if player:HasTrait("RVOwner") then
			local RVOptions = {}
			if getActivatedMods():contains("\\FRUsedCarsAlpha") then
				table.insert(RVOptions, "Base.fr_fl_bounder_86")
				table.insert(RVOptions, "Base.fr_fo_econoline_rv_86")
			end
			if getActivatedMods():contains("\\PzkVanillaPlusCarPack") then
				table.insert(RVOptions, "Base.pzkFranklinTruckRV")
			end
			if getActivatedMods():contains("\\73Winnebago") then
				table.insert(RVOptions, "Base.73Winnebago")
			end
			
			if #RVOptions > 0 then
				vehicleType = RVOptions[ZombRand(#RVOptions) + 1]
			else
				VNV_SayLater(player, "RVOwner trait detected but no RV mods enabled!")
				VNV_SayLater(player, "Check Vanvival's Description")
				VNV_SayLater(player, "RVOwner trait detected but no RV mods enabled!")
				VNV_SayLater(player, "Check Vanvival's Description")
				vehicleType = Vanvival_VehicleManager.getRandVehicle()
			end


			------------------Trucker Profession Logic---------------------------
		elseif profession == "Trucker" then
			local TruckOptions, TruckTrailersOptions = {}, {}
			local hasTruckMod = false
			local addedCompatible = false

			if getActivatedMods():contains("\\rSemiTruck") then
				hasTruckMod = true
				addedCompatible = true
				table.insert(TruckOptions, "Base.SemiTruck")
				table.insert(TruckTrailersOptions, "Base.SemiTrailerVan")
       		end
			if getActivatedMods():contains("\\ATA_Petyarbuilt") then
				hasTruckMod = true
				if currentRVmod == "PRI" then ---Change this later when RV Life adds compability
					addedCompatible = true
					table.insert(TruckOptions, "Base.ATAPetyarbuilt")
					table.insert(TruckOptions, "Base.ATAPetyarbuiltSleeper")
					table.insert(TruckOptions, "Base.ATAPetyarbuiltSleeperLong")
					table.insert(TruckTrailersOptions, "Base.TrailerTSMega")
					--table.insert(TruckTrailersOptions, "Base.TrailerTSMegaAnimal")-- Add when Mickey adds compability!
				else
					VNV_SayLater(player, "Autotsar Tuning Atelier - Petyarbuilt 379 [B42] not compatible with RV Life")
					VNV_SayLater(player, "Autotsar Tuning Atelier - Petyarbuilt 379 [B42] not compatible with RV Life")
					vehicleType = Vanvival_VehicleManager.getRandVehicle()
				end
			end

			if addedCompatible and #TruckOptions > 0 and #TruckTrailersOptions > 0 then
				if not playersquare:isOutside() then
					VNV_SayLater(player, "Can't spawn Truck -> Spawn using the Nomad/Vanvival Start option")
					VNV_SayLater(player, "Can't spawn Truck -> Spawn using the Nomad/Vanvival Start option")
					vehicleType = Vanvival_VehicleManager.getRandVehicle()
				return
				end
				vehicleType = TruckOptions[ZombRand(#TruckOptions) + 1]
				trailerType = TruckTrailersOptions[ZombRand(#TruckTrailersOptions) + 1]
        	else
				if not hasTruckMod then
					VNV_SayLater(player, "Trucker profession detected but Truck Mod not enabled!")
					VNV_SayLater(player, "Check Vanvival's Description")
					VNV_SayLater(player, "Trucker profession detected but Truck Mod not enabled!")
					VNV_SayLater(player, "Check Vanvival's Description")					
					vehicleType = Vanvival_VehicleManager.getRandVehicle()
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
				local trailerSquare = findTrailerSquare(square, vehicleDir)
				local trailer = addVehicleDebug(trailerType, vehicleDir, nil, trailerSquare)
				if trailer then
					trailer:repair()
					trailer:setGeneralPartCondition(1, 100)
					inv:AddItem(trailer:createVehicleKey())
				end				
			elseif ZombRand(100) < trailerChance and SandboxVars.Vanvival.TrailerSpawnToggle then
				trailerType = Vanvival_VehicleManager.getRandTrailer()
				local trailerSquare = findTrailerSquare(square, vehicleDir)
				local trailer = addVehicleDebug(trailerType, vehicleDir, nil, trailerSquare)				
				if trailer then
					trailer:repair()
					trailer:setGeneralPartCondition(1, 100)
					inv:AddItem(trailer:createVehicleKey())
				end
			end

			if player:HasTrait("VanSurvivor") then
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

	if player:HasTrait("BicycleOwner") and getActivatedMods():contains("\\BicycleMod") and not modData.carSpawned then
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