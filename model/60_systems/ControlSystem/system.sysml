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
    private import Elan8::Procurement::*;
    private import Elan8::Software::*;
    private import Elan8::Units::Engineering::*;
    private import Elan8::Units::Money::*;
    private import KitchenTimerLibrary::*;

    part def TimerMicrocontroller :> Microcontroller, CostedPart {
        doc /*
         * Low-power MCU on the coin-cell rail. No regulator: the cell voltage
         * is the logic voltage. Sleep current is part of the timer idle mode,
         * not a separate power term.
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
    }

    part def TimerCrystal :> CrystalResonator, CostedPart {
        doc /* 32.768 kHz watch crystal, 20 ppm. 20 ppm is 0.072 s of error per hour. */
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

    part def TimerFirmware :> EventDrivenTask {
        doc /*
         * Bare-metal countdown allocated to the MCU. The running state's
         * counting action waits one second between steps, which is this
         * task's deadline. Button edges closer than 50 ms are treated as one
         * press. The exhibited state machine is the control contract's machine.
         */
        attribute :>> deadline = 1 [s];
        attribute :>> minimumInterArrivalTime = 50 [ms];
        attribute :>> criticality = TaskCriticality::missionCritical;
    }

    part def ControlSpecification :> PhysicalComponent, Elan8::SystemsEngineering::SystemSpecification {
        port buttonIn : ~ButtonEventPort;
        port displayOut : DisplayCommandPort;
        port alarmOut : PwmPort;
        port power : ~PowerRailPort;
        attribute timebaseTolerancePpm : Real;
        attribute boardWidth : LengthValue;
        attribute boardDepth : LengthValue;
        attribute boardThickness : LengthValue;
        attribute componentCost : MonetaryAmount;
        exhibit state countdown : CountdownStates;
    }

    part def ControlArchitecture
            :> ControlSpecification, Elan8::SystemsEngineering::SystemArchitecture {
        part mcu : TimerMicrocontroller;
        part timebase : TimerCrystal;
        part board : TimerPrintedCircuitBoard;
        part platform : ExecutionPlatform {
            attribute :>> schedulingPolicy = SchedulingPolicy::fixedPriorityCooperative;
            attribute :>> tickPeriod = 1 [s];
        }
        part firmware : TimerFirmware;

        bind buttonIn = mcu.buttonIn;
        bind displayOut = mcu.displayOut;
        bind alarmOut = mcu.alarmOut;
        connect power to mcu.power;

        allocate countdown to firmware;
        allocate firmware to platform;
        allocate platform to mcu;

        attribute :>> timebaseTolerancePpm = timebase.frequencyTolerancePpm;
        attribute :>> boardWidth = board.width;
        attribute :>> boardDepth = board.height;
        attribute :>> boardThickness = board.thickness;
        attribute :>> mass = mcu.mass + timebase.mass + board.mass;
        attribute :>> componentCost = mcu.unitCost + timebase.unitCost + board.unitCost;
        doc /*
         * The printed board hosts the MCU and crystal. The mechanical assembly
         * mounts that board; this package owns the board because the MCU is
         * placed on it.
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
