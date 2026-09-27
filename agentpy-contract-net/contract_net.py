"""
Contract Net Protocol for manufacturing, simulated with AgentPy.

An OrderAgent sends a Call For Proposals (CFP) for a required operation.
Every MachineAgent with that capability replies with a PROPOSE (its processing
time). The order accepts the fastest bid and rejects the rest.

Run:  pip install agentpy  &&  python contract_net.py
"""
import agentpy as ap
import random

class MachineAgent(ap.Agent):
    def setup(self, capability="Generic"):
        self.capability = capability
        self.inbox = []
        print(f"MachineAgent {self.id} ready. Capability: {self.capability}")

    def step(self):
        for msg in self.inbox.copy():
            if msg["performative"] == "CFP":
                required = msg["content"]
                print(f"Machine {self.id} received CFP for: {required}")
                if self.capability == required:
                    bid = random.randint(10, 50)
                    print(f"Machine {self.id} bidding with time: {bid}")
                    reply = {
                        "performative": "PROPOSE",
                        "sender": self,
                        "content": bid
                    }
                    msg["sender"].inbox.append(reply)
                else:
                    print(f"Machine {self.id} cannot do {required}. Ignoring.")

            elif msg["performative"] == "ACCEPT_PROPOSAL":
                print(f">>> Machine {self.id} WON the job! Starting work...")

            elif msg["performative"] == "REJECT_PROPOSAL":
                print(f"Machine {self.id} was rejected. Waiting for next job.")

            self.inbox.remove(msg)


class OrderAgent(ap.Agent):
    def setup(self, required_operation="Generic"):
        self.required_operation = required_operation
        self.inbox = []
        self.state = 'seeking_machine'
        self.proposals = []
        print(f"OrderAgent {self.id} ready. Needs: {self.required_operation}")

    def step(self):
        if self.state == 'seeking_machine':
            message = {
                "performative": "CFP",
                "sender": self,
                "content": self.required_operation
            }
            for machine in self.target_machines:
                machine.inbox.append(message)
                print(f"Order {self.id}: Sent CFP to Machine {machine.id}")
            self.state = 'waiting_for_bids'

        elif self.state == 'waiting_for_bids':
            for msg in self.inbox.copy():
                if msg["performative"] == "PROPOSE":
                    print(f"Order {self.id}: Got proposal from "
                          f"Machine {msg['sender'].id} "
                          f"with time {msg['content']}")
                    self.proposals.append(msg)
                self.inbox.remove(msg)

            if len(self.proposals) > 0:
                best = min(self.proposals, key=lambda x: x["content"])
                print(f"\nOrder {self.id}: Best bid is from "
                      f"Machine {best['sender'].id} "
                      f"with time {best['content']}")

                for proposal in self.proposals:
                    if proposal == best:
                        accept = {
                            "performative": "ACCEPT_PROPOSAL",
                            "sender": self,
                            "content": "You got the job!"
                        }
                        proposal["sender"].inbox.append(accept)
                    else:
                        reject = {
                            "performative": "REJECT_PROPOSAL",
                            "sender": self,
                            "content": "Better luck next time."
                        }
                        proposal["sender"].inbox.append(reject)

                self.state = 'assigned'
                print(f"Order {self.id}: Job assigned. Done.\n")


class ManufacturingModel(ap.Model):
    def setup(self):
        self.machines = ap.AgentList(self, 2, MachineAgent,
                                     capability="Drilling")
        self.orders = ap.AgentList(self, 1, OrderAgent,
                                   required_operation="Drilling")
        self.orders[0].target_machines = self.machines
        print("--- Model setup complete ---\n")

    def step(self):
        self.orders.step()
        self.machines.step()


model = ManufacturingModel()
model.run(steps=5)