package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.MemoryEvent;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.arch.tso.TSOXchg;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.llvm.*;
import com.dat3m.dartagnan.program.event.lang.pthread.InitLock;
import com.dat3m.dartagnan.program.event.lang.pthread.Lock;
import com.dat3m.dartagnan.program.event.lang.pthread.Unlock;

import java.util.List;

import static com.dat3m.dartagnan.program.event.EventFactory.eventSequence;
import static com.google.common.base.Verify.verify;

class VisitorTso extends VisitorBase<EventFactory.X86> {

    VisitorTso(EventFactory events) {
        super(events.withX86());
    }

    @Override
    public List<Event> visitTSOXchg(TSOXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();

        Register dummyReg = e.getFunction().newRegister(resultRegister.getType());
        Load load = eventFactory.newRMWLoad(dummyReg, address);

        return tagList(eventSequence(
                load,
                eventFactory.newRMWStore(load, address, resultRegister),
                eventFactory.newLocal(resultRegister, dummyReg)
        ));
    }

    // =============================================================================================
    // ========================================= PTHREAD ===========================================
    // =============================================================================================

    public List<Event> visitInitLock(InitLock e) {
        return eventSequence(
                eventFactory.newStore(e.getAddress(), e.getMemValue()),
                eventFactory.newMemoryFence()
        );
    }

    @Override
    public List<Event> visitLock(Lock e) {
        IntegerType type = (IntegerType)e.getAccessType();
        Register dummy = e.getFunction().newRegister(type);
        // We implement locks as spinlocks which are guaranteed to succeed, i.e. we can
        // use assumes. Nothing else is needed to guarantee acquire semantics in TSO.
        Load load = eventFactory.newRMWLoad(dummy, e.getAddress());
        return eventSequence(
                load,
                eventFactory.newAssume(expressions.makeEQ(dummy, expressions.makeZero(type))),
                eventFactory.newRMWStore(load, e.getAddress(), expressions.makeOne(type))
        );
    }

    @Override
    public List<Event> visitUnlock(Unlock e) {
        return eventSequence(
                eventFactory.newStore(e.getAddress(),
                expressions.makeZero((IntegerType) e.getAccessType())),
                eventFactory.newMemoryFence()
        );
    }

    // =============================================================================================
    // =========================================== LLVM ============================================
    // =============================================================================================

    @Override
    public List<Event> visitLlvmLoad(LlvmLoad e) {
        return eventSequence(
                eventFactory.newLoad(e.getResultRegister(), e.getAddress())
        );
    }

    @Override
    public List<Event> visitLlvmStore(LlvmStore e) {
        Event optionalMFence = e.getMo().equals(Tag.C11.MO_SC) ? eventFactory.newMemoryFence() : null;

        return eventSequence(
                eventFactory.newStore(e.getAddress(), e.getMemValue()),
                optionalMFence
        );
    }

    @Override
    public List<Event> visitLlvmXchg(LlvmXchg e) {
        Expression address = e.getAddress();
        Load load = eventFactory.newRMWLoad(e.getResultRegister(), address);

        return tagList(eventSequence(
                load,
                eventFactory.newRMWStore(load, address, e.getValue())
        ));
    }

    @Override
    public List<Event> visitLlvmRMW(LlvmRMW e) {
        Register resultRegister = e.getResultRegister();
        Register dummyReg = e.getFunction().newRegister(resultRegister.getType());

        Expression address = e.getAddress();
        Expression modifiedValue = expressions.makeBinary(resultRegister, e.getOperator(), e.getOperand());
        Load load = eventFactory.newRMWLoad(resultRegister, address);

        return tagList(eventSequence(
                load,
                eventFactory.newLocal(dummyReg, modifiedValue),
                eventFactory.newRMWStore(load, address, dummyReg)
        ));
    }

    @Override
    public List<Event> visitLlvmCmpXchg(LlvmCmpXchg e) {
        Register oldValueRegister = e.getStructRegister(0);
        Register resultRegister = e.getStructRegister(1);
        verify(resultRegister.getType() instanceof BooleanType);

        Expression address = e.getAddress();
        Expression expectedValue = e.getExpectedValue();

        Local casCmpResult = eventFactory.newLocal(resultRegister, expressions.makeEQ(oldValueRegister, expectedValue));
        Label casEnd = eventFactory.newLabel("CAS_end");
        CondJump branchOnCasCmpResult = eventFactory.newJumpUnless(resultRegister, casEnd);

        Load load = eventFactory.newRMWLoad(oldValueRegister, address);
        Store store = eventFactory.newRMWStore(load, address, e.getStoreValue());

        return tagList(eventSequence(
                load,
                casCmpResult,
                branchOnCasCmpResult,
                store,
                casEnd
        ));
    }

