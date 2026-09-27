# LLM Agents with AutoGen

Manufacturing agents built on [AutoGen](https://github.com/microsoft/autogen), with a **local Llama 3** model served by [Ollama](https://ollama.com/) through its OpenAI-compatible API. No cloud API is used. Each machine's behaviour comes from its system prompt, not from code.

| Script | Setup |
|--------|-------|
| `one_to_one_negotiation.py` | An **Order_Manager** (UserProxyAgent) negotiates a milling job with one **Milling_Machine** agent for up to 3 automatic replies. |
| `group_bidding.py` | An LLM version of the contract net. **Drill_A** (older, slower: 30–50 min) and **Drill_B** (fast but busy: 15–25 min) bid in a **GroupChat**. The order manager awards `CONTRACT AWARDED` to the fastest, sends `REJECTED` to the others, and ends the chat with `TERMINATE`. |

![Group chat output](images/group_chat_output.png)

## What the run showed

The agents answer in character. Drill_A introduces itself as "an older but reliable" machine and bids 42 minutes, which stays inside its prompt's range. But it also *estimates Drill_B's time for it*, speaking on behalf of another agent. This is typical of LLM agents: flexible and natural, but not strictly bound to their role or to a protocol. That makes them less suitable than deterministic agents for controlling real equipment.

## Running

```bash
# 1. Install Ollama and pull the model
ollama pull llama3
ollama serve            # serves http://127.0.0.1:11434

# 2. Install AutoGen (0.2-style API)
pip install "pyautogen<0.3"

python one_to_one_negotiation.py
python group_bidding.py
```

AutoGen logs a harmless "model llama3 is not found … cost will be 0" warning, because it has no price table for local models.
