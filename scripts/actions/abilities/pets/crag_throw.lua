-----------------------------------
-- Crag Throw
-- Earth-based physical AoE with Slow
-- Final-tier Titan Blood Pact
-- Created by Caeda on 2025-06-08
-----------------------------------
---@type TAbilityPet
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.summoner.canUseBloodPact(player, player:getPet(), target, ability)
end

abilityObject.onPetAbility = function(target, pet, petskill, summoner, action)
    xi.job_utils.summoner.onUseBloodPact(target, petskill, summoner, action)

    local numhits = 1
    local accmod = 1.0
    local dmgmod = 13.0

    local damage = xi.summon.avatarPhysicalMove(
        pet, target, petskill,
        numhits, accmod, dmgmod,
        0,
        xi.mobskills.magicalTpBonus.NO_EFFECT,
        1, 2, 3
    )

    damage = xi.summon.avatarFinalAdjustments(
        damage.dmg,
        pet, petskill, target,
        xi.attackType.PHYSICAL,
        xi.damageType.EARTH,
        numhits
    )

    target:takeDamage(damage, pet, xi.attackType.PHYSICAL, xi.damageType.EARTH)
    target:updateEnmityFromDamage(pet, damage)

    -- Apply Slow to affected target
    target:addStatusEffect(xi.effect.SLOW, 2500, 0, 60)

    return damage
end

return abilityObject
