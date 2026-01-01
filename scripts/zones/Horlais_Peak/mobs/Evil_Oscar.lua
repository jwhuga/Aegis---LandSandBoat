-----------------------------------
-- Area: Horlais Peak
--  Mob: Evil Oscar
-- KSNM30: Contaminated Colliseum
-----------------------------------
local ID = zones[xi.zone.HORLAIS_PEAK]
-----------------------------------
---@type TMobEntity
local entity = {}

-- { Phase HP%, First Inhale Delay, Interval Delay }
local breathTimers =
{
    [1] = {  30, 10,  4 },
    [2] = {  40, 12,  6 },
    [3] = {  50, 14,  8 },
    [4] = {  60, 16, 10 },
    [5] = {  70, 18, 12 },
    [6] = {  80, 20, 14 },
    [7] = {  90, 22, 16 },
    [8] = {  99, 24, 18 },
    [9] = { 100, 26, 20 },
}

local function sendInhaleMessage(players)
    for _, player in pairs(players) do
        player:messageSpecial(ID.text.EVIL_OSCAR_BEGINS_FILLING)
    end
end

local function setupPhase(mob, phase)
    mob:setLocalVar('currentPhase', phase)
    mob:setLocalVar('firstDelay', breathTimers[phase][2])
    mob:setLocalVar('intervalDelay', breathTimers[phase][3])
end

entity.onMobInitialize = function(mob)
    mob:setMobMod(xi.mobMod.ADD_EFFECT, 1)
    mob:addImmunity(xi.immunity.LIGHT_SLEEP)
    mob:addImmunity(xi.immunity.DARK_SLEEP)
    mob:addImmunity(xi.immunity.PARALYZE)
    mob:addImmunity(xi.immunity.PETRIFY)
    mob:addImmunity(xi.immunity.STUN)
    mob:addImmunity(xi.immunity.TERROR)
    mob:setMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER, 150)
end

entity.onMobSpawn = function(mob)
    mob:setMod(xi.mod.DOUBLE_ATTACK, 65)
    mob:addListener('WEAPONSKILL_STATE_EXIT', 'EXTREMELY_BAD_BREATH_ATTEMPTED', function(mobArg, skillId)
        if skillId == xi.mobSkill.EXTREMELY_BAD_BREATH_1 then
        -- If we have readied Extremely Bad Breath, kick off the next cycle
        local firstDelay = mobArg:getLocalVar('firstDelay')

        mobArg:setLocalVar('inhaleCount', 0)
        mobArg:setLocalVar('nextInhaleTime', GetSystemTime() + firstDelay)
        end
    end)
end

entity.onMobEngage = function(mob, target)
    setupPhase(mob, 9) -- Start at phase 9 (100% HP)
    mob:setLocalVar('inhaleCount', 0)
    mob:setLocalVar('nextInhaleTime', GetSystemTime() + 15) -- First inhale is 15 seconds after engaging
end

entity.onMobFight = function(mob, target)
    if xi.combat.behavior.isEntityBusy(mob) then
        return
    end

    local currentPhase = mob:getLocalVar('currentPhase')

    -- Check for phase transition based off of HP Percent, if so, call setPhase to update intervals - if were in the last phase, skip this
    if currentPhase > 1 then
        local mobHPP   = mob:getHPP()
        local phaseHPP = breathTimers[currentPhase][1]

        -- If we dropped below the next HP threshold, go to the next phase and update timers
        if mobHPP < phaseHPP then
            currentPhase = currentPhase - 1
            setupPhase(mob, currentPhase)
        end
    end

    local inhaleCount = mob:getLocalVar('inhaleCount')

    -- If inhale count is less than 3, check to see if it's time to inhale again
    if inhaleCount < 3 then
        local currentTime = GetSystemTime()
        local nextInhaleTime = mob:getLocalVar('nextInhaleTime')

        -- If its not time yet, return
        if currentTime < nextInhaleTime then
            return
        end

        -- It's time to inhale, send message to players in battlefield regardless of distance and increment inhale count
        local battlefield = mob:getBattlefield()
        if battlefield then
            sendInhaleMessage(battlefield:getPlayers())
        end

        inhaleCount = inhaleCount + 1
        mob:setLocalVar('inhaleCount', inhaleCount)

        if inhaleCount < 3 then
            local intervalDelay = mob:getLocalVar('intervalDelay')
            mob:setLocalVar('nextInhaleTime', currentTime + intervalDelay)
        else
            mob:setLocalVar('nextInhaleTime', 0)
        end
    end

    -- If we've inhaled 3 times, use Extremely Bad Breath when the target is in range and not busy
    if
        inhaleCount >= 3 and
        mob:checkDistance(target) <= 10
    then
        mob:useMobAbility(xi.mobSkill.EXTREMELY_BAD_BREATH_1)
    end
end

entity.onAdditionalEffect = function(mob, target, damage)
    return xi.mob.onAddEffect(mob, target, damage, xi.mob.ae.WEIGHT, { chance = 10, power = 75 })
end

return entity
