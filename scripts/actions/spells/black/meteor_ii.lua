-----------------------------------
-- Spell: Meteor II
-- Deals Light-elemental damage to an enemy
-----------------------------------
---@type TSpell
local spellObject = {}

spellObject.onMagicCastingCheck = function(caster, target, spell)
    return 0
end

spellObject.onSpellCast = function(caster, target, spell)
    local params = {}
    params.attribute = xi.mod.INT
    params.bonus = 1.0
    params.diff = caster:getStat(xi.mod.INT) - target:getStat(xi.mod.INT)
    params.dmg = 1500 -- Base damage for Meteor II
    params.effect = nil
    params.hasMultipleTargetReduction = false
    params.multiplier = 3.5 -- Stronger than Impact
    params.resistBonus = 1.0
    params.skillType = xi.skill.ELEMENTAL_MAGIC

    -- Calculate resistance
    local resist = applyResistanceEffect(caster, target, spell, params)

    -- Calculate raw damage
    local dmg = calculateMagicDamage(caster, target, spell, params)

    -- Apply resistance
    dmg = dmg * resist

    -- Add bonuses (MAB, day/weather effects, etc.)
    dmg = addBonuses(caster, spell, target, dmg)

    -- Handle absorb/nullify for LIGHT element
    dmg = dmg * xi.spells.damage.calculateNukeAbsorbOrNullify(target, spell:getElement())

    -- Apply final adjustments (e.g. MDT, Stoneskin, etc.)
    dmg = finalMagicAdjustments(caster, target, spell, dmg)

    return dmg
end

return spellObject