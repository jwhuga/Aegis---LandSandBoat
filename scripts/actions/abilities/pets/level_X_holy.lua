-----------------------------------
-- Level X Holy
-----------------------------------
---@type TAbilityPet
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.summoner.canUseBloodPact(player, player:getPet(), target, ability)
end

abilityObject.onPetAbility = function(target, pet, petskill, summoner, action)
    xi.job_utils.summoner.onUseBloodPact(target, petskill, summoner, action)
    local damage            = 0
    local holyRollOneAnimID = 164
    local primaryTargetID   = action:getPrimaryTargetID()

    -- Roll animation for primary target, propagate to others
    if primaryTargetID == target:getID() then
        action:setAnimation(primaryTargetID, holyRollOneAnimID + math.random(0, 5))
    else
        local animationId = action:getAnimation(primaryTargetID)
        if animationId then
            action:setAnimation(target:getID(), animationId)
        end
    end

    local power = action:getAnimation(target:getID()) - 163 -- 1–6

    -- New damage formula using power as multiplier
    damage = math.floor((2325 + 0.025 * pet:getTP() + (pet:getStat(xi.mod.MND) - target:getStat(xi.mod.MND)) * 1.5) * power)

    damage = xi.mobskills.mobMagicalMove(pet, target, petskill, damage, xi.element.LIGHT, 1, xi.mobskills.magicalTpBonus.NO_EFFECT, 0)
    damage = xi.mobskills.mobAddBonuses(pet, target, damage, xi.element.LIGHT, petskill)
    damage = xi.summon.avatarFinalAdjustments(damage, pet, petskill, target, xi.attackType.MAGICAL, xi.damageType.LIGHT, 1)

    target:takeDamage(damage, pet, xi.attackType.MAGICAL, xi.damageType.LIGHT)
    target:updateEnmityFromDamage(pet, damage)

    return damage
end

return abilityObject
