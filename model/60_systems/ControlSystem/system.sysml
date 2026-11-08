/* SPDX-FileCopyrightText: 2026 Elan8
 * SPDX-License-Identifier: MIT */
package ControlSystem {
    private import ScalarValues::*;
    private import ISQ::*;
    private import SI::*;
    private import Elan8::Core::*;
    private import Elan8::Electronics::Core::*;
    private import Elan8::Electronics::Board::*;
    private import Elan8::Electronics::Components::*;
    private import Elan8::Electronics::Compute::*;
    private import Elan8::Electronics::Interconnection::*;
    private import Elan8::Electronics::Assembly::*;
    private import Elan8::Procurement::*;
    private import Elan8::Software::*;
    private import Elan8::Units::Engineering::*;
    private import Elan8::Units::Money::*;
    private import KitchenTimerLibrary::*;

    part def TimerMicrocontroller :> Microcontroller, CostedPart {
        doc /*
         * Low-power MCU on the coin-cell rail. No regulator: the cell voltage
         * is the logic voltage. Sleep current is part of the timer idle mode,
         * not a separate power term. xin and xout are the Pierce oscillator
         * pins. The four sense pins read the buttons. alarmPin is the PWM pin
         * that drives the sounder transistor; alarmOut is that same pin as the
         * firmware command.
         */
        @BuyPart {
            manufacturer = "illustrative";
            manufacturerPartNumber = "MCU-LOW-POWER";
            url = "";
        }
        attribute :>> mass = 0.0003 [kg];
        attribute :>> unitCost = 0.55 [EUR];
        port buttonIn : ~ButtonEventPort;
        port displayOut : DisplayCommandPort;
        port alarmOut : PwmPort;
        port alarmPin : ElectricalTerminalPort;
        port xin : ElectricalTerminalPort;
        port xout : ElectricalTerminalPort;
        port vcc : ElectricalTerminalPort;
        port gnd : ElectricalTerminalPort;
        port incrementPin : ElectricalTerminalPort;
        port decrementPin : ElectricalTerminalPort;
        port startStopPin : ElectricalTerminalPort;
        port cancelPin : ElectricalTerminalPort;
        port incrementGpio : GpioPort;
        port decrementGpio : GpioPort;
        port startStopGpio : GpioPort;
        port cancelGpio : GpioPort;
    }

    part def TimerCrystal :> CrystalResonator, CostedPart {
        doc /* 32.768 kHz watch crystal, 12.5 pF load, 20 ppm. 20 ppm is 0.072 s of error per hour. */
        @BuyPart {
            manufacturer = "illustrative";
            manufacturerPartNumber = "XTAL-32.768KHZ-20PPM";
            url = "";
        }
        attribute :>> resonantFrequency = 32768 [Hz];
        attribute :>> loadCapacitance = 0.0000000000125 [F];
        attribute :>> packageType = new ComponentPackage("2012");
        attribute frequencyTolerancePpm : Real = 20.0;
        attribute :>> mass = 0.0001 [kg];
        attribute :>> unitCost = 0.08 [EUR];
    }

    part def TimerLoadCapacitor :> CeramicCapacitor, CostedPart {
        doc /*
         * Pierce load capacitor, one on each crystal pin. Two 18 pF parts
         * in series are 9 pF; the crystal's 12.5 pF load treats the rest
         * as board stray. The value is a design selection, not an extracted
         * parasitic.
         */
        @BuyPart {
            manufacturer = "illustrative";
            manufacturerPartNumber = "C-18PF-50V";
            url = "";
        }
        attribute :>> capacitance = 0.000000000018 [F];
        attribute :>> tolerance = new ComponentTolerance(0.05);
        attribute :>> ratedVoltage = 50 [V];
        attribute :>> packageType = new ComponentPackage("0402");
        attribute :>> mass = 0.000001 [kg];
        attribute :>> unitCost = 0.01 [EUR];
    }

    part def TimerDecouplingCapacitor :> CeramicCapacitor, CostedPart {
        doc /* 100 nF across the microcontroller supply pins. */
        @BuyPart {
            manufacturer = "illustrative";
            manufacturerPartNumber = "C-100NF-16V";
            url = "";
        }
        attribute :>> capacitance = 0.0000001 [F];
        attribute :>> tolerance = new ComponentTolerance(0.1);
        attribute :>> ratedVoltage = 16 [V];
        attribute :>> packageType = new ComponentPackage("0402");
        attribute :>> mass = 0.000002 [kg];
        attribute :>> unitCost = 0.01 [EUR];
    }

    part def TimerPullUp :> Resistor, CostedPart {
        doc /*
         * Button pull-up to the cell rail. 100 kΩ keeps a held button
         * inside the setting-mode current.
         */
        @BuyPart {
            manufacturer = "illustrative";
            manufacturerPartNumber = "R-100K-0402";
            url = "";
        }
        attribute :>> resistance = 100000 [ohm];
        attribute :>> tolerance = new ComponentTolerance(0.05);
        attribute :>> ratedPower = 0.063 [W];
        attribute :>> maximumWorkingVoltage = 50 [V];
        attribute :>> packageType = new ComponentPackage("0402");
        attribute :>> mass = 0.000001 [kg];
        attribute :>> unitCost = 0.01 [EUR];
    }

    part def TimerBaseResistor :> Resistor, CostedPart {
        doc /*
         * Base resistor of the sounder transistor. At 3 V it supplies about
         * 50 µA, enough for the 3 mA piezo without adding a new term to the
         * alarm-current budget.
         */
        @BuyPart {
            manufacturer = "illustrative";
            manufacturerPartNumber = "R-47K-0402";
            url = "";
        }
        attribute :>> resistance = 47000 [ohm];
        attribute :>> tolerance = new ComponentTolerance(0.05);
        attribute :>> ratedPower = 0.063 [W];
        attribute :>> maximumWorkingVoltage = 50 [V];
        attribute :>> packageType = new ComponentPackage("0402");
        attribute :>> mass = 0.000001 [kg];
        attribute :>> unitCost = 0.01 [EUR];
    }

    part def TimerSounderDriver :> BipolarJunctionTransistor, CostedPart {
        doc /*
         * NPN switch. The PWM pin drives the base through the base resistor.
         * The emitter is ground. The collector sinks the piezo; the piezo's
         * other terminal is the cell rail. The tone is 4 kHz.
         */
        @BuyPart {
            manufacturer = "illustrative";
            manufacturerPartNumber = "Q-NPN-SOT23";
            url = "";
        }
        attribute :>> polarity = BipolarJunctionPolarity::npn;
        attribute :>> currentGain = 200.0;
        attribute :>> maximumCollectorEmitterVoltage = 40 [V];
        attribute :>> maximumCollectorCurrent = 0.1 [A];
        attribute :>> packageType = new ComponentPackage("SOT-23");
        attribute toneFrequency : FrequencyValue = 4000 [Hz];
        attribute :>> mass = 0.00001 [kg];
        attribute :>> unitCost = 0.03 [EUR];
    }

    part def TimerPrintedCircuitBoard :> PrintedCircuitBoard, CostedPart {
        @MakePart;
        attribute :>> layerCount = new LayerCount(2);
        attribute :>> technology = PrintedBoardTechnology::rigid;
        attribute :>> material = new BoardMaterial("FR-4");
        attribute :>> thickness = 1.6 [mm];
        attribute :>> width = 60 [mm];
        attribute :>> height = 45 [mm];
        attribute :>> mass = 0.008 [kg];
        attribute :>> unitCost = 0.45 [EUR];
    }

    part def TimerRuntime :> ExecutionPlatform {
        doc /*
         * Embassy executor: the Rust async runtime deployed on the
         * microcontroller. The countdown firmware is one Embassy task on
         * this executor. Scheduling is cooperative. The tick is the
         * one-second delay that task arms while the countdown is running.
         */
        attribute :>> schedulingPolicy = SchedulingPolicy::fixedPriorityCooperative;
        attribute :>> tickPeriod = 1 [s];
    }

    part def TimerFirmware :> EventDrivenTask {
        doc /*
         * One Embassy task, written in Rust. The running state's counting
         * action waits one second between steps, which is this task's
         * deadline. Button edges closer than 50 ms are treated as one press.
         * While alarming, the task drives the PWM pin at the sounder
         * driver's tone frequency. This task owns the countdown state
         * machine. That state is the performance.
         */
        attribute :>> deadline = 1 [s];
        attribute :>> minimumInterArrivalTime = 50 [ms];
        attribute :>> criticality = TaskCriticality::missionCritical;
        state countdown {
            doc /*
             * Observable countdown. From idle, increment adds one minute and
             * decrement removes one second, both clamped to the setpoint range.
             * The range is 1 s through 99 min 59 s, the same limits as KT-FUN-001.
             * Remaining starts at zero, so the first start is ignored until the
             * cook sets a time. While running, remaining decreases once per
             * second. When remaining reaches zero the machine enters alarming,
             * which drives the sounder. Cancel
             * returns to idle from running, paused and alarming. Start while
             * alarming also returns to idle. Pause holds whatever remains.
             */
            attribute minimumSetpoint : DurationValue = 1 [s];
            attribute maximumSetpoint : DurationValue = 5999 [s];
            attribute remaining : DurationValue := 0 [s];
            attribute mode : TimerMode := TimerMode::idle;
            attribute sounderDriven : Boolean := false;

            entry;
            then idle;

            state idle {
                doc /* Setpoint can be changed. The timer is not counting. */
                entry action showIdle {
                    assign mode := TimerMode::idle;
                    then assign sounderDriven := false;
                }
            }
            state running {
                doc /* Remaining time decreases once per second. */
                entry action showRunning {
                    assign mode := TimerMode::running;
                    then assign sounderDriven := false;
                }
                do action countDown {
                    while remaining > 1 [s] {
                        accept after 1 [s];
                        then assign remaining := remaining - 1 [s];
                    }
                    then accept after 1 [s];
                    then assign remaining := 0 [s];
                }
            }
            state paused {
                doc /* Remaining time is held. */
                entry action showPaused {
                    assign mode := TimerMode::paused;
                    then assign sounderDriven := false;
                }
            }
            state alarming {
                doc /* Countdown has reached zero and the sounder is driven. */
                entry action soundAlarm {
                    assign mode := TimerMode::alarming;
                    then assign sounderDriven := true;
                }
            }

            transition increment first idle
                accept IncrementPressed
                do action {
                    if remaining + 60 [s] > maximumSetpoint {
                        assign remaining := maximumSetpoint;
                    } else {
                        assign remaining := remaining + 60 [s];
                    }
                }
                then idle;
            transition decrement first idle
                accept DecrementPressed
                do action {
                    if remaining - 1 [s] < minimumSetpoint {
                        assign remaining := minimumSetpoint;
                    } else {
                        assign remaining := remaining - 1 [s];
                    }
                }
                then idle;
            transition startCountdown first idle
                accept StartStopPressed
                if remaining >= minimumSetpoint
                then running;
            transition pause first running
                accept StartStopPressed
                then paused;
            transition resume first paused
                accept StartStopPressed
                then running;
            transition complete first running
                accept when remaining == 0 [s]
                then alarming;
            transition cancelRunning first running
                accept CancelPressed
                then idle;
            transition cancelPaused first paused
                accept CancelPressed
                then idle;
            transition dismiss first alarming
                accept CancelPressed
                then idle;
            transition dismissWithStart first alarming
                accept StartStopPressed
                then idle;
        }
    }

    part def ControlSpecification :> PhysicalComponent, Elan8::SystemsEngineering::SystemSpecification {
        port buttonIn : ~ButtonEventPort;
        port displayOut : DisplayCommandPort;
        port alarmOut : PwmPort;
        port alarmSwitch : ElectricalTerminalPort;
        port vcc : ElectricalTerminalPort;
        port gnd : ElectricalTerminalPort;
        port power : ~PowerRailPort;
        port incrementSense : ElectricalTerminalPort;
        port decrementSense : ElectricalTerminalPort;
        port startStopSense : ElectricalTerminalPort;
        port cancelSense : ElectricalTerminalPort;
        port incrementGpio : GpioPort;
        port decrementGpio : GpioPort;
        port startStopGpio : GpioPort;
        port cancelGpio : GpioPort;
        attribute timebaseTolerancePpm : Real;
        attribute boardWidth : LengthValue;
        attribute boardDepth : LengthValue;
        attribute boardThickness : LengthValue;
        attribute componentCost : MonetaryAmount;
        exhibit state countdown;
    }

    part def ControlArchitecture
            :> ControlSpecification, Elan8::SystemsEngineering::SystemArchitecture {
        part printedBoard : TimerPrintedCircuitBoard;
        part mcu : TimerMicrocontroller {
            part runtime : TimerRuntime;
            part firmware : TimerFirmware;
            allocate firmware to runtime;
        }
        part timebase : TimerCrystal;
        part xinLoad : TimerLoadCapacitor;
        part xoutLoad : TimerLoadCapacitor;
        part decoupling : TimerDecouplingCapacitor;
        part incrementPullUp : TimerPullUp;
        part decrementPullUp : TimerPullUp;
        part startStopPullUp : TimerPullUp;
        part cancelPullUp : TimerPullUp;
        part baseResistor : TimerBaseResistor;
        part sounderDriver : TimerSounderDriver;
        part ground : Ground {
            attribute :>> mass = 0 [kg];
        }

        bind buttonIn = mcu.buttonIn;
        bind displayOut = mcu.displayOut;
        bind alarmOut = mcu.alarmOut;
        bind alarmSwitch = sounderDriver.collector;
        bind vcc = mcu.vcc;
        bind gnd = ground.terminal;
        bind incrementSense = mcu.incrementPin;
        bind decrementSense = mcu.decrementPin;
        bind startStopSense = mcu.startStopPin;
        bind cancelSense = mcu.cancelPin;
        bind incrementGpio = mcu.incrementGpio;
        bind decrementGpio = mcu.decrementGpio;
        bind startStopGpio = mcu.startStopGpio;
        bind cancelGpio = mcu.cancelGpio;
        connect power to mcu.power;

        allocate mcu.runtime to mcu;
        exhibit state countdown
                :>> ControlSpecification::countdown
                references mcu.firmware.countdown;
        bind countdown = mcu.firmware.countdown;

        connection mcuOnBoard : BoardMounting {
            attribute :>> referenceDesignator = new ReferenceDesignator("U1");
            attribute :>> side = BoardSide::top;
            attribute :>> mountingTechnology = MountingTechnology::surfaceMount;
            connect board ::> printedBoard to component ::> mcu;
        }
        connection crystalOnBoard : BoardMounting {
            attribute :>> referenceDesignator = new ReferenceDesignator("Y1");
            attribute :>> side = BoardSide::top;
            attribute :>> mountingTechnology = MountingTechnology::surfaceMount;
            connect board ::> printedBoard to component ::> timebase;
        }
        connection xinLoadOnBoard : BoardMounting {
            attribute :>> referenceDesignator = new ReferenceDesignator("C1");
            attribute :>> side = BoardSide::top;
            attribute :>> mountingTechnology = MountingTechnology::surfaceMount;
            connect board ::> printedBoard to component ::> xinLoad;
        }
        connection xoutLoadOnBoard : BoardMounting {
            attribute :>> referenceDesignator = new ReferenceDesignator("C2");
            attribute :>> side = BoardSide::top;
            attribute :>> mountingTechnology = MountingTechnology::surfaceMount;
            connect board ::> printedBoard to component ::> xoutLoad;
        }
        connection decouplingOnBoard : BoardMounting {
            attribute :>> referenceDesignator = new ReferenceDesignator("C3");
            attribute :>> side = BoardSide::top;
            attribute :>> mountingTechnology = MountingTechnology::surfaceMount;
            connect board ::> printedBoard to component ::> decoupling;
        }
        connection incrementPullUpOnBoard : BoardMounting {
            attribute :>> referenceDesignator = new ReferenceDesignator("R1");
            attribute :>> side = BoardSide::top;
            attribute :>> mountingTechnology = MountingTechnology::surfaceMount;
            connect board ::> printedBoard to component ::> incrementPullUp;
        }
        connection decrementPullUpOnBoard : BoardMounting {
            attribute :>> referenceDesignator = new ReferenceDesignator("R2");
            attribute :>> side = BoardSide::top;
            attribute :>> mountingTechnology = MountingTechnology::surfaceMount;
            connect board ::> printedBoard to component ::> decrementPullUp;
        }
        connection startStopPullUpOnBoard : BoardMounting {
            attribute :>> referenceDesignator = new ReferenceDesignator("R3");
            attribute :>> side = BoardSide::top;
            attribute :>> mountingTechnology = MountingTechnology::surfaceMount;
            connect board ::> printedBoard to component ::> startStopPullUp;
        }
        connection cancelPullUpOnBoard : BoardMounting {
            attribute :>> referenceDesignator = new ReferenceDesignator("R4");
            attribute :>> side = BoardSide::top;
            attribute :>> mountingTechnology = MountingTechnology::surfaceMount;
            connect board ::> printedBoard to component ::> cancelPullUp;
        }
        connection baseResistorOnBoard : BoardMounting {
            attribute :>> referenceDesignator = new ReferenceDesignator("R5");
            attribute :>> side = BoardSide::top;
            attribute :>> mountingTechnology = MountingTechnology::surfaceMount;
            connect board ::> printedBoard to component ::> baseResistor;
        }
        connection driverOnBoard : BoardMounting {
            attribute :>> referenceDesignator = new ReferenceDesignator("Q1");
            attribute :>> side = BoardSide::top;
            attribute :>> mountingTechnology = MountingTechnology::surfaceMount;
            connect board ::> printedBoard to component ::> sounderDriver;
        }

        interface crystalXin : ElectricalTerminalLink
            connect terminalA ::> mcu.xin to terminalB ::> timebase.terminal1;
        interface crystalXout : ElectricalTerminalLink
            connect terminalA ::> timebase.terminal2 to terminalB ::> mcu.xout;
        interface xinLoadHigh : ElectricalTerminalLink
            connect terminalA ::> mcu.xin to terminalB ::> xinLoad.terminal1;
        interface xinLoadLow : ElectricalTerminalLink
            connect terminalA ::> xinLoad.terminal2 to terminalB ::> ground.terminal;
        interface xoutLoadHigh : ElectricalTerminalLink
            connect terminalA ::> mcu.xout to terminalB ::> xoutLoad.terminal1;
        interface xoutLoadLow : ElectricalTerminalLink
            connect terminalA ::> xoutLoad.terminal2 to terminalB ::> ground.terminal;
        interface mcuGround : ElectricalTerminalLink
            connect terminalA ::> mcu.gnd to terminalB ::> ground.terminal;
        interface decouplingHigh : ElectricalTerminalLink
            connect terminalA ::> decoupling.terminal1 to terminalB ::> vcc;
        interface decouplingLow : ElectricalTerminalLink
            connect terminalA ::> decoupling.terminal2 to terminalB ::> ground.terminal;
        interface incrementPullHigh : ElectricalTerminalLink
            connect terminalA ::> incrementPullUp.terminal1 to terminalB ::> vcc;
        interface incrementPullSense : ElectricalTerminalLink
            connect terminalA ::> incrementPullUp.terminal2 to terminalB ::> incrementSense;
        interface decrementPullHigh : ElectricalTerminalLink
            connect terminalA ::> decrementPullUp.terminal1 to terminalB ::> vcc;
        interface decrementPullSense : ElectricalTerminalLink
            connect terminalA ::> decrementPullUp.terminal2 to terminalB ::> decrementSense;
        interface startStopPullHigh : ElectricalTerminalLink
            connect terminalA ::> startStopPullUp.terminal1 to terminalB ::> vcc;
        interface startStopPullSense : ElectricalTerminalLink
            connect terminalA ::> startStopPullUp.terminal2 to terminalB ::> startStopSense;
        interface cancelPullHigh : ElectricalTerminalLink
            connect terminalA ::> cancelPullUp.terminal1 to terminalB ::> vcc;
        interface cancelPullSense : ElectricalTerminalLink
            connect terminalA ::> cancelPullUp.terminal2 to terminalB ::> cancelSense;
        interface pwmToBaseResistor : ElectricalTerminalLink
            connect terminalA ::> mcu.alarmPin to terminalB ::> baseResistor.terminal1;
        interface baseResistorToBase : ElectricalTerminalLink
            connect terminalA ::> baseResistor.terminal2 to terminalB ::> sounderDriver.base;
        interface driverEmitterToGround : ElectricalTerminalLink
            connect terminalA ::> sounderDriver.emitter to terminalB ::> ground.terminal;

        attribute :>> timebaseTolerancePpm = timebase.frequencyTolerancePpm;
        attribute :>> boardWidth = printedBoard.width;
        attribute :>> boardDepth = printedBoard.height;
        attribute :>> boardThickness = printedBoard.thickness;
        attribute :>> mass =
            mcu.mass + timebase.mass + printedBoard.mass
            + xinLoad.mass + xoutLoad.mass + decoupling.mass
            + incrementPullUp.mass + decrementPullUp.mass
            + startStopPullUp.mass + cancelPullUp.mass
            + baseResistor.mass + sounderDriver.mass;
        attribute :>> componentCost =
            mcu.unitCost + timebase.unitCost + printedBoard.unitCost
            + xinLoad.unitCost + xoutLoad.unitCost + decoupling.unitCost
            + incrementPullUp.unitCost + decrementPullUp.unitCost
            + startStopPullUp.unitCost + cancelPullUp.unitCost
            + baseResistor.unitCost + sounderDriver.unitCost;
        doc /*
         * The printed board carries the microcontroller, the crystal and its
         * load capacitors, the supply decoupling capacitor, one pull-up per
         * button, and the NPN that sinks the piezo. The Embassy runtime and
         * its Rust task are deployed on the microcontroller.
         */
    }

    package Views {
        view specification : Elan8::SystemsEngineering::SpecificationView {
            expose ControlSystem::ControlSpecification;
        }
        view architecture : Elan8::SystemsEngineering::ArchitectureView {
            expose ControlSystem::ControlArchitecture;
        }
    }
}
