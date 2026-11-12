/* SPDX-FileCopyrightText: 2026 Elan8
 * SPDX-License-Identifier: MIT */
package UserInterfaceSystem {
    private import ScalarValues::*;
    private import ISQ::*;
    private import SI::*;
    private import Elan8::Core::*;
    private import Elan8::Electronics::Core::*;
    private import Elan8::Electronics::Interconnection::*;
    private import Elan8::Procurement::*;
    private import Elan8::Units::Money::*;
    private import Elan8::PhysicalModeling::*;
    private import KitchenTimerLibrary::*;

    part def SegmentedLcd :> ElectronicsComponent, CostedPart {
        doc /*
         * Reflective four-digit segmented LCD. Static drive current is included
         * in the timer's idle and running mode currents, not added separately.
         * Legible at 0.5 m in about 100 lux without a backlight.
         */
        @BuyPart {
            manufacturer = "illustrative";
            manufacturerPartNumber = "LCD-4DIGIT-STATIC";
            url = "";
        }
        attribute digitCount : Integer = 4;
        attribute legibleWithoutBacklight : Boolean = true;
        attribute viewingDistance : LengthValue = 0.5 [m];
        attribute outlineWidth : LengthValue = 40 [mm];
        attribute outlineHeight : LengthValue = 18 [mm];
        attribute :>> mass = 0.004 [kg];
        attribute :>> unitCost = 0.65 [EUR];
        port power : ~PowerRailPort;
        port command : ~DisplayCommandPort;
    }

    part def TimerButton :> Elan8::Electronics::Sensing::SwitchSensor, CostedPart {
        doc /*
         * Momentary contact, mounted on the printed board. contactHigh is the
         * sense net, pulled up on the board and read by a microcontroller pin.
         * contactLow is ground. The firmware debounces the edge.
         * The Modelica model is Elan8.KitchenTimer.ClosingSwitch. An input
         * named closed is 1 when the contact is closed and 0 when it is open.
         * Closed resistance and open conductance are the MSL IdealClosingSwitch
         * values, 1e-5 ohm and 1e-5 S.
         */
        @BuyPart {
            manufacturer = "illustrative";
            manufacturerPartNumber = "SW-TACT-6MM";
            url = "";
        }
        attribute :>> mass = 0.0004 [kg];
        attribute :>> unitCost = 0.06 [EUR];
        port contactHigh : ElectricalTerminalPort;
        port contactLow : ElectricalTerminalPort;
        @ModelicaModel {
            resourceUri = "modelica://Elan8";
            className = "Elan8.KitchenTimer.ClosingSwitch";
        }
    }

    part def PiezoSounder :> ElectronicsComponent, CostedPart {
        doc /*
         * Supplier rating 85 dB at 0.1 m. At 0.3 m a point source loses
         * 20*log10(0.3/0.1) = 9.5 dB, and the enclosure is assumed to lose
         * another 3 dB, giving 72.5 dB. This is an estimate, not a measurement.
         * The 3 mA alarm-mode current of the baseline includes this sounder.
         */
        @BuyPart {
            manufacturer = "illustrative";
            manufacturerPartNumber = "PIEZO-12MM";
            url = "";
        }
        attribute ratedSoundPressure : SoundPressureLevelValue = 85 [dB];
        attribute ratedDistance : LengthValue = 0.1 [m];
        attribute soundPressureAt300mm : SoundPressureLevelValue = 72.5 [dB];
        attribute :>> mass = 0.001 [kg];
        attribute :>> unitCost = 0.30 [EUR];
        port power : ~PowerRailPort;
        port drive : ~PwmPort;
        port positive : ElectricalTerminalPort;
        port negative : ElectricalTerminalPort;
    }

    part def UserInterfaceSpecification :> PhysicalComponent, Elan8::SystemsEngineering::SystemSpecification {
        port user : TimerUserPort;
        port buttonOut : ButtonEventPort;
        port displayIn : ~DisplayCommandPort;
        port alarmIn : ~PwmPort;
        port power : ~PowerRailPort;
        attribute legibleWithoutBacklight : Boolean;
        attribute viewingDistance : LengthValue;
        attribute soundPressureAt300mm : SoundPressureLevelValue;
        attribute displayWidth : LengthValue;
        attribute displayHeight : LengthValue;
        attribute componentCost : MonetaryAmount;
    }

    part def UserInterfaceArchitecture
            :> UserInterfaceSpecification, Elan8::SystemsEngineering::SystemArchitecture {
        part display : SegmentedLcd;
        part incrementButton : TimerButton;
        part decrementButton : TimerButton;
        part startStopButton : TimerButton;
        part cancelButton : TimerButton;
        part sounder : PiezoSounder;

        bind displayIn = display.command;
        bind alarmIn = sounder.drive;
        connect display.power to power;
        connect sounder.power to power;

        attribute :>> legibleWithoutBacklight = display.legibleWithoutBacklight;
        attribute :>> viewingDistance = display.viewingDistance;
        attribute :>> soundPressureAt300mm = sounder.soundPressureAt300mm;
        attribute :>> displayWidth = display.outlineWidth;
        attribute :>> displayHeight = display.outlineHeight;
        attribute :>> mass =
            display.mass + incrementButton.mass + decrementButton.mass
            + startStopButton.mass + cancelButton.mass + sounder.mass;
        attribute :>> componentCost =
            display.unitCost + incrementButton.unitCost + decrementButton.unitCost
            + startStopButton.unitCost + cancelButton.unitCost + sounder.unitCost;
        doc /*
         * The four switches are mounted on the control board. Each switch
         * sits between ground and a pulled-up sense pin. The firmware decodes
         * those pins into ButtonEvent values on buttonOut. The sounder's
         * positive terminal is the cell rail and its negative terminal is the
         * collector of the control transistor. drive carries the same PWM
         * command the firmware writes to that transistor's base.
         */
    }

    package Views {
        view specification : Elan8::SystemsEngineering::SpecificationView {
            expose UserInterfaceSystem::UserInterfaceSpecification;
        }
        view architecture : Elan8::SystemsEngineering::ArchitectureView {
            expose UserInterfaceSystem::UserInterfaceArchitecture;
        }
    }
}
