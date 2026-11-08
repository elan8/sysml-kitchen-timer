The firmware is one Embassy task, {{ControlSystem::TimerFirmware}}, written in Rust. It is allocated to {{ControlSystem::TimerRuntime}}, the Embassy executor, and that runtime is allocated to the microcontroller. The deployment view shows those two allocations, and the countdown machine exhibited by the task.

The task deadline is one second, which is also the delay the task arms while the countdown is running. Button edges closer than 50 ms are treated as one press. While alarming, the task drives the PWM pin at the sounder transistor's tone frequency. The task is marked mission-critical because a missed tick is a wrong remaining time, not a dropped log line.

There is no separate safety supervisor and no second processor. The alarming state is the only completion behaviour, and it is the same machine the cook observes. Source code is not generated from this model.
