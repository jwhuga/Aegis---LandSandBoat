-----------------------------------
-- Area: Ru'Aun Gardens
--   NM: Byakko
-----------------------------------
local ID = zones[xi.zone.RUAUN_GARDENS]
mixins = { require('scripts/mixins/job_special') }
-----------------------------------
---@type TMobEntity
local entity = {}

entity.onMobInitialize = function(mob)
    mob:setMobMod(xi.mobMod.ADD_EFFECT, 1)
    mob:setMobMod(xi.mobMod.IDLE_DESPAWN, 300)
    mob:setMobMod(xi.mobMod.GIL_MIN, 18000)
    mob:setMobMod(xi.mobMod.GIL_MAX, 18000)
    mob:setMobMod(xi.mobMod.WEAPON_BONUS, 32)
    mob:setMod(xi.mod.DOUBLE_ATTACK, 10)
    mob:setMod(xi.mod.VIT, 125)
end

entity.onMobSpawn = function(mob)
    mob:messageText(mob, ID.text.SKY_GOD_OFFSET + 11) -- Spawn message
    GetNPCByID(ID.npc.PORTAL_OFFSET + 8):setAnimation(xi.anim.CLOSE_DOOR)

    -- Sky gods wait 10 seconds after spawning to start casting
    mob:setMagicCastingEnabled(false)
    mob:timer(10000, function(mobArg)
        if mobArg then
            mobArg:setMagicCastingEnabled(true)
        end
    end)
end

entity.onAdditionalEffect = function(mob, target, damage)
    return xi.mob.onAddEffect(mob, target, damage, xi.mob.ae.ENLIGHT)
end

entity.onMobDeath = function(mob, player, optParams)
    player:showText(mob, ID.text.SKY_GOD_OFFSET + 12)
    GetNPCByID(ID.npc.PORTAL_OFFSET + 8):setAnimation(xi.anim.OPEN_DOOR)
end

entity.onMobDespawn = function(mob)
    GetNPCByID(ID.npc.PORTAL_OFFSET + 8):setAnimation(xi.anim.OPEN_DOOR)
end

return entity
