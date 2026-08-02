local VanRegistries = require("VanRegistries")

local Vanvival_VehicleRegistry = require("Vanvival_VehicleRegistry")
local Vanvival_VehicleSpawnHelper = require("Vanvival_VehicleSpawnHelper")
-- local Vanvival_ZombieDecimator = require("Vanvival_ZombieDecimator") -- removed in mp

local VanTraitsRegistry = VanRegistries.traits


local Vanvival_VehicleSpawner = {}

function Vanvival_VehicleSpawner.spawn(player, square, vehicleType, trailerType)
        local inv = player:getInventory()
        local trailerChance = SandboxVars.Vanvival.TrailerSpawnChance or 25
        local vehicleDir = Vanvival_VehicleSpawnHelper.chooseVehicleDirection(square)


    	local vehicle = addVehicleDebug(vehicleType, vehicleDir, nil, square)

		if vehicle then
			print("[Vanvival] Vehicle Key ID = " .. tostring(vehicle:getKeyId()))
			vehicle:repair()
			vehicle:setGeneralPartCondition(1,100);

			local gasvalue = vehicle:getPartById("GasTank"):getContainerCapacity() * (0.25 + (ZombRand(100)+1)/100);
			vehicle:getPartById("GasTank"):setContainerContentAmount(gasvalue);

			local key = vehicle:createVehicleKey()

			print("[Vanvival] Key = " .. tostring(key))

			if key then
				-- Only give the key here in singleplayer.
				if not isServer() then
					inv:AddItem(key)
				end
			end

			--Spawn trailer if defined or random chance
			if trailerType and SandboxVars.Vanvival.TrailerSpawnToggle then
				local trailerSquare = Vanvival_VehicleSpawnHelper.findTrailerSquare(square, vehicleDir, 10, 16)
				local trailer = addVehicleDebug(trailerType, vehicleDir, nil, trailerSquare)
				if trailer then
					trailer:repair()
					trailer:setGeneralPartCondition(1, 100)
					local trailerKey = trailer:createVehicleKey()

					if trailerKey then
						if not isServer() then
							inv:AddItem(trailerKey)
						end
					end
				end				
			elseif ZombRand(100) < trailerChance and SandboxVars.Vanvival.TrailerSpawnToggle then
				trailerType = Vanvival_VehicleRegistry.getRandTrailer()
				local trailerSquare = Vanvival_VehicleSpawnHelper.findTrailerSquare(square, vehicleDir, 8,12)
				local trailer = addVehicleDebug(trailerType, vehicleDir, nil, trailerSquare)				
				if trailer then
					trailer:repair()
					trailer:setGeneralPartCondition(1, 100)
					local trailerKey = trailer:createVehicleKey()

					if trailerKey then
						if not isServer() then
							inv:AddItem(trailerKey)
						end
					end
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
			--Vanvival_ZombieDecimator:StartPurge(player) -- Removed in MP


			return vehicle
        end

		return nil
end

return Vanvival_VehicleSpawner