package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.Tag.C11;
import com.dat3m.dartagnan.program.event.Tag.IMM;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.llvm.*;
import com.dat3m.dartagnan.program.event.metadata.MemoryOrder;

import java.util.Collections;
import java.util.List;

import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static com.dat3m.dartagnan.program.event.Tag.IMM.extractLoadMo;
import static com.dat3m.dartagnan.program.event.Tag.IMM.extractStoreMo;
import static com.google.common.base.Verify.verify;

class VisitorIMM extends VisitorBase<EventFactory> {

    VisitorIMM(EventFactory events) {
        super(events);
    }

    @Override
    public List<Event> visitLoad(Load e) {
        // FIXME: It is weird to compile a core-level load by transforming its tagging.
        final MemoryOrder mo = e.getMetadata(MemoryOrder.class);
        final boolean isNonAtomic = (mo == null || mo.value().equals(C11.NONATOMIC));
        final String moLoad = isNonAtomic ? C11.MO_RELAXED : mo.value();
        return eventSequence(
                eventFactory.newLoadWithMo(e.getResultRegister(), e.getAddress(), moLoad)
        );
    }

    @Override
    public List<Event> visitStore(Store e) {
        // FIXME: It is weird to compile a core-level load by transforming its tagging.
        final MemoryOrder mo = e.getMetadata(MemoryOrder.class);
        final boolean isNonAtomic = (mo == null || mo.value().equals(C11.NONATOMIC));
        String moStore = isNonAtomic ? C11.MO_RELAXED : mo.value();
        return eventSequence(
                eventFactory.newStoreWithMo(e.getAddress(), e.getMemValue(), moStore)
        );
    }

    // =============================================================================================
    // =========================================== C11 =============================================
    // =============================================================================================

    @Override
    public List<Event> visitAtomicCmpXchg(AtomicCmpXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();
        Event optionalFenceLoad = mo.equals(Tag.C11.MO_SC) ? eventFactory.newFence(Tag.C11.MO_SC) : null;
        Event optionalFenceStore = mo.equals(Tag.C11.MO_SC) ? eventFactory.newFence(Tag.C11.MO_SC) : null;
        Expression expectedAddr = e.getAddressOfExpected();
        Type type = resultRegister.getType();
        Register booleanResultRegister = type instanceof BooleanType ? resultRegister :
                e.getFunction().newRegister(types.getBooleanType());
        Local castResult = type instanceof BooleanType ? null : newAssignment(resultRegister, booleanResultRegister);
        Register regExpected = e.getFunction().newRegister(type);
        Register regValue = e.getFunction().newRegister(type);
        Load loadExpected = eventFactory.newLoad(regExpected, expectedAddr);
        loadExpected.addTags(Tag.IMM.CASDEPORIGIN);
        Store storeExpected = eventFactory.newStore(expectedAddr, regValue);
        Label casFail = eventFactory.newLabel("CAS_fail");
        Label casEnd = eventFactory.newLabel("CAS_end");
        Local casCmpResult = eventFactory.newLocal(booleanResultRegister, expressions.makeEQ(regValue, regExpected));
        CondJump branchOnCasCmpResult = eventFactory.newJumpUnless(booleanResultRegister, casFail);
        CondJump gotoCasEnd = eventFactory.newGoto(casEnd);
        Load loadValue = eventFactory.newRMWLoadWithMo(regValue, address, extractLoadMo(mo));
        Store storeValue = eventFactory.newRMWStoreWithMo(loadValue, address, e.getStoreValue(), extractStoreMo(mo));

        return eventSequence(
                loadExpected,
                optionalFenceLoad,
                loadValue,
                casCmpResult,
                branchOnCasCmpResult,
                optionalFenceStore,
                storeValue,
                gotoCasEnd,
                casFail,
                storeExpected,
                casEnd,
                castResult
        );
    }

    @Override
    public List<Event> visitAtomicFetchOp(AtomicFetchOp e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();
        Event optionalFenceBefore = mo.equals(Tag.C11.MO_SC) ? eventFactory.newFence(Tag.C11.MO_SC) : null;
        Event optionalFenceAfter = mo.equals(Tag.C11.MO_SC) ? eventFactory.newFence(Tag.C11.MO_SC) : null;

        Expression modifiedValue = expressions.makeBinary(resultRegister, e.getOperator(), e.getOperand());
        Register dummyReg = e.getFunction().newRegister(resultRegister.getType());
        Load load = eventFactory.newRMWLoadWithMo(resultRegister, address, extractLoadMo(mo));

        return eventSequence(
                optionalFenceBefore,
                load,
                eventFactory.newLocal(dummyReg, modifiedValue),
                optionalFenceAfter,
                eventFactory.newRMWStoreWithMo(load, address, dummyReg, extractStoreMo(mo))
        );
    }

