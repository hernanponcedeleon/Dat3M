package com.dat3m.dartagnan.program.processing.libraries;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.functions.FunctionCall;
import com.dat3m.dartagnan.program.event.functions.ValueFunctionCall;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Options;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

@Options
public class LKMMLibrary extends AbstractLibrary<LKMMLibrary> {

    public enum SupportedFunctions {
        LKMM_LOAD("__LKMM_load", LKMMLibrary::handleLKMMFunction),
        LKMM_STORE("__LKMM_store", LKMMLibrary::handleLKMMFunction),
        LKMM_XCHG("__LKMM_xchg", LKMMLibrary::handleLKMMFunction),
        LKMM_CMPXCHG("__LKMM_cmpxchg", LKMMLibrary::handleLKMMFunction),
        LKMM_ATOMIC_FETCH_OP("__LKMM_atomic_fetch_op", LKMMLibrary::handleLKMMFunction),
        LKMM_ATOMIC_OP("__LKMM_atomic_op",LKMMLibrary::handleLKMMFunction),
        LKMM_ATOMIC_OP_RETURN("__LKMM_atomic_op_return", LKMMLibrary::handleLKMMFunction),
        LKMM_SPIN_LOCK("__LKMM_SPIN_LOCK", LKMMLibrary::handleLKMMFunction),
        LKMM_SPIN_UNLOCK("__LKMM_SPIN_UNLOCK", LKMMLibrary::handleLKMMFunction),
        LKMM_FENCE("__LKMM_fence",  LKMMLibrary::handleLKMMFunction),
        ;

        private final List<String> variants;
        private final Handler<LKMMLibrary> handler;

        SupportedFunctions(List<String> variants, CallResolver<LKMMLibrary> handler) {
            this.variants = variants;
            this.handler = handler;
        }

        SupportedFunctions(String name, CallResolver<LKMMLibrary> handler) {
            this(List.of(name), handler);
        }

        private boolean matches(String funcName) {
            return variants.contains(funcName);
        }
    }
    

    public LKMMLibrary(Configuration config) throws InvalidConfigurationException {
        super(config);
    }

    @Override
    protected LKMMLibrary getThis() {
        return this;
    }

    @Override
    protected Optional<Handler<LKMMLibrary>> getHandler(Function func) {
        final String funcName = func.getName();
        return Arrays.stream(SupportedFunctions.values())
                .filter(f -> f.matches(funcName))
                .map(f -> f.handler)
                .findFirst();
    }


    // ========================================================================================

