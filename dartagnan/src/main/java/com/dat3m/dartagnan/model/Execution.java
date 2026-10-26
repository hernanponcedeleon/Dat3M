package com.dat3m.dartagnan.model;

import com.dat3m.dartagnan.encoding.IREvaluator;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.booleans.BoolLiteral;
import com.dat3m.dartagnan.expression.misc.NamedExpression;
import com.dat3m.dartagnan.expression.processing.ExprSimplifier;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.BlockingEvent;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.memory.FinalMemoryValue;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.misc.NonDetValue;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import com.google.common.base.Preconditions;

import java.math.BigInteger;
import java.util.*;

import static com.dat3m.dartagnan.expression.utils.ExpressionHelper.isConstant;
import static com.dat3m.dartagnan.expression.utils.ExpressionHelper.toUnsignedValue;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.CO;

/*
    A concrete execution of a program under a memory model, expressed purely in terms of Dartagnan's IR.

    In contrast to IREvaluator, this class does not depend on an SMT model: once constructed (e.g. via
    Execution.fromModel), it stays valid even after the solver and its model are closed.
    All values are represented as constant IR expressions (IntLiteral, BoolLiteral, ...).

    Since programs are unrolled, every event is executed at most once, so IR events identify executed events.
    Instances are immutable (derived relations are computed lazily from the base relations, which is thread-safe).
 */
public final class Execution {

    private final Program program;
    private final Wmm memoryModel;

    private final List<ThreadExecution> threads;
    private final Map<Thread, ThreadExecution> threadMap;
    // All executed events, thread by thread in program order. The index of an event is its id in this execution.
    private final List<Event> events;
    private final Map<Event, Integer> eventIds;

    private final Map<MemoryCoreEvent, Expression> addresses;
    private final Map<MemoryCoreEvent, Expression> values;
    private final Map<RegWriter, Expression> results;
    private final Set<CondJump> takenJumps;
    private final Set<Assert> violatedAssertions;
    private final Map<NonDetValue, Expression> nondetValues;

    private final MemoryLayout memoryLayout;
    // Contains all base relations; derived relations are computed on demand and cached.
    private final Map<Relation, EventGraph> relations;

    // Derived lookup structures
    private final Map<BigInteger, List<MemoryCoreEvent>> accessesByAddress;

    Execution(Program program, Wmm memoryModel, List<ThreadExecution> threads,
              Map<MemoryCoreEvent, Expression> addresses, Map<MemoryCoreEvent, Expression> values,
              Map<RegWriter, Expression> results, Set<CondJump> takenJumps, Set<Assert> violatedAssertions,
              Map<NonDetValue, Expression> nondetValues, MemoryLayout memoryLayout,
              Map<Relation, EventGraph> baseRelations) {
        this.program = program;
        this.memoryModel = memoryModel;
        this.threads = List.copyOf(threads);
        this.addresses = Map.copyOf(addresses);
        this.values = Map.copyOf(values);
        this.results = Map.copyOf(results);
        this.takenJumps = Set.copyOf(takenJumps);
        this.violatedAssertions = Set.copyOf(violatedAssertions);
        this.nondetValues = Map.copyOf(nondetValues);
        this.memoryLayout = memoryLayout;
        this.relations = new HashMap<>(baseRelations);

        final Map<Thread, ThreadExecution> threadMap = new LinkedHashMap<>();
        final List<Event> events = new ArrayList<>();
        final Map<Event, Integer> eventIds = new HashMap<>();
        for (ThreadExecution t : this.threads) {
            threadMap.put(t.getThread(), t);
            for (Event e : t.getTrace()) {
                eventIds.put(e, events.size());
                events.add(e);
            }
        }
        this.threadMap = Collections.unmodifiableMap(threadMap);
        this.events = Collections.unmodifiableList(events);
        this.eventIds = eventIds;

        final Map<BigInteger, List<MemoryCoreEvent>> accessesByAddress = new HashMap<>();
        for (Event e : events) {
            if (e instanceof MemoryCoreEvent memEvent) {
                accessesByAddress.computeIfAbsent(toUnsignedValue(this.addresses.get(memEvent)),
                        _ -> new ArrayList<>()).add(memEvent);
            }
        }
        accessesByAddress.replaceAll((_, list) -> List.copyOf(list));
        this.accessesByAddress = Collections.unmodifiableMap(accessesByAddress);
    }

    public static Execution fromModel(IREvaluator model) {
        return ExecutionBuilder.fromModel(model);
    }

    // ======================================================================================================
    // General

    public Program getProgram() {
        return program;
    }

    public Wmm getMemoryModel() {
        return memoryModel;
    }

    // ======================================================================================================
    // Threads & events

    // All threads of the program, including those that have not started.
    public List<ThreadExecution> getThreads() {
        return threads;
    }

    public ThreadExecution getThread(Thread thread) {
        final ThreadExecution t = threadMap.get(thread);
        Preconditions.checkArgument(t != null, "Unknown thread %s", thread);
        return t;
    }

