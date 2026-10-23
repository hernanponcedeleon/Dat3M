package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.Init;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.program.event.core.RMWStore;
import com.dat3m.dartagnan.program.event.lang.svcomp.EndAtomic;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import org.sosy_lab.java_smt.api.BitvectorFormulaManager;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.util.*;

import static com.dat3m.dartagnan.witness.svcomp.SvcompProperty.HB_RELATION;

/**
 * Orders the events of a candidate execution by bitvector ranks, the "witness clock".
 * The ranks respect every encoded hb-consistency edge and program order between executed events of the same thread,
 * and no event of another thread is ranked inside an executed atomic section or read-modify-write pair.
 * Thus, the order is compatible with the memory model, while unrelated events may also be ordered.
 */
final class WitnessOrderEncoder {

    private static final String WITNESS_CLOCK = "witness-hb";

    private final EncodingContext context;
    private final Program program;
    private final BooleanFormulaManager bmgr;
    private final BitvectorFormulaManager bvmgr;
    private final int rankWidth;
    private final String clockPrefix;

    WitnessOrderEncoder(EncodingContext context) {
        this.context = context;
        this.program = context.getTask().getProgram();
        this.bmgr = context.getBooleanFormulaManager();
        this.bvmgr = context.getFormulaManager().getBitvectorFormulaManager();
        this.clockPrefix = context.getFormulaManager().escape(WITNESS_CLOCK) + " ";
        // Every integer ordering of N events can be ranked from 0 to N - 1.
        // Use unsigned comparisons without arithmetic, so ranks cannot wrap around.
        this.rankWidth = Math.max(1, Integer.SIZE - Integer.numberOfLeadingZeros(
                program.getThreadEvents().size() - 1));
    }

    /** The rank of {@code first} is strictly smaller than the rank of {@code second}. */
    BooleanFormula before(Event first, Event second) {
        return bvmgr.lessThan(bvmgr.makeVariable(rankWidth, clockPrefix + first.getGlobalId()),
                bvmgr.makeVariable(rankWidth, clockPrefix + second.getGlobalId()), false);
    }

    /**
     * Constrains the ranks of all events of the program.
     * Program order is only enforced for {@code waypointEvents} and the memory events of their threads.
     * With {@code hasValues}, snapshots also respect communication inside atomic sections,
     * and every executed event follows the given initial writes.
     */
    BooleanFormula encode(Set<Event> waypointEvents, List<Init> inits, boolean hasValues) {
        final List<BooleanFormula> constraints = new ArrayList<>();
        constraints.add(encodeRelationOrder(HB_RELATION));
        if (hasValues) {
            constraints.add(encodeRelationOrder("com"));
        }

        // Atomic sections restrict the interleaving, independently of whether assumptions constrain values.
        final Set<Event> ordered = new LinkedHashSet<>(waypointEvents);
        for (EndAtomic end : program.getThreadEvents(EndAtomic.class)) {
            ordered.add(end.getBegin());
            ordered.add(end);
        }
        final Set<Event> orderedEvents = new LinkedHashSet<>(program.getThreadEvents(MemoryCoreEvent.class));
        orderedEvents.addAll(ordered);
        constraints.add(encodeProgramOrder(ordered, orderedEvents));
        for (EndAtomic end : program.getThreadEvents(EndAtomic.class)) {
            constraints.add(encodeAtomicInterval(end.getBegin(), end, orderedEvents));
        }
        for (RMWStore store : program.getThreadEvents(RMWStore.class)) {
            constraints.add(encodeAtomicInterval(store.getLoadEvent(), store, orderedEvents));
        }

        if (hasValues) {
            for (Init init : inits) {
                for (Event event : orderedEvents) {
                    if (!(event instanceof Init)) {
                        constraints.add(bmgr.implication(context.execution(event), before(init, event)));
                    }
                }
            }
        }
        return bmgr.and(constraints);
    }

    private BooleanFormula encodeRelationOrder(String name) {
        final Relation relation = context.getTask().getMemoryModel().getRelation(name);
        if (relation == null) {
            throw new IllegalArgumentException("Witness ordering requires the '" + name + "' relation");
        }
        if (!context.isEncoded(relation.getDefinition())) {
            throw new IllegalStateException("Witness ordering relation is not encoded: " + name);
        }
        final List<BooleanFormula> constraints = new ArrayList<>();
        final var may = context.getAnalysisContext().requires(RelationAnalysis.class).getKnowledge(relation).getMaySet();
        final EncodingContext.EdgeEncoder edge = context.edge(relation);
        // Clocks respect every actual edge, but may also order unrelated events.
        may.apply((first, second) -> constraints.add(bmgr.implication(edge.encode(first, second), before(first, second))));
        return bmgr.and(constraints);
    }

    private BooleanFormula encodeProgramOrder(Set<Event> waypoints, Collection<Event> events) {
        final List<BooleanFormula> constraints = new ArrayList<>();
        // Waypoints may refer to non-memory events outside the memory-model relation.
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

    private BooleanFormula encodeAtomicInterval(Event begin, Event end, Collection<Event> events) {
        final List<BooleanFormula> constraints = new ArrayList<>();
        constraints.add(bmgr.implication(context.execution(begin, end), before(begin, end)));
        for (Event event : events) {
            if (!event.getThread().equals(begin.getThread()) && !(event instanceof Init)) {
                constraints.add(bmgr.implication(bmgr.and(context.execution(begin, end), context.execution(event)),
                        bmgr.or(before(event, begin), before(end, event))));
            }
        }
        return bmgr.and(constraints);
    }
}
