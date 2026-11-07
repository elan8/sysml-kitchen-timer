# Kitchen Timer — End-to-End SysML v2 Engineering Demo

> **Status:** Project proposal / implementation brief  
> **Owner:** Elan8  
> **Purpose:** Demonstrate how a small, realistic mechatronic product can be specified, architected, analyzed, simulated, verified, and documented from a Git-managed SysML v2 model.

## 1. Project Overview

The **Kitchen Timer** is an end-to-end demonstration project for the Elan8 SysML v2 ecosystem. It uses a simple, battery-powered digital kitchen timer as a compact but genuinely multidisciplinary engineering case study.

The timer has a display, user controls, an audible alarm, embedded software, electronics, a battery, and a mechanical enclosure. Although the product is simple, engineering decisions are coupled: for example, replacing the display affects readability, power consumption, cost, PCB interfaces, firmware behavior, and enclosure geometry.

The demo should show **engineering work enabled by a system model**, rather than only SysML diagrams. The primary story is that one consistent SysML v2 model supports architecture decisions, executable analyses, change-impact assessment, verification, and document generation.

### Objectives

1. Demonstrate the Elan8 **recursive Black Box / Grey Box / White Box** MBSE methodology.
2. Exercise realistic SysML v2 modeling across requirements, behavior, interfaces, structure, and allocations.
3. Evaluate competing design options using model-connected analyses.
4. Simulate embedded behavior and its effect on electrical power consumption.
5. Trace requirements to architecture, analysis results, and verification evidence.
6. Generate useful engineering documentation from the model.
7. Keep the project small enough to understand, clone, modify, and run locally.

### Intended audience

Systems engineers, mechatronics architects, embedded engineers, MBSE practitioners, and prospective users of Elan8 tooling.

## 2. Demonstration Narrative

The primary end-to-end scenario is a **display technology change**:

1. Establish a baseline design with a low-power segmented LCD.
2. Demonstrate that its architecture and calculated battery life satisfy the baseline requirements.
3. Introduce a stakeholder request for improved display readability and/or visual appearance.
4. Evaluate an OLED and a seven-segment LED alternative against the LCD baseline.
5. Propagate the selected alternative through affected electrical, firmware, mechanical, cost, and energy models.
6. Re-run analyses and verification checks; show any violated constraints.
7. Apply a mitigation (for example, a display timeout, revised duty cycle, or different battery) and evaluate the outcome.
8. Show the change in model views, traceability, and generated engineering documentation.

The result should make it obvious **what changed, why it matters, and whether the design still meets its requirements**.

## 3. Product Concept and Scope

A compact, stand-alone kitchen timer with the following basic interactions:

- Set a duration using physical buttons.
- Start, pause/resume, and cancel a countdown.
- Display the remaining time and current operating state.
- Produce an audible alarm when the countdown reaches zero.
- Dismiss the alarm and return to an idle state.
- Operate from a replaceable battery.

### Included in the initial demo

| Discipline | Included capabilities |
| --- | --- |
| Systems engineering | Stakeholders, context, use cases, requirements, decomposition, interfaces, allocations, traceability |
| Electronics | Battery, power budget, MCU, display, buttons, buzzer; simplified component characteristics |
| Embedded software | Timer behavior, event handling, state machine, display control, low-power modes |
| Mechanical | Enclosure envelope, display opening, button locations, PCB and battery packaging constraints |
| Analysis | Battery life, display trade-off, estimated BOM cost, dimensional/packaging checks |
| Verification | Automated requirement checks and recorded evidence/results |
| Documentation | Generated system requirements, architecture description, trade study, verification summary |

### Explicitly deferred

- Production-ready electronics or a complete PCB layout.
- Transistor-level/SPICE circuit simulation.
- High-fidelity 3D CAD and manufacturing drawings.
- Full embedded firmware generation from SysML v2.
- Detailed audio/acoustic and environmental qualification.
- A physical prototype or hardware-in-the-loop testing (possible later extension).

The implementation should use **simple, transparent engineering models first** and only add fidelity where it strengthens the demonstration.

## 4. Initial Stakeholders and Use Cases

### Stakeholders

