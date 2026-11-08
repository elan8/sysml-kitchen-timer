The firmware is one event-driven task, {{ControlSystem::TimerFirmware}}, allocated to a cooperative fixed-priority platform and then to the microcontroller.

The task deadline is one second, which is also the platform tick. While the countdown is running the firmware wakes once per second. Button edges closer than 50 ms are treated as one press. The task is marked mission-critical because a missed tick is a wrong remaining time, not a dropped log line.

There is no separate safety supervisor and no second processor. The alarming state is the only completion behaviour, and it is the same machine the cook observes. Source code is not generated from this model.
