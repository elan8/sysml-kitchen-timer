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
        doc /* Momentary contact. Firmware debounces the edge. */
        @BuyPart {
            manufacturer = "illustrative";
            manufacturerPartNumber = "SW-TACT-6MM";
            url = "";
        }
        attribute :>> mass = 0.0004 [kg];
        attribute :>> unitCost = 0.06 [EUR];
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
         * The four switches are decoded by the firmware into ButtonEvent values
         * on buttonOut. The cook's port receives that same command and is shown
         * the display image. Pin mapping is not assigned in this baseline.
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
