The selected baseline is a reflective four-digit segmented LCD on a CR2032 cell, with no series regulator. A regulator's quiescent current would dominate a two-year coin-cell budget, so the cell voltage is the logic voltage.

Four subsystems make the product:

- the user interface: the display, four buttons and a piezo sounder;
- control: a low-power microcontroller, a 32.768 kHz crystal, the printed board, the passives and transistor on that board, and a Rust task on an Embassy runtime;
- power: the cell and a reservoir capacitor across it;
- the mechanical assembly: the enclosure, the cell holder and the battery door.

The integration mounts the board in the enclosure, holds the cell in the holder with a removable mount, and covers it with the door. The cook's port is the user-interface port. Button events flow to the microcontroller, and the display image flows back.

Display alternatives, a backlight and a rechargeable pack were not carried as variants. This document describes the one baseline the model checks.
