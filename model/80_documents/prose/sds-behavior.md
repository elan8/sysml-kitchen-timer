The countdown the cook observes is {{ControlSystem::TimerFirmware::countdown}}, the state owned by the firmware task.

From idle, increment adds one minute and decrement removes one second, both clamped to the configured range. Start begins the countdown. A start with no remaining time is ignored by the firmware. While running, the remaining time decreases once per second. Start again pauses, and start from pause resumes. Reaching zero enters alarming, which drives the sounder. Cancel, and start while alarming, return to idle.

The system specification and the control specification exhibit that state. Those exhibitions are bound to the task's state, so they are one performance. Deploying that task on the Embassy runtime, and the runtime on the microcontroller, is the allocation.
