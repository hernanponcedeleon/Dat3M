package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.arch.StoreExclusive;
import com.dat3m.dartagnan.program.event.arch.lisa.LISARMW;
import com.dat3m.dartagnan.program.event.arch.tso.TSOXchg;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.event.core.RMWStore;
import com.dat3m.dartagnan.program.event.lang.linux.*;
import com.dat3m.dartagnan.program.event.lang.llvm.LlvmLoad;
import com.dat3m.dartagnan.program.event.lang.llvm.LlvmStore;
import com.dat3m.dartagnan.program.event.lang.pthread.InitLock;
import com.dat3m.dartagnan.program.event.lang.pthread.Lock;
import com.dat3m.dartagnan.program.event.lang.pthread.Unlock;

import java.util.Collections;
import java.util.List;

import static com.dat3m.dartagnan.program.event.EventFactory.eventSequence;

class VisitorBase<F extends EventFactory> implements EventVisitor<List<Event>> {

    protected final F eventFactory;
    protected final ExpressionFactory expressions;
    protected final TypeFactory types;

    protected Function funcToBeCompiled;

    protected VisitorBase(F eventFactory) {
        this.eventFactory = eventFactory;
        expressions = eventFactory.getExpressionFactory();
        types = expressions.getTypeFactory();
    }

    protected Event newTerminator(Expression guard) {
        if (funcToBeCompiled instanceof Thread thread) {
            return eventFactory.newJump(guard, (Label) thread.getExit());
        } else {
            return eventFactory.newAbortIf(guard);
        }
    }

    protected Local newAssignment(Register register, Expression value) {
        return eventFactory.newLocal(register, expressions.makeCast(value, register.getType()));
    }

    @Override
    public List<Event> visitEvent(Event e) {
        return Collections.singletonList(e);
    }

    @Override
    public List<Event> visitInitLock(InitLock e) {
        return eventSequence(
                eventFactory.newStoreWithMo(e.getAddress(), e.getMemValue(), e.getMo())
        );
    }

    @Override
    public List<Event> visitLock(Lock e) {
        IntegerType type = (IntegerType) e.getAccessType(); // TODO: Boolean should be sufficient
        Register dummy = e.getFunction().newRegister(type);
        Expression zero = expressions.makeZero(type);
        Expression one = expressions.makeOne(type);
        String mo = e.getMo();

        Load rmwLoad = eventFactory.newRMWLoadWithMo(dummy, e.getAddress(), mo);
        return eventSequence(
                rmwLoad,
                newTerminator(expressions.makeNEQ(dummy, zero)),
                eventFactory.newRMWStoreWithMo(rmwLoad, e.getAddress(), one, mo)
        );
    }

    @Override
    public List<Event> visitUnlock(Unlock e) {
        IntegerType type = (IntegerType) e.getAccessType(); // TODO: Boolean should be sufficient
        Register dummy = e.getFunction().newRegister(type);
        Expression zero = expressions.makeZero(type);
        Expression one = expressions.makeOne(type);
        Expression address = e.getAddress();
        String mo = e.getMo();

        Load rmwLoad = eventFactory.newRMWLoadWithMo(dummy, address, mo);
        return eventSequence(
                rmwLoad,
                newTerminator(expressions.makeNEQ(dummy, one)),
                eventFactory.newRMWStoreWithMo(rmwLoad, address, zero, mo)
        );
    }

    @Override
    public List<Event> visitStoreExclusive(StoreExclusive e) {
        throw error(e);
    }

    @Override
    public List<Event> visitLKMMAddUnless(LKMMAddUnless e) {
        throw error(e);
    }

    @Override
    public List<Event> visitLKMMCmpXchg(LKMMCmpXchg e) {
        throw error(e);
    }

    @Override
    public List<Event> visitLKMMFetchOp(LKMMFetchOp e) {
        throw error(e);
    }

    @Override
    public List<Event> visitLKMMOpNoReturn(LKMMOpNoReturn e) {
        throw error(e);
    }

    @Override
    public List<Event> visitLKMMOpAndTest(LKMMOpAndTest e) {
        throw error(e);
    }

    @Override
    public List<Event> visitLKMMOpReturn(LKMMOpReturn e) {
        throw error(e);
    }

    @Override
    public List<Event> visitLKMMXchg(LKMMXchg e) {
        throw error(e);
    }

    @Override
    public List<Event> visitTSOXchg(TSOXchg e) {
        throw error(e);
    }

    @Override
    public List<Event> visitLISARMW(LISARMW e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();
        Register dummyReg = e.getFunction().newRegister(resultRegister.getType());
        Load load = eventFactory.newRMWLoadWithMo(dummyReg, address, mo);
        RMWStore store = eventFactory.newRMWStoreWithMo(load, address, e.getValue(), mo);
        return eventSequence(
                load,
                store,
                eventFactory.newLocal(resultRegister, dummyReg)
        );
    }

    @Override
    public List<Event> visitLlvmLoad(LlvmLoad e) {
        throw error(e);
    }

    @Override
    public List<Event> visitLlvmStore(LlvmStore e) {
        throw error(e);
    }

    private IllegalArgumentException error(Event e) {
        return new IllegalArgumentException("Compilation for " + e.getClass().getSimpleName() +
                " is not supported by " + getClass().getSimpleName());
    }

}