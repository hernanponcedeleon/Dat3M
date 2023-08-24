package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.MemoryEvent;
import com.dat3m.dartagnan.program.event.Tag.C11;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.llvm.*;
import com.dat3m.dartagnan.program.event.metadata.MemoryOrder;

import java.util.List;

import static com.dat3m.dartagnan.program.event.EventFactory.eventSequence;
import static com.google.common.base.Verify.verify;

public class VisitorC11 extends VisitorBase<EventFactory> {

    VisitorC11(EventFactory eventFactory) {
        super(eventFactory);
    }

    @Override
    public List<Event> visitLoad(Load e) {
        return tagList(eventSequence(e));
    }

    @Override
    public List<Event> visitStore(Store e) {
        return tagList(eventSequence(e));
    }

    // =============================================================================================
    // =========================================== C11 =============================================
    // =============================================================================================

    @Override
    public List<Event> visitAtomicCmpXchg(AtomicCmpXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();
        Expression expectedAddr = e.getAddressOfExpected();
        Type type = resultRegister.getType();
        Register booleanResultRegister = type instanceof BooleanType ? resultRegister :
                e.getFunction().newRegister(types.getBooleanType());
        Local castResult = type instanceof BooleanType ? null : newAssignment(resultRegister, booleanResultRegister);
        Register regExpected = e.getFunction().newRegister(type);
        Register regValue = e.getFunction().newRegister(type);
        Load loadExpected = eventFactory.newLoad(regExpected, expectedAddr);
        Store storeExpected = eventFactory.newStore(expectedAddr, regValue);
        Label casFail = eventFactory.newLabel("CAS_fail");
        Label casEnd = eventFactory.newLabel("CAS_end");
        Local casCmpResult = eventFactory.newLocal(booleanResultRegister, expressions.makeEQ(regValue, regExpected));
        CondJump branchOnCasCmpResult = eventFactory.newJumpUnless(booleanResultRegister, casFail);
        CondJump gotoCasEnd = eventFactory.newGoto(casEnd);
        Load loadValue = eventFactory.newRMWLoadWithMo(regValue, address, mo);
        Store storeValue = eventFactory.newRMWStoreWithMo(loadValue, address, e.getStoreValue(), mo);

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
        Expression address = e.getAddress();
        String mo = e.getMo();

        Register dummyReg = e.getFunction().newRegister(resultRegister.getType());
        Load load = eventFactory.newRMWLoadWithMo(resultRegister, address, mo);
        Local localOp = eventFactory.newLocal(dummyReg,
                expressions.makeBinary(resultRegister, e.getOperator(), e.getOperand()));
        RMWStore store = eventFactory.newRMWStoreWithMo(load, address, dummyReg, mo);

        return tagList(eventSequence(
                load,
                localOp,
                store
        ));
    }

    @Override
    public List<Event> visitAtomicLoad(AtomicLoad e) {
        return tagList(eventSequence(
                eventFactory.newLoadWithMo(e.getResultRegister(), e.getAddress(), e.getMo())
        ));
    }

    @Override
    public List<Event> visitAtomicStore(AtomicStore e) {
        return tagList(eventSequence(
                eventFactory.newStoreWithMo(e.getAddress(), e.getMemValue(), e.getMo())
        ));
    }

    @Override
    public List<Event> visitAtomicThreadFence(AtomicThreadFence e) {
        return tagList(eventSequence(
                eventFactory.newFence(e.getMo())
        ));
    }

    @Override
    public List<Event> visitAtomicXchg(AtomicXchg e) {
        Expression address = e.getAddress();
        String mo = e.getMo();

        Load load = eventFactory.newRMWLoadWithMo(e.getResultRegister(), address, mo);
        RMWStore store = eventFactory.newRMWStoreWithMo(load, address, e.getValue(), mo);

        return tagList(eventSequence(
                load,
                store
        ));
    }

    // =============================================================================================
    // =========================================== LLVM ============================================
    // =============================================================================================

    @Override
    public List<Event> visitLlvmLoad(LlvmLoad e) {
        return tagList(eventSequence(
                eventFactory.newLoadWithMo(e.getResultRegister(), e.getAddress(), e.getMo())
        ));
    }

    @Override
    public List<Event> visitLlvmStore(LlvmStore e) {
        return tagList(eventSequence(
                eventFactory.newStoreWithMo(e.getAddress(), e.getMemValue(), e.getMo())
        ));
    }

    @Override
    public List<Event> visitLlvmXchg(LlvmXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Load load = eventFactory.newRMWLoadExclusiveWithMo(resultRegister, address, mo);
        Store store = eventFactory.newRMWStoreExclusiveWithMo(address, e.getValue(), true, mo);

        return tagList(eventSequence(
                load,
                store
        ));
    }

    @Override
    public List<Event> visitLlvmRMW(LlvmRMW e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Register dummyReg = e.getFunction().newRegister(resultRegister.getType());
        Local localOp = eventFactory.newLocal(dummyReg,
                expressions.makeBinary(resultRegister, e.getOperator(), e.getOperand()));

        Load load = eventFactory.newRMWLoadExclusiveWithMo(resultRegister, address, mo);
        Store store = eventFactory.newRMWStoreExclusiveWithMo(address, dummyReg, true, mo);

        return tagList(eventSequence(
                load,
                localOp,
                store
        ));
    }

    @Override
    public List<Event> visitLlvmCmpXchg(LlvmCmpXchg e) {
        Register oldValueRegister = e.getStructRegister(0);
        Register resultRegister = e.getStructRegister(1);
        verify(resultRegister.getType() instanceof BooleanType);

        Expression address = e.getAddress();
        String mo = e.getMo();
        Expression expectedValue = e.getExpectedValue();

        Local casCmpResult = eventFactory.newLocal(resultRegister, expressions.makeEQ(oldValueRegister, expectedValue));
        Label casEnd = eventFactory.newLabel("CAS_end");
        CondJump branchOnCasCmpResult = eventFactory.newJumpUnless(resultRegister, casEnd);

        Load load = eventFactory.newRMWLoadExclusiveWithMo(oldValueRegister, address, mo);
        Store store = eventFactory.newRMWStoreExclusiveWithMo(address, e.getStoreValue(), true, mo);

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
        return tagList(eventSequence(
                eventFactory.newFence(e.getMo())
        ));
    }

    private List<Event> tagList(List<Event> in) {
        in.forEach(this::tagEvent);
        return in;
    }

    private void tagEvent(Event e) {
        if (e instanceof MemoryEvent) {
            final MemoryOrder mo = e.getMetadata(MemoryOrder.class);
            final boolean canRace = mo == null || mo.value().equals(C11.NONATOMIC);
            e.addTags(canRace ? C11.NONATOMIC : C11.ATOMIC);
        }
    }

}
