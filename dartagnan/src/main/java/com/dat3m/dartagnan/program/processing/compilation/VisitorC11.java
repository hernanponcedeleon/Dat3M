package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.MemoryEvent;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.Tag.C11;
import com.dat3m.dartagnan.program.event.arch.opencl.OpenCLRMWExtremum;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.llvm.*;
import com.dat3m.dartagnan.program.event.metadata.MemoryOrder;

import java.util.List;

import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static com.google.common.base.Verify.verify;

public class VisitorC11 extends VisitorBase {

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
        Local castResult = type instanceof BooleanType ? null :
                newLocal(resultRegister, expressions.makeCast(booleanResultRegister, type));
        Register regExpected = e.getFunction().newRegister(type);
        Register regValue = e.getFunction().newRegister(type);
        Load loadExpected = newLoad(regExpected, expectedAddr);
        Store storeExpected = newStore(expectedAddr, regValue);
        Label casFail = newLabel("CAS_fail");
        Label casEnd = newLabel("CAS_end");
        Local casCmpResult = newLocal(booleanResultRegister, expressions.makeEQ(regValue, regExpected));
        CondJump branchOnCasCmpResult = newJumpUnless(booleanResultRegister, casFail);
        CondJump gotoCasEnd = newGoto(casEnd);
        Load loadValue = newRMWLoadWithMo(regValue, address, Tag.C11.loadMO(mo));
        Store storeValue = newRMWStoreWithMo(loadValue, address, e.getStoreValue(), Tag.C11.storeMO(mo));

        return tagList(e, eventSequence(
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
        Load load = newRMWLoadWithMo(resultRegister, address, Tag.C11.loadMO(mo));
        Local localOp = newLocal(dummyReg, expressions.makeIntBinary(resultRegister, e.getOperator(), e.getOperand()));
        RMWStore store = newRMWStoreWithMo(load, address, dummyReg, Tag.C11.storeMO(mo));

        return tagList(e, eventSequence(
                load,
                localOp,
                store
        ));
    }

    @Override
    public List<Event> visitAtomicLoad(AtomicLoad e) {
        return tagList(e, eventSequence(
                newLoadWithMo(e.getResultRegister(), e.getAddress(), Tag.C11.loadMO(e.getMo()))
        ));
    }

    @Override
    public List<Event> visitAtomicStore(AtomicStore e) {
        return tagList(e, eventSequence(
                newStoreWithMo(e.getAddress(), e.getMemValue(), Tag.C11.storeMO(e.getMo()))
        ));
    }

    @Override
    public List<Event> visitAtomicThreadFence(AtomicThreadFence e) {
        return tagList(e, eventSequence(
                newFence(e.getMo())
        ));
    }

    @Override
    public List<Event> visitAtomicXchg(AtomicXchg e) {
        Expression address = e.getAddress();
        String mo = e.getMo();

        Load load = newRMWLoadWithMo(e.getResultRegister(), address, Tag.C11.loadMO(mo));
        RMWStore store = newRMWStoreWithMo(load, address, e.getValue(), Tag.C11.storeMO(mo));

        return tagList(e, eventSequence(
                load,
                store
        ));
    }

    @Override
    public List<Event> visitControlBarrier(ControlBarrier e) {
        Event barrier = EventFactory.newControlBarrier(e.getName(), e.getInstanceId());
        barrier.addTags(C11.MO_RELEASE, C11.MO_ACQUIRE);
        return tagList(e, eventSequence(barrier));
    }

    @Override
    public List<Event> visitOpenCLRMWExtremum(OpenCLRMWExtremum e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();
        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Load load = newRMWLoadWithMo(dummy, address, Tag.C11.loadMO(mo));
        Expression cmpExpr = expressions.makeIntCmp(dummy, e.getOperator(), e.getValue());
        Expression ite = expressions.makeITE(cmpExpr, dummy, e.getValue());
        RMWStore store = newRMWStoreWithMo(load, address, ite, Tag.C11.storeMO(mo));

        return tagList(e, eventSequence(
                load,
                store,
                newLocal(resultRegister, dummy)
        ));
    }

    // =============================================================================================
    // =========================================== LLVM ============================================
    // =============================================================================================

    @Override
    public List<Event> visitLlvmLoad(LlvmLoad e) {
        return tagList(eventSequence(
                newLoadWithMo(e.getResultRegister(), e.getAddress(), Tag.C11.loadMO(e.getMo()))
        ));
    }

    @Override
    public List<Event> visitLlvmStore(LlvmStore e) {
        return tagList(eventSequence(
                newStoreWithMo(e.getAddress(), e.getMemValue(), Tag.C11.storeMO(e.getMo()))
        ));
    }

    @Override
    public List<Event> visitLlvmXchg(LlvmXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Load load = newRMWLoadExclusiveWithMo(resultRegister, address, Tag.C11.loadMO(mo));
        Store store = newRMWStoreExclusiveWithMo(address, e.getValue(), true, Tag.C11.storeMO(mo));

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
        Local localOp = newLocal(dummyReg, expressions.makeIntBinary(resultRegister, e.getOperator(), e.getOperand()));

        Load load = newRMWLoadExclusiveWithMo(resultRegister, address, Tag.C11.loadMO(mo));
        Store store = newRMWStoreExclusiveWithMo(address, dummyReg, true, Tag.C11.storeMO(mo));

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

        Local casCmpResult = newLocal(resultRegister, expressions.makeEQ(oldValueRegister, expectedValue));
        Label casEnd = newLabel("CAS_end");
        CondJump branchOnCasCmpResult = newJumpUnless(resultRegister, casEnd);

        Load load = newRMWLoadExclusiveWithMo(oldValueRegister, address, Tag.C11.loadMO(mo));
        Store store = newRMWStoreExclusiveWithMo(address, e.getStoreValue(), true, Tag.C11.storeMO(mo));

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
                newFence(e.getMo())
        ));
    }

    protected List<Event> tagList(List<Event> in) {
        in.forEach(e -> tagEvent(null, e));
        return in;
    }

    protected List<Event> tagList(Event originalEvent, List<Event> in) {
        in.forEach(e -> tagEvent(originalEvent, e));
        return in;
    }

    private void tagEvent(Event originalEvent, Event e) {
        if (originalEvent != null) {
            String scope = Tag.getScopeTag(originalEvent, Arch.OPENCL);
            List<String> spaces = Tag.OpenCL.getSpaceTags(originalEvent);
            if (e instanceof MemoryEvent || e instanceof GenericVisibleEvent) {
                if (!scope.isEmpty()) {
                    e.addTags(scope);
                }
                e.addTags(spaces);
            }
        }
        if (e instanceof MemoryEvent) {
            MemoryOrder mo = e.getMetadata(MemoryOrder.class);
            boolean canRace = mo == null || mo.value().equals(C11.NONATOMIC);
            e.addTags(canRace ? C11.NONATOMIC : C11.ATOMIC);
        }
    }
}