- **End user:** wants an intuitive, readable, reliable timer.
- **Product owner:** balances usability, cost, and differentiation.
- **Electrical engineer:** selects the MCU, display, battery, and electronic components.
- **Embedded software engineer:** implements countdown behavior and energy-saving logic.
- **Mechanical engineer:** designs the compact and manufacturable enclosure.
- **Verification engineer:** determines whether the design satisfies its requirements.

### Primary use cases

| ID | Use case | Expected outcome |
| --- | --- | --- |
| UC-01 | Set countdown duration | User can select and inspect a valid duration |
| UC-02 | Start countdown | Timer transitions to running and updates remaining time |
| UC-03 | Pause and resume | Remaining time is preserved across a pause |
| UC-04 | Cancel countdown | Timer returns to an appropriate idle/reset state |
| UC-05 | Notify completion | Audible alarm activates at zero |
| UC-06 | Dismiss alarm | Alarm stops and timer becomes usable again |
| UC-07 | Replace battery | User can restore operation without specialized tools |

## 5. Candidate System Requirements

The following values are **illustrative starting assumptions, not agreed product specifications**. Assign stable requirement identifiers in the SysML model and refine the values as the design matures.

| ID | Candidate requirement | Initial target | Verification approach |
| --- | --- | --- | --- |
| REQ-FUN-001 | Configurable countdown range | 1 s to 99 min 59 s | Behavior tests |
| REQ-FUN-002 | Start/pause/resume/cancel functionality | All functions available | State-machine tests |
| REQ-FUN-003 | Countdown completion alarm | Audible notification | Behavior test |
| REQ-PER-001 | Timing accuracy | Within ±1 s/hour | Clock error analysis/test |
| REQ-PWR-001 | Battery operating life | ≥ 2 years under defined usage profile | Power analysis |
| REQ-UI-001 | Remaining-time readability | Measurable criteria to be defined | Display trade study / inspection |
| REQ-AC-001 | Alarm sound pressure | ≥ 75 dBA at 1 m | Component estimate; physical test later |
| REQ-MEC-001 | Maximum external dimensions | 90 × 70 × 25 mm | Packaging analysis |
| REQ-MEC-002 | Maximum product mass | < 100 g | Mass budget |
| REQ-COST-001 | Maximum component cost | BOM < €8 at defined volume | Cost analysis |
| REQ-ENV-001 | Operating temperature | 0–40 °C | Component rating review |

**Requirement hygiene:** define a reference usage profile, design lifetime, battery chemistry, production volume, viewing conditions, and alarm measurement method before treating numerical results as evidence of compliance. Keep assumptions and requirements separate.

## 6. SysML v2 Modeling Methodology

Follow the Elan8 methodology: **context → use cases → stakeholder/customer requirements → system requirements → recursive system decomposition**.

For each system or subsystem, distinguish three complementary perspectives:

| Perspective | Purpose | Proposed Elan8 library concept |
| --- | --- | --- |
| **Black Box** | What the system must do; external interfaces, requirements, observable behavior | `SystemSpecification` |
| **Grey Box** | How internal parts collaborate; logical/physical architecture, connections, allocations | `SystemArchitecture` |
| **White Box** | How the assembled implementation is integrated and verified | `SystemIntegration` |

These are **proposed Elan8 domain-library abstractions**, not claims that these names are built-in SysML v2 elements. Their exact implementation, specialization relationships, and ownership patterns must be validated against the SysML v2 language and the current Spec42 parser.

### Recursive decomposition

```text
Kitchen Timer
├── User Interface
│   ├── Display
│   ├── Buttons
│   └── Audible Alarm
├── Control
│   ├── Microcontroller
│   ├── Clock / Timebase
│   └── Embedded Software
├── Power
│   ├── Battery
│   └── Power Distribution / Regulation
└── Mechanical Assembly
    ├── Enclosure
    ├── PCB Mounting
    └── Battery Compartment
```

Model key interfaces across the disciplines, including button events, display data/control, buzzer drive, electrical power, timebase, and mounting/space constraints. Capture software-to-hardware allocations explicitly.

## 7. Proposed Repository Organization

This is a **logical layout**, to be adapted to valid SysML v2 package/import syntax and the current Elan8 libraries.

