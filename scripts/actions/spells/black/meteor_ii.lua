-----------------------------------
-- Spell: Meteor II
-- Deals Light-elemental damage (stronger than Meteor)
-----------------------------------
---@type TSpell
local spellObject = {}

spellObject.onMagicCastingCheck = function(caster, target, spell)
    -- No restrictions, always allow casting
    return 0
end

spellObject.onSpellCast = function(caster, target, spell)
    local dmg = 0

    if caster:isPC() then
        -- Stronger multiplier for players
        dmg = ((100 + caster:getMod(xi.mod.MATT)) / (100 + target:getMod(xi.mod.MDEF)))
            * (caster:getStat(xi.mod.INT) + caster:getSkillLevel(xi.skill.ELEMENTAL_MAGIC) / 6) * 5.5

    elseif caster:getFamily() == 51 or caster:getFamily() == 479 then
        -- Behemoth family: higher scaling
        dmg = 30 + caster:getMainLvl() * 45
    else
        -- Stronger multiplier for mobs
        dmg = ((100 + caster:getMod(xi.mod.MATT)) / (100 + target:getMod(xi.mod.MDEF)))
            * (caster:getStat(xi.mod.INT)
                + (caster:getMaxSkillLevel(caster:getMainLvl(), xi.job.BLM, xi.skill.ELEMENTAL_MAGIC)) / 6) * 13.5
    end

    -- Apply Light-element absorb/nullify
    dmg = dmg * xi.spells.damage.calculateNukeAbsorbOrNullify(target, spell:getElement())

    -- Apply resistances, buffs, and final adjustments
    dmg = finalMagicAdjustments(caster, target, spell, dmg)

    return dmg
end

return spellObject