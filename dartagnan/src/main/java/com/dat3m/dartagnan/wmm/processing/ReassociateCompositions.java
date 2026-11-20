package com.dat3m.dartagnan.wmm.processing;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.Constraint;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.analysis.RelationEventDomains;
import com.dat3m.dartagnan.wmm.definition.Composition;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.*;

/*
    Reorders chains r1;r2;...;rn of compositions to reduce the encoding size, like a query optimizer orders joins.
    The parser composes them as ((r1;r2);r3);..., but the number of encoded may-triples depends on the order.
    We pick the order with the fewest may-triples, an estimate of the encoding size.
    Runs after the relation analysis, because it needs the may-sets of the ri.
 */
public class ReassociateCompositions {

    private static final Logger logger = LoggerFactory.getLogger(ReassociateCompositions.class);

    private ReassociateCompositions() {}

    public static ReassociateCompositions newInstance() {
        return new ReassociateCompositions();
    }

    public void run(Wmm wmm, RelationAnalysis ra, RelationEventDomains domains) {
        final Map<Relation, List<Constraint>> uses = new HashMap<>();
        for (Constraint c : wmm.getConstraints()) {
            for (Relation r : c.getConstrainedRelations()) {
                if (!(c instanceof Definition d && d.getDefinedRelation() == r)) {
                    uses.computeIfAbsent(r, _ -> new ArrayList<>()).add(c);
                }
            }
        }
        int changed = 0;
        long saved = 0;
        for (Relation root : List.copyOf(wmm.getRelations())) {
            if (!(root.getDefinition() instanceof Composition) || root.isRecursive() || isInlinable(root, uses)) {
                continue;
            }
            final List<Relation> operands = new ArrayList<>();
            final List<Relation> inner = new ArrayList<>();
            flatten(root, uses, operands, inner);
            if (operands.size() < 3) {
                continue;
            }
            final Plan plan = Plan.compute(operands, ra);
            final long current = cost(root, uses, ra);
            if (plan.cost() < current) {
                rebuild(wmm, ra, domains, root, operands, inner, plan);
                changed++;
                saved += current - plan.cost();
            }
        }
        logger.info("Reordered {} composition chains, saving {} may-triples.", changed, saved);
    }

    // ----------------------------------------------------------------------------------------------------------------

    private static boolean isInlinable(Relation r, Map<Relation, List<Constraint>> uses) {
        final List<Constraint> users = uses.getOrDefault(r, List.of());
        return !r.hasName() && !r.isRecursive() && r.getDefinition() instanceof Composition
                && users.size() == 1 && users.getFirst() instanceof Composition user
                && !user.getDefinedRelation().isRecursive();
    }

    private static void flatten(Relation root, Map<Relation, List<Constraint>> uses, List<Relation> operands, List<Relation> inner) {
        final Composition comp = (Composition) root.getDefinition();
        for (Relation op : List.of(comp.getLeftOperand(), comp.getRightOperand())) {
            if (isInlinable(op, uses)) {
                inner.add(op);
                flatten(op, uses, operands, inner);
            } else {
                operands.add(op);
            }
        }
    }

    private static long cost(Relation r, Map<Relation, List<Constraint>> uses, RelationAnalysis ra) {
        final Composition comp = (Composition) r.getDefinition();
        long cost = triples(ra.getKnowledge(comp.getLeftOperand()).getMaySet(),
                ra.getKnowledge(comp.getRightOperand()).getMaySet());
        for (Relation op : List.of(comp.getLeftOperand(), comp.getRightOperand())) {
            if (isInlinable(op, uses)) {
                cost += cost(op, uses, ra);
            }
        }
        return cost;
    }

    private static long triples(EventGraph left, EventGraph right) {
        final Map<Event, Set<Event>> out = right.getOutMap();
        long sum = 0;
        for (Map.Entry<Event, Set<Event>> in : left.getInMap().entrySet()) {
            sum += (long) in.getValue().size() * out.getOrDefault(in.getKey(), Set.of()).size();
        }
        return sum;
    }

    // Matrix-chain multiplication algorithm, with the number of may-triples as the cost of a composition.
    private record Plan(int[][] split, long cost) {
        static Plan compute(List<Relation> operands, RelationAnalysis ra) {
            final int n = operands.size();
            final EventGraph[][] may = new EventGraph[n][n];
            final long[][] cost = new long[n][n];
            final int[][] split = new int[n][n];
            for (int i = 0; i < n; i++) {
                may[i][i] = ra.getKnowledge(operands.get(i)).getMaySet();
            }
            for (int length = 2; length <= n; length++) {
                for (int i = 0; i + length - 1 < n; i++) {
                    final int j = i + length - 1;
                    cost[i][j] = Long.MAX_VALUE;
                    for (int k = i; k < j; k++) {
                        final long c = cost[i][k] + cost[k + 1][j] + triples(may[i][k], may[k + 1][j]);
                        if (c < cost[i][j]) {
                            cost[i][j] = c;
                            split[i][j] = k;
                        }
                    }
                    may[i][j] = ra.computeComposition(may[i][j - 1], may[j][j]).getMaySet();
                }
            }
            return new Plan(split, cost[0][n - 1]);
        }
    }

    private static void rebuild(Wmm wmm, RelationAnalysis ra, RelationEventDomains domains, Relation root,
                                List<Relation> operands, List<Relation> inner, Plan plan) {
        wmm.removeDefinition(root);
        for (Relation r : inner) {
            wmm.removeDefinition(r);
        }
        final Composition comp = build(wmm, ra, domains, root, operands, plan.split(), 0, operands.size() - 1);
        wmm.addDefinition(comp);
        for (Relation r : inner) {
            wmm.deleteRelation(r);
        }
    }

    private static Composition build(Wmm wmm, RelationAnalysis ra, RelationEventDomains domains, Relation target,
                                     List<Relation> operands, int[][] split, int i, int j) {
        final int k = split[i][j];
        final Relation left = subRelation(wmm, ra, domains, operands, split, i, k);
        final Relation right = subRelation(wmm, ra, domains, operands, split, k + 1, j);
        return new Composition(target, left, right);
    }

    private static Relation subRelation(Wmm wmm, RelationAnalysis ra, RelationEventDomains domains,
                                        List<Relation> operands, int[][] split, int i, int j) {
        if (i == j) {
            return operands.get(i);
        }
        final Relation relation = wmm.newRelation();
        wmm.addDefinition(build(wmm, ra, domains, relation, operands, split, i, j));
        domains.addRelation(relation);
        ra.addRelation(relation);
        return relation;
    }
}
