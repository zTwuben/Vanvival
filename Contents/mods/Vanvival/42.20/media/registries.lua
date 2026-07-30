---@class VanvivalRegistries
VanRegistries = VanRegistries or {}

---@type VanvivalTraitsRegistries
VanRegistries.traits = {
    VAN_SURVIVOR = CharacterTrait.register('vanvival:VanSurvivor'),
    RV_Owner = CharacterTrait.register('vanvival:RVOwner'),
    BicycleOwner = CharacterTrait.register('vanvival:BicycleOwner'),
}

---@type VanvivalProfessionsRegistries
VanRegistries.professions = {
    NOMAD = CharacterProfession.register('vanvival:Nomad'),
    TRUCKER = CharacterProfession.register('vanvival:Trucker'),
} 