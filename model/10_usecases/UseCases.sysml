/* SPDX-FileCopyrightText: 2026 Elan8
 * SPDX-License-Identifier: MIT */
package KitchenTimerUseCases {
    private import KitchenTimerContext::Cook;
    private import KitchenTimerSystem::KitchenTimerSpecification;

    use case def SetCountdown {
        subject timer : KitchenTimerSpecification;
        actor cook : Cook;
        objective {
            doc /* UC-01. The cook sets a duration from 1 s through 99 min 59 s and can read it. */
        }
    }

    use case def StartCountdown {
        subject timer : KitchenTimerSpecification;
        actor cook : Cook;
        objective {
            doc /* UC-02. The timer starts counting and keeps the remaining time on the display. */
        }
    }

    use case def PauseAndResume {
        subject timer : KitchenTimerSpecification;
        actor cook : Cook;
        objective {
            doc /* UC-03. Pause holds the remaining time. Resume continues from that time. */
        }
    }

    use case def CancelCountdown {
        subject timer : KitchenTimerSpecification;
        actor cook : Cook;
        objective {
            doc /* UC-04. Cancel stops the countdown and returns the timer to idle. */
        }
    }

    use case def NotifyCompletion {
        subject timer : KitchenTimerSpecification;
        actor cook : Cook;
        objective {
            doc /* UC-05. At zero the sounder runs and the display shows completion. */
        }
    }

    use case def DismissAlarm {
        subject timer : KitchenTimerSpecification;
        actor cook : Cook;
        objective {
            doc /* UC-06. The cook silences the sounder and the timer accepts a new duration. */
        }
    }

    use case def ReplaceBattery {
        subject timer : KitchenTimerSpecification;
        actor cook : Cook;
        objective {
            doc /* UC-07. The cook replaces the cell without a tool and the timer can be used again. */
        }
    }

    use case <'UC-01'> setCountdown : SetCountdown {
        doc /* The cook sets a duration from 1 s through 99 min 59 s and can read it. */
    }
    use case <'UC-02'> startCountdown : StartCountdown {
        doc /* The timer starts counting and keeps the remaining time on the display. */
    }
    use case <'UC-03'> pauseAndResume : PauseAndResume {
        doc /* Pause holds the remaining time. Resume continues from that time. */
    }
    use case <'UC-04'> cancelCountdown : CancelCountdown {
        doc /* Cancel stops the countdown and returns the timer to idle. */
    }
    use case <'UC-05'> notifyCompletion : NotifyCompletion {
        doc /* At zero the sounder runs and the display shows completion. */
    }
    use case <'UC-06'> dismissAlarm : DismissAlarm {
        doc /* The cook silences the sounder and the timer accepts a new duration. */
    }
    use case <'UC-07'> replaceBattery : ReplaceBattery {
        doc /* The cook replaces the cell without a tool and the timer can be used again. */
    }
}