    @Override
    public List<Event> visitLlvmFence(LlvmFence e) {
        Event optionalFence = e.getMo().equals(Tag.C11.MO_SC) ? eventFactory.newMemoryFence() : null;

        return eventSequence(
                optionalFence
        );
    }

    // =============================================================================================
    // ============================================ C11 ============================================
    // =============================================================================================

    @Override
    public List<Event> visitAtomicCmpXchg(AtomicCmpXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        Expression value = e.getStoreValue();
        Expression expectedAddr = e.getAddressOfExpected();
        Type type = resultRegister.getType();
        Register booleanResultRegister = type instanceof BooleanType ? resultRegister :
                e.getFunction().newRegister(types.getBooleanType());
        Local castResult = booleanResultRegister == resultRegister ? null :
                newAssignment(resultRegister, booleanResultRegister);
        Register regExpected = e.getFunction().newRegister(type);
        Load loadExpected = eventFactory.newLoad(regExpected, expectedAddr);
        Register regValue = e.getFunction().newRegister(type);
        Load loadValue = eventFactory.newRMWLoad(regValue, address);
        Local casCmpResult = eventFactory.newLocal(booleanResultRegister, expressions.makeEQ(regValue, regExpected));
        Label casFail = eventFactory.newLabel("CAS_fail");
        CondJump branchOnCasCmpResult = eventFactory.newJumpUnless(booleanResultRegister, casFail);
        Store storeValue = eventFactory.newRMWStore(loadValue, address, value);
        Label casEnd = eventFactory.newLabel("CAS_end");
        CondJump gotoCasEnd = eventFactory.newGoto(casEnd);
        Store storeExpected = eventFactory.newStore(expectedAddr, regValue);
        return tagList(eventSequence(
                loadExpected,
                loadValue,
                casCmpResult,
                branchOnCasCmpResult,
                storeValue,
                gotoCasEnd,
                casFail,
                storeExpected,
                casEnd,
                castResult
        ));
    }

    @Override
    public List<Event> visitAtomicFetchOp(AtomicFetchOp e) {
        Register resultRegister = e.getResultRegister();
        Register dummyReg = e.getFunction().newRegister(resultRegister.getType());

        Expression address = e.getAddress();
        Expression modifiedValue = expressions.makeBinary(resultRegister, e.getOperator(), e.getOperand());
        Load load = eventFactory.newRMWLoad(resultRegister, address);

        return tagList(eventSequence(
                load,
                eventFactory.newLocal(dummyReg, modifiedValue),
                eventFactory.newRMWStore(load, address, dummyReg)
        ));
    }

    @Override
    public List<Event> visitAtomicLoad(AtomicLoad e) {
        return eventSequence(
                eventFactory.newLoad(e.getResultRegister(), e.getAddress())
        );
    }

    @Override
    public List<Event> visitAtomicStore(AtomicStore e) {
        String mo = e.getMo();
        Event optionalMFence = mo.equals(Tag.C11.MO_SC) ? eventFactory.newMemoryFence() : null;

        return eventSequence(
                eventFactory.newStore(e.getAddress(), e.getMemValue()),
                optionalMFence
        );
    }

    @Override
    public List<Event> visitAtomicThreadFence(AtomicThreadFence e) {
        Event optionalFence = e.getMo().equals(Tag.C11.MO_SC) ? eventFactory.newMemoryFence() : null;

        return eventSequence(
                optionalFence
        );
    }

    @Override
    public List<Event> visitAtomicXchg(AtomicXchg e) {
        Expression address = e.getAddress();
        Load load = eventFactory.newRMWLoad(e.getResultRegister(), address);

        return tagList(eventSequence(
                load,
                eventFactory.newRMWStore(load, address, e.getValue())
        ));
    }

    private List<Event> tagList(List<Event> in) {
        in.forEach(this::tagEvent);
        return in;
    }

    private void tagEvent(Event e) {
        if (e instanceof MemoryEvent) {
            e.addTags(Tag.TSO.ATOM);
        }
    }

}