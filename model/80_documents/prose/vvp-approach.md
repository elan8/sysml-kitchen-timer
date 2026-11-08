## Methods

The case in this plan uses analysis, the SysML verification method `analyze`: the requirement is shown by evaluating the design data already in the model. Test, inspection and demonstration are the methods for a built unit. They are not claimed here, because there is no unit.

Analysis is accepted for this baseline because the evidence is a calculation from stated assumptions. It is not accepted as the final evidence for loudness, life or readability. Those three need a measurement or a cook's review before release. The analysis still has to pass first, so that a unit is not built against a model that already fails its own limits.

## Pass criteria

VER-001 passes when every assert on the selected integration evaluates true. A requirement is verified by this plan only to the depth of that analysis. Passing VER-001 does not close the requirement for release.

## Order of work

The model analysis runs before any hardware is committed. When a unit exists, the same limits are measured on that unit, and the assumptions that the analysis used (mode currents, usable capacity, loudness) are replaced by the measurements. Validation with a cook comes after those measurements, on a unit that already meets the system limits.

## Nonconformance

A failed assert is traced to the attribute it reads: a current, a dimension, a cost or the crystal tolerance. The case is repeated after the model is changed. A later laboratory failure is traced the same way, from the requirement to the integration value and then to the part.

## What this plan does not do

It does not treat a satisfied requirement constraint as a test result. Several requirement constraints stay symbolic because their values exist only on the integration. The asserts on the integration are the evaluated evidence, and VER-001 names those requirements.
