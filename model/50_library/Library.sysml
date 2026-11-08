/* SPDX-FileCopyrightText: 2026 Elan8
 * SPDX-License-Identifier: MIT */
package KitchenTimerLibrary {
    private import ScalarValues::*;
    private import ISQ::*;
    private import SI::*;
    private import SIPrefixes::*;
    private import MeasurementReferences::*;

    doc /*
     * Shared timer vocabulary. Developed subsystems stay in 60_systems.
     * Mode currents are not defined here: they belong to a selected design,
     * because a display or firmware change must change them in one place.
     */

    enum def ButtonKind {
        increment;
        decrement;
        startStop;
        cancel;
    }

    enum def TimerMode {
        idle;
        running;
        paused;
        alarming;
    }

    item def ButtonEvent {
        attribute kind : ButtonKind;
    }

    item def DisplayImage {
        attribute remaining : DurationValue;
        attribute mode : TimerMode;
    }

    item def IncrementPressed;
    item def DecrementPressed;
    item def StartStopPressed;
    item def CancelPressed;

    port def ButtonEventPort {
        out item pressed : ButtonEvent;
    }

    attribute <mA> milliampere : ElectricCurrentUnit {
        doc /* Milliampere, for currents that are awkward in ampere literals. */
        :>> unitConversion {
            private attribute prefix : UnitPrefix = milli;
            :>> referenceUnit = A;
            :>> conversionFactor = prefix.conversionFactor;
        }
    }

    port def DisplayCommandPort {
        out item image : DisplayImage;
    }

    port def TimerUserPort {
        doc /* Commands from the cook and the remaining-time image shown back. */
        in item command : ButtonEvent;
        out item display : DisplayImage;
    }

    part def TypicalKitchenDay {
        doc /*
         * Reference usage assumption, not a requirement. Two countdowns in a
         * day: 20 s to set, 8 min running, 8 s of alarm. Second counts are the
         * inputs. Durations and day-fractions are derived from them, and the
         * energy calculation reads the fractions. Idle is the rest of the day.
         */
        attribute countdownsPerDay : Real = 2.0;
        attribute settingSecondsEach : Real = 20.0;
        attribute runningSecondsEach : Real = 480.0;
        attribute alarmSecondsEach : Real = 8.0;
        attribute periodSeconds : Real = 86400.0;
        attribute settingSeconds : Real = settingSecondsEach * countdownsPerDay;
        attribute runningSeconds : Real = runningSecondsEach * countdownsPerDay;
        attribute alarmSeconds : Real = alarmSecondsEach * countdownsPerDay;
        attribute idleSeconds : Real = periodSeconds - settingSeconds - runningSeconds - alarmSeconds;
        attribute settingFraction : Real = settingSeconds / periodSeconds;
        attribute runningFraction : Real = runningSeconds / periodSeconds;
        attribute alarmFraction : Real = alarmSeconds / periodSeconds;
        attribute idleFraction : Real = idleSeconds / periodSeconds;
        attribute settingTime : DurationValue = settingSeconds * 1 [s];
        attribute runningTime : DurationValue = runningSeconds * 1 [s];
        attribute alarmTime : DurationValue = alarmSeconds * 1 [s];
        attribute idleTime : DurationValue = idleSeconds * 1 [s];
        attribute period : DurationValue = periodSeconds * 1 [s];
        assert constraint dayIsAccounted {
            settingSeconds + runningSeconds + alarmSeconds + idleSeconds == periodSeconds
        }
    }

    part typicalKitchenDay : TypicalKitchenDay;

}
