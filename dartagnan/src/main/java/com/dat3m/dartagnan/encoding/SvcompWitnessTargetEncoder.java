package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.Assert;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.axiom.Emptiness;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * The selected target events of a witness must constitute the violation of the property.
 *
 * Assertion-based properties (e.g., unreach-call): every selected target is an assertion
 * that is executed with a false condition.
 *
 * CAT specifications (e.g., no-data-race): the selected targets must form an edge, in either direction,
 * of the relation of a flagged non-emptiness axiom (e.g., the data-race relation). A single target must be
 * an endpoint of such an edge.
 *
 * For other properties, reaching the targets suffices.
 */
final class SvcompWitnessTargetEncoder {

    private final EncodingContext context;
    private final Property property;
    private final BooleanFormulaManager bmgr;

    SvcompWitnessTargetEncoder(EncodingContext context, Property property) {
        this.context = context;
        this.property = property;
        this.bmgr = context.getBooleanFormulaManager();
    }

    /** Takes, for each target waypoint, the selector of each of its candidate events. */
    BooleanFormula encode(List<Map<Event, BooleanFormula>> targets) {
        return switch (property) {
            case PROGRAM_SPEC -> encodeViolatedAssertions(targets);
            case CAT_SPEC -> encodeFlaggedEdges(targets);
            default -> bmgr.makeTrue();
        };
    }

    private BooleanFormula encodeViolatedAssertions(List<Map<Event, BooleanFormula>> targets) {
        final List<BooleanFormula> constraints = new ArrayList<>();
        for (Map<Event, BooleanFormula> target : targets) {
            target.forEach((event, selector) -> {
                if (!(event instanceof Assert assertion)) {
                    throw new IllegalStateException("Assertion target is not an assertion: " + event);
                }
                final BooleanFormula condition = context.getExpressionEncoder()
                        .encodeBooleanAt(assertion.getExpression(), assertion).formula();
                constraints.add(bmgr.implication(selector,
                        bmgr.and(context.execution(assertion), bmgr.not(condition))));
            });
        }
        return bmgr.and(constraints);
    }

    private BooleanFormula encodeFlaggedEdges(List<Map<Event, BooleanFormula>> targets) {
        if (targets.isEmpty()) {
            return bmgr.makeTrue();
        }
        if (targets.size() > 2) {
            throw new IllegalArgumentException("Witness for a CAT specification has more than two targets");
        }
        final List<Relation> relations = context.getTask().getMemoryModel().getAxioms().stream()
                .filter(axiom -> axiom.isFlagged() && axiom.isNegated() && axiom instanceof Emptiness)
                .map(Axiom::getRelation)
                .toList();
        if (relations.isEmpty()) {
            throw new IllegalArgumentException("Witness targets require a flagged non-emptiness axiom");
        }
        final List<BooleanFormula> constraints = new ArrayList<>();
        if (targets.size() == 2) {
            for (var first : targets.getFirst().entrySet()) {
                for (var second : targets.getLast().entrySet()) {
                    final Event e1 = first.getKey();
                    final Event e2 = second.getKey();
                    final List<BooleanFormula> edges = new ArrayList<>();
                    for (Relation relation : relations) {
                        final EncodingContext.EdgeEncoder edge = edgeEncoder(relation);
                        edges.add(edge.encode(e1, e2));
                        edges.add(edge.encode(e2, e1));
                    }
                    constraints.add(bmgr.implication(bmgr.and(first.getValue(), second.getValue()), bmgr.or(edges)));
                }
            }
        } else {
            for (var target : targets.getFirst().entrySet()) {
                final Event event = target.getKey();
                final List<BooleanFormula> edges = new ArrayList<>();
                for (Relation relation : relations) {
                    final EncodingContext.EdgeEncoder edge = edgeEncoder(relation);
                    mayGraph(relation).apply((e1, e2) -> {
                        if (e1 == event || e2 == event) {
                            edges.add(edge.encode(e1, e2));
                        }
                    });
                }
                constraints.add(bmgr.implication(target.getValue(), bmgr.or(edges)));
            }
        }
        return bmgr.and(constraints);
    }

    private EncodingContext.EdgeEncoder edgeEncoder(Relation relation) {
        if (!context.isEncoded(relation.getDefinition())) {
            throw new IllegalStateException("Flagged relation is not encoded: " + relation.getNameOrTerm());
        }
        return context.edge(relation);
    }

    private EventGraph mayGraph(Relation relation) {
        return context.getAnalysisContext().requires(RelationAnalysis.class).getKnowledge(relation).getMaySet();
    }
}
