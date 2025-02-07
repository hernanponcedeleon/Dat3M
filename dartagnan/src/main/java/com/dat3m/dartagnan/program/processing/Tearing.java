package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.program.event.core.RMWStore;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.core.annotations.TransactionMarker;

import java.util.*;

//TODO add Big Endian
public final class Tearing {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    private final Map<MemoryCoreEvent, List<Event>> map = new HashMap<>();

    private Tearing() {}

    public static void run(Collection<MemoryCoreEvent> events) {
        new Tearing().replaceAll(events);
    }

    private void replaceAll(Collection<MemoryCoreEvent> events) {
        for (MemoryCoreEvent event : events) {
            if (event instanceof Load load) {
                map.put(load, replace(load));
            }
        }
        for (MemoryCoreEvent event : events) {
            if (event instanceof Store store) {
                map.put(store, replace(store));
            }
        }
        for (Map.Entry<MemoryCoreEvent, List<Event>> entry : map.entrySet()) {
            if (!entry.getValue().equals(List.of(entry.getKey()))) {
                entry.getKey().replaceBy(entry.getValue());
            }
        }
    }

    private List<Event> replace(Load load) {
        int bytes = types.getMemorySizeInBytes(load.getAccessType());
        if (bytes == 1) {
            return List.of(load);
        }
        List<Event> replacement = new ArrayList<>();
        IntegerType addressType = checkIntegerType(load.getAddress().getType(), "Non-integer address in '%s'", load);
        IntegerType accessType = checkIntegerType(load.getAccessType(), "Non-integer mixed-size access in '%s'", load);
        Function function = load.getFunction();
        Register addressRegister = toRegister(load.getAddress(), function, replacement);
        List<Register> smallerRegisters = new ArrayList<>();
        for (int i = 0; i < bytes; i++) {
            smallerRegisters.add(function.newRegister(types.getByteType()));
        }
        TransactionMarker begin = EventFactory.newTransactionBegin(load);
        replacement.add(begin);
        for (int i = 0; i < bytes; i++) {
            Expression address = expressions.makeAdd(addressRegister, expressions.makeValue(i, addressType));
            Load byteLoad = load.getCopy();
            byteLoad.setResultRegister(smallerRegisters.get(i));
            byteLoad.setAddress(address);
            replacement.add(byteLoad);
        }
        replacement.add(EventFactory.newTransactionEnd(load, begin));
        Expression combination = expressions.makeCast(smallerRegisters.get(0), accessType);
        for (int i = 1; i < bytes; i++) {
            Expression wideValue = expressions.makeCast(smallerRegisters.get(i), accessType);
            Expression shiftedValue = expressions.makeLshift(wideValue, expressions.makeValue(8L * i, accessType));
            combination = expressions.makeIntOr(combination, shiftedValue);
        }
        replacement.add(EventFactory.newLocal(load.getResultRegister(), combination));
        return replacement;
    }

    private List<Event> replace(Store store) {
        int bytes = types.getMemorySizeInBytes(store.getAccessType());
        if (bytes == 1) {
            return List.of(store);
        }
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
        for (int i = 0; i < bytes; i++) {
            Expression address = expressions.makeAdd(addressRegister, expressions.makeValue(i, addressType));
            Expression shiftedValue = expressions.makeRshift(valueRegister, expressions.makeValue(8L * i, accessType), false);
            Expression value = expressions.makeCast(shiftedValue, types.getByteType());
            Store byteStore = store.getCopy();
            byteStore.setAddress(address);
            byteStore.setMemValue(value);
            if (loads != null && byteStore instanceof RMWStore st) {
                st.updateReferences(Map.of(st.getLoadEvent(), loads.get(i)));
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

}
