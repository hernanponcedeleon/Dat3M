package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.Tag.C11;
import com.dat3m.dartagnan.program.event.arch.tso.TSOXchg;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.llvm.*;
import com.dat3m.dartagnan.program.event.lang.pthread.*;

import java.util.List;

import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static com.google.common.base.Verify.verify;

class VisitorTso extends VisitorBase {

    protected VisitorTso(boolean forceStart) {
        super(forceStart);
    }

    @Override
    public List<Event> visitTSOXchg(TSOXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();

        Register dummyReg = e.getThread().newRegister(resultRegister.getType());
        Load load = newRMWLoad(dummyReg, address);

        return tagList(eventSequence(
                load,
                newRMWStore(load, address, resultRegister),
                newLocal(resultRegister, dummyReg)
        ));
    }

    // =============================================================================================
    // ========================================= PTHREAD ===========================================
    // =============================================================================================

    @Override
    public List<Event> visitCreate(Create e) {
        Store store = newStore(e.getAddress(), e.getMemValue());
        store.addTags(C11.PTHREAD);

        return tagList(eventSequence(
                store,
                X86.newMemoryFence()
        ));
    }

    @Override
    public List<Event> visitEnd(End e) {
        return tagList(eventSequence(
                // Nothing comes after an End event thus no need for a fence
                newStore(e.getAddress(), expressions.makeZero(types.getArchType()))
        ));
    }

    @Override
    public List<Event> visitJoin(Join e) {
        Register resultRegister = e.getResultRegister();
        Expression zero = expressions.makeZero(resultRegister.getType());
        Load load = newLoad(resultRegister, e.getAddress());
        load.addTags(C11.PTHREAD);

        return tagList(eventSequence(
                load,
                newJump(expressions.makeNEQ(resultRegister, zero),
                        (Label) e.getThread().getExit())
        ));
    }

    @Override
    public List<Event> visitStart(Start e) {
        Register resultRegister = e.getResultRegister();
        verify(resultRegister.getType() instanceof BooleanType);
        Load load = newLoad(resultRegister, e.getAddress());
        load.addTags(Tag.STARTLOAD);

        return tagList(eventSequence(
                load,
                super.visitStart(e),
                newJumpUnless(resultRegister, (Label) e.getThread().getExit())
        ));
    }

    public List<Event> visitInitLock(InitLock e) {
        return eventSequence(
                newStore(e.getAddress(), e.getMemValue()),
                X86.newMemoryFence()
        );
    }

    @Override
    public List<Event> visitLock(Lock e) {
        IntegerType type = types.getArchType();
        Register dummy = e.getThread().newRegister(type);
        // We implement locks as spinlocks which are guaranteed to succeed, i.e. we can
        // use assumes. Nothing else is needed to guarantee acquire semantics in TSO.
        Load load = newRMWLoad(dummy, e.getAddress());
        return eventSequence(
                load,
                newAssume(expressions.makeEQ(dummy, expressions.makeZero(type))),
                newRMWStore(load, e.getAddress(), expressions.makeOne(type))
        );
    }

    @Override
    public List<Event> visitUnlock(Unlock e) {
        return eventSequence(
                newStore(e.getAddress(), expressions.makeZero(types.getArchType())),
                X86.newMemoryFence()
        );
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
        Fence optionalMFence = e.getMo().equals(Tag.C11.MO_SC) ? X86.newMemoryFence() : null;

        return eventSequence(
                newStore(e.getAddress(), e.getMemValue()),
                optionalMFence
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
        Register dummyReg = e.getThread().newRegister(resultRegister.getType());

        Expression address = e.getAddress();
        Load load = newRMWLoad(resultRegister, address);

        return tagList(eventSequence(
                load,
                newLocal(dummyReg, expressions.makeBinary(resultRegister, e.getOperator(), e.getOperand())),
                newRMWStore(load, address, dummyReg)
        ));
    }

    @Override
    public List<Event> visitLlvmCmpXchg(LlvmCmpXchg e) {
        Register oldValueRegister = e.getStructRegister(0);
        Register resultRegister = e.getStructRegister(1);
        Expression one = expressions.makeOne(resultRegister.getType());

        Expression address = e.getAddress();
        Expression expectedValue = e.getExpectedValue();

        Local casCmpResult = newLocal(resultRegister, expressions.makeEQ(oldValueRegister, expectedValue));
        Label casEnd = newLabel("CAS_end");
        CondJump branchOnCasCmpResult = newJump(expressions.makeNEQ(resultRegister, one), casEnd);

        Load load = newRMWLoad(oldValueRegister, address);
        Store store = newRMWStore(load, address, e.getStoreValue());

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
        Fence optionalFence = e.getMo().equals(Tag.C11.MO_SC) ? X86.newMemoryFence() : null;

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
        Expression one = expressions.makeOne(type);

        Register regExpected = e.getThread().newRegister(type);
        Load loadExpected = newLoad(regExpected, expectedAddr);
        Register regValue = e.getThread().newRegister(type);
        Load loadValue = newRMWLoad(regValue, address);
        Local casCmpResult = newLocal(resultRegister, expressions.makeEQ(regValue, regExpected));
        Label casFail = newLabel("CAS_fail");
        CondJump branchOnCasCmpResult = newJump(expressions.makeNEQ(resultRegister, one), casFail);
        Store storeValue = newRMWStore(loadValue, address, value);
        Label casEnd = newLabel("CAS_end");
        CondJump gotoCasEnd = newGoto(casEnd);
        Store storeExpected = newStore(expectedAddr, regValue);

        return tagList(eventSequence(
                loadExpected,
                loadValue,
                casCmpResult,
                branchOnCasCmpResult,
                storeValue,
                gotoCasEnd,
                casFail,
                storeExpected,
                casEnd
        ));
    }

    @Override
    public List<Event> visitAtomicFetchOp(AtomicFetchOp e) {
        Register resultRegister = e.getResultRegister();
        Register dummyReg = e.getThread().newRegister(resultRegister.getType());

        Expression address = e.getAddress();
        Load load = newRMWLoad(resultRegister, address);

        return tagList(eventSequence(
                load,
                newLocal(dummyReg, expressions.makeBinary(resultRegister, e.getOperator(), e.getOperand())),
                newRMWStore(load, address, dummyReg)
        ));
    }

    @Override
    public List<Event> visitAtomicLoad(AtomicLoad e) {
        return eventSequence(
                newLoad(e.getResultRegister(), e.getAddress())
        );
    }

    @Override
    public List<Event> visitAtomicStore(AtomicStore e) {
        String mo = e.getMo();
        Fence optionalMFence = mo.equals(Tag.C11.MO_SC) ? X86.newMemoryFence() : null;

        return eventSequence(
                newStore(e.getAddress(), e.getMemValue()),
                optionalMFence
        );
    }

    @Override
    public List<Event> visitAtomicThreadFence(AtomicThreadFence e) {
        Fence optionalFence = e.getMo().equals(Tag.C11.MO_SC) ? X86.newMemoryFence() : null;

        return eventSequence(
                optionalFence
        );
    }

    @Override
    public List<Event> visitAtomicXchg(AtomicXchg e) {
        Expression address = e.getAddress();
        Load load = newRMWLoad(e.getResultRegister(), address);

        return tagList(eventSequence(
                load,
                newRMWStore(load, address, e.getValue())
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