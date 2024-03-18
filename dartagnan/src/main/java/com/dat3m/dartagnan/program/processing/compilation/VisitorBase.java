package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.arch.StoreExclusive;
import com.dat3m.dartagnan.program.event.arch.lisa.LISARMW;
import com.dat3m.dartagnan.program.event.arch.tso.TSOXchg;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.RMWStore;
import com.dat3m.dartagnan.program.event.lang.linux.*;
import com.dat3m.dartagnan.program.event.lang.llvm.LlvmLoad;
import com.dat3m.dartagnan.program.event.lang.llvm.LlvmStore;
import com.dat3m.dartagnan.program.event.lang.pthread.InitLock;
import com.dat3m.dartagnan.program.event.lang.pthread.Lock;
import com.dat3m.dartagnan.program.event.lang.pthread.Unlock;

import java.util.Collections;
import java.util.List;

import static com.dat3m.dartagnan.program.event.EventFactory.*;

class VisitorBase implements EventVisitor<List<Event>> {

    protected final TypeFactory types = TypeFactory.getInstance();
    protected final ExpressionFactory expressions = ExpressionFactory.getInstance();

    protected Function funcToBeCompiled;

    protected VisitorBase() { }

    protected Event newTerminator(Expression guard) {
        if (funcToBeCompiled instanceof Thread thread) {
            return newJump(guard, (Label)thread.getExit());
        } else {
            return newAbortIf(guard);
        }
    }

    @Override
    public List<Event> visitEvent(Event e) {
        return Collections.singletonList(e);
    }

    @Override
    public List<Event> visitInitLock(InitLock e) {
        return eventSequence(
                newStoreWithMo(e.getAddress(), e.getMemValue(), e.getMo())
        );
    }

    @Override
    public List<Event> visitLock(Lock e) {
        IntegerType type = (IntegerType) e.getAccessType(); // TODO: Boolean should be sufficient
        Register dummy = e.getFunction().newRegister(type);
        Expression zero = expressions.makeZero(type);
        Expression one = expressions.makeOne(type);
        String mo = e.getMo();

        Load rmwLoad = newRMWLoadWithMo(dummy, e.getAddress(), mo);
        return eventSequence(
                rmwLoad,
                newTerminator(expressions.makeNEQ(dummy, zero)),
                newRMWStoreWithMo(rmwLoad, e.getAddress(), one, mo)
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

        Load rmwLoad = newRMWLoadWithMo(dummy, address, mo);
        return eventSequence(
                rmwLoad,
                newTerminator(expressions.makeNEQ(dummy, one)),
                newRMWStoreWithMo(rmwLoad, address, zero, mo)
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
        Load load = newRMWLoadWithMo(dummyReg, address, mo);
        RMWStore store = newRMWStoreWithMo(load, address, e.getValue(), mo);
        return eventSequence(
                load,
                store,
                newLocal(resultRegister, dummyReg)
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