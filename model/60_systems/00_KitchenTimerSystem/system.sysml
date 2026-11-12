/* SPDX-FileCopyrightText: 2026 Elan8
 * SPDX-License-Identifier: MIT */
package KitchenTimerSystem {
    private import ScalarValues::*;
    private import ISQ::*;
    private import SI::*;
    private import Elan8::Core::*;
    private import Elan8::Mechanical::Interconnection::*;
    private import Elan8::Electronics::Assembly::*;
    private import Elan8::Electronics::Interconnection::*;
    private import Elan8::Units::Money::*;
    private import KitchenTimerLibrary::*;
    private import UserInterfaceSystem::*;
    private import ControlSystem::*;
    private import PowerSystem::*;
    private import MechanicalAssemblySystem::*;

    requirement <'KT-FUN-001'> countdownRange {
        subject timer : KitchenTimerSpecification;
        require constraint {
            timer.minimumDuration <= 1 [s] and timer.maximumDuration >= 5999 [s]
        }
        doc /*
         * The cook can set any duration from 1 s through 99 min 59 s.
         * Source: STK-005.
         */
    }

    requirement <'KT-FUN-002'> countdownCommands {
        subject timer : KitchenTimerSpecification;
        require constraint {
            timer.acceptsStart and timer.acceptsPause
                and timer.acceptsResume and timer.acceptsCancel
        }
        doc /*
         * Start, pause, resume and cancel are the StartStopPressed and
         * CancelPressed transitions of the firmware countdown. Source: STK-005.
         */
    }

    requirement <'KT-FUN-003'> completionAlarm {
        subject timer : KitchenTimerSpecification;
        require constraint { timer.alarmsAtZero }
        doc /*
         * Reaching zero enters the alarming state, which drives the sounder.
         * Source: STK-003.
         */
    }

    requirement <'KT-PER-001'> timingAccuracy {
        subject timer : KitchenTimerSpecification;
        require constraint { timer.timebaseTolerancePpm <= 277.8 }
        doc /*
         * Within 1 s per hour. 1/3600 is 278 ppm; the limit is 277.8 ppm.
         * The baseline crystal is 20 ppm. Source: STK-005.
         */
    }

    requirement <'KT-PWR-001'> batteryLife {
        subject timer : KitchenTimerSpecification;
        require constraint { timer.operatingLife >= 17520 [h] }
        doc /*
         * At least two 365-day years on TypicalKitchenDay. The life is
         * usable cell capacity divided by the exclusive-mode average current.
         * Source: STK-002.
         */
    }

    requirement <'KT-PWR-002'> cellPulse {
        subject timer : KitchenTimerSpecification;
        require constraint { timer.alarmCurrent <= timer.cellPulseCurrentLimit }
        doc /*
         * Alarm-mode current asked of the cell stays within the cell's
         * short-pulse assumption. Average life does not show this.
         * Source: STK-002.
         */
    }

    requirement <'KT-UI-001'> readability {
        subject timer : KitchenTimerSpecification;
        require constraint {
            timer.legibleWithoutBacklight
                and timer.viewingDistance >= 0.5 [m]
        }
        doc /*
         * Remaining time is legible at 0.5 m in about 100 lux without a
         * backlight. Source: STK-001.
         */
    }

    requirement <'KT-AC-001'> alarmLoudness {
        subject timer : KitchenTimerSpecification;
        require constraint { timer.soundPressureAt300mm >= 70 [dB] }
        doc /*
         * At least 70 dB at 0.3 m, from the sounder's estimate. A candidate
         * of 75 dB at 1 m is not adopted: a coin-cell piezo does not support
         * it. Source: STK-003.
         */
    }

    requirement <'KT-MEC-001'> envelope {
        subject timer : KitchenTimerSpecification;
        require constraint {
            timer.width <= 90 [mm]
                and timer.depth <= 70 [mm]
                and timer.height <= 25 [mm]
        }
        doc /* Outer dimensions stay inside 90 x 70 x 25 mm. Source: STK-005. */
    }

    requirement <'KT-MEC-002'> productMass {
        subject timer : KitchenTimerSpecification;
        require constraint { timer.mass <= 0.1 [kg] }
        doc /* Mass is below 100 g. Source: STK-005. */
    }

    requirement <'KT-MEC-003'> batteryReplacement {
        subject timer : KitchenTimerSpecification;
        require constraint { timer.batteryReplaceableWithoutTools }
        doc /*
         * The cell is held by a removable mount and a door. No tool is
         * required. Source: STK-004.
         */
    }

    requirement <'KT-COST-001'> componentCostLimit {
        subject timer : KitchenTimerSpecification;
        require constraint { timer.componentCost <= 8 [EUR] }
        doc /*
         * Illustrative component cost, one currency, one included cell,
         * at the assumed volume. Not a supplier quote. Source: STK-005.
         */
    }

    part def KitchenTimerSpecification
            :> PhysicalComponent, Elan8::SystemsEngineering::SystemSpecification {
        port user : TimerUserPort;
        attribute minimumDuration : DurationValue = 1 [s];
        attribute maximumDuration : DurationValue = 5999 [s];
        attribute acceptsStart : Boolean = true;
        attribute acceptsPause : Boolean = true;
        attribute acceptsResume : Boolean = true;
        attribute acceptsCancel : Boolean = true;
        attribute alarmsAtZero : Boolean = true;
        attribute operatingLife : DurationValue;
        attribute alarmCurrent : ElectricCurrentValue;
        attribute cellPulseCurrentLimit : ElectricCurrentValue;
        attribute timebaseTolerancePpm : Real;
        attribute legibleWithoutBacklight : Boolean;
        attribute viewingDistance : LengthValue;
        attribute soundPressureAt300mm : SoundPressureLevelValue;
        attribute width : LengthValue;
        attribute depth : LengthValue;
        attribute height : LengthValue;
        attribute batteryReplaceableWithoutTools : Boolean;
        attribute componentCost : MonetaryAmount;
        exhibit state observableCountdown;
    }

    part def BaselineModeCurrents {
        doc /*
         * Whole-timer currents for the segmented-LCD baseline. Idle includes
         * MCU sleep and static LCD. Running is the once-per-second wake.
         * Setting is an awake button-handling interval. Alarm includes the
         * sounder. Modes are exclusive, so these currents are not summed
         * with the parts' own power draws.
         */
        attribute idleMilliampere : Real = 0.003;
        attribute settingMilliampere : Real = 0.150;
        attribute runningMilliampere : Real = 0.008;
        attribute alarmMilliampere : Real = 3.0;
        attribute idleCurrent : ElectricCurrentValue = idleMilliampere * 1 [mA];
        attribute settingCurrent : ElectricCurrentValue = settingMilliampere * 1 [mA];
        attribute runningCurrent : ElectricCurrentValue = runningMilliampere * 1 [mA];
        attribute alarmCurrent : ElectricCurrentValue = alarmMilliampere * 1 [mA];

        doc /*
         * The countdown mode selects one of these loads. Setting is not a
         * countdown mode; it stays a fraction of TypicalKitchenDay. Paused
         * has no authored current: time spent paused fails the run.
         */
        part whileIdle : ModeLoad {
            attribute :>> mode = TimerMode::idle;
            attribute :>> current = idleCurrent;
        }
        part whileRunning : ModeLoad {
            attribute :>> mode = TimerMode::running;
            attribute :>> current = runningCurrent;
        }
        part whileAlarming : ModeLoad {
            attribute :>> mode = TimerMode::alarming;
            attribute :>> current = alarmCurrent;
        }
    }

    part def ModeLoad {
        doc /*
         * One countdown mode and the cell current drawn while that mode is
         * current. The current is a whole-timer average, not a pin current.
         */
        attribute mode : TimerMode;
        attribute current : ElectricCurrentValue;
    }

    part def KitchenTimerArchitecture
            :> KitchenTimerSpecification, Elan8::SystemsEngineering::SystemArchitecture {
        part userInterface : UserInterfaceSpecification;
        part control : ControlSpecification;
        part power : PowerSpecification;
        part mechanical : MechanicalAssemblySpecification;

        bind user = userInterface.user;
        connect userInterface.buttonOut to control.buttonIn;
        connect control.displayOut to userInterface.displayIn;
        connect control.alarmOut to userInterface.alarmIn;
        connect power.supply to userInterface.power;
        connect power.supply to control.power;
        flow userInterface.buttonOut.pressed to control.buttonIn.pressed;
        flow control.displayOut.image to userInterface.displayIn.image;

        exhibit state observableCountdown
                :>> KitchenTimerSpecification::observableCountdown
                references control.countdown;
        bind observableCountdown = control.countdown;
    }

    part def KitchenTimerIntegration
            :> KitchenTimerArchitecture, Elan8::SystemsEngineering::SystemIntegration {
        part redefines userInterface : UserInterfaceArchitecture;
        part redefines control : ControlArchitecture;
        part redefines power : PowerArchitecture;
        part redefines mechanical : MechanicalAssemblyArchitecture;
        part baselineLoads : BaselineModeCurrents;

        doc /*
         * Exclusive-mode average in milliampere, weighted by TypicalKitchenDay.
         * Life in hours is usable milliampere-hours divided by that average.
         * The duration and current quantities are those numbers with units.
         */
        attribute averageMilliampere : Real =
            baselineLoads.idleMilliampere * typicalKitchenDay.idleFraction
            + baselineLoads.settingMilliampere * typicalKitchenDay.settingFraction
            + baselineLoads.runningMilliampere * typicalKitchenDay.runningFraction
            + baselineLoads.alarmMilliampere * typicalKitchenDay.alarmFraction;
        attribute averageCurrent : ElectricCurrentValue = averageMilliampere * 1 [mA];
        attribute lifeHours : Real = power.usableMilliampereHours / averageMilliampere;
        attribute :>> operatingLife = lifeHours * 1 [h];
        attribute :>> alarmCurrent = baselineLoads.alarmCurrent;
        attribute :>> cellPulseCurrentLimit = power.pulseCurrentLimit;
        attribute :>> timebaseTolerancePpm = control.timebaseTolerancePpm;
        attribute :>> legibleWithoutBacklight = userInterface.legibleWithoutBacklight;
        attribute :>> viewingDistance = userInterface.viewingDistance;
        attribute :>> soundPressureAt300mm = userInterface.soundPressureAt300mm;
        attribute :>> width = mechanical.width;
        attribute :>> depth = mechanical.depth;
        attribute :>> height = mechanical.height;
        attribute :>> batteryReplaceableWithoutTools = mechanical.batteryReplaceableWithoutTools;
        attribute :>> mass =
            userInterface.mass + control.mass + power.mass + mechanical.mass;
        attribute :>> componentCost =
            userInterface.componentCost + control.componentCost
            + power.componentCost + mechanical.componentCost;

        interface cellPositiveToBoard : ElectricalTerminalLink
            connect terminalA ::> power.cell.positive to terminalB ::> control.vcc;
        interface cellNegativeToBoard : ElectricalTerminalLink
            connect terminalA ::> power.cell.negative to terminalB ::> control.gnd;
        interface sounderToRail : ElectricalTerminalLink
            connect terminalA ::> userInterface.sounder.positive to terminalB ::> control.vcc;
        interface sounderToCollector : ElectricalTerminalLink
            connect terminalA ::> userInterface.sounder.negative to terminalB ::> control.alarmSwitch;
        interface incrementHigh : ElectricalTerminalLink
            connect terminalA ::> userInterface.incrementButton.contactHigh
            to terminalB ::> control.incrementSense;
        interface incrementLow : ElectricalTerminalLink
            connect terminalA ::> userInterface.incrementButton.contactLow
            to terminalB ::> control.gnd;
        interface decrementHigh : ElectricalTerminalLink
            connect terminalA ::> userInterface.decrementButton.contactHigh
            to terminalB ::> control.decrementSense;
        interface decrementLow : ElectricalTerminalLink
            connect terminalA ::> userInterface.decrementButton.contactLow
            to terminalB ::> control.gnd;
        interface startStopHigh : ElectricalTerminalLink
            connect terminalA ::> userInterface.startStopButton.contactHigh
            to terminalB ::> control.startStopSense;
        interface startStopLow : ElectricalTerminalLink
            connect terminalA ::> userInterface.startStopButton.contactLow
            to terminalB ::> control.gnd;
        interface cancelHigh : ElectricalTerminalLink
            connect terminalA ::> userInterface.cancelButton.contactHigh
            to terminalB ::> control.cancelSense;
        interface cancelLow : ElectricalTerminalLink
            connect terminalA ::> userInterface.cancelButton.contactLow
            to terminalB ::> control.gnd;
        connect userInterface.incrementButton.signal to control.incrementGpio;
        connect userInterface.decrementButton.signal to control.decrementGpio;
        connect userInterface.startStopButton.signal to control.startStopGpio;
        connect userInterface.cancelButton.signal to control.cancelGpio;

        connection boardMount : MechanicalMount
            connect support ::> mechanical.enclosure
            to mountedPart ::> control.printedBoard;
        connection displayOnBoard : BoardMounting {
            attribute :>> referenceDesignator = new ReferenceDesignator("LCD1");
            attribute :>> side = BoardSide::top;
            attribute :>> mountingTechnology = MountingTechnology::throughHole;
            connect board ::> control.printedBoard to component ::> userInterface.display;
        }
        connection sounderOnBoard : BoardMounting {
            attribute :>> referenceDesignator = new ReferenceDesignator("LS1");
            attribute :>> side = BoardSide::top;
            attribute :>> mountingTechnology = MountingTechnology::throughHole;
            connect board ::> control.printedBoard to component ::> userInterface.sounder;
        }
        connection reservoirOnBoard : BoardMounting {
            attribute :>> referenceDesignator = new ReferenceDesignator("C4");
            attribute :>> side = BoardSide::top;
            attribute :>> mountingTechnology = MountingTechnology::surfaceMount;
            connect board ::> control.printedBoard to component ::> power.reservoir;
        }
        connection incrementOnBoard : BoardMounting {
            attribute :>> referenceDesignator = new ReferenceDesignator("SW1");
            attribute :>> side = BoardSide::top;
            attribute :>> mountingTechnology = MountingTechnology::throughHole;
            connect board ::> control.printedBoard to component ::> userInterface.incrementButton;
        }
        connection decrementOnBoard : BoardMounting {
            attribute :>> referenceDesignator = new ReferenceDesignator("SW2");
            attribute :>> side = BoardSide::top;
            attribute :>> mountingTechnology = MountingTechnology::throughHole;
            connect board ::> control.printedBoard to component ::> userInterface.decrementButton;
        }
        connection startStopOnBoard : BoardMounting {
            attribute :>> referenceDesignator = new ReferenceDesignator("SW3");
            attribute :>> side = BoardSide::top;
            attribute :>> mountingTechnology = MountingTechnology::throughHole;
            connect board ::> control.printedBoard to component ::> userInterface.startStopButton;
        }
        connection cancelOnBoard : BoardMounting {
            attribute :>> referenceDesignator = new ReferenceDesignator("SW4");
            attribute :>> side = BoardSide::top;
            attribute :>> mountingTechnology = MountingTechnology::throughHole;
            connect board ::> control.printedBoard to component ::> userInterface.cancelButton;
        }
        connection cellRetention : RemovableMount
            connect support ::> mechanical.cellHolder
            to mountedPart ::> power.cell;
        connection doorMount : RemovableMount
            connect support ::> mechanical.enclosure
            to mountedPart ::> mechanical.batteryDoor;

        assert constraint meetsBatteryLife { lifeHours >= 17520.0 }
        assert constraint meetsPulse { alarmCurrent <= cellPulseCurrentLimit }
        assert constraint meetsTiming { timebaseTolerancePpm <= 277.8 }
        assert constraint meetsReadability {
            legibleWithoutBacklight and viewingDistance >= 0.5 [m]
        }
        assert constraint meetsLoudness { soundPressureAt300mm >= 70 [dB] }
        assert constraint meetsEnvelope {
            width <= 90 [mm] and depth <= 70 [mm] and height <= 25 [mm]
        }
        assert constraint meetsMass { mass <= 0.1 [kg] }
        assert constraint meetsCost { componentCost <= 8 [EUR] }
        assert constraint meetsReplacement { batteryReplaceableWithoutTools }
        assert constraint displayFitsAperture {
            userInterface.displayWidth <= mechanical.displayApertureWidth
                and userInterface.displayHeight <= mechanical.displayApertureHeight
        }
        assert constraint boardFitsEnclosure {
            control.boardWidth < mechanical.width
                and control.boardDepth < mechanical.depth
        }
        assert constraint stackFitsHeight {
            control.boardThickness + power.cellThickness + mechanical.wallAllowance
                <= mechanical.height
        }
    }

    part kitchenTimer : KitchenTimerIntegration;

    satisfy countdownRange by kitchenTimer;
    satisfy countdownCommands by kitchenTimer;
    satisfy completionAlarm by kitchenTimer;
    satisfy timingAccuracy by kitchenTimer;
    satisfy batteryLife by kitchenTimer;
    satisfy cellPulse by kitchenTimer;
    satisfy readability by kitchenTimer;
    satisfy alarmLoudness by kitchenTimer;
    satisfy envelope by kitchenTimer;
    satisfy productMass by kitchenTimer;
    satisfy batteryReplacement by kitchenTimer;
    satisfy componentCostLimit by kitchenTimer;

    package Verification {
        private import VerificationCases::*;

        verification <'VER-001'> baselineAnalysis {
            @VerificationMethod { kind = VerificationMethodKind::analyze; }
            subject timer : KitchenTimerSpecification = kitchenTimer;
            objective {
                verify countdownRange;
                verify countdownCommands;
                verify completionAlarm;
                verify timingAccuracy;
                verify batteryLife;
                verify cellPulse;
                verify readability;
                verify alarmLoudness;
                verify envelope;
                verify productMass;
                verify batteryReplacement;
                verify componentCostLimit;
            }
            doc /*
             * Evaluate the baseline asserts on the selected timer. The case
             * passes when every assert is true. This is analysis of the model,
             * not a laboratory measurement. Alarm loudness in particular is a
             * supplier-rating estimate.
             */
        }
        verification <'VER-002'> completionAlarmTest {
            @VerificationMethod { kind = VerificationMethodKind::test; }
            doc /*
             * Increment three times, start, and wait 180 s. The case passes
             * when the firmware countdown is alarming and drives the sounder.
             * The cell current is the baseline load for the countdown mode.
             */
            subject firmware : TimerFirmware;
            part loads : BaselineModeCurrents;
            objective {
                verify completionAlarm;
            }
            action stimulus {
                send new IncrementPressed() to firmware;
                then send new IncrementPressed() to firmware;
                then send new IncrementPressed() to firmware;
                then send new StartStopPressed() to firmware;
                then accept after 180 [s];
            }
            assert constraint alarmsAndDrives {
                firmware.countdown.mode == TimerMode::alarming and firmware.countdown.sounderDriven
            }
        }
    }

    package Views {
        view specification : Elan8::SystemsEngineering::SpecificationView {
            expose KitchenTimerSystem::KitchenTimerSpecification;
            expose ControlSystem::TimerFirmware::countdown;
        }
        view architecture : Elan8::SystemsEngineering::ArchitectureView {
            expose KitchenTimerSystem::KitchenTimerArchitecture;
        }
        view integration : Elan8::SystemsEngineering::IntegrationView {
            expose KitchenTimerSystem::kitchenTimer;
        }
    }
}
