package com.dat3m.dartagnan.wmm.graphRefinement.resolution;

import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.CoLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.SortedClauseSet;

import java.util.*;
import java.util.stream.Collectors;

public class ResolutionTree {

    private DecisionNode root;



    public SearchNode getRootNode() { return root.positive;}
    public void setRootNode(SearchNode root) { this.root.positive.replaceBy(root); }

    public ResolutionTree() {
        root = new FakeNode();
    }

    public SortedClauseSet<CoreLiteral> computeViolations() {
        reduceTree();

        List<Conjunction<CoreLiteral>> vio = computeViolations(getRootNode());
        SortedClauseSet<CoreLiteral> result = new SortedClauseSet<>(vio.size());
        result.addAll(vio);
        result.simplify();
        return result;
    }

    private List<Conjunction<CoreLiteral>> computeViolations(SearchNode node) {
        if (node.isEmptyNode()) {
            return Collections.emptyList();
        } else if (node.isLeaf()) {
            return ((LeafNode)node).violations;
        } else {
            DecisionNode decNode = (DecisionNode) node;
            CoreLiteral resLit = decNode.chosenLiteral;
            List<Conjunction<CoreLiteral>> positive = computeViolations(decNode.positive);
            List<Conjunction<CoreLiteral>> negative = computeViolations(decNode.negative);

            List<Conjunction<CoreLiteral>> violations = new ArrayList<>();

            ListIterator<Conjunction<CoreLiteral>> iter = negative.listIterator();
            while (iter.hasNext()) {
                Conjunction<CoreLiteral> c = iter.next();
                if (!(c.getLiterals().contains(resLit) || c.getLiterals().contains(resLit.getOpposite()))) {
                    violations.add(c);
                    iter.remove();
                }
            }

            for (Conjunction<CoreLiteral> c1 : positive) {
                if (!c1.getLiterals().contains(resLit)) {
                    violations.add(c1);
                } else {
                    for (Conjunction<CoreLiteral> c2 : negative) {
                        Conjunction<CoreLiteral> resolvent = c1.resolveOn(c2, resLit);
                        if (!resolvent.isFalse()) {
                            violations.add(resolvent);
                        }
                    }
                }
            }

            // ============ TEST CODE =============
            // TODO: Replace this by more reasonable code
            SortedClauseSet<CoreLiteral> clauseSet = new SortedClauseSet<>(violations.size());
            clauseSet.addAll(violations);
            clauseSet.simplify();
            violations.clear();
            for (Conjunction<CoreLiteral> c : clauseSet)
                violations.add(c);
            return violations;
        }
    }

    private void reduceTree() {
        removeUnproductiveNodes();
    }

    private void removeUnproductiveNodes() {
        List<LeafNode> leaves = (List<LeafNode>)getRootNode().findNodes(SearchNode::isLeaf);

        // Remove violations that are unproductive
        boolean progress;
        do {
            progress = false;
            Set<CoreLiteral> resolvableLits = new HashSet<>();
            leaves.forEach(x -> x.violations.forEach(y -> resolvableLits.addAll(y.getResolvableLiterals())));

            for (LeafNode leaf : leaves) {
                progress |= leaf.violations.removeIf(x -> x.getResolvableLiterals().stream()
                        .anyMatch(lit -> !resolvableLits.contains(lit.getOpposite())));
            }
        } while (progress);


        // Remove decision nodes with some empty branch
        for (LeafNode leaf : leaves) {
            if (!leaf.violations.isEmpty()) {
                continue;
            }

            DecisionNode decNode = leaf.parent;
            SearchNode otherBranch = decNode.positive == leaf ? decNode.negative : decNode.positive;
            decNode.replaceBy(otherBranch);

            /*if (decNode.isRoot()) {
                root = otherBranch;
            }*/
        }
    }


    private static class FakeNode extends DecisionNode {

        public FakeNode() {
            super(null);
        }

        public SearchNode getTrueNode() { return positive; }
    }


}
