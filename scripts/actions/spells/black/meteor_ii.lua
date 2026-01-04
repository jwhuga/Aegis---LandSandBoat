-----------------------------------
-- Spell: Meteor II
-- Deals non-elemental damage to an enemy. (Upgraded animation)
-----------------------------------
---@type TSpell
local spellObject = {}

spellObject.onMagicCastingCheck = function(caster, target, spell)
    -- Blocks same way as Meteor for invalid cases
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
        dmg = ((100 + caster:getMod(xi.mod.MATT)) / (100 + target:getMod(xi.mod.MDEF)))
        * (caster:getStat(xi.mod.INT) + caster:getSkillLevel(xi.skill.ELEMENTAL_MAGIC) / 6) * 3.5
    elseif -- Behemoth family
        caster:getFamily() == 51 or
        caster:getFamily() == 479
    then
        dmg = 14 + caster:getMainLvl() * 30
    else
        dmg = ((100 + caster:getMod(xi.mod.MATT)) / (100 + target:getMod(xi.mod.MDEF)))
        * (caster:getStat(xi.mod.INT) + (caster:getMaxSkillLevel(caster:getMainLvl(), xi.job.BLM, xi.skill.ELEMENTAL_MAGIC)) / 6) * 9.4
    end

    -- Add in target adjustments
    dmg = dmg * xi.spells.damage.calculateNukeAbsorbOrNullify(target, spell:getElement())
    -- Add in final adjustments
    dmg = finalMagicAdjustments(caster, target, spell, dmg)
    return dmg
end

return spellObject