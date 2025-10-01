-----------------------------------
-- Area: Kuftal Tunnel
--  NPC: Treasure Coffer
-- !zone 174
-----------------------------------
---@type TNpcEntity
local entity = {}

entity.onTrade = function(player, npc, trade)
    xi.treasure.onTrade(player, npc, trade, 0, 0)
end

entity.onTrigger = function(player, npc)
    xi.treasure.onTrigger(player, xi.treasure.type.COFFER)
end

return entity