```text
kitchen-timer-demo/
├── README.md
├── LICENSE
├── model/
│   ├── KitchenTimer.sysml               # Root model and imports
│   ├── context/                        # Actors, external systems, use cases
│   ├── requirements/                   # Stakeholder and system requirements
│   ├── system/                         # Black/Grey/White Box models
│   │   ├── KitchenTimer/
│   │   ├── UserInterface/
│   │   ├── Control/
│   │   ├── Power/
│   │   └── MechanicalAssembly/
│   ├── behavior/                       # States, actions, events, scenarios
│   ├── alternatives/                   # LCD, OLED, LED configurations
│   ├── analysis/                       # Energy, cost, mass, geometry analyses
│   └── verification/                   # Verification cases and traceability
├── data/
│   ├── components/                     # Assumed component properties and costs
│   └── usage-profiles/                 # Workload and operating assumptions
├── scenarios/                          # Baseline and change scenarios
├── scripts/                            # Reproducible analysis/demo commands
├── docs/                               # Generated artifacts; avoid hand editing
└── tests/                              # Model checks and regression fixtures
```

Prefer **packages grouped by system/subsystem**, with requirements, specification, architecture, and integration material colocated where practical. Keep genuinely cross-cutting behavior, analyses, and reusable component definitions separate when that improves reuse. Avoid organizing everything strictly by SysML element type.

## 8. Engineering Models and Analyses

### 8.1 Display technology trade-off

Model three candidate configurations:

| Candidate | Potential benefit | Potential drawback |
| --- | --- | --- |
| Segmented LCD | Very low power, good static display efficiency | Limited visual flexibility; contrast/illumination constraints |
| OLED | Flexible graphics and strong contrast | Potentially higher and content-dependent power |
| Seven-segment LED | Familiar and potentially bright | Continuous illumination can require significant power |

Compare the options across at least these criteria:

- Readability and operating conditions.
- Active and standby current consumption.
- Unit and assembly cost.
- Dimensions, display aperture, and PCB routing/interface implications.
- MCU pin count, peripheral needs, and firmware complexity.
- Battery-life impact under the same usage profile.

Represent alternatives as configurations/variants using **valid SysML v2 variation modeling**, where supported. Avoid inventing syntax to demonstrate a feature.

### 8.2 Battery-life analysis

Start with a time-weighted current model:

\[
I_{avg} = \frac{\sum_i I_i t_i}{\sum_i t_i}
\]

\[
T_{life,h} = \frac{C_{usable,mAh}}{I_{avg,mA}}
\]

Where the states include at least idle/sleep, active countdown, display-active, and alarm-active operation. These states can overlap; use a **well-defined accounting scheme** (exclusive system modes or component-level current summation) to avoid double counting.

Initial example parameters for a demonstration calculation (not measured specifications):

| Parameter | Example value |
| --- | ---: |
| Battery nominal capacity | 220 mAh |
| Usable capacity factor | 80% |
| Idle current | 8 µA |
| Active-control current | 250 µA |
| Alarm current | 15 mA |
| Daily usage | 3 countdowns × 20 min |
| Alarm duration | 15 s per countdown |

The above example is deliberately simplified and **does not yet represent display current separately**. The implementation must define whether each current is a whole-system value or a component contribution and incorporate the chosen display into each relevant mode.

For realistic predictions, eventually account for battery self-discharge, pulse-current capability, voltage cutoff, temperature dependence, aging, and uncertainty. A coin cell may not support the assumed alarm peak current without additional design measures: treat peak current as a separate feasibility check.

### 8.3 Embedded behavior simulation

A first behavioral model should cover:

```text
Idle → Setting → Running → Alarm → Idle
                   ↕
                 Paused
```

Also specify cancel, button debouncing, zero-time transition, alarm dismissal, and invalid/edge input handling. Simulate timed events, state transitions, display updates, and entry/exit from low-power modes. Connect behavior to power consumption so changing firmware policies changes calculated energy use.

**Simulation acceptance:** given a predefined sequence of button events and elapsed time, the execution produces expected states, remaining-time values, alarm activation, and a reproducible energy estimate.

### 8.4 Mechanical packaging analysis

