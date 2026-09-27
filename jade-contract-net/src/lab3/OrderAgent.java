package lab3;

import jade.core.Agent;
import jade.core.behaviours.CyclicBehaviour;
import jade.lang.acl.ACLMessage;
import jade.lang.acl.MessageTemplate;

import java.util.ArrayList;
import java.util.List;

public class OrderAgent extends Agent {

    private static final long serialVersionUID = 1L;
    private String requestedOperation;
    private int expectedProposals = 0;
    private List<ACLMessage> receivedProposals = new ArrayList<>();

    public void setExpectedProposals(int count) {
        this.expectedProposals = count;
    }

    @Override
    protected void setup() {
        Object[] args = getArguments();
        if (args != null && args.length > 0) {
            requestedOperation = (String) args[0];
            System.out.println(getLocalName() + " started. Needs: " + requestedOperation);
        }

        addBehaviour(new OrderBehaviour(requestedOperation));

        addBehaviour(new CyclicBehaviour() {
            @Override
            public void action() {
                MessageTemplate mt = MessageTemplate.MatchPerformative(ACLMessage.PROPOSE);
                ACLMessage msg = receive(mt);

                if (msg != null) {
                    receivedProposals.add(msg);
                    System.out.println(getLocalName() + " got PROPOSE from "
                            + msg.getSender().getLocalName()
                            + " with bid: " + msg.getContent());

                    if (receivedProposals.size() == expectedProposals) {
                        evaluateProposals();
                    }
                } else {
                    block();
                }
            }
        });
    }

    private void evaluateProposals() {
        ACLMessage best = null;
        int lowestBid = Integer.MAX_VALUE;

        for (ACLMessage proposal : receivedProposals) {
            try {
                int bid = Integer.parseInt(proposal.getContent().trim());
                if (bid < lowestBid) {
                    lowestBid = bid;
                    best = proposal;
                }
            } catch (NumberFormatException e) {
                System.out.println("Invalid bid from: "
                        + proposal.getSender().getLocalName());
            }
        }

        for (ACLMessage proposal : receivedProposals) {
            ACLMessage reply = proposal.createReply();
            if (proposal == best) {
                reply.setPerformative(ACLMessage.ACCEPT_PROPOSAL);
                reply.setContent("You are selected! Bid: " + lowestBid);
                System.out.println(getLocalName() + " ACCEPTED: "
                        + proposal.getSender().getLocalName()
                        + " (bid=" + lowestBid + ")");
            } else {
                reply.setPerformative(ACLMessage.REJECT_PROPOSAL);
                reply.setContent("Better bid received.");
                System.out.println(getLocalName() + " REJECTED: "
                        + proposal.getSender().getLocalName());
            }
            send(reply);
        }
        receivedProposals.clear();
    }

    @Override
    protected void takeDown() {
        System.out.println(getLocalName() + " terminating.");
    }
}