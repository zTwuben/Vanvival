local VanRegistries = require("VanRegistries")

local Vanvival_VehicleManager = require("Vanvival_VehicleManager")
local Vanvival_VehicleRegistry = require("Vanvival_VehicleRegistry")
local Vanvival_ZombieDecimator = require("Vanvival_ZombieDecimator")


local VanTraitsRegistry = VanRegistries.traits

local Vanvival_Client = {}

local function requestVehicleSpawn(player)
    if isClient() then
        -- Multiplayer: ask the server
        sendClientCommand(player, "Vanvival", "SpawnVehicle", {})
    else
        Vanvival_VehicleRegistry.populateValidVehicles()
        Vanvival_VehicleManager.spawnVehicle(player)

        -- Purge zombies
        Vanvival_ZombieDecimator:StartPurge()
    end
end

local function onPlayerCreated(playerIndex, player)
    if not player then return end

    local modData = player:getModData()

    if not SandboxVars.Vanvival.VehicleSpawnToggle then
        return
    end

    if player:hasTrait(VanTraitsRegistry.BicycleOwner)
        and getActivatedMods():contains("BicycleMod")
        and not modData.carSpawned then

        player:getInventory():AddItem("Bicycle.Bicycle")
        modData.carSpawned = true
        return
    end

    if not modData.carSpawned then
        if isClient() then
            -- Multiplayer: wait a bit for the server
            local ticks = 120

            local function delayedSpawn()
                ticks = ticks - 1

                if ticks <= 0 then
                    Events.OnTick.Remove(delayedSpawn)

                    requestVehicleSpawn(player)
                    modData.carSpawned = true
                end
            end

            Events.OnTick.Add(delayedSpawn)
        else
            -- Singleplayer: spawn immediately
            requestVehicleSpawn(player)
            modData.carSpawned = true
        end
    end
end

Events.OnCreatePlayer.Add(onPlayerCreated)

return Vanvival_Client