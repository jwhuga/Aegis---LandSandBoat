-----------------------------------
-- Pavor Nocturnus
-- Blood Pact: Ward
-- Attempts to instantly KO the target. If it fails, deals darkness-based damage.
-- Ineffective against undead and notorious monsters.
-- Created by Caeda on 2025-07-09
-----------------------------------
---@type TAbilityPet
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.summoner.canUseBloodPact(player, player:getPet(), target, ability)
end

abilityObject.onPetAbility = function(target, pet, petskill, summoner, action)
    xi.job_utils.summoner.onUseBloodPact(target, petskill, summoner, action)

    local damage = 0
    local instaDeath = false

    -- Check for instant KO: not undead, not NM, not magic shielded
    if not target:isUndead() and not target:isNM() and not target:hasStatusEffect(xi.effect.MAGIC_SHIELD) then
        local resistRate = xi.combat.magicHitRate.calculateResistRate(
            pet, target,
            xi.magic.spellGroup.BLACK,
            xi.skill.DARK_MAGIC,
            0, xi.element.DARK, 0, 0, 0
        )

        if resistRate == 1 then
            instaDeath = true
        end
    end

    if instaDeath then
        target:setHP(0)
        damage = 0
    else
        -- Fallback: Darkness-based magic damage if death fails
        damage = math.floor(325 + 0.025 * pet:getTP() + (pet:getStat(xi.mod.INT) - target:getStat(xi.mod.INT)) * 1.5)
        damage = xi.mobskills.mobMagicalMove(pet, target, petskill, damage, xi.element.DARK, 1, xi.mobskills.magicalTpBonus.NO_EFFECT, 0)
        damage = xi.mobskills.mobAddBonuses(pet, target, damage, xi.element.DARK, petskill)
        damage = xi.summon.avatarFinalAdjustments(damage, pet, petskill, target, xi.attackType.MAGICAL, xi.damageType.DARK, 1)

        target:takeDamage(damage, pet, xi.attackType.MAGICAL, xi.damageType.DARK)
    end

    target:updateEnmityFromDamage(pet, damage)

    return damage
end

return abilityObject
