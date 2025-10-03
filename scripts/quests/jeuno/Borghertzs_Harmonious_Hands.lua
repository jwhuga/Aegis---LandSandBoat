-----------------------------------
-- Borghertz's Harmonious Hands
-----------------------------------
-- Log ID: 3, Quest ID: 53
-- Torch         : !pos  63 -24  21 161
-- Guslam        : !pos  -5   1  48 244
-- Deadly Minnow : !pos  -5   1  48 244
-- Yin Pocanakhu : !pos  35   4 -43 245
-- qm1           : !pos -51   8  -4 246
-----------------------------------
local zvahlID = zones[xi.zone.CASTLE_ZVAHL_BAILEYS]
-----------------------------------

local quest = Quest:new(xi.questLog.JEUNO, xi.quest.id.jeuno.BORGHERTZS_HARMONIOUS_HANDS)

local otherBorghertzQuests =
{
    xi.quest.id.jeuno.BORGHERTZS_WARRING_HANDS,
    xi.quest.id.jeuno.BORGHERTZS_STRIKING_HANDS,
    xi.quest.id.jeuno.BORGHERTZS_HEALING_HANDS,
    xi.quest.id.jeuno.BORGHERTZS_SORCEROUS_HANDS,
    xi.quest.id.jeuno.BORGHERTZS_VERMILLION_HANDS,
    xi.quest.id.jeuno.BORGHERTZS_SNEAKY_HANDS,
    xi.quest.id.jeuno.BORGHERTZS_STALWART_HANDS,
    xi.quest.id.jeuno.BORGHERTZS_SHADOWY_HANDS,
    xi.quest.id.jeuno.BORGHERTZS_WILD_HANDS,
--    xi.quest.id.jeuno.BORGHERTZS_HARMONIOUS_HANDS,
    xi.quest.id.jeuno.BORGHERTZS_CHASING_HANDS,
    xi.quest.id.jeuno.BORGHERTZS_LOYAL_HANDS,
    xi.quest.id.jeuno.BORGHERTZS_LURKING_HANDS,
    xi.quest.id.jeuno.BORGHERTZS_DRAGON_HANDS,
    xi.quest.id.jeuno.BORGHERTZS_CALLING_HANDS,
}

local function canStartQuest(player)
    -- Previous quest check.
    if player:getQuestStatus(xi.questLog.JEUNO, xi.quest.id.jeuno.THE_REQUIEM) == xi.questStatus.QUEST_AVAILABLE then
        return false
    end

    -- Job check.
    if player:getMainJob() ~= xi.job.BRD then
        return false
    end

    -- Level check.
    if player:getMainLvl() < 50 then
        return false
    end

    -- Any other Borghertz quest check.
    for i = 1, #otherBorghertzQuests do
        if player:getQuestStatus(xi.questLog.JEUNO, otherBorghertzQuests[i]) == xi.questStatus.QUEST_ACCEPTED then
            return false
        end
    end

    return true
end

local function isFirstBorghertzQuest(player)
    for i = 1, #otherBorghertzQuests do
        if player:getQuestStatus(xi.questLog.JEUNO, otherBorghertzQuests[i]) == xi.questStatus.QUEST_COMPLETED then
            return false
        end
    end

    return true
end

quest.reward =
{
    item = xi.item.CHORAL_CUFFS,
}