    @Override
    public List<Event> visitAtomicLoad(AtomicLoad e) {
        String mo = e.getMo();
        Event optionalFence = mo.equals(Tag.C11.MO_SC) ? eventFactory.newFence(Tag.C11.MO_SC) : null;
        return eventSequence(
                optionalFence,
                eventFactory.newLoadWithMo(e.getResultRegister(), e.getAddress(), extractLoadMo(mo))
        );
    }

    @Override
    public List<Event> visitAtomicStore(AtomicStore e) {
        String mo = e.getMo();
        Event optionalFence = mo.equals(Tag.C11.MO_SC) ? eventFactory.newFence(Tag.C11.MO_SC) : null;
        return eventSequence(
                optionalFence,
                eventFactory.newStoreWithMo(e.getAddress(), e.getMemValue(), extractStoreMo(mo))
        );
    }

    @Override
    public List<Event> visitAtomicThreadFence(AtomicThreadFence e) {
        return Collections.singletonList(eventFactory.newFence(e.getMo()));
    }

    @Override
    public List<Event> visitAtomicXchg(AtomicXchg e) {
        Expression address = e.getAddress();
        String mo = e.getMo();
        Event optionalFenceLoad = mo.equals(Tag.C11.MO_SC) ? eventFactory.newFence(Tag.C11.MO_SC) : null;
        Event optionalFenceStore = mo.equals(Tag.C11.MO_SC) ? eventFactory.newFence(Tag.C11.MO_SC) : null;

        Load load = eventFactory.newRMWLoadWithMo(e.getResultRegister(), address, mo);

        return eventSequence(
                optionalFenceLoad,
                load,
                optionalFenceStore,
                eventFactory.newRMWStoreWithMo(load, address, e.getValue(), extractStoreMo(mo))
        );
    }

    // =============================================================================================
    // =========================================== LLVM ============================================
    // =============================================================================================

    @Override
    public List<Event> visitLlvmLoad(LlvmLoad e) {
        return eventSequence(
                eventFactory.newLoadWithMo(e.getResultRegister(), e.getAddress(), IMM.extractLoadMo(e.getMo()))
        );
    }

    @Override
    public List<Event> visitLlvmStore(LlvmStore e) {
        return eventSequence(
                eventFactory.newStoreWithMo(e.getAddress(), e.getMemValue(), IMM.extractStoreMo(e.getMo()))
        );
    }

    @Override
    public List<Event> visitLlvmXchg(LlvmXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Load load = eventFactory.newRMWLoadExclusiveWithMo(resultRegister, address, IMM.extractLoadMo(mo));
        Store store = eventFactory.newRMWStoreExclusiveWithMo(address, e.getValue(), true, IMM.extractStoreMo(mo));
        Label label = eventFactory.newLabel("FakeDep");
        Event fakeCtrlDep = eventFactory.newFakeCtrlDep(resultRegister, label);

        return eventSequence(
                load,
                fakeCtrlDep,
                label,
                store
        );
    }

    @Override
    public List<Event> visitLlvmRMW(LlvmRMW e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Expression modifiedValue = expressions.makeBinary(resultRegister, e.getOperator(), e.getOperand());
        Register dummyReg = e.getFunction().newRegister(resultRegister.getType());
        Local localOp = eventFactory.newLocal(dummyReg, modifiedValue);

        Load load = eventFactory.newRMWLoadExclusiveWithMo(resultRegister, address, IMM.extractLoadMo(mo));
        Store store = eventFactory.newRMWStoreExclusiveWithMo(address, dummyReg, true, IMM.extractStoreMo(mo));
        Label label = eventFactory.newLabel("FakeDep");
        Event fakeCtrlDep = eventFactory.newFakeCtrlDep(resultRegister, label);

        return eventSequence(
                load,
                fakeCtrlDep,
                label,
                localOp,
                store
        );
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

        Load load = eventFactory.newRMWLoadExclusiveWithMo(oldValueRegister, address, IMM.extractLoadMo(mo));
        Store store = eventFactory.newRMWStoreExclusiveWithMo(address, e.getStoreValue(), true, IMM.extractStoreMo(mo));

        return eventSequence(
                load,
                casCmpResult,
                branchOnCasCmpResult,
                store,
                casEnd
        );
    }

    @Override
    public List<Event> visitLlvmFence(LlvmFence e) {
        return eventSequence(
                eventFactory.newFence(e.getMo())
        );
    }

}