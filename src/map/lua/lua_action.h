/*
===========================================================================

  Copyright (c) 2010-2015 Darkstar Dev Teams

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see http://www.gnu.org/licenses/

===========================================================================
*/

#ifndef _LUAACTION_H
#define _LUAACTION_H

#include "ability.h"
#include "common/cbasetypes.h"
#include "enums/action/knockback.h"
#include "luautils.h"

enum class HitDistortion : uint8_t;
enum class ActionInfo : uint8_t;
enum class ActionResolution : uint8_t;
struct action_t;
struct action_target_t;
class CLuaAction
{
    action_t* m_PLuaAction;

public:
    CLuaAction(action_t*);

    action_t* GetAction() const
    {
        return m_PLuaAction;
    }

    friend std::ostream& operator<<(std::ostream& out, const CLuaAction& action);

    void   ID(uint32 actionTargetID, uint32 newActionTargetID);
    uint32 getPrimaryTargetID();
    void   setRecast(uint16 recast);
    uint16 getRecast();
    void   actionID(uint16 actionid);
    uint16 getParam(uint32 actionTargetID);
    void   param(uint32 actionTargetID, int32 param);
    void   messageID(uint32 actionTargetID, MSGBASIC_ID messageID);
    auto   getMsg(uint32 actionTargetID) const -> std::optional<uint16>;
    auto   getAnimation(uint32 actionTargetID) -> std::optional<ActionAnimation>;
    void   setAnimation(uint32 actionTargetID, ActionAnimation animation);
    auto   getCategory() const -> ActionCategory;
    void   setCategory(uint8 category);
    void   resolution(uint32 actionTargetID, ActionResolution resolution) const;
    void   info(uint32 actionTargetID, ActionInfo info) const;
    void   hitDistortion(uint32 actionTargetID, HitDistortion distortion) const;
    void   knockback(uint32 actionTargetID, Knockback knockback) const;
    void   damage(CLuaBaseEntity* PLuaTarget, int32 damage) const;
    void   physicalDamage(CLuaBaseEntity* PLuaTarget, int32 damage, bool isCritical) const;
    void   modifier(uint32 actionTargetID, uint8 modifier);
    void   additionalEffect(uint32 actionTargetID, uint16 additionalEffect);
    void   addEffectParam(uint32 actionTargetID, int32 addEffectParam);
    void   addEffectMessage(uint32 actionTargetID, MSGBASIC_ID addEffectMessage);
    bool   addAdditionalTarget(uint32 actionTargetID);

    bool operator==(const CLuaAction& other) const
    {
        return this->m_PLuaAction == other.m_PLuaAction;
    }

    static void Register();
};

#endif
