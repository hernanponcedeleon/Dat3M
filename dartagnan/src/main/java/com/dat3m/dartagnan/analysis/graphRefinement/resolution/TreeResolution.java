package com.dat3m.dartagnan.analysis.graphRefinement.resolution;

import com.dat3m.dartagnan.analysis.graphRefinement.coreReason.CoLiteral;
import com.dat3m.dartagnan.analysis.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.analysis.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.analysis.graphRefinement.logic.SortedClauseSet;
import com.dat3m.dartagnan.analysis.graphRefinement.searchTree.DecisionNode;
import com.dat3m.dartagnan.analysis.graphRefinement.searchTree.LeafNode;
import com.dat3m.dartagnan.analysis.graphRefinement.searchTree.SearchNode;
import com.dat3m.dartagnan.analysis.graphRefinement.searchTree.SearchTree;

import java.util.*;

public class TreeResolution {

    private final SearchTree tree;

    public TreeResolution(SearchTree tree) {
        this.tree = tree;
    }

    public SortedClauseSet<CoreLiteral> computeViolations() {
        reduceTree();

        List<Conjunction<CoreLiteral>> vio = computeViolations(tree.getRoot());
        SortedClauseSet<CoreLiteral> result = new SortedClauseSet<>(vio.size());
        result.addAll(vio);
        result.simplify();
        return result;
    }


    private List<Conjunction<CoreLiteral>> computeViolations(SearchNode node) {
        if (node.isEmptyNode()) {
            return Collections.emptyList();
        } else if (node.isLeaf()) {
            return ((LeafNode)node).getViolations();
        } else {
            DecisionNode decNode = (DecisionNode) node;
            CoreLiteral resLit = new CoLiteral(decNode.getEdge());
            List<Conjunction<CoreLiteral>> positive = computeViolations(decNode.getPositive());
            List<Conjunction<CoreLiteral>> negative = computeViolations(decNode.getNegative());

            List<Conjunction<CoreLiteral>> violations = new ArrayList<>();

            // Move all non-resolvable violations to <violations>
            ListIterator<Conjunction<CoreLiteral>> iter = negative.listIterator();
            while (iter.hasNext()) {
                Conjunction<CoreLiteral> c = iter.next();
                if (!(c.getLiterals().contains(resLit) || c.getLiterals().contains(resLit.getOpposite()))) {
                    violations.add(c);
                    iter.remove();
                }
            }

            for (Conjunction<CoreLiteral> c1 : positive) {
                // Move all non-resolvable violations to <violations>
                if (!c1.getLiterals().contains(resLit)) {
                    violations.add(c1);
                } else {
                    // Resolve
                    for (Conjunction<CoreLiteral> c2 : negative) {
                        Conjunction<CoreLiteral> resolvent = c1.resolveOn(c2, resLit);
                        if (!resolvent.isFalse()) {
                            violations.add(resolvent);
                        }
                    }
                }
            }

            // ==== TEST CODE =====
            //TODO: Remove the ugly conversion to clauseSet for minimization
            // Remark: clauseSet.simplify does in general not give as good reduction as the reduction performed
            // by DNF.reduce. However, right now it seems that they are equivalently strong for 1-SAT at least
            SortedClauseSet<CoreLiteral> clauseSet = new SortedClauseSet<>(violations.size());
            clauseSet.addAll(violations);
            clauseSet.simplify();
            violations.clear();
            violations.addAll(clauseSet.getClauses());
            return violations;

        }
    }

    // ============= Preprocessing ================

    private void reduceTree() {
        removeUnproductiveNodes();
    }

    private void removeUnproductiveNodes() {
        List<LeafNode> leaves = (List<LeafNode>)tree.getRoot().findNodes(SearchNode::isLeaf);

        // Remove violations that are unproductive
        boolean progress;
        do {
            progress = false;
            Set<CoreLiteral> resolvableLits = new HashSet<>();
            leaves.forEach(x -> x.getViolations().forEach(y -> resolvableLits.addAll(y.getResolvableLiterals())));

            for (LeafNode leaf : leaves) {
                progress |= leaf.getViolations().removeIf(x -> x.getResolvableLiterals().stream()
                        .anyMatch(lit -> !resolvableLits.contains(lit.getOpposite())));
            }
        } while (progress);


        // Remove decision nodes with some empty branch
        for (LeafNode leaf : leaves) {
            if (!leaf.getViolations().isEmpty()) {
                continue;
            }

            DecisionNode decNode = leaf.getParent();
            SearchNode otherBranch = decNode.getPositive() == leaf ? decNode.getNegative() : decNode.getPositive();
            if (otherBranch != null) {
                decNode.replaceBy(otherBranch);
            } else {
                throw new IllegalStateException("Empty branches in TreeResolution. Probably some reason computation bug (again).");
            }
        }
    }
}
