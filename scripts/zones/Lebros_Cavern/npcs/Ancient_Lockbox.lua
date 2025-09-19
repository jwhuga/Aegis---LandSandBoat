-----------------------------------
-- Area: Lebros Cavern
-- Ancient Lockbox
-----------------------------------
---@type TNpcEntity
local entity = {}

entity.onTrigger = function(player, npc)
    local qItem =
    {
        [xi.assault.mission.EXCAVATION_DUTY] =
        {
            {
                { item = xi.item.UNAPPRAISED_BOX,     weight = 300 },
                { item = xi.item.UNAPPRAISED_EARRING, weight = 700 },
            },
        },

        [xi.assault.mission.LEBROS_SUPPLIES] =
        {
            {
                { item = xi.item.UNAPPRAISED_BOX,  weight = 300 },
                { item = xi.item.UNAPPRAISED_CAPE, weight = 700 },
            },
        },

        [xi.assault.mission.TROLL_FUGITIVES] =
        {
            {
                { item = xi.item.UNAPPRAISED_AXE,       weight = 300 },
                { item = xi.item.UNAPPRAISED_POLEARM,   weight = 200 },
                { item = xi.item.UNAPPRAISED_HEADPIECE, weight = 100 },
                { item = xi.item.UNAPPRAISED_BOX,       weight = 400 },
            },
        },
    }

    local regItem =
    {
        [xi.assault.mission.EXCAVATION_DUTY] =
        {
            {
                { item = xi.item.REMEDY, weight = 900 },
                { item = 0,               weight = 100 },
            },

            {
                { item = xi.item.REMEDY, weight = 200 },
                { item = 0,               weight = 800 },
            },

            {
                { item = xi.item.HI_POTION_P3, weight = 400 },
                { item = 0,                    weight = 600 },
            },

            {
                { item = xi.item.HI_POTION_P3, weight = 200 },
                { item = 0,                      weight = 800 },
            },
        },

        [xi.assault.mission.LEBROS_SUPPLIES] =
        {
            {
                { item = xi.item.REMEDY, weight = 800 },
                { item = 0,               weight = 200 },
            },

            {
                { item = xi.item.RERAISER, weight = 200 },
                { item = 0,                 weight = 800 },
            },

            {
                { item = xi.item.HI_POTION_TANK, weight = 100 },
                { item = 0,                       weight = 900 },
            },
        },

        [xi.assault.mission.TROLL_FUGITIVES] =
        {
            {
                { item = xi.item.HI_POTION_P3, weight = 800 },
                { item = 0,                      weight = 200 },
            },

            {
                { item = xi.item.RERAISER, weight = 200 },
                { item = 0,                 weight = 800 },
            },

            {
                { item = xi.item.HI_POTION_TANK, weight = 100 },
                { item = 0,                       weight = 900 },
            },

            {
                { item = xi.item.HI_ETHER_TANK, weight = 100 },
                { item = 0,                      weight = 900 },
            },
        },
    }

    local area = player:getCurrentAssault()
    xi.appraisal.assaultChestTrigger(player, npc, qItem[area], regItem[area])
end

return entity