quest.sections =
{
    {
        check = function(player, status, vars)
            return status == xi.questStatus.QUEST_AVAILABLE
        end,

        [xi.zone.UPPER_JEUNO] =
        {
            ['Guslam'] =
            {
                onTrigger = function(player, npc)
                    if canStartQuest(player) then
                        return quest:progressEvent(155)
                    end
                end,

            },

            onEventFinish =
            {
                [155] = function(player, csid, option, npc)
                    quest:begin(player)
                end,
            },
        },
    },

    {
        check = function(player, status, vars)
            return status == xi.questStatus.QUEST_ACCEPTED
        end,

        [xi.zone.CASTLE_ZVAHL_BAILEYS] =
        {
            ['Dark_Spark'] =
            {
                onMobDeath = function(mob, player, optParams)
                    if quest:getVar(player, 'Prog') == 4 then
                        quest:setVar(player, 'Prog', 5)
                    end
                end,
            },

            ['Torch'] =
            {
                onTrigger = function(player, npc)
                    local questProgress = quest:getVar(player, 'Prog')

                    if
                        questProgress == 4 and
                        npcUtil.popFromQM(player, npc, zvahlID.mob.DARK_SPARK, { claim = true, hide = 0 })
                    then
                        return quest:messageSpecial(zvahlID.text.SENSE_OF_FOREBODING)
                    elseif
                        questProgress == 5 and
                        not player:hasKeyItem(xi.keyItem.SHADOW_FLAMES)
                    then
                        npcUtil.giveKeyItem(player, xi.keyItem.SHADOW_FLAMES)
                        return quest:noAction()
                    end
                end,
            },
        },

        [xi.zone.LOWER_JEUNO] =
        {
            ['Yin_Pocanakhu'] =
            {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 2 then
                        return quest:progressEvent(220)
                    end
                end,

            },

            onEventUpdate =
            {
                [220] = function(player, csid, option, npc)
                    if player:getGil() >= 1000 then
                        player:delGil(1000)
                        quest:setVar(player, 'Prog', 3) -- Spoken with Yin Pocanakhu.
                        player:updateEvent(1)
                    end
                end,
            },
        },

        [xi.zone.PORT_JEUNO] =
        {
            ['qm1'] =
            {
                onTrigger = function(player, npc)
                    local questProgress = quest:getVar(player, 'Prog')

                    if questProgress == 3 then
                        return quest:progressEvent(20)
                    elseif questProgress >= 4 and not player:hasKeyItem(xi.keyItem.SHADOW_FLAMES) then
                        return quest:event(49)
                    elseif questProgress == 5 and player:hasKeyItem(xi.keyItem.SHADOW_FLAMES) then
                        return quest:progressEvent(48)
                    end
                end,

            },

            onEventFinish =
            {
                [20] = function(player, csid, option, npc)
                    if option == 1 then
                        quest:setVar(player, 'Prog', 4) -- Spoken with Borghertz. Requested "Shadow Flames".
                    end
                end,

                [48] = function(player, csid, option, npc)
                    if quest:complete(player) then
                        player:delKeyItem(xi.keyItem.OLD_GAUNTLETS)
                        player:delKeyItem(xi.keyItem.SHADOW_FLAMES)
                    end
                end,
            },
        },

        [xi.zone.UPPER_JEUNO] =
        {
            ['Deadly_Minnow'] =
            {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 1 then
                        return quest:progressEvent(24)
                    end
                end,

            },

            ['Guslam'] =
            {
                onTrigger = function(player, npc)
                    if player:hasKeyItem(xi.keyItem.OLD_GAUNTLETS) then
                        return quest:progressEvent(26)
                    else
                        return quest:event(43)
                    end
                end,

            },

            onEventFinish =
            {
                [24] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 2) -- Spoken with deadly Minnow.
                end,

                [26] = function(player, csid, option, npc)
                    if quest:getVar(player, 'Prog') == 0 then
                        if isFirstBorghertzQuest(player) then
                            quest:setVar(player, 'Prog', 1) -- Speak with Deadly Minnow and Yin Pocanakhu.
                        else
                            quest:setVar(player, 'Prog', 3) -- Skip intermediaries.
                        end
                    end
                end,
            },
        },

        -- Old gauntlets coffer logic.
        [xi.zone.CASTLE_ZVAHL_BAILEYS] =
        {
            ['Treasure_Coffer'] =
            {
                onTrade = function(player, npc, trade)
                    if not player:hasKeyItem(xi.keyItem.OLD_GAUNTLETS) then
                        xi.treasure.onTrade(player, npc, trade, 2, xi.keyItem.OLD_GAUNTLETS)

                        return quest:noAction()
                    end
                end,
            },
        },
    },

    {
        check = function(player, status, vars)
            return status ~= xi.questStatus.QUEST_AVAILABLE and
                player:getMainJob() == xi.job.BRD
        end,

        [xi.zone.CASTLE_OZTROJA] =
        {
            ['Treasure_Coffer'] =
            {
                onTrade = function(player, npc, trade)
                    if not player:hasItem(xi.item.CHORAL_CANNIONS) then
                        xi.treasure.onTrade(player, npc, trade, 1, xi.item.CHORAL_CANNIONS)

                        return quest:noAction()
                    end
                end,
            },
        },

        [xi.zone.CRAWLERS_NEST] =
        {
            ['Treasure_Coffer'] =
            {
                onTrade = function(player, npc, trade)
                    if not player:hasItem(xi.item.CHORAL_ROUNDLET) then
                        xi.treasure.onTrade(player, npc, trade, 1, xi.item.CHORAL_ROUNDLET)

                        return quest:noAction()
                    end
                end,
            },
        },
    },
}

return quest
