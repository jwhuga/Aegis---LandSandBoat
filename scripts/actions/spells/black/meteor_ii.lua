-----------------------------------
-- Spell: Meteor II
-- Deals non-elemental damage to an enemy (stronger than Meteor).
-----------------------------------
---@type TSpell
local spellObject = {}

spellObject.onMagicCastingCheck = function(caster, target, spell)
    -- Same restriction logic as Meteor
    if caster:isMob() then
        return 0
    elseif caster:hasStatusEffect(xi.effect.ELEMENTAL_SEAL) then
        return 0
    else
        return xi.msg.basic.STATUS_PREVENTS
    end
end

spellObject.onSpellCast = function(caster, target, spell)
    local dmg = 0

    if caster:isPC() then
        -- Enhanced multiplier for Meteor II
        dmg = ((100 + caster:getMod(xi.mod.MATT)) / (100 + target:getMod(xi.mod.MDEF))) 
            * (caster:getStat(xi.mod.INT) + caster:getSkillLevel(xi.skill.ELEMENTAL_MAGIC) / 6) * 5.0

    elseif -- Behemoth family (Family IDs 51 and 479)
        caster:getFamily() == 51 or
        caster:getFamily() == 479
    then
        -- Stronger Behemoth family scaling
        dmg = 20 + caster:getMainLvl() * 40

    else
        -- Enhanced multiplier for mobs
        dmg = ((10000 + caster:getMod(xi.mod.MATT)) / (100 + target:getMod(xi.mod.MDEF))) 
            * (caster:getStat(xi.mod.INT) + (caster:getMaxSkillLevel(caster:getMainLvl(), xi.job.BLM, xi.skill.ELEMENTAL_MAGIC)) / 6) * 12.0
    end

    -- Add in target adjustment
    dmg = dmg * xi.spells.damage.calculateNukeAbsorbOrNullify(target, spell:getElement())

    -- Add in final adjustments
    dmg = finalMagicAdjustments(caster, target, spell, dmg)

    return dmg
end

return spellObject