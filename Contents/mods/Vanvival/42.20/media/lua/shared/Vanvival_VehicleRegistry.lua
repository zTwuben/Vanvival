local vehicles_list = require("VehiclesList")


local Vanvival_VehicleRegistry = {}


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


-- =====================================
-- Registry Data
-- =====================================

Vanvival_VehicleRegistry.validVehicles = {}

Vanvival_VehicleRegistry.validVans = {}
Vanvival_VehicleRegistry.validStepVans = {}
Vanvival_VehicleRegistry.validCamperRVs = {}
Vanvival_VehicleRegistry.validBigRVs = {}
Vanvival_VehicleRegistry.validBoxTrucks = {}
Vanvival_VehicleRegistry.validSemiTrucks = {}
Vanvival_VehicleRegistry.validBuses = {}
Vanvival_VehicleRegistry.validUtility = {}

Vanvival_VehicleRegistry.currentRVmod = nil

Vanvival_VehicleRegistry.validUtilityTrailers = {}
Vanvival_VehicleRegistry.validSemiTrailers = {}
Vanvival_VehicleRegistry.validCamperTrailers = {}


function Vanvival_VehicleRegistry.addCategory(source, destination)
    if not source then return end

    for _, vehicle in ipairs(source) do
        table.insert(destination, vehicle)
        table.insert(Vanvival_VehicleRegistry.validVehicles, vehicle)
    end
end

function Vanvival_VehicleRegistry.addTrailerCategory(source, destination)
	if not source then return end

	for _, trailer in ipairs(source) do
		table.insert(destination, trailer)
	end
end


function Vanvival_VehicleRegistry.populateValidVehicles()
Vanvival_VehicleRegistry.validVehicles = {}

Vanvival_VehicleRegistry.validVans = {}
Vanvival_VehicleRegistry.validStepVans = {}
Vanvival_VehicleRegistry.validCamperRVs = {}
Vanvival_VehicleRegistry.validBigRVs = {}
Vanvival_VehicleRegistry.validBoxTrucks = {}
Vanvival_VehicleRegistry.validSemiTrucks = {}
Vanvival_VehicleRegistry.validBuses = {}
Vanvival_VehicleRegistry.validUtility = {}

Vanvival_VehicleRegistry.validUtilityTrailers = {}
Vanvival_VehicleRegistry.validSemiTrailers = {}
Vanvival_VehicleRegistry.validCamperTrailers = {}

