-----------------------------------
-- Night Terror
-- Description: Deals Darkness-element magical damage (AoE). 
-- Characteristics:
-- * Does 40% more damage to targets that are asleep.
-- * Frequently used solo or against high-stat monsters.
-- Note: Created by Caeda on 2025-07-11
-----------------------------------
---@type TAbilityPet
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.summoner.canUseBloodPact(player, player:getPet(), target, ability)
end

abilityObject.onPetAbility = function(target, pet, petskill, summoner, action)
    xi.job_utils.summoner.onUseBloodPact(target, petskill, summoner, action)

    local baseDamage = 3000 + (pet:getStat(xi.mod.INT) - target:getStat(xi.mod.INT))
    local multiplier = 1.0

    -- Increase damage by 40% if target is asleep
    if target:hasStatusEffect(xi.effect.SLEEP) or target:hasStatusEffect(xi.effect.SLEEP_II) then
        multiplier = 1.4
    end

    local damage = baseDamage * multiplier

    damage = xi.mobskills.mobMagicalMove(pet, target, petskill, damage, xi.element.DARK, 4.0, xi.mobskills.magicalTpBonus.NO_EFFECT, 0)
    damage = xi.mobskills.mobAddBonuses(pet, target, damage, xi.element.DARK, petskill)
    damage = xi.summon.avatarFinalAdjustments(damage, pet, petskill, target, xi.attackType.MAGICAL, xi.damageType.DARK, 1)

    target:takeDamage(damage, pet, xi.attackType.MAGICAL, xi.damageType.DARK)
    target:updateEnmityFromDamage(pet, damage)

    return damage
end

return abilityObject
