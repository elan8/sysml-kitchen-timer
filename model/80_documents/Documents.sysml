/*
 * SPDX-FileCopyrightText: 2026 Elan8
 * SPDX-License-Identifier: MIT
 *
 * Customer requirements, system requirements, system design, and the
 * verification and validation plan. Each document is a view; its nested views
 * are the sections, in order. Tables, values and diagrams are read from the
 * model. A short text is the `doc` of its section; a long one is a Markdown
 * file in `prose/`.
 */
package KitchenTimerDocuments {
    private import Elan8::Documents::*;
    private import StandardViewDefinitions::*;

    view crs {
        @Document {
            title = "Kitchen Timer";
            subtitle = "Customer Requirements Specification";
            organization = "Elan8";
            number = "KT-CRS-001";
            revision = "A";
            status = "Draft for review";
            template = "template";
        }

        view introduction {
            @Section { title = "Introduction"; }
            view purpose {
                @Section { title = "Purpose"; }
                doc /*
                 * This specification records what a cook expects from the kitchen timer
                 * developed by Elan8. It states the customer requirements in the cook's
                 * terms, before any design decision, and is the baseline against which the
                 * finished product is validated.
                 */
            }
            view scope {
                @Section { title = "Scope"; }
                @Prose { file = "prose/crs-scope.md"; }
            }
            view conventions {
                @Section { title = "Document conventions"; }
                @Prose { file = "prose/conventions.md"; }
            }
            view referenceDocuments {
                @Section { title = "Applicable and reference documents"; }
                @Prose { file = "prose/references.md"; }
            }
        }

        view context {
            @Section { title = "Stakeholders and operating context"; }
            @Prose { file = "prose/crs-context.md"; }
            view contextDiagram : InterconnectionView {
                @Section { title = "Operating context"; }
                doc /*
                 * The cook and the timer. The kitchen is the setting, not a second system.
                 * The cell is inside the timer.
                 */
                expose KitchenTimerContext::kitchenScenario;
            }
        }

        view scenarios {
            @Section { title = "Operational scenarios"; }
            @Prose { file = "prose/crs-scenarios.md"; }
            @Table {
                columns = "ID = id, Scenario = name, What the cook does = text";
                kind = "use case";
                sort = "id";
            }
            expose KitchenTimerUseCases::setCountdown;
            expose KitchenTimerUseCases::startCountdown;
            expose KitchenTimerUseCases::pauseAndResume;
            expose KitchenTimerUseCases::cancelCountdown;
            expose KitchenTimerUseCases::notifyCompletion;
            expose KitchenTimerUseCases::dismissAlarm;
            expose KitchenTimerUseCases::replaceBattery;
        }

        view customerRequirements {
            @Section { title = "Customer requirements"; }
            doc /*
             * Each requirement is a need of the cook, stated in the cook's terms and
             * identified by a stable number. None of them says how the product meets it
             * or how that is measured: the system requirements that make each need
             * measurable are in KT-SRS-001.
             */
            @Table {
                columns = "ID = id, Requirement = name, Text = text";
                kind = "requirement";
                sort = "id";
            }
            expose KitchenTimerStakeholderRequirements::*;
        }

        view constraints {
            @Section { title = "Constraints and assumptions"; }
            @Prose { file = "prose/crs-constraints.md"; }
        }

        view validation {
            @Section { title = "Validation and open points"; }
            @Prose { file = "prose/crs-validation.md"; }
        }
    }

    view srs {
        @Document {
            title = "Kitchen Timer";
            subtitle = "System Requirements Specification";
            organization = "Elan8";
            number = "KT-SRS-001";
            revision = "A";
            status = "Draft for review";
            template = "template";
        }

        view introduction {
            @Section { title = "Introduction"; }
            view purpose {
                @Section { title = "Purpose"; }
                doc /*
                 * This specification states what the timer shall do and how well, as
                 * verifiable requirements on the timer as a whole. It carries the customer
                 * requirements of KT-CRS-001 into a system contract and is the baseline for
                 * the design (KT-SDS-001) and for verification (KT-VVP-001). It contains no
                 * design.
                 */
            }
            view scope {
                @Section { title = "Scope"; }
                doc /*
                 * The system of interest is the timer: its enclosure, electronics and
                 * firmware, including one supplied cell. The requirements apply to the
                 * timer as delivered, used as described in KT-CRS-001.
                 *
                 * The cook is outside the system and appears here only through the user
                 * port. There is no external power supply, docking station or application.
                 */
            }
            view conventions {
                @Section { title = "Document conventions"; }
                @Prose { file = "prose/conventions.md"; }
            }
            view referenceDocuments {
                @Section { title = "Applicable and reference documents"; }
                @Prose { file = "prose/references.md"; }
            }
        }

        view overview {
            @Section { title = "System overview"; }
            @Prose { file = "prose/srs-overview.md"; }
            view boundary : InterconnectionView {
                @Section { title = "System context"; }
                doc /*
                 * The system of interest is the timer. The cook is outside it. The
                 * requirements constrain the timer at this interface.
                 */
                expose KitchenTimerContext::kitchenScenario;
            }
        }

        view requirements {
            @Section { title = "System requirements"; }
            doc /*
             * Each requirement constrains one property of the timer and states its limit.
             * The documentation of each requirement names the customer requirement it
             * carries forward. The limits are the same values the design checks use.
             * A requirement states what the timer shall do or be. The design that meets
             * it is in KT-SDS-001, and how it is verified is in KT-VVP-001.
             */

            view functional {
                @Section { title = "Functional requirements"; }
                @Table {
                    columns = "ID = id, Requirement = name, Text = text";
                    kind = "requirement";
                    sort = "id";
                }
                expose KitchenTimerSystem::countdownRange;
                expose KitchenTimerSystem::countdownCommands;
                expose KitchenTimerSystem::completionAlarm;
            }
            view performance {
                @Section { title = "Performance and power requirements"; }
                @Table {
                    columns = "ID = id, Requirement = name, Text = text";
                    kind = "requirement";
                    sort = "id";
                }
                expose KitchenTimerSystem::timingAccuracy;
                expose KitchenTimerSystem::batteryLife;
                expose KitchenTimerSystem::cellPulse;
                expose KitchenTimerSystem::alarmLoudness;
            }
            view userInterface {
                @Section { title = "User-interface requirements"; }
                @Table {
                    columns = "ID = id, Requirement = name, Text = text";
                    kind = "requirement";
                    sort = "id";
                }
                expose KitchenTimerSystem::readability;
            }
            view physical {
                @Section { title = "Physical requirements"; }
                @Table {
                    columns = "ID = id, Requirement = name, Text = text";
                    kind = "requirement";
                    sort = "id";
                }
                expose KitchenTimerSystem::envelope;
                expose KitchenTimerSystem::productMass;
                expose KitchenTimerSystem::batteryReplacement;
            }
            view cost {
                @Section { title = "Cost requirements"; }
                @Table {
                    columns = "ID = id, Requirement = name, Text = text";
                    kind = "requirement";
                    sort = "id";
                }
                expose KitchenTimerSystem::componentCostLimit;
            }
        }

        view traceability {
            @Section { title = "Traceability to customer requirements"; }
            @Prose { file = "prose/srs-traceability.md"; }
        }

        view plannedVerification {
            @Section { title = "Verification"; }
            doc /*
             * Every requirement of this specification is verified by the baseline analysis
             * case. The method, the pass criterion and the requirements verification
             * matrix are in the Verification and Validation Plan, KT-VVP-001. This
             * specification states what is required; it claims nothing about whether a
             * later measurement will agree.
             */
        }
    }

    view sds {
        @Document {
            title = "Kitchen Timer";
            subtitle = "System Design Specification";
            organization = "Elan8";
            number = "KT-SDS-001";
            revision = "A";
            status = "Draft for review";
            template = "template";
        }

        view introduction {
            @Section { title = "Introduction"; }
            view purpose {
                @Section { title = "Purpose"; }
                doc /*
                 * This specification describes how the timer is built to meet KT-SRS-001:
                 * its countdown behaviour, its physical and firmware architecture, the
                 * parts it is made of, and the calculations that link the selected design
                 * to the requirements.
                 */
            }
            view scope {
                @Section { title = "Scope"; }
                doc /*
                 * The design described here is the single selected baseline: a reflective
                 * segmented LCD, a coin cell with no regulator, and a molded enclosure.
                 * It covers the countdown behaviour, the four subsystems, the firmware
                 * allocation, the board netlist and the parts that determine cost,
                 * mass and life.
                 *
                 * A laid-out schematic drawing, mechanical drawings, source code and
                 * display alternatives are outside this document.
                 */
            }
            view conventions {
                @Section { title = "Document conventions"; }
                @Prose { file = "prose/conventions.md"; }
            }
            view referenceDocuments {
                @Section { title = "Applicable and reference documents"; }
                @Prose { file = "prose/references.md"; }
            }
        }

        view designOverview {
            @Section { title = "Design overview"; }
            @Prose { file = "prose/sds-overview.md"; }
        }

        view functionalDesign {
            @Section { title = "Functional design"; }
            @Prose { file = "prose/sds-behavior.md"; }
            view countdown : StateTransitionView {
                @Section { title = "Countdown states"; }
                doc /*
                 * Idle, running, paused and alarming. Cancel returns to idle from
                 * running, paused and alarming. The alarming state is the completion
                 * notification.
                 */
                expose ControlSystem::TimerFirmware::countdown;
            }
        }

        view physicalArchitecture {
            @Section { title = "Physical architecture"; }
            @Prose { file = "prose/sds-physical.md"; }
            view product : InterconnectionView {
                @Section { title = "Selected product"; }
                doc /*
                 * The selected integration: user interface, control, power and the
                 * mechanical assembly, with the mounts between them.
                 */
                expose KitchenTimerSystem::kitchenTimer;
            }
            view userInterface : InterconnectionView {
                @Section { title = "User interface"; }
                doc /* Display, four buttons and the sounder. */
                expose KitchenTimerSystem::kitchenTimer::userInterface;
            }
            view control : InterconnectionView {
                @Section { title = "Control"; }
                doc /*
                 * Printed board with the microcontroller, crystal, passives and
                 * the sounder transistor mounted on it. The Embassy runtime and
                 * its Rust task are on the microcontroller.
                 */
                expose KitchenTimerSystem::kitchenTimer::control;
            }
            view power : InterconnectionView {
                @Section { title = "Power"; }
                doc /* Coin cell and reservoir capacitor, with no series regulator. */
                expose KitchenTimerSystem::kitchenTimer::power;
            }
            view mechanical : InterconnectionView {
                @Section { title = "Mechanical assembly"; }
                doc /* Enclosure, cell holder and battery door. */
                expose KitchenTimerSystem::kitchenTimer::mechanical;
            }
        }

        view firmwareArchitecture {
            @Section { title = "Firmware architecture"; }
            @Prose { file = "prose/sds-firmware.md"; }
            view deployment : GeneralView {
                @Section { title = "Firmware deployment"; }
                doc /*
                 * The countdown machine is exhibited by the firmware task.
                 * That task is allocated to the Embassy runtime, and the
                 * runtime is allocated to the microcontroller.
                 */
                filter @SysML::PartUsage or @SysML::AllocationUsage
                    or @SysML::StateUsage or @SysML::ExhibitStateUsage;
                expose KitchenTimerSystem::kitchenTimer::control::mcu;
            }
        }

        view billOfMaterials {
            @Section { title = "Parts"; }
            @Prose { file = "prose/sds-components.md"; }
            @Table {
                columns = "Part = name, Mass = .mass, Unit cost = .unitCost";
                kind = "part def";
                sort = "name";
                caption = "Part definitions that carry a mass and a unit cost. Four buttons are one definition, used four times. The crystal load capacitor and the button pull-up are each one definition, used twice and four times.";
            }
            expose UserInterfaceSystem::SegmentedLcd;
            expose UserInterfaceSystem::TimerButton;
            expose UserInterfaceSystem::PiezoSounder;
            expose ControlSystem::TimerMicrocontroller;
            expose ControlSystem::TimerCrystal;
            expose ControlSystem::TimerLoadCapacitor;
            expose ControlSystem::TimerDecouplingCapacitor;
            expose ControlSystem::TimerPullUp;
            expose ControlSystem::TimerBaseResistor;
            expose ControlSystem::TimerSounderDriver;
            expose ControlSystem::TimerPrintedCircuitBoard;
            expose PowerSystem::TimerCoinCell;
            expose PowerSystem::TimerReservoirCapacitor;
            expose MechanicalAssemblySystem::TimerEnclosure;
            expose MechanicalAssemblySystem::BatteryDoor;
            expose MechanicalAssemblySystem::CellHolder;
        }

        view analyses {
            @Section { title = "Design analyses"; }
            @Prose { file = "prose/sds-analyses.md"; }
        }

        view satisfaction {
            @Section { title = "Requirement satisfaction"; }
            doc /*
             * {{KitchenTimerSystem::kitchenTimer}} claims each system requirement. A claim
             * is a design intent recorded in the model, not evidence. Evidence is the
             * verification case of KT-VVP-001. Which subsystem determines the property is
             * described in the architecture sections above.
             */
            @Table {
                columns = "ID = id, System requirement = name, Satisfied by = satisfied-by";
                kind = "requirement";
                sort = "id";
            }
            expose KitchenTimerSystem::countdownRange;
            expose KitchenTimerSystem::countdownCommands;
            expose KitchenTimerSystem::completionAlarm;
            expose KitchenTimerSystem::timingAccuracy;
            expose KitchenTimerSystem::batteryLife;
            expose KitchenTimerSystem::cellPulse;
            expose KitchenTimerSystem::readability;
            expose KitchenTimerSystem::alarmLoudness;
            expose KitchenTimerSystem::envelope;
            expose KitchenTimerSystem::productMass;
            expose KitchenTimerSystem::batteryReplacement;
            expose KitchenTimerSystem::componentCostLimit;
        }

        view openPoints {
            @Section { title = "Limitations and open design points"; }
            @Prose { file = "prose/sds-open.md"; }
        }
    }

    view vvp {
        @Document {
            title = "Kitchen Timer";
            subtitle = "Verification and Validation Plan";
            organization = "Elan8";
            number = "KT-VVP-001";
            revision = "A";
            status = "Draft for review";
            template = "template";
        }

        view introduction {
            @Section { title = "Introduction"; }
            view purpose {
                @Section { title = "Purpose"; }
                doc /*
                 * This plan states how Elan8 will show that the timer meets its
                 * requirements and that it is the product a cook needs. Verification
                 * answers the first question against KT-SRS-001. Validation answers the
                 * second against KT-CRS-001. The plan defines the method, the case and
                 * its pass criterion, and the matrix that shows every system requirement
                 * is covered. It contains no laboratory results.
                 */
            }
            view scope {
                @Section { title = "Scope"; }
                @Prose { file = "prose/vvp-scope.md"; }
            }
            view conventions {
                @Section { title = "Document conventions"; }
                @Prose { file = "prose/conventions.md"; }
            }
            view referenceDocuments {
                @Section { title = "Applicable and reference documents"; }
                @Prose { file = "prose/references.md"; }
            }
        }

        view system {
            @Section { title = "System under verification"; }
            @Prose { file = "prose/vvp-system.md"; }
            view product : InterconnectionView {
                @Section { title = "Selected configuration"; }
                doc /* The integration occurrence the baseline analysis subjects. */
                expose KitchenTimerSystem::kitchenTimer;
            }
        }

        view approach {
            @Section { title = "Verification and validation approach"; }
            @Prose { file = "prose/vvp-approach.md"; }
        }

        view resources {
            @Section { title = "Test articles, facilities and equipment"; }
            @Prose { file = "prose/vvp-resources.md"; }
        }

        view systemVerification {
            @Section { title = "System verification"; }
            doc /*
             * The analysis case covers the twelve system requirements. The
             * completion-alarm test runs the firmware countdown.
             */
            view cases {
                @Section { title = "Verification cases"; }
                doc /*
                 * The case states its method, what is evaluated, and the criterion for
                 * passing. The last column lists the requirements the case verifies.
                 */
                @Table {
                    columns = "ID = id, Case = name, Method = @VerificationMethod.kind, Procedure and pass criterion = text, Verifies = verifies / id";
                    kind = "verification case";
                    sort = "id";
                }
                expose KitchenTimerSystem::Verification::baselineAnalysis;
                expose KitchenTimerSystem::Verification::completionAlarmTest;
            }
            view matrix {
                @Section { title = "Requirements verification matrix"; }
                doc /*
                 * Every system requirement of KT-SRS-001 with the case that verifies it.
                 */
                @Table {
                    columns = "ID = id, System requirement = name, Method = verified-by / @VerificationMethod.kind, Verified by = verified-by / id";
                    kind = "requirement";
                    sort = "id";
                }
                expose KitchenTimerSystem::countdownRange;
                expose KitchenTimerSystem::countdownCommands;
                expose KitchenTimerSystem::completionAlarm;
                expose KitchenTimerSystem::timingAccuracy;
                expose KitchenTimerSystem::batteryLife;
                expose KitchenTimerSystem::cellPulse;
                expose KitchenTimerSystem::readability;
                expose KitchenTimerSystem::alarmLoudness;
                expose KitchenTimerSystem::envelope;
                expose KitchenTimerSystem::productMass;
                expose KitchenTimerSystem::batteryReplacement;
                expose KitchenTimerSystem::componentCostLimit;
            }
        }

        view validation {
            @Section { title = "Validation"; }
            @Prose { file = "prose/vvp-validation.md"; }
        }

        view status {
            @Section { title = "Status and open points"; }
            @Prose { file = "prose/vvp-status.md"; }
        }
    }
}