Vanvival_VehicleRegistry.currentRVmod = nil





	if getActivatedMods():contains("PROJECTRVInterior42") then
		Vanvival_VehicleRegistry.currentRVmod = "PRI"
	elseif getActivatedMods():contains("RVLife") then
		Vanvival_VehicleRegistry.currentRVmod = "RVL"
	end

	--Vehicles Modded
	for mod_name, vehicle_table in pairs(vehicles_list.vehicles.mods) do
        if getActivatedMods():contains(mod_name) then
			if vehicle_table.rvSupport == "both" or vehicle_table.rvSupport == Vanvival_VehicleRegistry.currentRVmod then
				local v = vehicle_table.vehicles

				Vanvival_VehicleRegistry.addCategory(v.vans,        Vanvival_VehicleRegistry.validVans)
				Vanvival_VehicleRegistry.addCategory(v.stepVans,    Vanvival_VehicleRegistry.validStepVans)
				Vanvival_VehicleRegistry.addCategory(v.camperRVs,   Vanvival_VehicleRegistry.validCamperRVs)
				Vanvival_VehicleRegistry.addCategory(v.bigRVs,      Vanvival_VehicleRegistry.validBigRVs)
				Vanvival_VehicleRegistry.addCategory(v.boxTrucks,   Vanvival_VehicleRegistry.validBoxTrucks)
				Vanvival_VehicleRegistry.addCategory(v.semiTrucks,  Vanvival_VehicleRegistry.validSemiTrucks)
				Vanvival_VehicleRegistry.addCategory(v.buses,       Vanvival_VehicleRegistry.validBuses)
				Vanvival_VehicleRegistry.addCategory(v.utility,     Vanvival_VehicleRegistry.validUtility)
			end
        end
    end

	-- Vanilla vehicles
	local v = vehicles_list.vehicles.vanilla

	Vanvival_VehicleRegistry.addCategory(v.vans,       Vanvival_VehicleRegistry.validVans)
	Vanvival_VehicleRegistry.addCategory(v.stepVans,   Vanvival_VehicleRegistry.validStepVans)
	Vanvival_VehicleRegistry.addCategory(v.camperRVs,  Vanvival_VehicleRegistry.validCamperRVs)
	Vanvival_VehicleRegistry.addCategory(v.bigRVs,     Vanvival_VehicleRegistry.validBigRVs)
	Vanvival_VehicleRegistry.addCategory(v.boxTrucks,  Vanvival_VehicleRegistry.validBoxTrucks)
	Vanvival_VehicleRegistry.addCategory(v.semiTrucks, Vanvival_VehicleRegistry.validSemiTrucks)
	Vanvival_VehicleRegistry.addCategory(v.buses,      Vanvival_VehicleRegistry.validBuses)
	Vanvival_VehicleRegistry.addCategory(v.utility,    Vanvival_VehicleRegistry.validUtility)

	-- Modded trailers
	for mod_name, trailer_table in pairs(vehicles_list.trailers.mods) do
		if getActivatedMods():contains(mod_name) then
			if trailer_table.rvSupport == "both" or trailer_table.rvSupport == Vanvival_VehicleRegistry.currentRVmod then
				local t = trailer_table.trailers

				Vanvival_VehicleRegistry.addTrailerCategory(t.utility,         Vanvival_VehicleRegistry.validUtilityTrailers)
				Vanvival_VehicleRegistry.addTrailerCategory(t.semi,            Vanvival_VehicleRegistry.validSemiTrailers)
				Vanvival_VehicleRegistry.addTrailerCategory(t.camperTrailers,  Vanvival_VehicleRegistry.validCamperTrailers)
			end
		end
	end

	-- Vanilla trailers
	local t = vehicles_list.trailers.vanilla

	Vanvival_VehicleRegistry.addTrailerCategory(t.utility,         Vanvival_VehicleRegistry.validUtilityTrailers)
	Vanvival_VehicleRegistry.addTrailerCategory(t.semi,            Vanvival_VehicleRegistry.validSemiTrailers)
	Vanvival_VehicleRegistry.addTrailerCategory(t.camperTrailers,  Vanvival_VehicleRegistry.validCamperTrailers)

	-- B42 AUTO-DISCOVERY: union every installed DRIVEABLE van/RV vehicle script on
	-- top of the whitelist above (dedup by full name). This is what makes ALL your
	-- van and RV mods usable, not just the few listed in VehiclesList.lua.
	local haveVehicle = {}
	for _, v in ipairs(Vanvival_VehicleRegistry.validVehicles) do haveVehicle[v] = true end

	local dVehicles, _, dTrailers = VNV_discover()
	for full in pairs(dVehicles) do
		if not haveVehicle[full] then
			haveVehicle[full] = true
			table.insert(Vanvival_VehicleRegistry.validVehicles, full)
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
    "[Vanvival] Vehicles: " .. #Vanvival_VehicleRegistry.validVehicles ..
    " | Utility trailers: " .. #Vanvival_VehicleRegistry.validUtilityTrailers ..
    " | Semi trailers: " .. #Vanvival_VehicleRegistry.validSemiTrailers ..
    " | Camper trailers: " .. #Vanvival_VehicleRegistry.validCamperTrailers
)

print("Vans:", #Vanvival_VehicleRegistry.validVans)
print("Step Vans:", #Vanvival_VehicleRegistry.validStepVans)
print("Camper RVs:", #Vanvival_VehicleRegistry.validCamperRVs)
print("Big RVs:", #Vanvival_VehicleRegistry.validBigRVs)
print("Box Trucks:", #Vanvival_VehicleRegistry.validBoxTrucks)
print("Semi Trucks:", #Vanvival_VehicleRegistry.validSemiTrucks)
print("Buses:", #Vanvival_VehicleRegistry.validBuses)
print("Utility:", #Vanvival_VehicleRegistry.validUtility)

print("Utility Trailers:", #Vanvival_VehicleRegistry.validUtilityTrailers)
print("Semi Trailers:", #Vanvival_VehicleRegistry.validSemiTrailers)
print("Camper Trailers:", #Vanvival_VehicleRegistry.validCamperTrailers)



function Vanvival_VehicleRegistry.getRandVehicle()
    return Vanvival_VehicleRegistry.validVehicles[
        ZombRand(#Vanvival_VehicleRegistry.validVehicles) + 1
    ]
end

function Vanvival_VehicleRegistry.getRandTrailer()
    return Vanvival_VehicleRegistry.validUtilityTrailers[
        ZombRand(#Vanvival_VehicleRegistry.validUtilityTrailers) + 1
    ]
end



end



return Vanvival_VehicleRegistry