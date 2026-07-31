local Vanvival_VehicleManager = require("Vanvival_VehicleManager")
local Vanvival_VehicleRegistry = require("Vanvival_VehicleRegistry")

print("[Vanvival] Registering OnClientCommand...")

local function onClientCommand(module, command, player, args)
    print("[Vanvival] OnClientCommand fired!")
    print("[Vanvival] Module = " .. tostring(module))
    print("[Vanvival] Command = " .. tostring(command))
    print("[Vanvival] Player = " .. tostring(player))

    if module == "Vanvival" and command == "SpawnVehicle" then
        print("[Vanvival] Spawning vehicle...")

        Vanvival_VehicleRegistry.populateValidVehicles()
        Vanvival_VehicleManager.spawnVehicle(player)

        local modData = player:getModData()
        modData.carSpawned = true
    end
end

Events.OnClientCommand.Add(onClientCommand)

local function onGameStart()
    print("[Vanvival] Server module loaded.")
end

Events.OnGameStart.Add(onGameStart)