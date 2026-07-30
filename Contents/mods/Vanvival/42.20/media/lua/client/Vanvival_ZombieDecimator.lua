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
                                            
    Build 42.19 compatibility fix (overrides Vanvival's Vanvival_ZombieDecimator.lua
    by identical relative path, loaded after Vanvival). The starting-zone zombie purge
    crashed every tick with "Object tried to call nil in clearZombiesAroundPlayer":
    getCell():getObjectList() returns a Java Set in B42 (size() but no get(index)).
    Only that one accessor is changed (-> getObjectListForLua()); the rest is verbatim.
--]]

Vanvival_ZombieDecimator = {}
Vanvival_ZombieDecimator .__index = Vanvival_ZombieDecimator 

-- Store purge state
Vanvival_ZombieDecimator.purgeCounter = 0
Vanvival_ZombieDecimator.runPurgeTick = nil

local function calcDistance(entity1, entity2)
    if not entity1 or not entity2 then return -1 end

    local x1, y1 = entity1:getX(), entity1:getY()
    local x2, y2 = entity2:getX(), entity2:getY()

    local deltaX = x1 - x2
    local deltaY = y1 - y2

    return math.sqrt(deltaX * deltaX + deltaY * deltaY)
end

local function clearZombiesAroundPlayer()
    local player = getPlayer()
    if not player then return end

    -- B42.19 fix: getObjectList() returns a Java Set (size() but no get(index), and is
    -- not the Lua-facing accessor) which made objects:get(i) call nil. The @UsedFromLua
    -- method getObjectListForLua() returns a List with get(i). (Kriz999)
    local objects = player:getCell():getObjectListForLua()
    local maxDistance = SandboxVars.Vanvival.PurgeRadius or 20

    if objects then
        for i = objects:size() - 1, 0, -1 do
            local obj = objects:get(i)
            if obj and obj ~= player and instanceof(obj, "IsoZombie") then
                local dist = calcDistance(player, obj)
                if dist <= maxDistance then
                    obj:removeFromWorld()
                    obj:removeFromSquare()
                end
            end
        end
    end
end


Vanvival_ZombieDecimator.runPurgeTick = function()
    if Vanvival_ZombieDecimator.purgeCounter <= 0 then
        Events.OnTick.Remove(Vanvival_ZombieDecimator.runPurgeTick)
        return
    end

    Vanvival_ZombieDecimator.purgeCounter = Vanvival_ZombieDecimator.purgeCounter - 1

    if Vanvival_ZombieDecimator.purgeCounter % 10 == 0 then
        clearZombiesAroundPlayer()
    end
end

function Vanvival_ZombieDecimator:StartPurge()
    if SandboxVars.Vanvival.PurgeOnSpawn then
        Vanvival_ZombieDecimator.purgeCounter = 100
        Events.OnTick.Add(Vanvival_ZombieDecimator.runPurgeTick)
    end
end