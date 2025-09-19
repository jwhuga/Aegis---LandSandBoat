-----------------------------------
-- Area: Periqia
-- Ancient Lockbox
-----------------------------------
---@type TNpcEntity
local entity = {}

entity.onTrigger = function(player, npc)
    local qItem =
    {
        [xi.assault.mission.SEAGULL_GROUNDED] =
        {
            {
                { item = xi.item.UNAPPRAISED_BOX,     weight = 400 },
                { item = xi.item.UNAPPRAISED_SWORD,   weight = 200 },
                { item = xi.item.UNAPPRAISED_POLEARM, weight = 200 },
                { item = xi.item.UNAPPRAISED_GLOVES,  weight = 200 },
            },
        },

        [xi.assault.mission.REQUIEM] =
        {
            {
                { item = xi.item.UNAPPRAISED_BOX,     weight = 400 },
                { item = xi.item.UNAPPRAISED_GLOVES,  weight = 200 },
                { item = xi.item.UNAPPRAISED_POLEARM, weight = 200 },
                { item = xi.item.UNAPPRAISED_AXE,     weight = 200 },
            },
        },

        [xi.assault.mission.SHOOTING_DOWN_THE_BARON] =
        {
            {
                { item = xi.item.UNAPPRAISED_BOW,   weight = 600 },
                { item = xi.item.UNAPPRAISED_BOX,   weight = 400 },
            },
        },
    }

    local regItem =
    {
        [xi.assault.mission.SEAGULL_GROUNDED] =
        {
            {
                { item = xi.item.HI_RERAISER,       weight = 700 },
                { item = 0,                         weight = 300 },
            },

            {
                { item = xi.item.HI_POTION_TANK,    weight = 100 },
                { item = xi.item.HI_ETHER_TANK,     weight = 100 },
                { item = 0,                         weight = 800 },
            },

            {
                { item = xi.item.HI_POTION_P3,      weight = 530 },
                { item = 0,                         weight = 470 },
            },
        },

        [xi.assault.mission.REQUIEM] =
        {
            {
                { item = xi.item.HI_POTION_P3,      weight = 500 },
                { item = 0,                         weight = 500 },
            },

            {
                { item = xi.item.HI_ETHER_TANK,     weight = 100 },
                { item = 0,                         weight = 900 },
            },

            {
                { item = xi.item.HI_RERAISER,       weight = 500 },
                { item = 0,                         weight = 500 },
            },
        },

        [xi.assault.mission.SHOOTING_DOWN_THE_BARON] =
        {
            {
                { item = xi.item.HI_POTION_P2,      weight = 850 },
                { item = 0,                         weight = 150 },
            },
            {
                { item = xi.item.HI_POTION_P3,      weight = 50 },
                { item = 0,                         weight = 950 },
            },
            {
                { item = xi.item.HI_POTION_TANK,    weight = 400 },
                { item = 0,                         weight = 600 },
            },
            {
                { item = xi.item.HI_RERAISER,       weight = 200 },
                { item = 0,                         weight = 800 },
            },
        },
    }

    local area = player:getCurrentAssault()
    xi.appraisal.assaultChestTrigger(player, npc, qItem[area], regItem[area])
end

return entity
