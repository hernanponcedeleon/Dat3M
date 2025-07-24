package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntBinaryExpr;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.event.core.*;
import com.google.common.collect.Maps;
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

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

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
        for (final MemAlloc allocation : function.getEvents(MemAlloc.class)) {
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
        // Replace every unmarked address.
        final Map<RegWriter, Promotable> promotableObjects = collectPromotableObjects(function, matcher);
        final Map<Event, List<Event>> updates = new HashMap<>();

        // Compute replacement of allocation sites:
        for (final Map.Entry<RegWriter, Promotable> entry : promotableObjects.entrySet()) {
            final MemAlloc alloc = (MemAlloc) entry.getKey();
            final List<Event> replacement = alloc.doesZeroOutMemory() ?
                    entry.getValue().replacingRegisters.values().stream()
                            .map(reg -> (Event) EventFactory.newLocal(reg, expressions.makeGeneralZero(reg.getType())))
                            .toList()
                    : List.of();
            replacement.forEach(e -> e.copyAllMetadataFrom(alloc));
            updates.put(alloc, replacement);
        }

        // Mark all loads and stores to replaceable storage.
        updates.putAll(Maps.transformEntries(matcher.accesses, (k, v) -> promoteAccess(k, v, promotableObjects)));
        // Mark involved local GEP assignments.
        for (final Map.Entry<Local, AddressOffset> entry : matcher.assignments.entrySet()) {
            if (promotableObjects.containsKey(entry.getValue().base)) {
                updates.put(entry.getKey(), List.of());
            }
        }
        updates.values().removeIf(Objects::isNull);
        // If some events cannot be removed, give up.
        //TODO Build a dependency graph and replace the events that can be removed.
        if (updates.keySet().stream().anyMatch(e -> !e.getUsers().isEmpty())) {
            logger.warn("Could not remove events, because some are still used.");
            return;
        }
        // Replace events.
        for (Map.Entry<Event, List<Event>> update : updates.entrySet()) {
            update.getKey().replaceBy(update.getValue());
        }
        // Evaluate the process.
        if (!updates.isEmpty()) {
            final long loadCount = updates.keySet().stream().filter(Load.class::isInstance).count();
            final long storeCount = updates.keySet().stream().filter(Store.class::isInstance).count();
            logger.debug("Removed {} loads and {} stores in function \"{}\".", loadCount, storeCount, function.getName());
        }
    }

    private Map<RegWriter, Promotable> collectPromotableObjects(Function function, Matcher matcher) {
        final Map<RegWriter, Promotable> promotableObjects = new HashMap<>();
        for (final MemAlloc allocation : function.getEvents(MemAlloc.class)) {
            if (!matcher.reachabilityGraph.containsKey(allocation)) {
                continue;
            }
            final Set<Field> registerTypes = new HashSet<>();
            for (Map.Entry<MemoryCoreEvent, AddressOffset> entry : matcher.accesses.entrySet()) {
                if (!entry.getValue().base.equals(allocation)) {
                    continue;
                }
                final Type accessType = entry.getKey().getAccessType();
                final int accessSize = types.getMemorySizeInBytes(accessType);
                registerTypes.add(new Field((int) entry.getValue().offset, accessSize, accessType));
            }
            final Map<Field, Register> registers = Maps.asMap(registerTypes, f -> newRegister(allocation, f));
            promotableObjects.put(allocation, new Promotable(registers));
        }
        return promotableObjects;
    }

    private Register newRegister(MemAlloc allocation, Field field) {
        return allocation.getFunction().newUniqueRegister("__memToReg", field.type);
    }

    private List<Event> promoteAccess(MemoryCoreEvent event, AddressOffset access,
            Map<RegWriter, Promotable> promotableObjects) {
        final Promotable object = access == null ? null : promotableObjects.get(access.base);
        final Type accessType = event.getAccessType();
        final int accessSize = types.getMemorySizeInBytes(accessType);
        final Field field = object == null ? null : new Field((int) access.offset, accessSize, accessType);
        final Register memreg = field == null ? null : object.replacingRegisters.get(field);
        if (memreg == null) {
            return null;
        }
        final List<Event> replacement = new ArrayList<>();
        if (event instanceof Load load) {
            final Register reg = load.getResultRegister();
            assert load.getUsers().isEmpty();
            replacement.add(EventFactory.newLocal(reg, expressions.makeCast(memreg, reg.getType())));
        } else if (event instanceof Store store) {
            assert store.getUsers().isEmpty();
            replacement.add(EventFactory.newLocal(memreg, expressions.makeCast(store.getMemValue(), accessType)));
            updateMixedRegisters(memreg, field, object, replacement);
        }
        return replacement;
    }

    private void updateMixedRegisters(Register memreg, Field field, Promotable object, List<Event> replacement) {
        // Update all registers representing overlapping byte ranges.
        if (!object.hasMixedAccesses) {
            return;
        }
        final boolean bigEndian = memreg.getFunction().getProgram().getMemory().isBigEndian();
        assert memreg.getType().equals(field.type);
        final Type integerType = types.getIntegerType(types.getMemorySizeInBits(field.type));
        final Expression storedValue = expressions.makeCast(memreg, integerType);
        final int end = field.offset + field.size;
        for (Map.Entry<Field, Register> otherEntry : object.replacingRegisters.entrySet()) {
            final Field other = otherEntry.getKey();
            if (other.equals(field) || !other.overlaps(field)) {
                continue;
            }
            final Register otherRegister = otherEntry.getValue();
            final int overlapBegin = Integer.max(field.offset, other.offset);
            final int overlapEnd = Integer.min(end, other.offset + other.size);
            final int firstByte = bigEndian ? end - overlapEnd : overlapBegin - field.offset;
            final Expression truncated = extractBytes(storedValue, firstByte, overlapEnd - overlapBegin);
            final Type otherType = otherRegister.getType();
            final int otherBytes = types.getMemorySizeInBytes(otherType);
            final Type otherIntegerType = types.getIntegerType(8 * otherBytes);
            final Expression formerValue = expressions.makeCast(otherRegister, otherIntegerType);
            final int frontBytes = overlapBegin - other.offset;
            final int backBytes = other.offset + other.size - overlapEnd;
            final int lowBytes = bigEndian ? backBytes : frontBytes;
            final int highBytes = bigEndian ? frontBytes : backBytes;
            final Expression lowBits = extractBytes(formerValue, 0, lowBytes);
            final Expression highBits = extractBytes(formerValue, otherBytes - highBytes, highBytes);
            final List<Expression> operands = Arrays.asList(lowBits, truncated, highBits);
            final List<Expression> filteredOperands = operands.stream().filter(Objects::nonNull).toList();
            final Expression extended = expressions.makeIntConcat(filteredOperands);
            replacement.add(EventFactory.newLocal(otherRegister, expressions.makeCast(extended, otherType)));
        }
    }

    private Expression extractBytes(Expression operand, int offset, int size) {
        return size <= 0 ? null : expressions.makeIntExtract(operand, 8 * offset, 8 * (offset + size) - 1);
    }

    private static final class Promotable {
        private final Map<Field, Register> replacingRegisters;
        // Redundant flag for the likely case, that a promoted object
        private final boolean hasMixedAccesses;

        private Promotable(Map<Field, Register> fields) {
            replacingRegisters = new HashMap<>(fields);
            hasMixedAccesses = hasMixedAccesses(replacingRegisters.keySet());
        }
    }

    private record Field(int offset, int size, Type type) {
        private boolean overlaps(Field other) {
            return Long.max(offset, other.offset) < Long.min(offset + size, other.offset + other.size);
        }
    }

    private sealed interface AddressOffsets {}

    // Invariant: base != null
    private record AddressOffset(RegWriter base, long offset) implements AddressOffsets {
        private AddressOffset increase(long o) {
            return o == 0 ? this : new AddressOffset(base, offset + o);
        }
    }

    // Invariant: hint != null && !hint.isEmpty()
    private record AddressOffsetSet(Set<RegWriter> hint) implements AddressOffsets {}

    // Checks if mixed-size accesses to a promotable object were collected.
    private static boolean hasMixedAccesses(Set<Field> registerTypes) {
        final List<Field> registerTypeList = List.copyOf(registerTypes);
        for (int i = 0; i < registerTypeList.size(); i++) {
            for (int j = 0; j < i; j++) {
                if (registerTypeList.get(i).overlaps(registerTypeList.get(j))) {
                    return true;
                }
            }
        }
        return false;
    }

    // Processes events in program order.
    // Returns a label, if it is program-ordered before the current event and its symbolic state was updated.
    private static final class Matcher implements EventVisitor<Label> {

        // Current local symbolic state.  Missing values mean irreplaceable contents.
        private final Map<Object, AddressOffsets> state = new HashMap<>();
        // Maps labels and jumps to symbolic state information.
        private final Map<Label, Map<Object, AddressOffsets>> jumps = new HashMap<>();
        // Join over all memory information.  Initialized to all empty.  Missing entries mean not promotable.
        private final Map<RegWriter, Set<RegWriter>> reachabilityGraph = new HashMap<>();
        // Collects candidates to be replaced.
        private final Map<MemoryCoreEvent, AddressOffset> accesses = new HashMap<>();
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
            final AddressOffset value = computeAddressOffsetFromState(assignment.getExpr());
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
            final AddressOffset address = computeAddressOffsetFromState(load.getAddress());
            final boolean isDeletable = load.getUsers().isEmpty();
            // If too complex, treat like global address.
            if (address == null || !isDeletable) {
                publishRegisters(load.getAddress().getRegs());
            }
            final AddressOffsets value = address == null ? null : state.get(address);
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
            final AddressOffset address = computeAddressOffsetFromState(store.getAddress());
            final AddressOffset value = computeAddressOffsetFromState(store.getMemValue());
            final boolean isDeletable = store.getUsers().isEmpty();
            // On complex address expression, give up on any address that could contribute here.
            if (address == null || !isDeletable) {
                publishRegisters(store.getAddress().getRegs());
            }
            // On ambiguous address, give up on any address that could be stored here.
            if (address == null || value == null || !isDeletable) {
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
            final Map<Object, AddressOffsets> restoredState = looping ? jumps.get(label) : jumps.remove(label);
            if (restoredState != null && dead) {
                assert state.isEmpty();
                state.putAll(restoredState);
                dead = false;
            } else if (restoredState != null) {
                mergeInto(state, restoredState);
                mergeInto(restoredState, state);
            } else if (!dead) {
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
            final Map<Object, AddressOffsets> labelState = jumps.get(label);
            if (labelState != null) {
                // NOTE no short-circuiting.
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
                final AddressOffsets element = state.remove(register);
                if (element instanceof AddressOffset value) {
                    queue.add(value.base);
                }
                if (element instanceof AddressOffsetSet hint) {
                    queue.addAll(hint.hint);
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

        private record RegisterOffset(Register register, long offset) {}

        private AddressOffset computeAddressOffsetFromState(Expression expression) {
            final RegisterOffset gep = matchGEP(expression);
            assert gep == null || gep.register != null;
            final AddressOffsets element = gep == null ? null : state.get(gep.register);
            return element instanceof AddressOffset base ? base.increase(gep.offset) : null;
        }

        private static RegisterOffset matchGEP(Expression expression) {
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

        private static boolean mergeInto(Map<Object, AddressOffsets> target, Map<Object, AddressOffsets> other) {
            boolean changed = false;
            // Keep links between registers and objects to properly propagate publishing.
            for (Map.Entry<Object, AddressOffsets> entry : target.entrySet()) {
                final AddressOffsets otherElement = other.get(entry.getKey());
                final AddressOffset otherAddress = otherElement instanceof AddressOffset a ? a : null;
                final AddressOffsetSet otherHint = otherElement instanceof AddressOffsetSet h ? h : null;
                final AddressOffset targetAddress = entry.getValue() instanceof AddressOffset a ? a : null;
                final AddressOffsetSet targetHint = entry.getValue() instanceof AddressOffsetSet h ? h : null;
                assert targetAddress != null || targetHint != null;
                if (otherElement == null ||
                        targetAddress != null && targetAddress.equals(otherAddress) ||
                        targetHint != null && otherAddress != null && targetHint.hint.contains(otherAddress.base) ||
                        targetHint != null && otherHint != null && targetHint.hint.containsAll(otherHint.hint)) {
                    continue;
                }
                final Set<RegWriter> hint = new HashSet<>();
                if (targetAddress != null) {
                    hint.add(targetAddress.base);
                }
                if (otherAddress != null) {
                    hint.add(otherAddress.base);
                }
                if (targetHint != null) {
                    hint.addAll(targetHint.hint);
                }
                if (otherHint != null) {
                    hint.addAll(otherHint.hint);
                }
                entry.setValue(new AddressOffsetSet(hint));
                changed = true;
            }
            for (Map.Entry<Object, AddressOffsets> entry : other.entrySet()) {
                changed |= target.putIfAbsent(entry.getKey(), entry.getValue()) == null;
            }
            return changed;
        }

        private static <K, V> void update(Map<K, V> target, K key, V value) {
            target.compute(key, (k, v) -> value);
        }
    }
}
