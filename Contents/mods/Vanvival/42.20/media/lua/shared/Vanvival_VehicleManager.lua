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
local Vanvival_VehicleSpawner = require("Vanvival_VehicleSpawner")


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

    local vehicleType, trailerType =
        Vanvival_VehicleSelector.choose(player, playersquare)

    return Vanvival_VehicleSpawner.spawn(
        player,
        square,
        vehicleType,
        trailerType
    )
end


return Vanvival_VehicleManager