    public boolean threadHasStarted(Thread thread) {
        return getThread(thread).hasStarted();
    }

    public List<Event> getEvents() {
        return events;
    }

    public <T extends Event> List<T> getEvents(Class<T> cls) {
        return events.stream().filter(cls::isInstance).map(cls::cast).toList();
    }

    public boolean isExecuted(Event e) {
        return eventIds.containsKey(e);
    }

    // Dense id of an executed event (its index in getEvents()).
    public int getId(Event e) {
        return eventIds.get(checkExecuted(e));
    }

    // ======================================================================================================
    // Control flow & local values

    public boolean jumpTaken(CondJump jump) {
        return takenJumps.contains(checkExecuted(jump));
    }

    public boolean isBlocked(BlockingEvent event) {
        return getThread(checkExecuted(event).getThread()).getBlockedEvents().contains(event);
    }

    public boolean assertionViolated(Assert assertion) {
        return violatedAssertions.contains(assertion);
    }

    // The value chosen for a nondeterministic value of the program.
    public Optional<Expression> value(NonDetValue nonDet) {
        return Optional.ofNullable(nondetValues.get(nonDet));
    }

    public record RegisterRead(Register register, Event reader) { }

    // Register reads that happen before any write to that register in the same thread.
    public List<RegisterRead> getUninitializedRegisterReads() {
        final List<RegisterRead> reads = new ArrayList<>();
        for (ThreadExecution thread : threads) {
            final List<Event> trace = thread.getTrace();
            for (int i = 0; i < trace.size(); i++) {
                if (trace.get(i) instanceof RegReader reader) {
                    for (Register.Read read : reader.getRegisterReads()) {
                        if (thread.getLastWriterBefore(read.register(), i).isEmpty()) {
                            reads.add(new RegisterRead(read.register(), reader));
                        }
                    }
                }
            }
        }
        return reads;
    }

    public Expression result(RegWriter writer) {
        final Expression result = results.get(checkExecuted(writer));
        Preconditions.checkState(result != null, "No result for %s", writer);
        return result;
    }

    // ======================================================================================================
    // Memory

    public MemoryLayout getMemoryLayout() {
        return memoryLayout;
    }

    public Expression address(MemoryCoreEvent e) {
        return addresses.get(checkExecuted(e));
    }

    // The accessed address of the event as an unsigned number.
    public BigInteger addressValue(MemoryCoreEvent e) {
        return toUnsignedValue(address(e));
    }

    // The accessed memory location of the event, if it lies within an allocated object.
    public Optional<MemoryLayout.Location> location(MemoryCoreEvent e) {
        return memoryLayout.resolve(addressValue(e));
    }

    // The value read or written by a load or store, respectively.
    public Expression value(MemoryCoreEvent e) {
        final Expression value = values.get(checkExecuted(e));
        Preconditions.checkArgument(value != null, "Event %s has no value", e);
        return value;
    }

    // All executed memory events accessing exactly the given (unsigned) address.
    public List<MemoryCoreEvent> getAccesses(BigInteger address) {
        return accessesByAddress.getOrDefault(address, List.of());
    }

    public Set<BigInteger> getAccessedAddresses() {
        return accessesByAddress.keySet();
    }

    // The co-maximal store to the given address, if the memory model defines "co" and there are stores.
    public Optional<Store> getFinalStore(BigInteger address) {
        final Relation coRelation = memoryModel.getRelation(CO);
        if (coRelation == null) {
            return Optional.empty();
        }
        final EventGraph co = getRelation(coRelation);
        final List<Store> stores = getAccesses(address).stream()
                .filter(Store.class::isInstance).map(Store.class::cast).toList();
        return stores.stream()
                .filter(s -> stores.stream().noneMatch(other -> other != s && co.contains(s, other)))
                .findFirst();
    }

    // ======================================================================================================
    // Memory model

    public synchronized EventGraph getRelation(Relation relation) {
        Preconditions.checkArgument(memoryModel.getRelations().contains(relation), "Unknown relation %s", relation);
        if (!relations.containsKey(relation)) {
            relations.putAll(RelationEvaluator.computeDerived(List.of(relation), relations));
        }
        return relations.get(relation);
    }

    public Optional<EventGraph> getRelation(String name) {
        return Optional.ofNullable(memoryModel.getRelation(name)).map(this::getRelation);
    }

    public boolean hasEdge(Relation relation, Event a, Event b) {
        return getRelation(relation).contains(a, b);
    }

    public boolean hasElement(Relation relation, Event a) {
        Preconditions.checkArgument(relation.isSet(), "Non-unary relation %s", relation);
        return getRelation(relation).contains(a, a);
    }

    public boolean isSatisfied(Axiom axiom) {
        return RelationEvaluator.isSatisfied(axiom, getRelation(axiom.getRelation()));
    }

