-----------------------------------
-- Blood Pact: Lunar Bay
-- Deals darkness-elemental magic damage to enemies in range.
-- Created by Caeda on 2025-06-09
-----------------------------------

---@type TAbilityPet
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.summoner.canUseBloodPact(player, player:getPet(), target, ability)
end

abilityObject.onPetAbility = function(target, pet, petskill, summoner, action)
    xi.job_utils.summoner.onUseBloodPact(target, petskill, summoner, action)

    local damage = 300 + (pet:getStat(xi.mod.INT) - target:getStat(xi.mod.INT))
    
    -- Apply standard bonuses (MAB, day/weather, etc.)
    damage = xi.mobskills.mobMagicalMove(pet, target, petskill, damage, xi.element.DARK, 1, xi.mobskills.magicalTpBonus.NO_EFFECT, 0)
    damage = xi.mobskills.mobAddBonuses(pet, target, damage, xi.element.DARK, petskill)
    damage = xi.summon.avatarFinalAdjustments(damage, pet, petskill, target, xi.attackType.MAGICAL, xi.damageType.DARK, 1)

    target:takeDamage(damage, pet, xi.attackType.MAGICAL, xi.damageType.DARK)
    target:updateEnmityFromDamage(pet, damage)

    return damage
end

return abilityObject
