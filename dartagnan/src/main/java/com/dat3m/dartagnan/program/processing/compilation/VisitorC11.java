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
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.lang.llvm.*;

import java.util.List;

import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static com.dat3m.dartagnan.program.event.Tag.C11.*;
import static com.google.common.base.Verify.verify;

public class VisitorC11 extends Compiler.Visitor {

    // Plain accesses get the NA tag (or A if they carry an atomic order), independent of the frontend.
    // TODO: Move to the compilation of C-family plain accesses once frontends emit those.
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
    public List<Event> visitControlBarrier(ControlBarrier e) {
        Event barrier = EventFactory.newControlBarrier(e.getName(), e.getInstanceId(), e.getExecScope());
        barrier.addTags(MO_ACQUIRE_RELEASE);
        return tagList(e, eventSequence(barrier));
    }

    // =============================================================================================
    // =========================================== LLVM ============================================
    // =============================================================================================

    @Override
    public List<Event> visitLlvmLoad(LlvmLoad e) {
        return tagList(e, eventSequence(
                newLoadWithMo(e.getResultRegister(), e.getAddress(), loadMO(e.getMo()))
        ));
    }

    @Override
    public List<Event> visitLlvmStore(LlvmStore e) {
        return tagList(e, eventSequence(
                newStoreWithMo(e.getAddress(), e.getMemValue(), storeMO(e.getMo()))
        ));
    }

    @Override
    public List<Event> visitLlvmRMWNoReturn(LlvmRMWNoReturn e) {
        Expression address = e.getAddress();
        String mo = e.getMo();

        Register dummyReg = funcToBeCompiled.newRegister(e.getAccessType());
        Load load = newRMWLoad(dummyReg, address);
        Local localOp = newLocal(dummyReg, expressions.makeIntBinary(dummyReg, e.getOperator(), e.getOperand()));
        RMWStore store = newRMWStoreWithMo(load, address, dummyReg, Tag.C11.storeMO(mo));

        load.addTags(Tag.C11.ATOMIC, Tag.C11.NORETURN); // Note that the load has no mo, but is still atomic!
        store.addTags(Tag.C11.NORETURN);

        return tagList(e, eventSequence(
                load,
                localOp,
                store
        ));
    }

    @Override
    public List<Event> visitLlvmXchg(LlvmXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Load load = newRMWLoadWithMo(resultRegister, address, loadMO(mo));
        Store store = newRMWStoreWithMo(load, address, e.getValue(), storeMO(mo));

        return tagList(e, eventSequence(
                load,
                store
        ));
    }

    @Override
    public List<Event> visitLlvmRMW(LlvmRMW e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Register dummyReg = funcToBeCompiled.newRegister(resultRegister.getType());
        Local localOp = newLocal(dummyReg, expressions.makeIntBinary(resultRegister, e.getOperator(), e.getOperand()));

        Load load = newRMWLoadWithMo(resultRegister, address, loadMO(mo));
        Store store = newRMWStoreWithMo(load, address, dummyReg, storeMO(mo));

        return tagList(e, eventSequence(
                load,
                localOp,
                store
        ));
    }

    @Override
    protected List<Event> newLlvmCmpXchg(Event original, Register oldValue, Register success, Expression address, Expression expected,
            Expression newValue, String mo, boolean strong) {
        verify(success.getType() instanceof BooleanType, "Non-boolean success register.");

        Local casCmpResult = newLocal(success, expressions.makeEQ(oldValue, expected));
        Label casEnd = newLabel("CAS_end");
        CondJump branchOnCasCmpResult = newJumpUnless(success, casEnd);

        Load load = newRMWLoadExclusiveWithMo(oldValue, address, loadMO(mo));
        Store store = newRMWStoreExclusiveWithMo(address, newValue, strong, false, storeMO(mo));

        return tagList(original, eventSequence(
                load,
                casCmpResult,
                branchOnCasCmpResult,
                store,
                strong ? null : newExecutionStatus(success, store),
                strong ? null : newLocal(success, expressions.makeNot(success)),
                casEnd
        ));
    }

    @Override
    public List<Event> visitLlvmFence(LlvmFence e) {
        return tagList(e, eventSequence(
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
            MemoryCoreEvent.MemoryOrder mo = e.getMetadata(MemoryCoreEvent.MemoryOrder.class);
            boolean canRace = mo == null || mo.value().equals(NONATOMIC);
            e.addTags(canRace ? NONATOMIC : ATOMIC);
        }
    }
}