    /*
        Flagged axioms (e.g. "flag ~empty race") whose condition holds in this execution, i.e., that raise their flag.
        These are the axioms that IREvaluator.isFlaggedAxiomViolated reports as violated.
     */
    public List<Axiom> getRaisedFlags() {
        return memoryModel.getAxioms().stream().filter(Axiom::isFlagged).filter(this::isSatisfied).toList();
    }

    // ======================================================================================================
    // Expression evaluation

    /*
        Evaluates the expression at the given (executed) event, i.e., registers take the values they have
        right before the event executes. Returns empty if the expression cannot be reduced to a constant,
        e.g., because it reads an uninitialized register or contains unsupported operations.
     */
    public Optional<Expression> evaluateAt(Expression expression, Event at) {
        final ThreadExecution thread = getThread(checkExecuted(at).getThread());
        return evaluate(expression, new Substitution(thread, thread.getPosition(at)));
    }

    // Evaluates the expression in the final state of the execution.
    public Optional<Expression> evaluateFinal(Expression expression) {
        return evaluate(expression, new Substitution(null, -1));
    }

    public Optional<Boolean> evaluateBooleanAt(Expression expression, Event at) {
        return evaluateAt(expression, at).map(e -> ((BoolLiteral) e).getValue());
    }

    public Optional<Boolean> evaluateBooleanFinal(Expression expression) {
        return evaluateFinal(expression).map(e -> ((BoolLiteral) e).getValue());
    }

    private Optional<Expression> evaluate(Expression expression, Substitution substitution) {
        try {
            final Expression value = expression
                    .accept(substitution)
                    .accept(new ExprSimplifier(true));
            return isConstant(value) ? Optional.of(value) : Optional.empty();
        } catch (NotEvaluableException _) {
            return Optional.empty();
        }
    }

    private <T extends Event> T checkExecuted(T e) {
        Preconditions.checkArgument(isExecuted(e), "Event %s is not executed", e);
        return e;
    }

    private static final class NotEvaluableException extends RuntimeException {
        NotEvaluableException() {
            super(null, null, false, false);
        }
    }

    // Replaces program-specific leaves (registers, addresses, final memory values) by their concrete values.
    private final class Substitution extends ExprTransformer {

        // The thread and position at which we evaluate, or null for the final state.
        private final ThreadExecution thread;
        private final int position;

        private Substitution(ThreadExecution thread, int position) {
            this.thread = thread;
            this.position = position;
        }

        @Override
        public Expression visitRegister(Register reg) {
            final Optional<RegWriter> writer;
            if (thread != null) {
                writer = thread.getLastWriterBefore(reg, position);
            } else {
                final Function function = reg.getFunction();
                if (!(function instanceof Thread t) || !threadMap.containsKey(t)) {
                    throw new NotEvaluableException();
                }
                writer = threadMap.get(t).getLastWriter(reg);
            }
            if (writer.isPresent()) {
                return results.get(writer.get());
            }
            if (program.registersAreZeroInitialized()) {
                return expressions.makeGeneralZero(reg.getType());
            }
            throw new NotEvaluableException();
        }

        @Override
        public Expression visitMemoryObject(MemoryObject memObj) {
            final Optional<MemoryLayout.AllocatedObject> obj = memoryLayout.get(memObj);
            if (obj.isEmpty() || !(memObj.getType() instanceof IntegerType type)) {
                throw new NotEvaluableException();
            }
            return expressions.makeValue(obj.get().address(), type);
        }

        @Override
        public Expression visitFinalMemoryValue(FinalMemoryValue val) {
            Preconditions.checkState(thread == null, "Cannot evaluate final memory value %s at an event", val);
            final Optional<MemoryLayout.AllocatedObject> obj = memoryLayout.get(val.getMemoryObject());
            if (obj.isEmpty()) {
                throw new NotEvaluableException();
            }
            final BigInteger address = obj.get().address().add(BigInteger.valueOf(val.getOffset()));
            final Optional<Store> store = getFinalStore(address);
            if (store.isEmpty()) {
                throw new NotEvaluableException();
            }
            // Same (relaxed) conversion as used by the encoding of final memory values: the stored value may
            // have a different size than the final value, e.g., in mixed-size accesses.
            try {
                return expressions.makeCastOverMemory(values.get(store.get()), val.getType(), false);
            } catch (IllegalArgumentException | UnsupportedOperationException _) {
                throw new NotEvaluableException();
            }
        }

        @Override
        public Expression visitNamedExpression(NamedExpression expr) {
            // Names (e.g. of litmus variables) would prevent constant folding.
            return expr.getOperand().accept(this);
        }

        @Override
        public Expression visitNonDetValue(NonDetValue nonDet) {
            final Expression value = nondetValues.get(nonDet);
            if (value == null) {
                throw new NotEvaluableException();
            }
            return value;
        }

        @Override
        public Expression visitFunction(Function function) {
            throw new NotEvaluableException();
        }
    }
}
