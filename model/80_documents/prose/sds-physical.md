The product diagram is the selected integration, {{KitchenTimerSystem::kitchenTimer}}. The four diagrams after it open one subsystem each.

The user interface binds its display and sounder ports to the parts and connects both parts to the power port. The four switches are one button definition used four times. Pin assignment is not in this baseline. The firmware decodes the switches into button events.

Control places the microcontroller and the crystal on the printed board and connects the coin-cell rail to the microcontroller. The board is 60 mm by 45 mm and 1.6 mm thick, two-layer rigid FR-4.

Power binds the cell terminal to the supply port. The reservoir capacitor is across that rail so the piezo's high-frequency pulses are not asked of the cell as a continuous current. The capacitor does not source the alarm current for the whole alarm. The alarm current in the budget is still the current asked of the cell.

The enclosure is the product envelope. The display aperture and the four button positions are attributes of that enclosure. The integration checks that the display outline fits the aperture, that the board fits the enclosure footprint, and that the board, the cell and the wall allowance fit the height.
