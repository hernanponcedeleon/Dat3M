package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Init;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.program.event.core.RMWStore;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.core.annotations.TransactionMarker;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.util.*;

import static com.google.common.base.Preconditions.checkArgument;

public final class Tearing {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    private final boolean bigEndian;
    private final Map<MemoryCoreEvent, List<Event>> map = new HashMap<>();

    private Tearing(boolean e) {
        bigEndian = e;
    }

    public static boolean run(AliasAnalysis alias, List<MemoryCoreEvent> events) {
        if (events.isEmpty()) {
            return false;
        }
        final boolean bigEndian = events.iterator().next().getFunction().getProgram().getMemory().isBigEndian();
        return new Tearing(bigEndian).replaceAll(alias, events);
    }

    private boolean replaceAll(AliasAnalysis alias, List<MemoryCoreEvent> events) {
        // Generate transaction events for mixed-size accesses
        tearInits(alias, events);
        //NOTE RMWStores need to access the associated load's replacements
        for (MemoryCoreEvent event : events) {
            final Load load = event instanceof Load l ? l : null;
            final List<Integer> msa = load == null ? List.of() : alias.mayMixedSizeAccesses(event);
            if (!msa.isEmpty()) {
                map.put(load, createTransaction(load, msa));
            }
        }
        for (MemoryCoreEvent event : events) {
            final Store store = event instanceof Store s && !(event instanceof Init) ? s : null;
            final List<Integer> msa = store == null ? List.of() : alias.mayMixedSizeAccesses(event);
            if (!msa.isEmpty()) {
                map.put(store, createTransaction(store, msa));
            }
        }
        // Replace instructions by transactions of events
        //NOTE Some loads are used by stores, and cannot be replaced before them
        for (Map.Entry<MemoryCoreEvent, List<Event>> entry : map.entrySet()) {
            if (entry.getKey() instanceof Store store && !entry.getValue().equals(List.of(store))) {
                store.replaceBy(entry.getValue());
            }
        }
        for (Map.Entry<MemoryCoreEvent, List<Event>> entry : map.entrySet()) {
            if (entry.getKey() instanceof Load load && !entry.getValue().equals(List.of(load))) {
                load.replaceBy(entry.getValue());
            }
        }
        return !map.isEmpty();
    }

    private void tearInits(AliasAnalysis alias, List<MemoryCoreEvent> events) {
        final Program program = events.get(0).getThread().getProgram();
        for (MemoryCoreEvent event : events) {
            final Init init = event instanceof Init i ? i : null;
            final List<Integer> offsets = init == null ? List.of() : alias.mayMixedSizeAccesses(event);
            if (offsets.isEmpty()) {
                continue;
            }
            final int bytes = checkBytes(init, offsets);
            final MemoryObject base = init.getBase();
            final int offset = init.getOffset();
            final Expression value = init.getValue();
            final IntegerType type = checkIntegerType(value.getType(), "Non-integer value type in '%s'", init);
            // Tear initial values
            final Expression frontShiftBits = bigEndian ? expressions.makeValue(bytes - offsets.get(0), type) : null;
            final Expression frontShifted = bigEndian ? expressions.makeRshift(value, frontShiftBits, false) : value;
            final Expression frontValue = expressions.makeCast(frontShifted, types.getIntegerType(8 * offsets.get(0)));
            base.setInitialValue(offset, frontValue);
            for (int i = 0; i < offsets.size(); i++) {
                final int begin = offsets.get(i);
                final int end = i + 1 < offsets.size() ? offsets.get(i + 1) : bytes;
                final int shift = bigEndian ? bytes - end : begin;
                final Expression shiftBits = expressions.makeValue(8L * shift, type);
                final Expression shifted = expressions.makeRshift(value, shiftBits, false);
                final Expression tearedValue = expressions.makeCast(shifted, types.getIntegerType(8 * (end - begin)));
                base.setInitialValue(offset + begin, tearedValue);
            }
            // Tear init event
            init.setMemValue(frontValue);
            for (int begin : offsets) {
                program.addInit(base, offset + begin);
            }
        }
    }

