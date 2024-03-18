package com.dat3m.dartagnan.utils;

import com.google.common.collect.Iterables;
import com.google.common.collect.Lists;

import java.util.*;
import java.util.function.Function;

/*
    Description of dominator trees.

    Let G = (V, A, r) be a directed graph rooted in r.
    NOTE: In the following description we assume that all nodes in V are reachable from r.

    DEFINITION (Domination): A node w is dominated by v if all paths from r to w pass through v, i.e.,
    all those paths have the shape r ->* v ->* w.
    Note that every node v has dominators Dom(v), containing at least itself and the root.

    PROPOSITION: For every node that is not the root, there is a unique "closest/nearest" dominator,
                 the immediate dominator.

    DEFINITION (Dominator tree): The "immediate-dominator-relation" induces the dominator tree (rooted at r).
    A node w is strictly dominated by v if v is an ancestor in this tree (Dom(w) = {w} + all its ancestors).


   IMPLEMENTATION NOTES:
        - Based on Cooper's iterative algorithm.
        - There are more efficient implementations like SLT (Simple Lengauer-Tarjan)
          and Semi-NCA, but those are harder to implement.

 */
public final class DominatorTree<TNode> {

    private final TNode root;
    private final Comparator<TNode> reversePostOrder;
    private final Map<TNode, TNode> immDominator;

    public DominatorTree(TNode root, Function<TNode, ? extends Iterable<? extends TNode>> successors) {
        final List<TNode> reversePostOrderNodes = Lists.reverse(computePostOrder(root, successors));
        final Map<TNode, List<TNode>> predecessorMap = computePredecessorMap(root, successors);

        this.root = root;
        this.reversePostOrder = computeOrderFromSequence(reversePostOrderNodes);
        this.immDominator = computeDominatorTree(root, reversePostOrderNodes, predecessorMap, reversePostOrder);
    }

    public TNode getRoot() {
        return root;
    }

    public boolean isDominatedBy(TNode node, TNode dominator) {
        return getNearestCommonDominator(node, dominator) == dominator;
    }

    public TNode getImmediateDominator(TNode node) {
        return immDominator.get(node);
    }

    public TNode getNearestCommonDominator(TNode a, TNode b) {
        return intersect(a, b, immDominator, reversePostOrder);
    }

    public Iterable<TNode> getDominators(TNode node) {
        return () -> new Iterator<>() {
            TNode cur = node;
            @Override
            public boolean hasNext() { return cur != null; }
            @Override
            public TNode next() {
                final TNode ret = cur;
                cur = (cur == root) ? null : getImmediateDominator(cur);
                return ret;
            }
        };
    }

    public Iterable<TNode> getStrictDominators(TNode node) {
        return Iterables.skip(getDominators(node), 1);
    }

    // ===============================================================================================================
    // Internals

    private List<TNode> computePostOrder(TNode root, Function<TNode, ? extends Iterable<? extends TNode>> successors) {
        List<TNode> order = new ArrayList<>();
        Map<TNode, TNode> parentMap = new HashMap<>();

        parentMap.put(root, null);
        TNode cur = root;
        while (cur != null) {
            boolean childrenTraversed = true;
            for (TNode succ : successors.apply(cur)) {
                if (!parentMap.containsKey(succ)) {
                    parentMap.put(succ, cur);
                    cur = succ;
                    childrenTraversed = false;
                }
            }
            if (childrenTraversed) {
                order.add(cur);
                cur = parentMap.get(cur);
            }
        }

        assert order.get(order.size() - 1) == root;
        return order;
    }

    private Map<TNode, TNode> computeDominatorTree(
            TNode root,
            List<TNode> nodes,
            Map<TNode, List<TNode>> predecessorMap,
            Comparator<TNode> reversePostOrder
    ) {

        final Map<TNode, TNode> immDom = new HashMap<>();
        immDom.put(root, root);

        boolean changed = true;
        while (changed) {
            changed = false;
            for (TNode node : nodes) {
                if (node == root) {
                    continue;
                }
                TNode newDom = null;
                for (TNode pred : predecessorMap.get(node)) {
                    if (immDom.containsKey(pred)) {
                        newDom = (newDom == null) ? pred : intersect(newDom, pred, immDom, reversePostOrder);
                    }
                }
                if (immDom.get(node) != newDom) {
                    immDom.put(node, newDom);
                    changed = true;
                }
            }
        }

        return immDom;
    }

    private TNode intersect(TNode a, TNode b, Map<TNode, TNode> immDom, Comparator<? super TNode> reversePostOrder) {
        while (a != b) {
            if (reversePostOrder.compare(a, b) < 0) {
                b = immDom.get(b);
            } else {
                a = immDom.get(a);
            }
        }
        return a;
    }

    private Map<TNode, List<TNode>> computePredecessorMap(TNode root, Function<TNode, ? extends Iterable<? extends TNode>> successors) {
        Set<TNode> processed = new HashSet<>();
        Map<TNode, List<TNode>> predecessorMap = new HashMap<>();
        Deque<TNode> workqueue = new ArrayDeque<>();

        workqueue.add(root);
        while (!workqueue.isEmpty()) {
            final TNode cur = workqueue.remove();
            processed.add(cur);
            for (TNode succ : successors.apply(cur)) {
                predecessorMap.computeIfAbsent(succ, key -> new ArrayList<>()).add(cur);
                if (!processed.contains(succ)) {
                    workqueue.add(succ);
                }
            }
        }

        return predecessorMap;
    }

    private Comparator<TNode> computeOrderFromSequence(Iterable<TNode> seq) {
        final Map<TNode, Integer> orderNumbers = new HashMap<>();
        seq.forEach(n -> orderNumbers.put(n, orderNumbers.size()));
        return Comparator.comparingInt(orderNumbers::get);
    }
}
