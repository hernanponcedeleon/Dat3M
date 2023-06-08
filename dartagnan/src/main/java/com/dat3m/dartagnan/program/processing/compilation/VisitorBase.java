package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.arch.StoreExclusive;
import com.dat3m.dartagnan.program.event.arch.lisa.RMW;
import com.dat3m.dartagnan.program.event.arch.tso.Xchg;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.lang.RMWAbstract;
import com.dat3m.dartagnan.program.event.lang.catomic.AtomicAbstract;
import com.dat3m.dartagnan.program.event.lang.linux.*;
import com.dat3m.dartagnan.program.event.lang.llvm.LlvmAbstractRMW;
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
        Register resultRegister = e.getResultRegister();
        Register statusRegister = e.getThread().newRegister(resultRegister.getType());

        return eventSequence(
                forceStart ? newExecutionStatus(statusRegister, e.getCreationEvent()) : null,
                forceStart ? newAssume(expressions.makeOr(resultRegister, statusRegister)) : null
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
        Register resultRegister = e.getResultRegister();
        Type type = resultRegister.getType();
        Expression zero = expressions.makeZero(type);
        Expression one = expressions.makeOne(type);
        String mo = e.getMo();

        Load rmwLoad = newRMWLoadWithMo(resultRegister, e.getAddress(), mo);
        return eventSequence(
                rmwLoad,
                newJump(expressions.makeNEQ(resultRegister, zero), (Label) e.getThread().getExit()),
                newRMWStoreWithMo(rmwLoad, e.getAddress(), one, mo)
        );
    }

    @Override
    public List<Event> visitUnlock(Unlock e) {
        Register resultRegister = e.getResultRegister();
        Type type = resultRegister.getType();
        Expression zero = expressions.makeZero(type);
        Expression one = expressions.makeOne(type);
        Expression address = e.getAddress();
        String mo = e.getMo();

        Load rmwLoad = newRMWLoadWithMo(resultRegister, address, mo);
        return eventSequence(
                rmwLoad,
                newJump(expressions.makeNEQ(resultRegister, one), (Label) e.getThread().getExit()),
                newRMWStoreWithMo(rmwLoad, address, zero, mo)
        );
    }

    @Override
    public List<Event> visitStoreExclusive(StoreExclusive e) {
        throw error(e);
    }

    @Override
    public List<Event> visitRMWAbstract(RMWAbstract e) {
        throw error(e);
    }

    @Override
    public List<Event> visitRMWAddUnless(RMWAddUnless e) {
        throw error(e);
    }

    @Override
    public List<Event> visitRMWCmpXchg(RMWCmpXchg e) {
        throw error(e);
    }

    @Override
    public List<Event> visitRMWFetchOp(RMWFetchOp e) {
        throw error(e);
    }

    @Override
    public List<Event> visitRMWOp(RMWOp e) {
        throw error(e);
    }

    @Override
    public List<Event> visitRMWOpAndTest(RMWOpAndTest e) {
        throw error(e);
    }

    @Override
    public List<Event> visitRMWOpReturn(RMWOpReturn e) {
        throw error(e);
    }

    @Override
    public List<Event> visitRMWXchg(RMWXchg e) {
        throw error(e);
    }

    @Override
    public List<Event> visitXchg(Xchg e) {
        throw error(e);
    }

    @Override
    public List<Event> visitRMW(RMW e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();
        Register dummyReg = e.getThread().newRegister(resultRegister.getType());
        Load load = newRMWLoadWithMo(dummyReg, address, mo);
        RMWStore store = newRMWStoreWithMo(load, address, e.getMemValue(), mo);
        return eventSequence(
                load,
                store,
                newLocal(resultRegister, dummyReg)
        );
    }

    @Override
    public List<Event> visitAtomicAbstract(AtomicAbstract e) {
        throw error(e);
    }

    // LLVM Events
    @Override
    public List<Event> visitLlvmAbstract(LlvmAbstractRMW e) {
        throw error(e);
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