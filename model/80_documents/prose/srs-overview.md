The timer is one product. A cook sets a countdown, reads the remaining time, hears completion, and replaces the cell. The observable behaviour is the countdown state machine: idle, running, paused and alarming. That machine is a requirement on what the cook can observe. Which firmware and which board realize it is design, and is described in KT-SDS-001.

The contract is twelve requirements:

- three functional requirements for the duration range, the commands, and the alarm at zero;
- timing accuracy, operating life, the pulse the cell must support, and alarm loudness;
- readability without a backlight;
- envelope, mass and tool-free cell replacement;
- an illustrative component-cost limit.

Each requirement's text names the customer requirement it carries forward. There is no second system on the boundary. The cook is the only external part.
