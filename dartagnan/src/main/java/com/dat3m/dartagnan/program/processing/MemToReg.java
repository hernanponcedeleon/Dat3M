package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntBinaryExpr;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.event.core.*;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.*;

/*
 * Replaces memory accesses that involve addresses that are only used by one thread.
 * Loops are allowed, this analysis ensures termination by storing local copies for each destination of a backwards jump.
 * On each function, the iteration happens on the finite function lattice E -> (((R+A) -> (A+top))+bot):
 * A is the finite set of allocation events.
 * E is the finite set of events.
 * R is the finite set of registers.
 * A+top is the co-semi-lattice with new top element over A.
 * (R+A) -> (A+top) is the function semi-lattice over A+1.
 * ((R+A) -> (A+top))+bot is the lattice with new bottom element over (R+A) -> (A+top).
 * Tracks when a register or address contains an address.
 * Unifies all global addresses into one element represented by {@code null}.
 * TODO also replace memcpy memset memcmp.  Currently treated as calls to unknown.
 * TODO Thread-local variables were already created as MemoryObject and are not removed, yet.
 */
public class MemToReg implements FunctionProcessor {

    private static final Logger logger = LogManager.getLogger(MemToReg.class);

    private MemToReg() {
    }

    public static MemToReg fromConfig(Configuration config) throws InvalidConfigurationException {
        return new MemToReg();
    }

    @Override
    public void run(Function function) {
        logger.trace("Processing function \"{}\".", function.getName());
        final Matcher info = analyze(function);
        promoteAll(function, info);
    }

    private Matcher analyze(Function function) {
        final var matcher = new Matcher();
        // Initially, all locally-allocated addresses are potentially promotable.
        for (final Alloc allocation : function.getEvents(Alloc.class)) {
            // Allocations will usually not have users.  Otherwise, their object is not promotable.
            if (allocation.getUsers().isEmpty()) {
                matcher.reachabilityGraph.put(allocation, new HashSet<>());
            }
        }
        // This loop should terminate, since back jumps occur, only if changes were made.
        final List<Event> events = function.getEvents();
        Label back;
        for (int i = 0; i < events.size(); i = back == null ? i + 1 : events.indexOf(back)) {
            back = events.get(i).accept(matcher);
        }
        return matcher;
    }

    private void promoteAll(Function function, Matcher matcher) {
        final ExpressionFactory expressions = ExpressionFactory.getInstance();
        // Replace every unmarked address.
        final var replacingRegisters = new HashMap<RegWriter, List<Register>>();
        for (final Alloc allocation : function.getEvents(Alloc.class)) {
            if (matcher.reachabilityGraph.containsKey(allocation)) {
                final List<Type> registerTypes = getPrimitiveReplacementTypes(allocation);
                if (registerTypes != null) {
                    replacingRegisters.put(allocation, registerTypes.stream().map(function::newRegister).toList());
                    boolean deleted = allocation.tryDelete();
                    assert deleted : "Allocation cannot be removed, probably because it has remaining users.";
                }
            }
        }
        int loadCount = 0, storeCount = 0;
        // Replace all loads and stores to replaceable storage.
        for (final Map.Entry<MemoryEvent, AddressOffset> entry : matcher.accesses.entrySet()) {
            final MemoryEvent event = entry.getKey();
            final AddressOffset access = entry.getValue();
            final List<Register> registers = access == null ? null : replacingRegisters.get(access.base);
            if (registers == null || access.offset < 0 || access.offset >= registers.size()) {
                continue;
            }
            if (event instanceof Load load) {
                final Register reg = load.getResultRegister();
                assert load.getUsers().isEmpty();
                load.replaceBy(EventFactory.newLocal(reg, expressions.makeCast(registers.get((int)access.offset), reg.getType())));
                loadCount++;
            }
            if (event instanceof Store store) {
                final Register reg = registers.get((int)access.offset);
                assert store.getUsers().isEmpty();
                store.replaceBy(EventFactory.newLocal(reg, expressions.makeCast(store.getMemValue(), reg.getType())));
                storeCount++;
            }
        }
        // Remove involved local assignments.
        for (final Map.Entry<Local, AddressOffset> entry : matcher.assignments.entrySet()) {
            if (replacingRegisters.containsKey(entry.getValue().base)) {
                assert entry.getKey().getUsers().isEmpty();
                entry.getKey().tryDelete();
            }
        }
        if (loadCount + storeCount > 0) {
            logger.debug("Removed {} loads and {} stores in function \"{}\".", loadCount, storeCount, function.getName());
        }
    }