Model at minimum:

- Outer enclosure bounding dimensions.
- PCB and display footprints.
- Display aperture and button positions.
- Battery-holder placement and replaceability.
- Clearance and assembly constraints.
- Mass contributions for a simple mass budget.

Begin with parametric dimensions and constraints; integrate with CAD only after basic traceability and analyses work. SysML v2 should describe the engineering intent, not replace all detailed CAD geometry.

### 8.5 Cost and feasibility

Maintain a traceable BOM estimate with component costs, quantities, assumed production volume, and uncertainty. Add checks for MCU GPIO/peripherals, voltage compatibility, battery peak current, and mechanical clearance, rather than relying on average-current calculations alone.

## 9. Verification Strategy

Each critical requirement should link to one or more verification cases, with an explicit method and result status.

| Requirement class | Verification mechanism | Expected evidence |
| --- | --- | --- |
| Functional behavior | Discrete-event simulation | Scenario assertions and event trace |
| Battery life | Parametric/usage-profile analysis | Calculated lifetime plus assumptions |
| Timing accuracy | Oscillator error budget | Error estimate or measured clock result |
| Cost | BOM aggregation | Total estimated BOM and versioned prices |
| Dimensions/mass | Packaging and mass budget | Constraint check output |
| Display readability | Structured trade-off initially; physical test later | Decision rationale; test evidence when available |
| Alarm loudness | Supplier data initially; test later | Rating assumption and measured result when available |

Classify verification results as **pass, fail, or not yet verified**; distinguish analytical predictions from physical-test evidence. Where external/manual evidence is required, support importing or recording results without falsely implying that the model itself performed the test.

## 10. Elan8 Tooling Roles

| Tool / asset | Role in this demo |
| --- | --- |
| **Spec42** | Author, parse, validate, and visualize SysML v2 source; inspect diagrams and diagnostics |
| **Elan8 domain libraries** | Shared concepts for recursive decomposition, components, analyses, and generated documents |
| **Elan8 MBSE methodology** | Structure the engineering workflow and package organization |
| **Run42** *(planned / incremental)* | Execute supported behavioral and engineering simulations; initially use external scripts where needed |
| **Doc42** *(planned / incremental)* | Generate requirements, architecture, trade-off, and verification documentation from the model |
| **Git and CI** | Version design alternatives, validate models, run reproducible checks, publish results |

**Implementation principle:** the demo must be useful even when a planned tool capability is not yet available. Use small, clearly labeled adapters or scripts rather than pretending that incomplete features already exist.

## 11. Reference Workflow and Demo Commands

The target workflow is:

1. Clone repository and obtain required Elan8 tools/libraries.
2. Validate the model and generate useful system views.
3. Execute the baseline behavior and engineering analyses.
4. Run requirement/verification checks.
5. Select a display alternative or change a design parameter.
6. Re-run the same analyses and compare against baseline.
7. Generate project documentation.

The repository should eventually offer a compact command surface such as:

```sh
# Illustrative interface only — not yet implemented
./scripts/demo.sh validate
./scripts/demo.sh analyze --scenario baseline-lcd
./scripts/demo.sh analyze --scenario oled-alternative
./scripts/demo.sh verify --scenario oled-alternative
./scripts/demo.sh docs --scenario oled-alternative
```

Commands must exit non-zero on failures, produce machine-readable results (for example JSON), and generate readable summaries. Do not require a proprietary cloud service to reproduce the core demo.

## 12. Implementation Roadmap

### Milestone 1 — Modeling baseline

**Goal:** a coherent, navigable system model.

- Create repository scaffolding and package structure.
- Define context, use cases, and initial system requirements.
- Implement the recursive Black/Grey/White Box system decomposition.
- Model subsystem interfaces, connections, and software-to-hardware allocations.
- Produce useful Spec42 views and pass model validation.

**Done when:** a new engineer can understand the system architecture from the repository and generated views without a guided walkthrough.

### Milestone 2 — Executable engineering

**Goal:** make design changes produce quantifiable consequences.

- Add explicit component parameters and usage profiles.
- Implement battery-life and BOM analyses.
- Implement countdown behavioral simulation and scenario assertions.
- Introduce display variants and a reproducible comparison.
- Check numerical requirements and publish a structured result summary.

