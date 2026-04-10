package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.llvm.*;
import com.dat3m.dartagnan.program.event.metadata.MemoryOrder;

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
        final boolean isNonAtomic = (mo == null || mo.value().equals(Tag.C11.NONATOMIC));
        return eventSequence(
                newLoadWithMo(e.getResultRegister(), e.getAddress(), isNonAtomic ? Tag.C11.MO_RELAXED : mo.value())
        );
    }

    @Override
    public List<Event> visitStore(Store e) {
        // FIXME: It is weird to compile a core-level load by transforming its tagging.
        final MemoryOrder mo = e.getMetadata(MemoryOrder.class);
        final boolean isNonAtomic = (mo == null || mo.value().equals(Tag.C11.NONATOMIC));
        return eventSequence(
                newStoreWithMo(e.getAddress(), e.getMemValue(), isNonAtomic ? Tag.C11.MO_RELAXED : mo.value())
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
                optionalFence(mo),
                loadValue,
                casCmpResult,
                branchOnCasCmpResult,
                optionalFence(mo),
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

        Register dummyReg = e.getFunction().newRegister(resultRegister.getType());
        Load load = newRMWLoadWithMo(resultRegister, address, extractLoadMo(mo));

        return eventSequence(
                optionalFence(mo),
                load,
                newLocal(dummyReg, expressions.makeIntBinary(resultRegister, e.getOperator(), e.getOperand())),
                optionalFence(mo),
                newRMWStoreWithMo(load, address, dummyReg, extractStoreMo(mo))
        );
    }

    @Override
    public List<Event> visitAtomicLoad(AtomicLoad e) {
        String mo = e.getMo();
        return eventSequence(
                optionalFence(mo),
                newLoadWithMo(e.getResultRegister(), e.getAddress(), extractLoadMo(mo))
        );
    }

    @Override
    public List<Event> visitAtomicStore(AtomicStore e) {
        String mo = e.getMo();
        return eventSequence(
                optionalFence(mo),
                newStoreWithMo(e.getAddress(), e.getMemValue(), extractStoreMo(mo))
        );
    }

    @Override
    public List<Event> visitAtomicThreadFence(AtomicThreadFence e) {
        return eventSequence(
                newFence(e.getMo())
        );
    }

    @Override
    public List<Event> visitAtomicXchg(AtomicXchg e) {
        Expression address = e.getAddress();
        String mo = e.getMo();

        Load load = newRMWLoadWithMo(e.getResultRegister(), address, mo);

        return eventSequence(
                optionalFence(mo),
                load,
                optionalFence(mo),
                newRMWStoreWithMo(load, address, e.getValue(), extractStoreMo(mo))
        );
    }

    private Event optionalFence(String mo) {
        return mo.equals(Tag.C11.MO_SC) ? newFence(Tag.C11.MO_SC) : null;
    }

    // =============================================================================================
    // =========================================== LLVM ============================================
    // =============================================================================================

    @Override
    public List<Event> visitLlvmLoad(LlvmLoad e) {
        return eventSequence(
                newLoadWithMo(e.getResultRegister(), e.getAddress(), extractLoadMo(e.getMo()))
        );
    }

    @Override
    public List<Event> visitLlvmStore(LlvmStore e) {
        return eventSequence(
                newStoreWithMo(e.getAddress(), e.getMemValue(), extractStoreMo(e.getMo()))
        );
    }

    @Override
    public List<Event> visitLlvmXchg(LlvmXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Load load = newRMWLoadExclusiveWithMo(resultRegister, address, extractLoadMo(mo));
        Store store = newRMWStoreExclusiveWithMo(address, e.getValue(), true, false, extractStoreMo(mo));

        return eventSequence(
                load,
                newFakeCtrlDep(resultRegister),
                store
        );
    }

    @Override
    public List<Event> visitLlvmRMW(LlvmRMW e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Register dummyReg = e.getFunction().newRegister(resultRegister.getType());
        Local localOp = newLocal(dummyReg, expressions.makeIntBinary(resultRegister, e.getOperator(), e.getOperand()));

        Load load = newRMWLoadExclusiveWithMo(resultRegister, address, extractLoadMo(mo));
        Store store = newRMWStoreExclusiveWithMo(address, dummyReg, true, false, extractStoreMo(mo));

        return eventSequence(
                load,
                newFakeCtrlDep(resultRegister),
                localOp,
                store
        );
    }

    @Override
    protected List<Event> newLlvmCmpXchg(Register oldValue, Register success, Expression address, Expression expected,
            Expression newValue, String mo, boolean strong) {
        verify(success.getType() instanceof BooleanType, "Non-boolean success register.");

        Local casCmpResult = newLocal(success, expressions.makeEQ(oldValue, expected));
        Label casEnd = newLabel("CAS_end");
        CondJump branchOnCasCmpResult = newJumpUnless(success, casEnd);

        Load load = newRMWLoadExclusiveWithMo(oldValue, address, extractLoadMo(mo));
        Store store = newRMWStoreExclusiveWithMo(address, newValue, strong, false, extractStoreMo(mo));

        return eventSequence(
                load,
                casCmpResult,
                branchOnCasCmpResult,
                store,
                strong ? null : newExecutionStatus(success, store),
                strong ? null : newLocal(success, expressions.makeNot(success)),
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