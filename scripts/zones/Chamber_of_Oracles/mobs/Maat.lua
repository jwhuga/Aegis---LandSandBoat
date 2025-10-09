-----------------------------------
-- Area: Chamber of Oracles
--  Mob: Maat
-- Genkai 5 Fight
-----------------------------------
mixins = { require('scripts/mixins/families/maat') }
-----------------------------------
---@type TMobEntity
local entity = {}

entity.onMobInitialize = function(mob)
    xi.pet.setMobPet(mob, 1, 'Maats_Wyvern')
end

entity.onMobFight = function(mob, target)
    -- TODO is this necessary? pets automatically assist their master in roam ticks
    local mobId = mob:getID()
    local pet   = GetMobByID(mobId + 1)

    if
        pet and
        pet:isSpawned() and
        pet:getCurrentAction() == xi.action.ROAMING
    then
        pet:updateEnmity(target)
    end
end

entity.onMobDeath = function(mob, player, optParams)
end

return entity
