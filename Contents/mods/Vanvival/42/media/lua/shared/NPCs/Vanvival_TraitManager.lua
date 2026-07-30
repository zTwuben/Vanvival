--[[
 _____  _    _  _   _ ______  _____  _   _      _    _   ___   _____      _   _  _____ ______  _____ 
|_   _|| |  | || | | || ___ \|  ___|| \ | |    | |  | | / _ \ /  ___|    | | | ||  ___|| ___ \|  ___|
  | |  | |  | || | | || |_/ /| |__  |  \| |    | |  | |/ /_\ \\ `--.     | |_| || |__  | |_/ /| |__  
  | |  | |/\| || | | || ___ \|  __| | . ` |    | |/\| ||  _  | `--. \    |  _  ||  __| |    / |  __| 
  | |  \  /\  /| |_| || |_/ /| |___ | |\  |    \  /\  /| | | |/\__/ /    | | | || |___ | |\ \ | |___ 
  \_/   \/  \/  \___/ \____/ \____/ \_| \_/     \/  \/ \_| |_/\____/     \_| |_/\____/ \_| \_|\____/ 
                                                                                                                                                                                               
--]]

local function AddCustomTraits()
    TraitFactory.addTrait(
    "VanSurvivor", 
    getText("UI_trait_VanSurvivor"),
    1, 
    getText("UI_trait_VanSurvivorDesc"),
    false, 
    false
    );

    TraitFactory.addTrait(
    "RVOwner", 
    getText("UI_trait_RVOwner"),
    1, 
    getText("UI_trait_RVOwnerDesc"),
    false,
    false
    );

    TraitFactory.addTrait(
    "BicycleOwner", 
    getText("UI_trait_BikeOwner"),
    1, 
    getText("UI_trait_BikeOwnerDesc"),
    false,
    false
    );

    TraitFactory.sortList();
end

local function AddCustomProfession()
    local Nomad = ProfessionFactory.addProfession(
        "Nomad",
        getText("UI_prof_Nomad"),
        "prof_Nomad",
        -4
    );
    
    local Trucker = ProfessionFactory.addProfession(
        "Trucker",
        getText("UI_prof_Trucker"),
        "prof_Trucker",
        -3
    );

    Nomad:addXPBoost(Perks.Mechanics, 2)
    Nomad:addXPBoost(Perks.Cooking, 1)
    Nomad:addXPBoost(Perks.Trapping, 1)
    Nomad:addXPBoost(Perks.Survivalist, 2)
    Nomad:addXPBoost(Perks.PlantScavenging, 1)
    Nomad:addXPBoost(Perks.Fitness, 1)
    Nomad:addFreeTrait("Mechanics2")

    Trucker:addXPBoost(Perks.Mechanics, 2)
    Trucker:addXPBoost(Perks.Fitness, 2)
    Trucker:addXPBoost(Perks.Strength, 1)
    Trucker:addXPBoost(Perks.Electricity, 1)



    local proflist = ProfessionFactory:getProfessions()

    for i = 1, proflist:size() do
        local profession = proflist:get(i - 1)
        BaseGameCharacterDetails.SetProfessionDescription(profession);
    end

end
Events.OnGameBoot.Add(AddCustomTraits);
Events.OnGameBoot.Add(AddCustomProfession);