/*
===========================================================================

  Copyright (c) 2025 LandSandBoat Dev Teams

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

#include "action.h"

#include "interrupts.h"
#include "packets/s2c/0x028_battle2.h"
#include "utils/battleutils.h"

void action_result_t::recordSkillchain(const ActionProcSkillChain effect, const int16_t dmg)
{
    if (dmg < 0)
    {
        // Absorbs damage
        this->addEffectParam   = -dmg;
        this->addEffectMessage = static_cast<MSGBASIC_ID>(384 + static_cast<uint8_t>(effect));
    }
    else
    {
        this->addEffectParam   = dmg;
        this->addEffectMessage = static_cast<MSGBASIC_ID>(287 + static_cast<uint8_t>(effect));
    }

    this->additionalEffect = effect;
}

auto action_result_t::recordDamage(const attack_outcome_t& outcome) -> action_result_t&
{
    this->param = outcome.damage;

    // Every attack type sets this bit if the target died as a result
    if (outcome.target && outcome.target->isDead())
    {
        this->info |= ActionInfo::Defeated;
    }

    switch (outcome.atkType)
    {
        case ATTACK_TYPE::SPECIAL:  // Assumed
        case ATTACK_TYPE::PHYSICAL: // Confirmed
        case ATTACK_TYPE::RANGED:   // Confirmed
        {
            if (outcome.isCritical) // TODO: Double check magic crits
            {
                this->info |= ActionInfo::CriticalHit;
            }

            // Set the defender hit recoil (HitDistortion) based on HPP dealt
            if (const auto* PTarget = outcome.target)
            {
                // Calculate damage percentage
                const uint8_t damageHPP  = PTarget->GetMaxHP() > 0 ? static_cast<uint8_t>((outcome.damage * 100) / PTarget->GetMaxHP()) : 0;
                auto          distortion = HitDistortion::None;

                // Values below are not quite made up but deserve refinement as the captured ranges appear to vary based on some unknown conditions
                // This has been observed as 30~37% depending on the mob
                if (damageHPP > 30)
                {
                    distortion = HitDistortion::Heavy;
                }
                else if (damageHPP > 17)
                {
                    distortion = HitDistortion::Medium;
                }
                else if (damageHPP > 0)
                {
                    distortion = HitDistortion::Light;
                }

                this->hitDistortion = distortion;
            }

            break;
        }
        default:
            break;
    }

    return *this;
}
