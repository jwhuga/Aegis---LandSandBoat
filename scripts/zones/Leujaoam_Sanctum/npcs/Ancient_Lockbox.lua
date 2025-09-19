-----------------------------------
-- Area: Leujaoam Sanctum
-- Ancient Lockbox
-----------------------------------
---@type TNpcEntity
local entity = {}

entity.onTrigger = function(player, npc)
    local qItem =
    {
        [xi.assault.mission.LEUJAOAM_CLEANSING] =
        {
            {
                { item = xi.item.UNAPPRAISED_RING, weight = 700 },
                { item = xi.item.UNAPPRAISED_BOX,  weight = 300 },
            },
        },

        [xi.assault.mission.ORICHALCUM_SURVEY] =
        {
            {
                { item = xi.item.UNAPPRAISED_NECKLACE, weight = 300 },
                { item = xi.item.UNAPPRAISED_BOX,      weight = 400 },
                { item = xi.item.UNAPPRAISED_GLOVES,   weight = 300 },
            },
        },
    }

    local regItem =
    {
        [xi.assault.mission.LEUJAOAM_CLEANSING] =
        {
            {
                { item = xi.item.HI_POTION_P3, weight = 1000 },
            },

            {
                { item = xi.item.HI_POTION_P3, weight = 100 },
                { item = 0,                    weight = 900 },
            },

            {
                { item = xi.item.REMEDY, weight = 530 },
                { item = 0,               weight = 470 },
            },
        },

        [xi.assault.mission.ORICHALCUM_SURVEY] =
        {
            {
                { item = xi.item.HI_POTION_P3, weight = 1000 },
            },

            {
                { item = xi.item.REMEDY, weight = 530 },
                { item = 0,               weight = 470 },
            },
        },
    }

    local area = player:getCurrentAssault()
    xi.appraisal.assaultChestTrigger(player, npc, qItem[area], regItem[area])
end

return entity