    private List<Type> getPrimitiveReplacementTypes(Alloc allocation) {
        if (!(allocation.getArraySize() instanceof IntLiteral sizeExpression)) {
            return null;
        }
        final int size = sizeExpression.getValueAsInt();
        if (size != 1) {
            //TODO arrays
            return null;
        }
        final List<Type> replacementTypes = new ArrayList<>();
        final Type type = allocation.getAllocationType();
        //TODO PointerType
        if (type instanceof IntegerType || type instanceof BooleanType) {
            replacementTypes.add(type);
        } else {
            //TODO aggregate types
            return null;
        }
        //TODO check for mixed-size accesses
        return replacementTypes;
    }

    // Invariant: base != null
    private record AddressOffset(RegWriter base, long offset) {
        private AddressOffset increase(long o) {
            return o == 0 ? this : new AddressOffset(base, offset + o);
        }
    }

    // Invariant: register != null
    private record RegisterOffset(Register register, long offset) {}

    // Processes events in program order.
    // Returns a label, if it is program-ordered before the current event and its symbolic state was updated.
    private static final class Matcher implements EventVisitor<Label> {

        // Current local symbolic state.  Missing values mean irreplaceable contents.
        private final Map<Object, AddressOffset> state = new HashMap<>();
        // Maps labels and jumps to symbolic state information.
        private final Map<Label, Map<Object, AddressOffset>> jumps = new HashMap<>();
        // Join over all memory information.  Initialized to all empty.  Missing entries mean not promotable.
        private final Map<RegWriter, Set<RegWriter>> reachabilityGraph = new HashMap<>();
        // Collects candidates to be replaced.
        private final Map<MemoryEvent, AddressOffset> accesses = new HashMap<>();
        // Keeps track of pointer operations.  Maps assignments to the address value they must return.
        private final Map<Local, AddressOffset> assignments = new HashMap<>();
        private boolean dead;

        @Override
        public Label visitEvent(Event e) {
            if (dead) {
                return null;
            }
            // Publish all addresses used in this event.
            if (e instanceof RegReader reader) {
                final var registers = new HashSet<Register>();
                for (Register.Read read : reader.getRegisterReads()) {
                    registers.add(read.register());
                }
                publishRegisters(registers);
            }
            // Includes function call return values.
            if (e instanceof RegWriter writer) {
                state.put(writer.getResultRegister(), new AddressOffset(writer, 0));
            }
            return null;
        }

        @Override
        public Label visitLocal(Local assignment) {
            if (dead) {
                return null;
            }
            final Register register = assignment.getResultRegister();
            final RegisterOffset expression = matchGEP(assignment.getExpr());
            assert expression == null || expression.register != null;
            final AddressOffset valueBase = expression == null ? null : state.get(expression.register);
            final AddressOffset value = valueBase == null ? null : valueBase.increase(expression.offset);
            // If too complex, treat like a global address.
            if (value == null) {
                publishRegisters(assignment.getExpr().getRegs());
            }
            update(assignments, assignment, value);
            update(state, register, value);
            return null;
        }

        @Override
        public Label visitLoad(Load load) {
            if (dead) {
                return null;
            }
            // Each path must update state and accesses.
            final Register register = load.getResultRegister();
            final RegisterOffset addressExpression = matchGEP(load.getAddress());
            assert addressExpression == null || addressExpression.register != null;
            final AddressOffset addressBase = addressExpression == null ? null : state.get(addressExpression.register);
            final var address = addressBase == null ? null : addressBase.increase(addressExpression.offset);
            // If too complex, treat like global address.
            if (addressExpression == null) {
                publishRegisters(load.getAddress().getRegs());
            }
            final var value = address == null ? null : state.get(address);
            update(accesses, load, address);
            update(state, register, value);
            return null;
        }

