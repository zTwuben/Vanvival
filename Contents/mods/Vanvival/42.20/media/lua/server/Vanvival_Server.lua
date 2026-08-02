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

        local modData = player:getModData()

        print("[Vanvival] carSpawned = " .. tostring(modData.carSpawned))

        if modData.carSpawned then
            print("[Vanvival] Vehicle already spawned.")
            return
        end

        print("[Vanvival] Spawning vehicle...")

        Vanvival_VehicleRegistry.populateValidVehicles()

        local vehicle = Vanvival_VehicleManager.spawnVehicle(player)

        if vehicle then
            local key = vehicle:createVehicleKey()

            print("[Vanvival] Server key = " .. tostring(key))

            if key then
                local item = player:getInventory():AddItem(key)

                print("[Vanvival] Added = " .. tostring(item))

                if item then
                    sendAddItemToContainer(player:getInventory(), item)
                    print("[Vanvival] Sent inventory update.")
                end
            end

            modData.carSpawned = true
            player:transmitModData()
            print("[Vanvival] Vehicle marked as spawned.")
        end
    end
end

Events.OnClientCommand.Add(onClientCommand)

local function onGameStart()
    print("[Vanvival] Server module loaded.")
end

Events.OnGameStart.Add(onGameStart)