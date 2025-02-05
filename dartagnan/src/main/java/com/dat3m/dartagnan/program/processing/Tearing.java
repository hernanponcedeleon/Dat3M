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
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Store;

import java.util.ArrayList;
import java.util.List;

//TODO Keep link between the teared events.  They belong to the same instruction.
//TODO add Big Endian
public final class Tearing implements EventVisitor<List<Event>> {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    public static void applyReplacement(Event event) {
        event.replaceBy(event.accept(new Tearing()));
    }

    private Tearing() {}

    @Override
    public List<Event> visitEvent(Event e) {
        return List.of(e);
    }

    @Override
    public List<Event> visitLoad(Load load) {
        List<Event> replacement = new ArrayList<>();
        IntegerType addressType = checkIntegerType(load.getAddress().getType(), "Non-integer address in '%s'", load);
        IntegerType accessType = checkIntegerType(load.getAccessType(), "Non-integer mixed-size access in '%s'", load);
        int bytes = types.getMemorySizeInBytes(accessType);
        Function function = load.getFunction();
        Register addressRegister = toRegister(load.getAddress(), function, replacement);
        List<Register> smallerRegisters = new ArrayList<>();
        for (int i = 0; i < bytes; i++) {
            smallerRegisters.add(function.newRegister(types.getByteType()));
        }
        for (int i = 0; i < bytes; i++) {
            Expression a = expressions.makeAdd(addressRegister, expressions.makeValue(i, addressType));
            replacement.add(EventFactory.newLoad(smallerRegisters.get(i), a));
        }
        Expression combination = expressions.makeCast(smallerRegisters.get(0), accessType);
        for (int i = 1; i < bytes; i++) {
            Expression wideValue = expressions.makeCast(smallerRegisters.get(i), accessType);
            Expression shiftedValue = expressions.makeLshift(wideValue, expressions.makeValue(8L * i, accessType));
            combination = expressions.makeIntOr(combination, shiftedValue);
        }
        replacement.add(EventFactory.newLocal(load.getResultRegister(), combination));
        return replacement;
    }

    @Override
    public List<Event> visitStore(Store store) {
        List<Event> replacement = new ArrayList<>();
        IntegerType addressType = checkIntegerType(store.getAddress().getType(), "Non-integer address in '%s'", store);
        IntegerType accessType = checkIntegerType(store.getAccessType(), "Non-integer access in '%s'", store);
        int bytes = types.getMemorySizeInBytes(accessType);
        Function function = store.getFunction();
        Register addressRegister = toRegister(store.getAddress(), function, replacement);
        Register valueRegister = toRegister(store.getMemValue(), function, replacement);
        for (int i = 0; i < bytes; i++) {
            Expression a = expressions.makeAdd(addressRegister, expressions.makeValue(i, addressType));
            Expression shiftedValue = expressions.makeRshift(valueRegister, expressions.makeValue(8L * i, accessType), false);
            Expression value = expressions.makeCast(shiftedValue, types.getByteType());
            replacement.add(EventFactory.newStore(a, value));
        }
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