**Done when:** changing the display choice or duty cycle causes the expected analysis and verification outputs to change.

### Milestone 3 — Model-driven engineering deliverables

**Goal:** close the loop between model, evidence, and documentation.

- Trace analyses and verification cases to requirements.
- Generate SRS/architecture/trade-study/verification reports through Doc42 or a temporary generator.
- Add CI checks and a documented end-to-end demo script.
- Record design rationale and explain differences between baseline and alternative.

**Done when:** one command sequence validates, analyzes, verifies, and documents a chosen design scenario.

### Milestone 4 — Optional physical/detailed engineering extension

- Add detailed CAD or parametric enclosure generation.
- Add PCB design/interface export and realistic component selection.
- Build a physical prototype and capture measurements.
- Compare measured battery behavior, timing, and alarm performance to predictions.
- Feed test evidence back into traceability and reports.

Milestone 4 is explicitly **not required** to complete the initial end-to-end demo.

## 13. Definition of Done for the Initial Demo

The initial project is complete when all of the following hold:

- [ ] All SysML v2 source validates with the supported Spec42 version.
- [ ] The system model includes context, use cases, requirements, recursive decomposition, interfaces, and allocations.
- [ ] Baseline LCD and at least one alternative display are reproducible configurations.
- [ ] A battery-life calculation uses explicit, version-controlled assumptions and reflects display/firmware changes.
- [ ] The countdown behavior runs against at least one deterministic event sequence.
- [ ] Cost and at least one packaging constraint are checked.
- [ ] Important requirements have linked verification cases with clear result statuses.
- [ ] The baseline and alternative yield a visible, explainable trade-off or requirement impact.
- [ ] Generated engineering documentation is consistent with the selected configuration.
- [ ] A new user can run the demo using documented local commands.

## 14. Working Principles

- **SysML v2 is the engineering backbone.** Avoid an independent, manually maintained architecture hiding in scripts or documents.
- **One source of truth for each parameter.** Do not duplicate battery, display, or cost assumptions across models and analysis code without explicit data flow.
- **Executable results over decorative diagrams.** Prioritize meaningful cross-discipline effects and automatic checks.
- **Keep model fidelity honest.** Label assumptions, approximations, unsupported behavior, and manually entered evidence.
- **Prefer standard SysML v2 semantics.** Use Elan8 extensions only where they provide concrete value and document them.
- **Keep the example approachable.** A reader should be able to follow the whole engineering story in a short walkthrough.
- **Make every demo scenario reproducible.** Version inputs, results, and tool versions in Git or CI artifacts.

## 15. Open Decisions

Resolve these early, without blocking initial model creation:

1. **Physical baseline:** coin cell vs. AAA battery; whether the 2-year life target is realistic for the alarm and selected display.
2. **User interface:** exact button arrangement, default display behavior, and whether backlighting is required.
3. **Requirements:** final measurable readability criteria, reference usage profile, and alarm measurement conditions.
4. **Model library:** exact SysML v2 definitions and usage rules for `SystemSpecification`, `SystemArchitecture`, and `SystemIntegration`.
5. **Variant mechanism:** how configurations and alternatives are represented and selected in the currently supported toolchain.
6. **Execution boundary:** which analyses Run42 executes natively and which use standalone scripts in the first iteration.
7. **Document contracts:** minimal domain-library annotations needed by Doc42 and the initial generated document set.
8. **Data model:** whether component characteristic data live in SysML source, versioned external files, or a deliberate combination.

## 16. First Implementation Task

Start with a **model-only vertical slice**:

1. Create the root `KitchenTimer` model and context package.
2. Define `UC-01`, `UC-02`, and `UC-05`, plus a small subset of functional and battery-life requirements.
3. Build the Black Box specification for the complete timer.
4. Build a first Grey Box architecture containing user interface, control, power, and mechanical assembly.
5. Define a minimal set of ports/interfaces and trace selected requirements to responsible parts.
6. Validate the model with Spec42 and commit generated architecture views.

Do not start by building the simulator or CAD integration. First establish a valid SysML v2 model that serves as a stable foundation for the executable parts of the demo.
