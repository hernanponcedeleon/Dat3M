package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.arch.StoreExclusive;
import com.dat3m.dartagnan.program.event.arch.lisa.LISARMW;
import com.dat3m.dartagnan.program.event.arch.tso.TSOXchg;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.lang.linux.*;
import com.dat3m.dartagnan.program.event.lang.llvm.LlvmLoad;
import com.dat3m.dartagnan.program.event.lang.llvm.LlvmStore;
import com.dat3m.dartagnan.program.event.lang.pthread.InitLock;
import com.dat3m.dartagnan.program.event.lang.pthread.Lock;
import com.dat3m.dartagnan.program.event.lang.pthread.Start;
import com.dat3m.dartagnan.program.event.lang.pthread.Unlock;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.base.Preconditions;

import java.util.Collections;
import java.util.List;

import static com.dat3m.dartagnan.program.event.EventFactory.*;

class VisitorBase implements EventVisitor<List<Event>> {

    protected boolean forceStart;
    protected final TypeFactory types = TypeFactory.getInstance();
    protected final ExpressionFactory expressions = ExpressionFactory.getInstance();

    protected VisitorBase(boolean forceStart) {
        this.forceStart = forceStart;
    }

    @Override
    public List<Event> visitEvent(Event e) {
        return Collections.singletonList(e);
    }

    @Override
    public List<Event> visitCondJump(CondJump e) {
        Preconditions.checkState(e.getSuccessor() != null, "Malformed CondJump event");
        return visitEvent(e);
    }

    @Override
    public List<Event> visitStart(Start e) {
        throw error(e);
    }

    protected List<Event> visitStartBase(Register resultRegister, Start e) {
        Register statusRegister = e.getFunction().newRegister(types.getBooleanType());
        return eventSequence(
                forceStart ? newExecutionStatus(statusRegister, e.getCreationEvent()) : null,
                forceStart ? newAssume(expressions.makeOr(resultRegister, statusRegister)) : null,
                newJumpUnless(resultRegister, (Label) e.getThread().getExit())
        );
    }

    @Override
    public List<Event> visitInitLock(InitLock e) {
        return eventSequence(
                newStoreWithMo(e.getAddress(), e.getMemValue(), e.getMo())
        );
    }

    @Override
    public List<Event> visitLock(Lock e) {
        IntegerType type = types.getArchType(); // TODO: Boolean should be sufficient
        Register dummy = e.getThread().newRegister(type);
        Expression zero = expressions.makeZero(type);
        Expression one = expressions.makeOne(type);
        String mo = e.getMo();

        Load rmwLoad = newRMWLoadWithMo(dummy, e.getAddress(), mo);
        return eventSequence(
                rmwLoad,
                newJump(expressions.makeNEQ(dummy, zero), (Label) e.getThread().getExit()),
                newRMWStoreWithMo(rmwLoad, e.getAddress(), one, mo)
        );
    }

    @Override
    public List<Event> visitUnlock(Unlock e) {
        IntegerType type = types.getArchType(); // TODO: Boolean should be sufficient
        Register dummy = e.getThread().newRegister(type);
        Expression zero = expressions.makeZero(type);
        Expression one = expressions.makeOne(type);
        Expression address = e.getAddress();
        String mo = e.getMo();

        Load rmwLoad = newRMWLoadWithMo(dummy, address, mo);
        return eventSequence(
                rmwLoad,
                newJump(expressions.makeNEQ(dummy, one), (Label) e.getThread().getExit()),
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