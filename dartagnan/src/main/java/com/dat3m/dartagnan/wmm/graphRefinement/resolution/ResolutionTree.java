package com.dat3m.dartagnan.wmm.graphRefinement.resolution;

import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.CoLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.Conjunction;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class ResolutionTree {

    private SearchNode root;

    private Set<CoLiteral> presentLiterals;

    public List<Conjunction<CoreLiteral>> resolve() {
        return null;
    }

    private void reduceTree() {
        removeUnproductiveNodes();

        List<LeafNode> leaves = new ArrayList<>();
        findLeafsRecursive(root, leaves);



    }

    private void removeUnproductiveNodes() {
        List<LeafNode> leaves = (List<LeafNode>)root.findNodes(SearchNode::isLeaf);

        // Remove violations that are unproductive
        boolean progress = false;
        do {
            Set<CoreLiteral> resolvableLits = new HashSet<>();
            leaves.forEach(x -> x.violations.forEach(y -> resolvableLits.addAll(y.getResolvableLiterals())));

            for (LeafNode leaf : leaves) {
                progress |= leaf.violations.removeIf(x -> x.getResolvableLiterals().stream()
                        .anyMatch(lit -> !resolvableLits.contains(lit)));
            }
        } while (progress);

        // Replace empty leaves
        for (LeafNode leaf : leaves) {
            if (leaf.violations.isEmpty()) {
                leaf.delete();
            }
        }
        leaves.removeIf(x -> x.violations.isEmpty());

        // Remove decision nodes with empty branches
        for (LeafNode leaf : leaves) {
            if (!leaf.violations.isEmpty()) {
                continue;
            }

            DecisionNode decNode = leaf.parent;
            SearchNode otherBranch = decNode.positive == leaf ? decNode.negative : decNode.positive;
            decNode.replaceBy(otherBranch);

            if (decNode.isRoot()) {
                root = otherBranch;
            }
        }
    }

    private void computeResolvableLiteralsRecursive(SearchNode node, Set<CoreLiteral> lits) {
        if (node.isLeaf()) {
            LeafNode leaf = (LeafNode)node;
            leaf.violations.forEach(x -> lits.addAll(x.getResolvableLiterals()));
        } else if (node.isDecisionNode()) {
            DecisionNode decNode = (DecisionNode)node;
            computeResolvableLiteralsRecursive(decNode.positive, lits);
            computeResolvableLiteralsRecursive(decNode.negative, lits);
        }
    }

    private void findLeafsRecursive(SearchNode node, List<LeafNode> leafs) {
        if (node.isLeaf()) {
            leafs.add((LeafNode)node);
        } else if (node.isDecisionNode()) {
            DecisionNode decNode = (DecisionNode)node;
            findLeafsRecursive(decNode.positive, leafs);
            findLeafsRecursive(decNode.negative, leafs);
        }
    }


}
