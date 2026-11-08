/* SPDX-FileCopyrightText: 2026 Elan8
 * SPDX-License-Identifier: MIT */
package KitchenTimerStakeholderRequirements {
    private import KitchenTimerSystem::KitchenTimerSpecification;

    requirement <'STK-001'> readableCountdown {
        subject timer : KitchenTimerSpecification;
        doc /*
         * The cook can read the remaining time in ordinary kitchen light
         * without leaning over the timer. KT-UI-001 makes this measurable.
         */
    }

    requirement <'STK-002'> longOperatingLife {
        subject timer : KitchenTimerSpecification;
        doc /*
         * The product owner wants multi-year operation from a replaceable
         * cell under ordinary kitchen use. KT-PWR-001 and KT-PWR-002 are the
         * system obligations. The reference day is an assumption, not this need.
         */
    }

    requirement <'STK-003'> audibleCompletion {
        subject timer : KitchenTimerSpecification;
        doc /*
         * The cook can hear completion from a normal working distance.
         * KT-FUN-003 and KT-AC-001 carry this into the system contract.
         */
    }

    requirement <'STK-004'> replaceableCell {
        subject timer : KitchenTimerSpecification;
        doc /*
         * The cook replaces the cell without a tool. KT-MEC-003 is the
         * system obligation.
         */
    }

    requirement <'STK-005'> simpleCountdown {
        subject timer : KitchenTimerSpecification;
        doc /*
         * Setting, starting, pausing, resuming and cancelling stay obvious,
         * and the product stays small, light and inexpensive. KT-FUN-001,
         * KT-FUN-002, KT-PER-001, KT-MEC-001, KT-MEC-002 and KT-COST-001
         * carry this into the system contract.
         */
    }
}
