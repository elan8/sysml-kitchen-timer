/* SPDX-FileCopyrightText: 2026 Elan8
 * SPDX-License-Identifier: MIT */
package KitchenTimerContext {
    private import KitchenTimerLibrary::TimerUserPort;
    private import KitchenTimerSystem::KitchenTimerSpecification;

    part def Cook {
        doc /* Person who sets the timer, reads it, hears it and replaces the cell. */
        port timer : ~TimerUserPort;
    }

    part def KitchenScenario {
        doc /*
         * The timer is a stand-alone product. The kitchen is the setting, not
         * a second system. The cell is inside the timer; replacing it is a
         * use of the timer, not an external power supply.
         */
        ref part cook : Cook;
        ref part timer : KitchenTimerSpecification;
        connect cook.timer to timer.user;
    }

    part kitchenScenario : KitchenScenario;

    view context : Elan8::SystemsEngineering::ContextView {
        expose KitchenTimerContext::kitchenScenario;
    }
}
