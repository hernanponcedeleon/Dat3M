package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.Tag.C11;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.llvm.*;
import com.dat3m.dartagnan.program.event.lang.pthread.Create;
import com.dat3m.dartagnan.program.event.lang.pthread.End;
import com.dat3m.dartagnan.program.event.lang.pthread.Join;
import com.dat3m.dartagnan.program.event.lang.pthread.Start;
import com.dat3m.dartagnan.program.event.metadata.MemoryOrder;

import java.util.List;

import static com.dat3m.dartagnan.program.event.EventFactory.*;

public class VisitorC11 extends VisitorBase {

    protected VisitorC11(boolean forceStart) {
        super(forceStart);
    }

    @Override
    public List<Event> visitCreate(Create e) {
        Store store = newStoreWithMo(e.getAddress(), e.getMemValue(), Tag.C11.MO_RELEASE);
        store.addTags(C11.PTHREAD);

        return tagList(eventSequence(
                store));
    }

    @Override
    public List<Event> visitEnd(End e) {
        //TODO boolean
        return tagList(eventSequence(
                newStoreWithMo(e.getAddress(), expressions.makeZero(types.getArchType()), Tag.C11.MO_RELEASE)));
    }

    @Override
    public List<Event> visitJoin(Join e) {
        Register resultRegister = e.getResultRegister();
        Expression zero = expressions.makeZero(resultRegister.getType());
        Load load = newLoadWithMo(resultRegister, e.getAddress(), Tag.C11.MO_ACQUIRE);
        load.addTags(C11.PTHREAD);

        return tagList(eventSequence(
                load,
                newJumpUnless(expressions.makeEQ(resultRegister, zero), (Label) e.getThread().getExit())));
    }

    @Override
    public List<Event> visitStart(Start e) {
        Register resultRegister = e.getResultRegister();
        Expression one = expressions.makeOne(resultRegister.getType());
        Load load = newLoadWithMo(resultRegister, e.getAddress(), Tag.C11.MO_ACQUIRE);
        load.addTags(Tag.STARTLOAD);

        return tagList(eventSequence(
                load,
                super.visitStart(e),
                newJumpUnless(expressions.makeEQ(resultRegister, one), (Label) e.getThread().getExit())));
    }

    @Override
    public List<Event> visitLoad(Load e) {
        return tagList(eventSequence(
                newLoadWithMo(e.getResultRegister(), e.getAddress(), e.getMo())));
    }

    @Override
    public List<Event> visitStore(Store e) {
        return tagList(eventSequence(
                newStoreWithMo(e.getAddress(), e.getMemValue(), e.getMo())));
    }

    // =============================================================================================
    // =========================================== C11 =============================================
    // =============================================================================================

    @Override
    public List<Event> visitAtomicCmpXchg(AtomicCmpXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();
        Expression expectedAddr = e.getExpectedAddr();
        IntegerType type = resultRegister.getType();

        Register regExpected = e.getThread().newRegister(type);
        Register regValue = e.getThread().newRegister(type);
        Load loadExpected = newLoad(regExpected, expectedAddr);
        Store storeExpected = newStore(expectedAddr, regValue);
        Label casFail = newLabel("CAS_fail");
        Label casEnd = newLabel("CAS_end");
        Local casCmpResult = newLocal(resultRegister, expressions.makeEQ(regValue, regExpected));
        CondJump branchOnCasCmpResult = newJump(expressions.makeNEQ(resultRegister, expressions.makeOne(type)), casFail);
        CondJump gotoCasEnd = newGoto(casEnd);
        Load loadValue = newRMWLoadWithMo(regValue, address, mo);
        Store storeValue = newRMWStoreWithMo(loadValue, address, e.getMemValue(), mo);

        return tagList(eventSequence(
                // Indentation shows the branching structure
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
        IOpBin op = e.getOp();
        Expression address = e.getAddress();
        String mo = e.getMo();
        Register dummyReg = e.getThread().newRegister(resultRegister.getType());
        Load load = newRMWLoadWithMo(resultRegister, address, mo);
        RMWStore store = newRMWStoreWithMo(load, address, dummyReg, mo);

        return tagList(eventSequence(
                load,
                newLocal(dummyReg, expressions.makeBinary(resultRegister, op, e.getMemValue())),
                store
        ));
    }

    @Override
    public List<Event> visitAtomicLoad(AtomicLoad e) {
        return tagList(eventSequence(
                newLoadWithMo(e.getResultRegister(), e.getAddress(), e.getMo())
        ));
    }

    @Override
    public List<Event> visitAtomicStore(AtomicStore e) {
        return tagList(eventSequence(
                newStoreWithMo(e.getAddress(), e.getMemValue(), e.getMo())
        ));
    }

    @Override
    public List<Event> visitAtomicThreadFence(AtomicThreadFence e) {
        return tagList(eventSequence(
                newFence(e.getMo())));
    }

    @Override
    public List<Event> visitAtomicXchg(AtomicXchg e) {
        Expression address = e.getAddress();
        String mo = e.getMo();

        Load load = newRMWLoadWithMo(e.getResultRegister(), address, mo);
        RMWStore store = newRMWStoreWithMo(load, address, e.getMemValue(), mo);

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
                newLoadWithMo(e.getResultRegister(), e.getAddress(), e.getMo())));
    }

