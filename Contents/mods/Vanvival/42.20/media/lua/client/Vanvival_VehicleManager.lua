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
local VanRegistries = require('VanRegistries')

local Vanvival_VehicleSpawnHelper = require("Vanvival_VehicleSpawnHelper")
local Vanvival_VehicleRegistry = require("Vanvival_VehicleRegistry")
local Vanvival_VehicleSelector = require("Vanvival_VehicleSelector")


local VanTraitsRegistry = VanRegistries.traits
local VanProfessionsRegistry = VanRegistries.professions


local Vanvival_VehicleManager = {}
Vanvival_VehicleManager.__index = Vanvival_VehicleManager


-- Spawn vehicle
function Vanvival_VehicleManager.spawnVehicle(player)
	if not player then return end
	local playersquare = player:getCurrentSquare()
	if not playersquare then return end

	local square = Vanvival_VehicleSpawnHelper.getVehicleSpawnNearPlayer(player)
	if not square then return end

		local inv = player:getInventory();
		local vehicleType, trailerType = Vanvival_VehicleSelector.choose(player, playersquare)
		local trailerChance = SandboxVars.Vanvival.TrailerSpawnChance or 25
		local vehicleDir = Vanvival_VehicleSpawnHelper.chooseVehicleDirection(square)
	
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
				local trailerSquare = Vanvival_VehicleSpawnHelper.findTrailerSquare(square, vehicleDir, 10, 16)
				local trailer = addVehicleDebug(trailerType, vehicleDir, nil, trailerSquare)
				if trailer then
					trailer:repair()
					trailer:setGeneralPartCondition(1, 100)
					inv:AddItem(trailer:createVehicleKey())
				end				
			elseif ZombRand(100) < trailerChance and SandboxVars.Vanvival.TrailerSpawnToggle then
				trailerType = Vanvival_VehicleRegistry.getRandTrailer()
				local trailerSquare = Vanvival_VehicleSpawnHelper.findTrailerSquare(square, vehicleDir, 8,12)
				local trailer = addVehicleDebug(trailerType, vehicleDir, nil, trailerSquare)				
				if trailer then
					trailer:repair()
					trailer:setGeneralPartCondition(1, 100)
					inv:AddItem(trailer:createVehicleKey())
				end
			end

			if player:hasTrait(VanTraitsRegistry.VAN_SURVIVOR) then
				Vanvival_VehicleSpawnHelper.ClearVehicleInventory(vehicle)
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
		Vanvival_VehicleRegistry.populateValidVehicles()
		Vanvival_VehicleManager.spawnVehicle(player)
		modData.carSpawned = true
	end

end

Events.OnCreatePlayer.Add(onPlayerCreated)