-----------------------------------
-- Area: Mamool Ja Training Grounds
-- Ancient Lockbox
-----------------------------------
---@type TNpcEntity
local entity = {}

entity.onTrigger = function(player, npc)
    local qItem =
    {
        [xi.assault.mission.IMPERIAL_AGENT_RESCUE] =
        {
            {
                { item = xi.item.UNAPPRAISED_BOX,  weight = 300 },
                { item = xi.item.UNAPPRAISED_RING, weight = 700 },
            },
        },

        [xi.assault.mission.PREEMPTIVE_STRIKE] =
        {
            {
                { item = xi.item.UNAPPRAISED_BOX,      weight = 300 },
                { item = xi.item.UNAPPRAISED_NECKLACE, weight = 700 },
            },
        },
    }

    local regItem =
    {
        [xi.assault.mission.IMPERIAL_AGENT_RESCUE] =
        {
            {
                { item = xi.item.HI_POTION_P2, weight = 900 },
                { item =    0,                 weight = 100 },
            },

            {
                { item = xi.item.HI_POTION_TANK, weight = 100 },
                { item =     0,                  weight = 900 },
            },

            {
                { item = xi.item.RERAISER, weight = 530 },
                { item =    0,             weight = 470 },
            },
        },

        [xi.assault.mission.PREEMPTIVE_STRIKE] =
        {
            {
                { item = xi.item.HI_POTION_TANK, weight = 100 },
                { item =     0,                   weight = 900 },
            },

            {
                { item = xi.item.RERAISER, weight = 300 },
                { item =    0,              weight = 700 },
            },

            {
                { item = xi.item.HI_RERAISER, weight = 500 },
                { item =    0,                 weight = 500 },
            },
        },
    }

    local area = player:getCurrentAssault()
    xi.appraisal.assaultChestTrigger(player, npc, qItem[area], regItem[area])
end

return entity
