package lab3;

import jade.core.behaviours.OneShotBehaviour;
import jade.domain.DFService;
import jade.domain.FIPAAgentManagement.DFAgentDescription;
import jade.domain.FIPAAgentManagement.ServiceDescription;
import jade.domain.FIPAException;
import jade.lang.acl.ACLMessage;

public class OrderBehaviour extends OneShotBehaviour {

    private static final long serialVersionUID = 1L;
    private String requestedOperation;

    public OrderBehaviour(String operation) {
        this.requestedOperation = operation;
    }

    @Override
    public void action() {

        DFAgentDescription template = new DFAgentDescription();
        ServiceDescription sd = new ServiceDescription();
        sd.setType("manufacturing-operation");
        sd.setName(requestedOperation);
        template.addServices(sd);

        try {
            DFAgentDescription[] result = DFService.search(myAgent, template);

            if (result == null || result.length == 0) {
                System.out.println(myAgent.getLocalName() + ": No machines found for " + requestedOperation);
                return;
            }

            System.out.println(myAgent.getLocalName() + ": Found " + result.length + " machine(s). Sending CFP...");

            ACLMessage cfp = new ACLMessage(ACLMessage.CFP);
            cfp.setContent(requestedOperation);

            for (DFAgentDescription d : result) {
                cfp.addReceiver(d.getName());
                System.out.println(" - CFP sent to: " + d.getName().getLocalName());
            }

            myAgent.send(cfp);

            ((OrderAgent) myAgent).setExpectedProposals(result.length);

        } catch (FIPAException fe) {
            fe.printStackTrace();
        }
    }
}