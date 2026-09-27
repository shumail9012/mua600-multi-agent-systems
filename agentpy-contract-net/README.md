# Contract Net in AgentPy

The same order/machine contract net as the JADE lab, built as a discrete-step simulation in [AgentPy](https://agentpy.readthedocs.io/). Agents talk by appending FIPA-style messages (`CFP`, `PROPOSE`, `ACCEPT_PROPOSAL`, `REJECT_PROPOSAL`) to each other's inboxes. The order agent is a small state machine: `seeking_machine` → `waiting_for_bids` → `assigned`.

Machines only bid on jobs that match their capability, so an order for *Drilling* is ignored by a *Milling* machine.

```bash
pip install agentpy
python contract_net.py
```

Example output:

```
Order 3: Sent CFP to Machine 1
Order 3: Sent CFP to Machine 2
Machine 1 bidding with time: 26
Machine 2 bidding with time: 47
Order 3: Best bid is from Machine 1 with time 26
>>> Machine 1 WON the job! Starting work...
Machine 2 was rejected. Waiting for next job.
```

Compared with JADE, there is no platform, no directory service and no real concurrency. Agents act in a fixed order each step, which makes runs reproducible and easy to analyse.
