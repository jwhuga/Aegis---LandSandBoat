-----------------------------------
-- Extremely Bad Breath
-- Description : A horrific case of halitosis instantly K.O.'s any players in a fan-shaped area of effect.
-- Family: Morbol
-- Type: Breath
-- Range: 12' AoE
-- Utsusemi/Blink absorb: Ignores shadows
-- Notes: Only used by Evil Oscar, Cirrate Christelle, Lividroot Amooshah, Eccentric Eve, Deranged Ameretat, and Melancholic Moira.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

-- TODO: Death resistance check
mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    skill:setMsg(xi.msg.basic.FALL_TO_GROUND)
    target:setHP(0)
    return 0
end

return mobskillObject
