The baseline is internally consistent and intentionally incomplete.

- Mode currents, the 80 percent usable capacity and the 6 mA pulse limit are assumptions. They are not discharge measurements.
- Alarm loudness is estimated from a supplier rating. It has not been measured on an enclosure.
- Part costs use placeholder manufacturers. They are not quotes.
- The button nets, the crystal oscillator and the piezo driver are a structural netlist with part values. No SPICE run is linked, and the results are not a simulation.
- The LCD segment map is not assigned.
- No board layout, mechanical drawing or firmware image is generated from the model.
- No second display, and no backlight, is in the model. A darker counter may reject the reflective LCD even though the readability assert passes.
- The reference day is lighter than a timer that runs several long countdowns every day. A heavier day can fail the two-year life without any part changing.

Those points are design and evidence gaps. They do not change the requirements in KT-SRS-001.
