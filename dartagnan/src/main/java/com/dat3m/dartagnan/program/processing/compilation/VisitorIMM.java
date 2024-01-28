package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
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

class VisitorIMM extends VisitorBase {

    @Override
    public List<Event> visitLoad(Load e) {
        // FIXME: It is weird to compile a core-level load by transforming its tagging.
        final MemoryOrder mo = e.getMetadata(MemoryOrder.class);
        final boolean isNonAtomic = (mo == null || mo.value().equals(C11.NONATOMIC));
        return eventSequence(
                newLoadWithMo(e.getResultRegister(), e.getAddress(), isNonAtomic ? C11.MO_RELAXED : mo.value())
        );
    }

    @Override
    public List<Event> visitStore(Store e) {
        // FIXME: It is weird to compile a core-level load by transforming its tagging.
        final MemoryOrder mo = e.getMetadata(MemoryOrder.class);
        final boolean isNonAtomic = (mo == null || mo.value().equals(C11.NONATOMIC));
        return eventSequence(
                newStoreWithMo(e.getAddress(), e.getMemValue(), isNonAtomic ? C11.MO_RELAXED : mo.value())
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
        Event optionalFenceLoad = mo.equals(Tag.C11.MO_SC) ? newFence(Tag.C11.MO_SC) : null;
        Event optionalFenceStore = mo.equals(Tag.C11.MO_SC) ? newFence(Tag.C11.MO_SC) : null;
        Expression expectedAddr = e.getAddressOfExpected();
        Type type = resultRegister.getType();
        Register booleanResultRegister = type instanceof BooleanType ? resultRegister :
                e.getFunction().newRegister(types.getBooleanType());
        Local castResult = type instanceof BooleanType ? null :
                newLocal(resultRegister, expressions.makeCast(booleanResultRegister, type));
        Register regExpected = e.getFunction().newRegister(type);
        Register regValue = e.getFunction().newRegister(type);
        Load loadExpected = newLoad(regExpected, expectedAddr);
        loadExpected.addTags(Tag.IMM.CASDEPORIGIN);
        Store storeExpected = newStore(expectedAddr, regValue);
        Label casFail = newLabel("CAS_fail");
        Label casEnd = newLabel("CAS_end");
        Local casCmpResult = newLocal(booleanResultRegister, expressions.makeEQ(regValue, regExpected));
        CondJump branchOnCasCmpResult = newJumpUnless(booleanResultRegister, casFail);
        CondJump gotoCasEnd = newGoto(casEnd);
        Load loadValue = newRMWLoadWithMo(regValue, address, extractLoadMo(mo));
        Store storeValue = newRMWStoreWithMo(loadValue, address, e.getStoreValue(), extractStoreMo(mo));

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
        Event optionalFenceBefore = mo.equals(Tag.C11.MO_SC) ? newFence(Tag.C11.MO_SC) : null;
        Event optionalFenceAfter = mo.equals(Tag.C11.MO_SC) ? newFence(Tag.C11.MO_SC) : null;

        Register dummyReg = e.getFunction().newRegister(resultRegister.getType());
        Load load = newRMWLoadWithMo(resultRegister, address, extractLoadMo(mo));

        return eventSequence(
                optionalFenceBefore,
                load,
                newLocal(dummyReg, expressions.makeBinary(resultRegister, e.getOperator(), e.getOperand())),
                optionalFenceAfter,
                newRMWStoreWithMo(load, address, dummyReg, extractStoreMo(mo))
        );
    }

    @Override
    public List<Event> visitAtomicLoad(AtomicLoad e) {
        String mo = e.getMo();
        Event optionalFence = mo.equals(Tag.C11.MO_SC) ? newFence(Tag.C11.MO_SC) : null;
        return eventSequence(
                optionalFence,
                newLoadWithMo(e.getResultRegister(), e.getAddress(), extractLoadMo(mo))
        );
    }

    @Override
    public List<Event> visitAtomicStore(AtomicStore e) {
        String mo = e.getMo();
        Event optionalFence = mo.equals(Tag.C11.MO_SC) ? newFence(Tag.C11.MO_SC) : null;
        return eventSequence(
                optionalFence,
                newStoreWithMo(e.getAddress(), e.getMemValue(), extractStoreMo(mo))
        );
    }

    @Override
    public List<Event> visitAtomicThreadFence(AtomicThreadFence e) {
        return Collections.singletonList(newFence(e.getMo()));
    }

    @Override
    public List<Event> visitAtomicXchg(AtomicXchg e) {
        Expression address = e.getAddress();
        String mo = e.getMo();
        Event optionalFenceLoad = mo.equals(Tag.C11.MO_SC) ? newFence(Tag.C11.MO_SC) : null;
        Event optionalFenceStore = mo.equals(Tag.C11.MO_SC) ? newFence(Tag.C11.MO_SC) : null;

        Load load = newRMWLoadWithMo(e.getResultRegister(), address, mo);

        return eventSequence(
                optionalFenceLoad,
                load,
                optionalFenceStore,
                newRMWStoreWithMo(load, address, e.getValue(), extractStoreMo(mo))
        );
    }

    // =============================================================================================
    // =========================================== LLVM ============================================
    // =============================================================================================

    @Override
    public List<Event> visitLlvmLoad(LlvmLoad e) {
        return eventSequence(
                newLoadWithMo(e.getResultRegister(), e.getAddress(), IMM.extractLoadMo(e.getMo()))
        );
    }

    @Override
    public List<Event> visitLlvmStore(LlvmStore e) {
        return eventSequence(
                newStoreWithMo(e.getAddress(), e.getMemValue(), IMM.extractStoreMo(e.getMo()))
        );
    }

    @Override
    public List<Event> visitLlvmXchg(LlvmXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Load load = newRMWLoadExclusiveWithMo(resultRegister, address, IMM.extractLoadMo(mo));
        Store store = newRMWStoreExclusiveWithMo(address, e.getValue(), true, IMM.extractStoreMo(mo));
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

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

        Register dummyReg = e.getFunction().newRegister(resultRegister.getType());
        Local localOp = newLocal(dummyReg, expressions.makeBinary(resultRegister, e.getOperator(), e.getOperand()));

        Load load = newRMWLoadExclusiveWithMo(resultRegister, address, IMM.extractLoadMo(mo));
        Store store = newRMWStoreExclusiveWithMo(address, dummyReg, true, IMM.extractStoreMo(mo));
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

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

        Local casCmpResult = newLocal(resultRegister, expressions.makeEQ(oldValueRegister, expectedValue));
        Label casEnd = newLabel("CAS_end");
        CondJump branchOnCasCmpResult = newJumpUnless(resultRegister, casEnd);

        Load load = newRMWLoadExclusiveWithMo(oldValueRegister, address, IMM.extractLoadMo(mo));
        Store store = newRMWStoreExclusiveWithMo(address, e.getStoreValue(), true, IMM.extractStoreMo(mo));

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
                newFence(e.getMo())
        );
    }

}