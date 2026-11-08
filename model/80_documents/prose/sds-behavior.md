The countdown the cook observes is {{KitchenTimerLibrary::CountdownStates}}.

From idle, increment adds one minute and decrement removes one second, both clamped to the configured range. Start begins the countdown. A start with no remaining time is ignored by the firmware. While running, the remaining time decreases once per second. Start again pauses, and start from pause resumes. Reaching zero enters alarming, which drives the sounder. Cancel, and start while alarming, return to idle.

The same machine is exhibited by the system specification and by the control specification. The integration binds the system's machine to the control machine and allocates it to control. The firmware task then carries that machine onto the microcontroller.
