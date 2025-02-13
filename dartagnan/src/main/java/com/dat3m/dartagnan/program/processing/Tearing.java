package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.program.event.core.RMWStore;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.core.annotations.TransactionMarker;

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
        boolean bigEndian = events.iterator().next().getFunction().getProgram().getMemory().isBigEndian();
        return new Tearing(bigEndian).replaceAll(alias, events);
    }

    private boolean replaceAll(AliasAnalysis alias, List<MemoryCoreEvent> events) {
        // Generate transaction events for mixed-size accesses
        //NOTE RMWStores need to access the associated load's replacements
        for (MemoryCoreEvent event : events) {
            final Load load = event instanceof Load l ? l : null;
            final List<Integer> msa = load == null ? List.of() : alias.mayMixedSizeAccesses(event);
            if (!msa.isEmpty()) {
                map.put(load, createTransaction(load, msa));
            }
        }
        for (MemoryCoreEvent event : events) {
            final Store store = event instanceof Store s ? s : null;
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

    private List<Event> createTransaction(Load load, List<Integer> offsets) {
        final int bytes = checkBytes(load, offsets);
        List<Event> replacement = new ArrayList<>();
        IntegerType addressType = checkIntegerType(load.getAddress().getType(), "Non-integer address in '%s'", load);
        IntegerType accessType = checkIntegerType(load.getAccessType(), "Non-integer mixed-size access in '%s'", load);
        Function function = load.getFunction();
        Register addressRegister = toRegister(load.getAddress(), function, replacement);
        List<Register> smallerRegisters = new ArrayList<>();
        for (int i = -1; i < offsets.size(); i++) {
            int start = i < 0 ? 0 : offsets.get(i);
            int end = i + 1 < offsets.size() ? offsets.get(i + 1) : bytes;
            assert start < end;
            smallerRegisters.add(function.newRegister(types.getIntegerType(8 * (end - start))));
        }
        assert bytes == smallerRegisters.stream().mapToInt(t -> types.getMemorySizeInBytes(t.getType())).sum();
        TransactionMarker begin = EventFactory.newTransactionBegin(load);
        replacement.add(begin);
        for (int i = -1; i < offsets.size(); i++) {
            int start = i < 0 ? 0 : offsets.get(i);
            Expression offset = expressions.makeValue(start, addressType);
            Expression address = expressions.makeAdd(addressRegister, offset);
            Load byteLoad = load.getCopy();
            byteLoad.setResultRegister(smallerRegisters.get(i + 1));
            byteLoad.setAddress(address);
            replacement.add(byteLoad);
        }
        replacement.add(EventFactory.newTransactionEnd(load, begin));
        Expression combination = expressions.makeCast(smallerRegisters.get(0), accessType);
        for (int i = 0; i < offsets.size(); i++) {
            Expression wideValue = expressions.makeCast(smallerRegisters.get(i + 1), accessType);
            long shift = bigEndian ? i + 1 < offsets.size() ? bytes - offsets.get(i + 1) : 0 : offsets.get(i);
            Expression shiftBits = expressions.makeValue(8L * shift, accessType);
            Expression shiftedValue = expressions.makeLshift(wideValue, shiftBits);
            combination = expressions.makeIntOr(combination, shiftedValue);
        }
        replacement.add(EventFactory.newLocal(load.getResultRegister(), combination));
        return replacement;
    }

    private List<Event> createTransaction(Store store, List<Integer> offsets) {
        final int bytes = checkBytes(store, offsets);
        List<Event> replacement = new ArrayList<>();
        IntegerType addressType = checkIntegerType(store.getAddress().getType(), "Non-integer address in '%s'", store);
        IntegerType accessType = checkIntegerType(store.getAccessType(), "Non-integer access in '%s'", store);
        Function function = store.getFunction();
        Register addressRegister = toRegister(store.getAddress(), function, replacement);
        Register valueRegister = toRegister(store.getMemValue(), function, replacement);
        List<Load> loads = store instanceof RMWStore st ? map.get(st.getLoadEvent()).stream()
                .filter(Load.class::isInstance).map(Load.class::cast).toList() : null;
        TransactionMarker begin = EventFactory.newTransactionBegin(store);
        replacement.add(begin);
        for (int i = -1; i < offsets.size(); i++) {
            Expression address = expressions.makeAdd(addressRegister, expressions.makeValue(i + 1, addressType));
            int shift = bigEndian ? i + 1 < offsets.size() ? bytes - offsets.get(i + 1) : 0 : i < 0 ? 0 : offsets.get(i);
            Expression shiftBits = expressions.makeValue(8L * shift, accessType);
            Expression shiftedValue = expressions.makeRshift(valueRegister, shiftBits, false);
            Expression value = expressions.makeCast(shiftedValue, types.getByteType());
            Store byteStore = store.getCopy();
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
        IntegerType integerType = type instanceof IntegerType t ? t : null;
        if (integerType != null) {
            return integerType;
        }
        throw new UnsupportedOperationException(String.format(message, event));
    }

    private Register toRegister(Expression expression, Function function, List<Event> replacement) {
        if (expression instanceof Register r) {
            return r;
        }
        Register r = function.newRegister(expression.getType());
        replacement.add(EventFactory.newLocal(r, expression));
        return r;
    }

    private int checkBytes(MemoryCoreEvent event, List<Integer> offsets) {
        int bytes = types.getMemorySizeInBytes(event.getAccessType());
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
