package com.dat3m.dartagnan.model.execution;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.encoding.IREvaluator;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.BlockingEvent;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.misc.NonDetValue;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.definition.SameLocation;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MapEventGraph;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigInteger;
import java.util.*;

/*
    Extracts an Execution from an SMT model. This is the only place where the SMT model is accessed;
    the resulting Execution does not keep any reference to it.

    Relations:
      - Base relations are read from the SMT model, except for "loc" which is computed from the concrete addresses.
        Edges in the must-set are present iff both events are executed, so only may-but-not-must edges are queried.
      - Derived relations are computed on demand by the Execution from the base relations (see RelationEvaluator),
        because the SMT encoding only constrains derived edges that are relevant to the axioms (active sets).
 */
public final class ExecutionBuilder {

    private static final Logger logger = LoggerFactory.getLogger(ExecutionBuilder.class);

    private final IREvaluator model;
    private final EncodingContext context;
    private final Program program;
    private final Wmm memoryModel;

    private final Set<Event> executed = new HashSet<>();
    private final Map<MemoryCoreEvent, Expression> addresses = new HashMap<>();
    private final Map<MemoryCoreEvent, Expression> values = new HashMap<>();
    private final Map<RegWriter, Expression> results = new HashMap<>();
    private final Set<CondJump> takenJumps = new HashSet<>();
    private final Set<Assert> violatedAssertions = new HashSet<>();

    private ExecutionBuilder(IREvaluator model) {
        this.model = model;
        this.context = model.getEncodingContext();
        this.program = context.getTask().getProgram();
        this.memoryModel = context.getTask().getMemoryModel();
    }

    public static Execution fromModel(IREvaluator model) {
        return new ExecutionBuilder(model).build();
    }

    private Execution build() {
        final List<ThreadExecution> threads = program.getThreads().stream().map(this::extractThread).toList();
        final Map<NonDetValue, Expression> nondetValues = extractNondetValues();
        final MemoryLayout layout = extractMemoryLayout();
        final Map<Relation, EventGraph> relations = extractBaseRelations();
        return new Execution(program, memoryModel, threads, addresses, values, results, takenJumps,
                violatedAssertions, nondetValues, layout, relations);
    }

    // ======================================================================================================
    // Program

    private ThreadExecution extractThread(Thread thread) {
        // Programs are unrolled (acyclic), so the executed events in program order form the thread's trace.
        final List<Event> trace = new ArrayList<>();
        final List<BlockingEvent> blocked = new ArrayList<>();
        for (Event e : thread.getEvents()) {
            if (!model.isExecuted(e)) {
                continue;
            }
            trace.add(e);
            executed.add(e);
            extractEventData(e);
            if (e instanceof BlockingEvent b && model.isBlocked(b)) {
                blocked.add(b);
            }
        }
        return new ThreadExecution(thread, trace, blocked);
    }

    private void extractEventData(Event e) {
        if (e instanceof MemoryCoreEvent memEvent) {
            addresses.put(memEvent, ValueConverter.toExpression(model.address(memEvent)));
            if (memEvent instanceof Load || memEvent instanceof Store) {
                values.put(memEvent, ValueConverter.toExpression(model.value(memEvent)));
            }
        }
        if (e instanceof RegWriter writer) {
            try {
                results.put(writer, ValueConverter.toExpression(model.result(writer)));
            } catch (UnsupportedOperationException ex) {
                logger.warn("Could not extract result of {}: {}", writer, ex.getMessage());
            }
        }
        if (e instanceof CondJump jump && model.jumpTaken(jump)) {
            takenJumps.add(jump);
        }
        if (e instanceof Assert assertion && model.assertionViolated(assertion)) {
            violatedAssertions.add(assertion);
        }
    }

    private Map<NonDetValue, Expression> extractNondetValues() {
        final Map<NonDetValue, Expression> nondetValues = new HashMap<>();
        for (NonDetValue nonDet : program.getConstants()) {
            try {
                nondetValues.put(nonDet, ValueConverter.toExpression(model.evaluateFinal(nonDet)));
            } catch (UnsupportedOperationException ex) {
                logger.warn("Could not extract value of {}: {}", nonDet, ex.getMessage());
            }
        }
        return nondetValues;
    }

    private MemoryLayout extractMemoryLayout() {
        final List<MemoryLayout.AllocatedObject> objects = new ArrayList<>();
        for (MemoryObject obj : program.getMemory().getObjects()) {
            if (model.isAllocated(obj)) {
                final BigInteger address = ValueConverter.toUnsigned(ValueConverter.toExpression(model.address(obj)));
                objects.add(new MemoryLayout.AllocatedObject(obj, address, model.size(obj).value()));
            }
        }
        return new MemoryLayout(objects);
    }

    // ======================================================================================================
    // Memory model

    private Map<Relation, EventGraph> extractBaseRelations() {
        final Map<Relation, EventGraph> base = new HashMap<>();
        for (Relation r : memoryModel.getRelations()) {
            if (RelationEvaluator.isBase(r)) {
                base.put(r, r.getDefinition() instanceof SameLocation ? computeSameLocation() : extractFromModel(r));
            }
        }
        return base;
    }

    private EventGraph extractFromModel(Relation relation) {
        final RelationAnalysis.Knowledge knowledge = context.getAnalysisContext().get(RelationAnalysis.class)
                .getKnowledge(relation);
        final EventGraph must = knowledge.getMustSet();
        final EncodingContext.EdgeEncoder edge = context.edge(relation);
        final MapEventGraph graph = new MapEventGraph();
        knowledge.getMaySet().apply((e1, e2) -> {
            if (executed.contains(e1) && executed.contains(e2) && (must.contains(e1, e2) || model.hasEdge(edge, e1, e2))) {
                graph.add(e1, e2);
            }
        });
        return graph;
    }

    private EventGraph computeSameLocation() {
        final Map<BigInteger, Set<Event>> byAddress = new HashMap<>();
        addresses.forEach((e, addr) ->
                byAddress.computeIfAbsent(ValueConverter.toUnsigned(addr), _ -> new HashSet<>()).add(e));
        final MapEventGraph graph = new MapEventGraph();
        for (Set<Event> events : byAddress.values()) {
            events.forEach(e -> graph.addRange(e, events));
        }
        return graph;
    }
}