        @Override
        public Label visitStore(Store store) {
            if (dead) {
                return null;
            }
            // Each path must update state and accesses.
            final RegisterOffset addressExpression = matchGEP(store.getAddress());
            assert addressExpression == null || addressExpression.register != null;
            final AddressOffset addressBase = addressExpression == null ? null : state.get(addressExpression.register);
            final AddressOffset address = addressBase == null ? null : addressBase.increase(addressExpression.offset);
            final RegisterOffset valueExpression = matchGEP(store.getMemValue());
            assert valueExpression == null || valueExpression.register != null;
            final AddressOffset value = valueExpression == null ? null : state.get(valueExpression.register);
            // On complex address expression, give up on any address that could contribute here.
            if (addressExpression == null) {
                publishRegisters(store.getAddress().getRegs());
            }
            // On ambiguous address, give up on any address that could be stored here.
            if (address == null || valueExpression == null) {
                publishRegisters(store.getMemValue().getRegs());
            }
            update(accesses, store, address);
            update(state, address, value);
            final Set<RegWriter> reachableSet = address == null ? null : reachabilityGraph.get(address.base);
            if (reachableSet != null && value != null) {
                reachableSet.add(value.base);
            }
            return null;
        }

        @Override
        public Label visitLabel(Label label) {
            final int localId = label.getLocalId();
            final boolean looping = label.getJumpSet().stream().anyMatch(jump -> localId < jump.getLocalId());
            final Map<Object, AddressOffset> restoredState = looping ? jumps.get(label) : jumps.remove(label);
            if (restoredState != null) {
                if (dead) {
                    assert state.isEmpty();
                    state.putAll(restoredState);
                    dead = false;
                } else {
                    mergeInto(state, restoredState);
                    mergeInto(restoredState, state);
                }
            } else {
                jumps.put(label, new HashMap<>(state));
            }
            return null;
        }

        @Override
        public Label visitCondJump(CondJump jump) {
            if (dead || jump.isDead()) {
                return null;
            }
            // Give up on every address used in the condition.
            publishRegisters(jump.getGuard().getRegs());
            final Label label = jump.getLabel();
            final boolean looping = label.getLocalId() < jump.getLocalId();
            final boolean isGoto = jump.isGoto();
            assert !looping || jumps.containsKey(label);
            // Prepare the current state for continuing from the label.
            final Map<Object, AddressOffset> labelState = jumps.get(label);
            if (labelState != null) {
                //NOTE no short-circuiting.
                final boolean change = mergeInto(labelState, state);
                if (looping && change) {
                    state.clear();
                    state.putAll(labelState);
                    return label;
                }
            } else {
                jumps.put(label, new HashMap<>(state));
            }
            // If unconditional, discard the state.
            if (isGoto) {
                state.clear();
                dead = true;
            }
            return null;
        }

        private void publishRegisters(Set<Register> registers) {
            final var queue = new ArrayDeque<RegWriter>();
            for (final Register register : registers) {
                final AddressOffset value = state.remove(register);
                if (value != null) {
                    queue.add(value.base);
                }
            }
            while (!queue.isEmpty()) {
                final RegWriter allocation = queue.remove();
                final Set<RegWriter> reachableSet = reachabilityGraph.remove(allocation);
                if (reachableSet != null) {
                    queue.addAll(reachableSet);
                }
            }
        }

        private RegisterOffset matchGEP(Expression expression) {
            long sum = 0;
            while (!(expression instanceof Register register)) {
                if (!(expression instanceof IntBinaryExpr bin) ||
                        bin.getKind() != IntBinaryOp.ADD ||
                        !(bin.getRight() instanceof IntLiteral offset)) {
                    return null;
                }
                sum += offset.getValueAsLong();
                expression = bin.getLeft();
            }
            return new RegisterOffset(register, sum);
        }

        private static <K, V> boolean mergeInto(Map<K, V> target, Map<K, V> other) {
            return target.entrySet().removeIf(entry -> !entry.getValue().equals(other.get(entry.getKey())));
        }

        private static <K, V> void update(Map<K, V> target, K key, V value) {
            target.compute(key, (k, v) -> value);
        }
    }
}
