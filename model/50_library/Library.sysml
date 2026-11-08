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

    state def CountdownStates {
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
