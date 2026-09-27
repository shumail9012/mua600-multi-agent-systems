# Contract Net in JADE

A FIPA **Contract Net Protocol** between order and machine agents on the [JADE](https://jade.tilab.com/) agent platform.

```
OrderAgent                       DF (yellow pages)            MachineAgent ×N
    │── search "manufacturing-operation: <op>" ──▶│                  │
    │◀──────────── matching machines ─────────────│                  │
    │── CFP (<op>) ─────────────────────────────────────────────────▶│
    │◀──────────────────────────────────────────── PROPOSE (time) ───│
    │── ACCEPT_PROPOSAL (lowest time) / REJECT_PROPOSAL (others) ───▶│
```

| Class | Role |
|-------|------|
| `MachineAgent` | Registers its machine type with the **Directory Facilitator** as a `manufacturing-operation` service. Answers every CFP with a random processing time (10–50). Deregisters on shutdown. |
| `OrderBehaviour` | One-shot behaviour: searches the DF for machines offering the required operation, sends them a CFP, and tells the order agent how many proposals to expect. |
| `OrderAgent` | Collects `PROPOSE` messages with a message template. Once every machine has answered, it accepts the lowest bid and rejects the rest. |

## Running

Requires JDK 8+ and `jade.jar` (JADE 4.x).

```bash
javac -cp jade.jar -d classes src/lab3/*.java
java -cp "jade.jar:classes" jade.Boot -gui -agents \
  "Drill1:lab3.MachineAgent(Drilling);Drill2:lab3.MachineAgent(Drilling);Mill1:lab3.MachineAgent(Milling);Order1:lab3.OrderAgent(Drilling)"
```

Start the machine agents before the order agent, so they are registered in the DF when the order searches for them. In this example, only the two drilling machines receive the CFP.