    private List<Event> handleLKMMFunction(FunctionCall call) {
        final Register reg = (call instanceof ValueFunctionCall valueCall) ? valueCall.getResultRegister() : null;
        final List<Expression> args = call.getArguments();

        final Expression p0 = args.get(0);
        final Expression p1 = args.size() > 1 ? args.get(1) : null;
        final Expression p2 = args.size() > 2 ? args.get(2) : null;
        final Expression p3 = args.size() > 3 ? args.get(3) : null;
        final Expression p4 = args.size() > 4 ? args.get(4) : null;

        final List<Event> result = new ArrayList<>();
        switch (call.getCalledFunction().getName()) {
            case "__LKMM_load" -> {
                checkArguments(3, call);
                final Type bytes = toLKMMAccessSize(p1);
                final String mo = toLKMMMemoryOrder(p2);
                final Register dummy = call.getFunction().newUniqueRegister("__lkmm_temp", bytes);
                result.add(EventFactory.Linux.newLoad(dummy, p0, mo));
                result.add(EventFactory.newLocal(reg, expressions.makeCast(dummy, reg.getType())));
            }
            case "__LKMM_store" -> {
                checkArguments(4, call);
                final Type bytes = toLKMMAccessSize(p1);
                final String mo = toLKMMMemoryOrder(p3);
                final Expression value = expressions.makeCast(p2, bytes);
                result.add(EventFactory.Linux.newStore(p0, value, mo));
            }
            case "__LKMM_xchg" -> {
                checkArguments(4, call);
                final Type bytes = toLKMMAccessSize(p1);
                final String mo = toLKMMMemoryOrder(p3);
                final Register dummy = call.getFunction().newUniqueRegister("__lkmm_temp", bytes);
                final Expression value = expressions.makeCast(p2, bytes);
                result.add(EventFactory.Linux.newRMWExchange(p0, dummy, value, mo));
                result.add(EventFactory.newLocal(reg, expressions.makeCast(dummy, reg.getType())));
            }
            case "__LKMM_cmpxchg" -> {
                checkArguments(6, call);
                final Type bytes = toLKMMAccessSize(p1);
                final String mo = toLKMMMemoryOrder(p4);
                final Register dummy = call.getFunction().newUniqueRegister("__lkmm_temp", bytes);
                final Expression expectation = expressions.makeCast(p2, bytes);
                final Expression value = expressions.makeCast(p3, bytes);
                result.add(EventFactory.Linux.newRMWCompareExchange(p0, dummy, expectation, value, mo));
                result.add(EventFactory.newLocal(reg, expressions.makeCast(dummy, reg.getType())));
            }
            case "__LKMM_atomic_fetch_op" -> {
                checkArguments(5, call);
                final Type bytes = toLKMMAccessSize(p1);
                final String mo = toLKMMMemoryOrder(p3);
                final IntBinaryOp op = toLKMMOperation(p4);
                final Register dummy = call.getFunction().newUniqueRegister("__lkmm_temp", bytes);
                final Expression value = expressions.makeCast(p2, bytes);
                result.add(EventFactory.Linux.newRMWFetchOp(p0, dummy, value, op, mo));
                result.add(EventFactory.newLocal(reg, expressions.makeCast(dummy, reg.getType())));
            }
            case "__LKMM_atomic_op_return" -> {
                checkArguments(5, call);
                final Type bytes = toLKMMAccessSize(p1);
                final String mo = toLKMMMemoryOrder(p3);
                final IntBinaryOp op = toLKMMOperation(p4);
                final Register dummy = call.getFunction().newUniqueRegister("__lkmm_temp", bytes);
                final Expression value = expressions.makeCast(p2, bytes);
                result.add(EventFactory.Linux.newRMWOpReturn(p0, dummy, value, op, mo));
                result.add(EventFactory.newLocal(reg, expressions.makeCast(dummy, reg.getType())));
            }
            case "__LKMM_atomic_op" -> {
                checkArguments(4, call);
                final Type bytes = toLKMMAccessSize(p1);
                final IntBinaryOp op = toLKMMOperation(p3);
                final Expression value = expressions.makeCast(p2, bytes);
                result.add(EventFactory.Linux.newRMWOp(p0, value, op));
            }
            case "__LKMM_fence" -> {
                checkArguments(1, call);
                final String mo = toLKMMMemoryOrder(p0);
                result.add(EventFactory.Linux.newBarrier(mo));
            }
            case "__LKMM_SPIN_LOCK" -> {
                checkArguments(1, call);
                result.add(EventFactory.Linux.newLock(p0));
            }
            case "__LKMM_SPIN_UNLOCK" -> {
                checkArguments(1, call);
                result.add(EventFactory.Linux.newUnlock(p0));
            }
            default -> {
                assert false;
            }
        }
        return result;
    }

    private Type toLKMMAccessSize(Expression argument) {
        if (!(argument instanceof IntLiteral literal)) {
            throw new UnsupportedOperationException("Variable LKMM access size \"" + argument + "\"");
        }
        return types.getIntegerType(8 * literal.getValueAsInt());
    }

    private String toLKMMMemoryOrder(Expression argument) {
        if (!(argument instanceof IntLiteral literal)) {
            throw new UnsupportedOperationException("Variable LKMM memory order \"" + argument + "\"");
        }
        return Tag.Linux.intToMo(literal.getValueAsInt());
    }

    private IntBinaryOp toLKMMOperation(Expression argument) {
        if (!(argument instanceof IntLiteral literal)) {
            throw new UnsupportedOperationException("Variable LKMM operation \"" + argument + "\"");
        }
        return IntBinaryOp.intToOp(literal.getValueAsInt());
    }


}
