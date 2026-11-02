package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.Init;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.program.event.core.RMWStore;
import com.dat3m.dartagnan.program.event.lang.svcomp.EndAtomic;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import org.sosy_lab.java_smt.api.BitvectorFormula;
import org.sosy_lab.java_smt.api.BitvectorFormulaManager;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.math.BigInteger;
import java.util.*;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.witness.svcomp.CatNames.CO_RELATION;
import static com.dat3m.dartagnan.witness.svcomp.CatNames.FR_RELATION;
import static com.dat3m.dartagnan.witness.svcomp.CatNames.HB_RELATION;
import static com.dat3m.dartagnan.witness.svcomp.CatNames.RF_RELATION;

/**
 * Orders the events of a candidate execution by ranks, the "witness clock". The ranks
 * respect every encoded hb-consistency edge and program order (the later may include
 * non-visible events) between executed events, and no event of another thread is
 * ranked inside an executed atomic section or read-modify-write pair. Thus, the order
 * is compatible with the memory model, while unrelated events may also be ordered.
 */
final class SvcompWitnessOrderEncoder {

    private static final String WITNESS_CLOCK = "witness-hb";

    private final EncodingContext context;
    private final Program program;
    private final BooleanFormulaManager bmgr;
    private final BitvectorFormulaManager bvmgr;
    private final int rankWidth;
    private final String clockPrefix;

    SvcompWitnessOrderEncoder(EncodingContext context) {
        this.context = context;
        this.program = context.getTask().getProgram();
        this.bmgr = context.getBooleanFormulaManager();
        this.bvmgr = context.getFormulaManager().getBitvectorFormulaManager();
        this.clockPrefix = context.getFormulaManager().escape(WITNESS_CLOCK) + " ";
        this.rankWidth = Math.max(1, BigInteger.valueOf(program.getThreadEvents().size() - 1).bitLength());
    }

    BooleanFormula before(Event first, Event second) {
        return bvmgr.lessThan(rank(first), rank(second), false);
    }

    /**
     * A rank that is an upper bound for events in segment {@code index - 1}
     * and a lower bound for events in segment {@code index}.
     */
    BitvectorFormula separator(int index) {
        return bvmgr.makeVariable(rankWidth, clockPrefix + "separator " + index);
    }

    BooleanFormula upperBound(Event event, BitvectorFormula separator) {
        return bvmgr.lessOrEquals(rank(event), separator, false);
    }

    BooleanFormula lowerBound(Event event, BitvectorFormula separator) {
        return bvmgr.lessThan(separator, rank(event), false);
    }

    private BitvectorFormula rank(Event event) {
        return bvmgr.makeVariable(rankWidth, clockPrefix + event.getGlobalId());
    }

    /**
     * Constrains the ranks of all events of the program.
     * Program order is only enforced for {@code waypointEvents} and the memory events of their threads.
     * The ranks also respect rf, co and fr, so the last write before an assumption is the write it observes,
     * and every executed event follows the given initial writes.
     */
    BooleanFormula encode(Set<Event> waypointEvents, List<Init> inits) {
        final List<BooleanFormula> constraints = new ArrayList<>();
        constraints.add(encodeRelationOrder(HB_RELATION));
        // The active set of hb-consistency may omit some rf, co and fr edges, which the clock would then not follow,
        // so we order it by these relations directly.
        constraints.add(encodeRelationOrder(RF_RELATION));
        constraints.add(encodeRelationOrder(CO_RELATION));
        constraints.add(encodeRelationOrder(FR_RELATION));

        final Set<Event> ordered = new LinkedHashSet<>(waypointEvents);
        for (EndAtomic end : program.getThreadEvents(EndAtomic.class)) {
            ordered.add(end.getBegin());
            ordered.add(end);
        }
        final Set<Event> orderedEvents = program.getThreadEvents(MemoryCoreEvent.class).stream()
                .filter(event -> !(event instanceof Init))
                .collect(Collectors.toCollection(LinkedHashSet::new));
        orderedEvents.addAll(ordered);
        constraints.add(encodeProgramOrder(ordered, orderedEvents));
        for (EndAtomic end : program.getThreadEvents(EndAtomic.class)) {
            constraints.add(encodeAtomicInterval(end.getBegin(), end, orderedEvents));
        }
        for (RMWStore store : program.getThreadEvents(RMWStore.class)) {
            constraints.add(encodeAtomicInterval(store.getLoadEvent(), store, orderedEvents));
        }
        for (Init init : inits) {
            for (Event event : orderedEvents) {
                constraints.add(bmgr.implication(context.execution(event), before(init, event)));
            }
        }
        return bmgr.and(constraints);
    }

    private BooleanFormula encodeRelationOrder(String name) {
        final Relation relation = encodedRelation(name);
        final List<BooleanFormula> constraints = new ArrayList<>();
        final EncodingContext.EdgeEncoder edge = context.edge(relation);
        maySet(relation).apply((first, second) ->
                constraints.add(bmgr.implication(edge.encode(first, second), before(first, second))));
        return bmgr.and(constraints);
    }

    private Relation encodedRelation(String name) {
        final Relation relation = context.getTask().getMemoryModel().getRelation(name);
        if (relation == null) {
            throw new IllegalArgumentException("Witness ordering requires the '" + name + "' relation");
        }
        if (!context.isEncoded(relation.getDefinition())) {
            throw new IllegalStateException("Witness ordering relation is not encoded: " + name);
        }
        return relation;
    }

    private EventGraph maySet(Relation relation) {
        return context.getAnalysisContext().requires(RelationAnalysis.class).getKnowledge(relation).getMaySet();
    }

    private BooleanFormula encodeProgramOrder(Set<Event> waypoints, Set<Event> events) {
        final List<BooleanFormula> constraints = new ArrayList<>();
        // Waypoints may be non-visible events.
        for (Event waypoint : waypoints) {
            for (Event event : events) {
                if (!waypoint.getThread().equals(event.getThread()) || waypoint == event
                        || (waypoints.contains(event) && event.getGlobalId() < waypoint.getGlobalId())) {
                    continue;
                }
                final BooleanFormula order = waypoint.getGlobalId() < event.getGlobalId()
                        ? before(waypoint, event) : before(event, waypoint);
                constraints.add(bmgr.implication(context.execution(waypoint, event), order));
            }
        }
        return bmgr.and(constraints);
    }

    private BooleanFormula encodeAtomicInterval(Event begin, Event end, Set<Event> events) {
        final List<Event> outsideAtomicBlock = events.stream()
                .filter(event -> !event.getThread().equals(begin.getThread()))
                .toList();
        final List<BooleanFormula> constraints = new ArrayList<>();
        constraints.add(bmgr.implication(context.execution(begin, end), before(begin, end)));
        for (Event event : outsideAtomicBlock) {
            constraints.add(bmgr.implication(bmgr.and(context.execution(begin, end), context.execution(event)),
                    bmgr.or(before(event, begin), before(end, event))));
        }
        return bmgr.and(constraints);
    }
}