    @Override
    public List<Event> visitLlvmStore(LlvmStore e) {
        return tagList(eventSequence(
                newStoreWithMo(e.getAddress(), e.getMemValue(), e.getMo())));
    }

    @Override
    public List<Event> visitLlvmXchg(LlvmXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression value = e.getMemValue();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Load load = newRMWLoadExclusiveWithMo(resultRegister, address, mo);
        Store store = newRMWStoreExclusiveWithMo(address, value, true, mo);

        return tagList(eventSequence(
                load,
                store));
    }

    @Override
    public List<Event> visitLlvmRMW(LlvmRMW e) {
        Register resultRegister = e.getResultRegister();
        IOpBin op = e.getOp();
        Expression value = e.getMemValue();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Register dummyReg = e.getThread().newRegister(resultRegister.getType());
        Local localOp = newLocal(dummyReg, expressions.makeBinary(resultRegister, op, value));

        Load load = newRMWLoadExclusiveWithMo(resultRegister, address, mo);
        Store store = newRMWStoreExclusiveWithMo(address, dummyReg, true, mo);

        return tagList(eventSequence(
                load,
                localOp,
                store));
    }

    @Override
    public List<Event> visitLlvmCmpXchg(LlvmCmpXchg e) {
        Register oldValueRegister = e.getStructRegister(0);
        Register resultRegister = e.getStructRegister(1);

        Expression value = e.getMemValue();
        Expression address = e.getAddress();
        String mo = e.getMo();
        Expression expectedValue = e.getExpectedValue();

        Local casCmpResult = newLocal(resultRegister, expressions.makeEQ(oldValueRegister, expectedValue));
        Label casEnd = newLabel("CAS_end");
        Expression one = expressions.makeOne(resultRegister.getType());
        CondJump branchOnCasCmpResult = newJump(expressions.makeNEQ(resultRegister, one), casEnd);

        Load load = newRMWLoadExclusive(oldValueRegister, address, mo);
        Store store = newRMWStoreExclusive(address, value, true, mo);

        return tagList(eventSequence(
                // Indentation shows the branching structure
                load,
                casCmpResult,
                branchOnCasCmpResult,
                    store,
                casEnd));
    }

    @Override
    public List<Event> visitLlvmFence(LlvmFence e) {
        return tagList(eventSequence(
                newFence(e.getMo())));
    }

    private List<Event> tagList(List<Event> in) {
        in.forEach(this::tagEvent);
        return in;
    }

    private void tagEvent(Event e) {
        if(e instanceof MemoryEvent) {
            final MemoryOrder mo = e.getMetadata(MemoryOrder.class);
            final boolean canRace = mo == null || mo.value().equals(C11.NONATOMIC);
            e.addTags(canRace ? C11.NONATOMIC : C11.ATOMIC);
        }
    }

}
