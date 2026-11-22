package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemoryEvent;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.arch.tso.TSOXchg;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.lang.llvm.*;

import java.util.List;

import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static com.google.common.base.Verify.verify;

class VisitorTso extends Compiler.Visitor {

    @Override
    public List<Event> visitTSOXchg(TSOXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();

        Register dummyReg = funcToBeCompiled.newRegister(resultRegister.getType());
        Load load = newRMWLoad(dummyReg, address);

        return tagList(eventSequence(
                load,
                newRMWStore(load, address, resultRegister),
                newLocal(resultRegister, dummyReg)
        ));
    }

    // =============================================================================================
    // =========================================== LLVM ============================================
    // =============================================================================================

    @Override
    public List<Event> visitLlvmLoad(LlvmLoad e) {
        return eventSequence(
                newLoad(e.getResultRegister(), e.getAddress())
        );
    }

    @Override
    public List<Event> visitLlvmStore(LlvmStore e) {
        return eventSequence(
                newStore(e.getAddress(), e.getMemValue()),
                optionalMFence(e.getMo())
        );
    }

    @Override
    public List<Event> visitLlvmXchg(LlvmXchg e) {
        Expression address = e.getAddress();
        Load load = newRMWLoad(e.getResultRegister(), address);

        return tagList(eventSequence(
                load,
                newRMWStore(load, address, e.getValue())
        ));
    }

    @Override
    public List<Event> visitLlvmRMW(LlvmRMW e) {
        Register resultRegister = e.getResultRegister();
        Register dummyReg = funcToBeCompiled.newRegister(resultRegister.getType());

        Expression address = e.getAddress();
        Load load = newRMWLoad(resultRegister, address);

        return tagList(eventSequence(
                load,
                newLocal(dummyReg, expressions.makeIntBinary(resultRegister, e.getOperator(), e.getOperand())),
                newRMWStore(load, address, dummyReg)
        ));
    }

    @Override
    protected List<Event> newLlvmCmpXchg(Event original, Register oldValue, Register success, Expression address, Expression expected,
            Expression newValue, String mo, boolean strong) {
        verify(success.getType() instanceof BooleanType, "Non-boolean success register.");

        Local casCmpResult = newLocal(success, expressions.makeEQ(oldValue, expected));
        Label casEnd = newLabel("CAS_end");
        CondJump branchOnCasCmpResult = newJumpUnless(success, casEnd);

        Load load = newRMWLoad(oldValue, address);
        Store store = newRMWStore(load, address, newValue);

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
        return eventSequence(
                optionalMFence(e.getMo())
        );
    }

    // =============================================================================================
    // ============================================ C11 ============================================
    // =============================================================================================

    private Event optionalMFence(String mo) {
        return mo.equals(Tag.C11.MO_SC) ? X86.newMemoryFence("mfence") : null;
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