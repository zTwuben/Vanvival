local VanRegistries = require("VanRegistries")

local Vanvival_VehicleRegistry = require("Vanvival_VehicleRegistry")
local Vanvival_VehicleSpawnHelper = require("Vanvival_VehicleSpawnHelper")

local VanTraitsRegistry = VanRegistries.traits
local VanProfessionsRegistry = VanRegistries.professions

local Vanvival_VehicleSelector = {}

function Vanvival_VehicleSelector.choose(player, playersquare)
    local vehicleType
    local trailerType

		------------------RVOwner Priority---------------------------
		if player:hasTrait(VanTraitsRegistry.RV_Owner) then
			-- 75% chance for a full-size RV if available
			if #Vanvival_VehicleRegistry.validBigRVs > 0 and ZombRand(100) < 75 then
				vehicleType = Vanvival_VehicleRegistry.validBigRVs[ZombRand(#Vanvival_VehicleRegistry.validBigRVs) + 1]

			-- Otherwise use a camper RV
			elseif #Vanvival_VehicleRegistry.validCamperRVs > 0 then
				vehicleType = Vanvival_VehicleRegistry.validCamperRVs[ZombRand(#Vanvival_VehicleRegistry.validCamperRVs) + 1]

			-- Fallback to a big RV if that's all we have
			elseif #Vanvival_VehicleRegistry.validBigRVs > 0 then
				vehicleType = Vanvival_VehicleRegistry.validBigRVs[ZombRand(#Vanvival_VehicleRegistry.validBigRVs) + 1]

			-- Final fallback
			else
				Vanvival_VehicleSpawnHelper.sayLater(player, "RVOwner trait detected but no compatible RVs found!")
				Vanvival_VehicleSpawnHelper.sayLater(player, "Check your enabled vehicle mods.")
				vehicleType = Vanvival_VehicleRegistry.getRandVehicle()			
		end

		------------------Trucker Profession Logic---------------------------
		elseif player:getDescriptor():getCharacterProfession() == VanProfessionsRegistry.TRUCKER then

				if #Vanvival_VehicleRegistry.validSemiTrucks == 0 or #Vanvival_VehicleRegistry.validSemiTrailers == 0 then
					Vanvival_VehicleSpawnHelper.sayLater(player, "Trucker profession detected but no compatible truck/trailer mods found!")
					Vanvival_VehicleSpawnHelper.sayLater(player, "Check Vanvival's Description")
					vehicleType = Vanvival_VehicleRegistry.getRandVehicle()
				else
				if not playersquare:isOutside() then
					Vanvival_VehicleSpawnHelper.sayLater(player, "Can't spawn Truck -> Spawn using the Nomad/Vanvival Start option")
					Vanvival_VehicleSpawnHelper.sayLater(player, "Can't spawn Truck -> Spawn using the Nomad/Vanvival Start option")
					vehicleType = Vanvival_VehicleRegistry.getRandVehicle()
					return
				end

				vehicleType = Vanvival_VehicleRegistry.validSemiTrucks[ZombRand(#Vanvival_VehicleRegistry.validSemiTrucks) + 1]

				if SandboxVars.Vanvival.TrailerSpawnToggle and #Vanvival_VehicleRegistry.validSemiTrailers > 0 then
					trailerType = Vanvival_VehicleRegistry.validSemiTrailers[ZombRand(#Vanvival_VehicleRegistry.validSemiTrailers) + 1]
				end
			end
			-------- Default Random Vehicle--------------
		else
			vehicleType = Vanvival_VehicleRegistry.getRandVehicle()
		end

    return vehicleType, trailerType
end

return Vanvival_VehicleSelector