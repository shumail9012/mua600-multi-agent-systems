# Final Project – Agent-Controlled Production Cell (CMAS)

A small cyber-physical production flow controlled entirely by agents in **CMAS**, a multi-agent platform for manufacturing. Every physical resource (two sources, a gantry crane, two processes and a sink) is a **resource agent** with its own logic and skills. Every product is a **part agent** that works through its own list of goals. The agents drive a simulated cell through **Modbus TCP**. There is no central controller or global sequence.

## The cell

```
 Source1 (X=55)   Source2 (X=158)        Process1 (X=450)   Process2 (X=650)        Sink (X=945)
      │                 │                       ▲                  ▲                    ▲
      └── Part1 ────────┼── crane ──────────────┘                  │                    │
                        └── Part2 ──── crane ──────────────────────┘                    │
                                       Part1 / Part2 ──── crane ────────────────────────┘
```

| Agent | Type | Skill (process plan) | What it does |
|-------|------|----------------------|--------------|
| Source1, Source2 | Resource | – | Watch their part sensor and deploy a new part agent (`Part1` / `Part2`) when a product appears |
| Crane | Resource | `sMove` via `ifCrane` | Full pick-and-place: travel height → source X → descend → vacuum on → rise → destination X → descend → release → rise. Position feedback has a ±10 tolerance |
| Process1, Process2 | Resource | `sProcess` via `ifProcess` | Wait for a part on their sensor, start the machine, wait for it to start and then finish |
| Sink | Resource | `sArrive` via `ifSink` | Confirms the part has completed its route |
| Part1, Part2 | Part | – | Goal list: **MoveToProcess → RunProcess → MoveToSink → Arrive**, each with its own parameters (e.g. Part1: source 55 → Process1 at 450 → sink 945) |

Parts don't know *how* the crane moves or *how* a process runs. They only request a service through an interface (`ifCrane`, `ifProcess`, `ifSink`) and pass parameters such as `sourceX` and `destX`. Adding a new machine or product type means adding an agent, not rewriting a central program.

## Modbus I/O map

All I/O goes to `modbus.tcp:127.0.0.1`, the same gantry-crane simulator register layout as in [Programming-for-automation](https://github.com/shumail9012/Programming-for-automation).

| Register | Signal | Register | Signal |
|---|---|---|---|
| 1 / 2 | Crane set X / set Y | 15 / 16 | Crane position X / Y |
| 3 | Vacuum gripper | 17 / 18 | Source 1 / Source 2 part sensor |
| 4 / 5 | Process 1 / 2 run | 19 / 20 | Process 1 / 2 running |
| | | 21 / 22 | Process part sensors |

## Files

- `ProjectE4.cmas`: the complete CMAS model (open in CMAS 2.14 or later)
- `agent-programs/`: every agent's program exported as plain text for reading on GitHub (CMAS's Pascal-like Structured Text):
  - `Source1.pas`, `Source2.pas`: part detection and deployment
  - `Crane_sMove.pas`: the pick-and-place skill
  - `Process1_sProcess.pas`, `Process2_sProcess.pas`: machine control skills
  - `Sink_sArrive.pas`, plus the `onDeploy` setup of each resource

## Design reflections

- **Centralized alternative.** One PLC-style controller would read every sensor, keep a global state table, and command every crane move and process start itself. That is simple to verify for a small cell, but it becomes a large monolithic state machine that has to be rewritten whenever a resource or product type changes. The agent version keeps that knowledge local.
- **Ethics.** Autonomous coordination can displace material-handling jobs. Networked agents widen the attack surface. Agents that command physical motion must never override certified safety layers. Distributed decisions need logging so actions stay traceable and accountable.
- **Adoption barriers.** Industry is slow to adopt multi-agent systems because engineers are used to centralized PLC design, there are no agent standards on top of OPC UA or fieldbuses, integrating with legacy systems costs money, and distributed behaviour is hard to verify and certify.