    private List<Event> createTransaction(Load load, List<Integer> offsets) {
        final int bytes = checkBytes(load, offsets);
        final List<Event> replacement = new ArrayList<>();
        final IntegerType addressType = checkIntegerType(load.getAddress().getType(),
                "Non-integer address in '%s'", load);
        final IntegerType accessType = checkIntegerType(load.getAccessType(),
                "Non-integer mixed-size access in '%s'", load);
        final Function function = load.getFunction();
        final Register addressRegister = toRegister(load.getAddress(), function, replacement);
        final List<Register> smallerRegisters = new ArrayList<>();
        for (int i = -1; i < offsets.size(); i++) {
            int start = i < 0 ? 0 : offsets.get(i);
            int end = i + 1 < offsets.size() ? offsets.get(i + 1) : bytes;
            assert start < end;
            smallerRegisters.add(function.newRegister(types.getIntegerType(8 * (end - start))));
        }
        assert bytes == smallerRegisters.stream().mapToInt(t -> types.getMemorySizeInBytes(t.getType())).sum();
        final TransactionMarker begin = EventFactory.newTransactionBegin(load);
        replacement.add(begin);
        for (int i = -1; i < offsets.size(); i++) {
            final int start = i < 0 ? 0 : offsets.get(i);
            final Expression offset = expressions.makeValue(start, addressType);
            final Expression address = expressions.makeAdd(addressRegister, offset);
            final Load byteLoad = load.getCopy();
            byteLoad.setResultRegister(smallerRegisters.get(i + 1));
            byteLoad.setAddress(address);
            replacement.add(byteLoad);
        }
        replacement.add(EventFactory.newTransactionEnd(load, begin));
        Expression combination = expressions.makeCast(smallerRegisters.get(0), accessType);
        for (int i = 0; i < offsets.size(); i++) {
            final int start = offsets.get(i);
            final int end = i + 1 < offsets.size() ? offsets.get(i + 1) : bytes;
            Expression wideValue = expressions.makeCast(smallerRegisters.get(i + 1), accessType);
            final long shift = bigEndian ? bytes - end : start;
            Expression shiftBits = expressions.makeValue(8L * shift, accessType);
            Expression shiftedValue = expressions.makeLshift(wideValue, shiftBits);
            combination = expressions.makeIntOr(combination, shiftedValue);
        }
        replacement.add(EventFactory.newLocal(load.getResultRegister(), combination));
        return replacement;
    }

    private List<Event> createTransaction(Store store, List<Integer> offsets) {
        final int bytes = checkBytes(store, offsets);
        final List<Event> replacement = new ArrayList<>();
        final IntegerType addressType = checkIntegerType(store.getAddress().getType(),
                "Non-integer address in '%s'", store);
        final IntegerType accessType = checkIntegerType(store.getAccessType(),
                "Non-integer mixed-size access in '%s'", store);
        final Function function = store.getFunction();
        final Register addressRegister = toRegister(store.getAddress(), function, replacement);
        final Register valueRegister = toRegister(store.getMemValue(), function, replacement);
        final List<Load> loads = store instanceof RMWStore st ? map.get(st.getLoadEvent()).stream()
                .filter(Load.class::isInstance).map(Load.class::cast).toList() : null;
        final TransactionMarker begin = EventFactory.newTransactionBegin(store);
        replacement.add(begin);
        for (int i = -1; i < offsets.size(); i++) {
            final int start = i < 0 ? 0 : offsets.get(i);
            final int end = i + 1 < offsets.size() ? offsets.get(i + 1) : bytes;
            final Expression offset = expressions.makeValue(start, addressType);
            final Expression address = expressions.makeAdd(addressRegister, offset);
            final int shift = bigEndian ? bytes - end : start;
            final Expression shiftBits = expressions.makeValue(8L * shift, accessType);
            final Expression shiftedValue = expressions.makeRshift(valueRegister, shiftBits, false);
            final Expression value = expressions.makeCast(shiftedValue, types.getIntegerType(8 * (end - start)));
            final Store byteStore = store.getCopy();
            byteStore.setAddress(address);
            byteStore.setMemValue(value);
            if (loads != null && byteStore instanceof RMWStore st) {
                st.updateReferences(Map.of(st.getLoadEvent(), loads.get(i + 1)));
            }
            replacement.add(byteStore);
        }
        replacement.add(EventFactory.newTransactionEnd(store, begin));
        return replacement;
    }

    private IntegerType checkIntegerType(Type type, String message, Event event) {
        final IntegerType integerType = type instanceof IntegerType t ? t : null;
        if (integerType != null) {
            return integerType;
        }
        throw new UnsupportedOperationException(String.format(message, event));
    }

    private Register toRegister(Expression expression, Function function, List<Event> replacement) {
        if (expression instanceof Register r) {
            return r;
        }
        final Register r = function.newRegister(expression.getType());
        replacement.add(EventFactory.newLocal(r, expression));
        return r;
    }

    private int checkBytes(MemoryCoreEvent event, List<Integer> offsets) {
        final int bytes = types.getMemorySizeInBytes(event.getAccessType());
        checkArgument(offsets.stream().allMatch(i -> 0 < i && i < bytes), "offset out of range");
        checkArgument(isStrictlySorted(offsets), "unsorted offset list");
        return bytes;
    }

    private static <T extends Comparable<T>> boolean isStrictlySorted(List<T> list) {
        for (int i = 0; i < list.size() - 1; i++) {
            if (list.get(i).compareTo(list.get(i + 1)) >= 0) {
                return false;
            }
        }
        return true;
    }
}
