# Multi-Agent Systems for Manufacturing (MUA600)

Labs and final project from the **MUA600 Multi-Agent Systems** course in the M.Sc. programme in AI and Automation at University West, Sweden (Spring 2026).

The same manufacturing problem runs through the course: **orders need machines, and machines compete for jobs**. It is solved with four agent approaches, from classic FIPA agents to LLM agents. The final project then uses agents to control a simulated production cell over Modbus.

| Folder | Framework | What it shows |
|--------|-----------|---------------|
| [agent-interaction-design](agent-interaction-design/) | UML | Sequence diagram of a part moving through a cell of sensors, belts, a station and a robot |
| [jade-contract-net](jade-contract-net/) | **JADE** (Java, FIPA-ACL) | Machines register their skills in the Directory Facilitator; an order agent finds them and runs a contract net |
| [agentpy-contract-net](agentpy-contract-net/) | **AgentPy** (Python) | The same contract net as a step-based simulation with message inboxes |
| [autogen-llm-agents](autogen-llm-agents/) | **AutoGen** + local **Llama 3** (Ollama) | LLM machine agents negotiate processing times in natural language; an order manager awards the contract |
| [project-cmas-production-cell](project-cmas-production-cell/) | **CMAS** | **Final project.** Resource and part agents control a two-source, two-process production cell with a gantry crane over Modbus TCP |

## Comparing the approaches

| | JADE | AgentPy | AutoGen (LLM) | CMAS |
|---|---|---|---|---|
| Communication | FIPA-ACL messages (CFP, PROPOSE, ACCEPT/REJECT) | Python dicts in agent inboxes | Natural-language chat | Parts request services through skill interfaces |
| Discovery | Directory Facilitator (yellow pages) | Agent lists set in the model | Group-chat manager picks the speaker | Interface matching between part goals and resource skills |
| Behaviour | Deterministic | Deterministic, stepped | Non-deterministic, prompt-driven | Deterministic, connected to real I/O |
| Best suited for | Distributed agent platforms | Simulation and experiments | Flexible reasoning and human-like negotiation | Controlling physical production resources |

The LLM agents are the most flexible, but also the least predictable. In the group chat, an agent even estimated its competitor's time. For time-critical and safety-relevant control, the deterministic, resource-centric CMAS approach fits much better.

**Author:** Shumail Alam Khan
