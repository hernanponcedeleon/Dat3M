package com.dat3m.dartagnan.wmm.graphRefinement;

import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.RelationData;
import com.dat3m.dartagnan.wmm.graphRefinement.edgeSet.EdgeSet;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.DNF;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.Literal;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.SortedClauseSet;
import com.dat3m.dartagnan.wmm.utils.Tuple;

import java.util.*;

// Not used right now.
public class ReasonGraph {

    private Map<Node, Node> nodes;
    private Set<Node> violations;

    public ReasonGraph() {
        nodes = new HashMap<>();
        violations = new HashSet<>();
    }

    public boolean hasViolations() {
        return !violations.isEmpty();
    }

    public Set<Node> getViolations() {
        return violations;
    }
    public Set<Node> getNodes() {
        return nodes.keySet();
    }

    public void initialize() {
        nodes.clear();
        violations.clear();
    }

    public void forgetHistory(int from) {
        Iterator<Node> nodeIterator = nodes.values().iterator();
        while (nodeIterator.hasNext()) {
            Node next = nodeIterator.next();
            if (next.time > from) {
                nodeIterator.remove();
                if (next.relData.isAxiom())
                    violations.remove(next);
            }
            else
                next.forgetHistory(from);
        }

    }

    public void mergeHistory(int mergePoint) {
        for (Node node : nodes.values())
            node.time = Math.min(node.time, mergePoint);
    }

    // Adds a node at time <time> if it doesn't exist. Otherwise, returns the existing one regardless of the time.
    public Node addNode(RelationData relData, Tuple edge, int time) {
        Node retVal = new Node(relData, edge);
        retVal.time = time;
        if (!nodes.containsKey(retVal)) {
            nodes.put(retVal, retVal);
            if (relData.isAxiom())
                violations.add(retVal);
        }
        else
            retVal = nodes.get(retVal);
        return retVal;
    }

    public Node addNode(EdgeSet edgeSet, Tuple edge, int time) {
        return addNode(edgeSet.getRelation(), edge, time);
    }

    // for recursive relations we might want to add/get the inner node instead
    public Node getNode(RelationData relData, Tuple edge) {
        Node retVal = new Node(relData, edge);
        retVal = nodes.getOrDefault(retVal, null);
        if (retVal == null)
            throw new NoSuchElementException("This node does not exist in the reason graph: " + relData.toString() + edge.toString());
        return retVal;
    }

    public Node getNode(EdgeSet edgeSet, Tuple edge) {
        return getNode(edgeSet.getRelation(), edge);
    }

    public static class Node implements Literal<Node>
    {
        RelationData relData;
        Tuple edge;
        int time;
        // Maybe we want to have a modifiable formula instead of an immutable here.
        public DNF<Node> reasons;
        public SortedClauseSet<Node> sortedReasons = new SortedClauseSet<>();
        Conjunction<CoreLiteral> coreReason;

        public Node(RelationData relData, Tuple edge) {
            this.relData = relData;
            this.edge = edge;
            reasons = DNF.FALSE;
        }

        private void forgetHistory(int from) {
            // tracking a sort of earliest and latest time might give an early decision on whether something
            // should be removed
            sortedReasons.removeWhere(x -> x.time > from);

           /* Set<Conjunction<Node>> branchesToForget = new HashSet<>();
            for (Conjunction<Node> cube : reasons.getCubes()) {
                for (Node node : cube.getLiterals()) {
                    if (node.time > from) {
                        branchesToForget.add(cube);
                        break;
                    }
                }
            }
            reasons = reasons.remove(branchesToForget);*/
        }

        public void addReason(Node reason) {
            Conjunction<Node> clause = new Conjunction(reason);
            this.sortedReasons.add(clause);
            //this.reasons = this.reasons.or(new DNF<>(clause));
        }

        public void addReason(Node... reasons) {
            Conjunction<Node> clause = new Conjunction(reasons);
            this.sortedReasons.add(clause);
            //this.reasons = this.reasons.or(new DNF<>(clause);
        }

        public void setCoreReason(Conjunction<CoreLiteral> coreReason) {
            this.coreReason = coreReason;

        }
        public void setCoreReason(CoreLiteral ...coreLiterals) {
            setCoreReason(new Conjunction<>(coreLiterals));
        }

        private boolean visited = false;
        public DNF<CoreLiteral> computeCoreReason() {
            if (this.coreReason != null)
                return new DNF<CoreLiteral>(coreReason);
            else if (visited) {
                return DNF.FALSE;
            } else {
                visited = true; // Prevent recursive exploration of dependencies
                DNF<CoreLiteral> result = DNF.FALSE;
                for (Conjunction<Node> cube : reasons.getCubes()) {
                    DNF<CoreLiteral> temp = DNF.TRUE;
                    for (Node node : cube.getLiterals()) {
                        temp = temp.and(node.computeCoreReason());
                        if (temp.isFalse())
                            break;
                    }
                    result = result.or(temp);
                }
                visited = false;
                return result;
            }
        }

        public DNF<CoreLiteral> computeSingleCoreReason() {
            if (this.coreReason != null)
                return new DNF<>(coreReason);
            else if (visited) {
                return DNF.FALSE;
            } else {
                visited = true; // Prevent recursive exploration of dependencies
                DNF<CoreLiteral> result = DNF.FALSE;
                for (Conjunction<Node> cube : reasons.getCubes()) {
                    if (!hasValue(cube))
                        continue;
                    DNF<CoreLiteral> temp = DNF.TRUE;
                    for (Node node : cube.getLiterals()) {
                        temp = temp.and(node.computeSingleCoreReason());
                        if (temp.isFalse())
                            break;
                    }
                    result = result.or(temp);
                    break;
                }
                visited = false;
                return result;
            }
        }
        // test
        public Conjunction<CoreLiteral> getSingleCoreReason() {
            if (coreReason != null)
                return coreReason;
            if (this.visited) {
                return Conjunction.FALSE;
            }
            int i = 0;
            while (!hasValue(sortedReasons.get(i)))
                i++;

            visited = true;
            Conjunction<CoreLiteral> res = Conjunction.TRUE;
            for (Node node : sortedReasons.get(i).getLiterals()) {
                res = res.and(node.getSingleCoreReason());
            }
            visited = false;
            return res;
        }


        private boolean hasValue(Conjunction<Node> cube) {
            for (Node node : cube.getLiterals()) {
                if (node.visited)
                    return false;
            }
            return true;
        }

        @Override
        public int hashCode() {
            return relData.hashCode() + 31 * edge.hashCode();
        }

        @Override
        public boolean equals(Object obj) {
            if (this == obj)
                return true;
            if (obj == null || !(obj instanceof  Node))
                return false;
            Node other = (Node)obj;
            return this.relData.equals(other.relData) && this.edge.equals(other.edge);
        }

        @Override
        public String toString() {
            return relData.getRelation().toString() + eventsTostring();
        }

        private String eventsTostring() {
            return "(" + edge.getFirst().getCId() + ", " + edge.getSecond().getCId() +  ")";
        }

        @Override
        public boolean hasOpposite() {
            return false;
        }

        @Override
        public Node getOpposite() {
            return null;
        }
    }
}
