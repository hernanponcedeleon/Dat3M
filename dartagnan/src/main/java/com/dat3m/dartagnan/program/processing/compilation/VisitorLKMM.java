package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.RMWStore;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.lang.linux.*;

import java.util.List;

import static com.dat3m.dartagnan.program.Program.SourceLanguage.LITMUS;
import static com.dat3m.dartagnan.program.event.EventFactory.eventSequence;

public class VisitorLKMM extends VisitorBase<EventFactory> {

    VisitorLKMM(EventFactory events) {
        super(events);
    }

    @Override
    public List<Event> visitLKMMAddUnless(LKMMAddUnless e) {
        Register resultRegister = e.getResultRegister();
        Expression operand = e.getOperand();
        Register dummy = e.getFunction().newRegister(operand.getType());
        Expression cmp = e.getCmp();
        Expression address = e.getAddress();
        Expression unexpected = expressions.makeNEQ(dummy, cmp);
        Function nondetBoolFunction = getNondetBoolFunction(e);
        Register havocRegister = e.getFunction().newRegister(nondetBoolFunction.getFunctionType().getReturnType());

        Label success = eventFactory.newLabel("RMW_success");
        Label end = eventFactory.newLabel("RMW_end");
        Load rmwLoad = eventFactory.newRMWLoadWithMo(dummy, address, Tag.Linux.MO_ONCE);
        return eventSequence(
                eventFactory.newValueFunctionCall(havocRegister, nondetBoolFunction, List.of()),
                eventFactory.newJump(expressions.makeBooleanCast(havocRegister), success),
                newCoreLoad(dummy, address, Tag.Linux.MO_ONCE),
                eventFactory.newAssume(expressions.makeEQ(dummy, cmp)),
                eventFactory.newGoto(end),
                success, // RMW success branch
                newCoreMemoryBarrier(),
                rmwLoad,
                eventFactory.newAssume(unexpected),
                eventFactory.newRMWStoreWithMo(rmwLoad, address, expressions.makeADD(dummy, operand), Tag.Linux.MO_ONCE),
                newCoreMemoryBarrier(),
                end,
                newAssignment(resultRegister, unexpected)
        );
    }

    @Override
    public List<Event> visitLKMMCmpXchg(LKMMCmpXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression cmp = e.getExpectedValue();
        Expression address = e.getAddress();
        String mo = e.getMo();
        Function nondetBoolFunction = getNondetBoolFunction(e);
        Register havocRegister = e.getFunction().newRegister(nondetBoolFunction.getFunctionType().getReturnType());

        Label success = eventFactory.newLabel("CAS_success");
        Label end = eventFactory.newLabel("CAS_end");
        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Load casLoad = eventFactory.newRMWLoadWithMo(dummy, address, Tag.Linux.loadMO(mo));
        return eventSequence(
                eventFactory.newValueFunctionCall(havocRegister, nondetBoolFunction, List.of()),
                eventFactory.newJump(expressions.makeBooleanCast(havocRegister), success),
                // Cas failure branch
                newCoreLoad(dummy, address, Tag.Linux.MO_ONCE),
                eventFactory.newAssume(expressions.makeNEQ(dummy, cmp)),
                eventFactory.newGoto(end),
                success,
                // CAS success branch
                mo.equals(Tag.Linux.MO_MB) ? newCoreMemoryBarrier() : null,
                casLoad,
                eventFactory.newAssume(expressions.makeEQ(dummy, cmp)),
                eventFactory.newRMWStoreWithMo(casLoad, address, e.getStoreValue(), Tag.Linux.storeMO(mo)),
                mo.equals(Tag.Linux.MO_MB) ? newCoreMemoryBarrier() : null,
                end,
                eventFactory.newLocal(resultRegister, dummy)
        );
    }

    @Override
    public List<Event> visitLKMMFetchOp(LKMMFetchOp e) {
        Register resultRegister = e.getResultRegister();
        String mo = e.getMo();
        Expression address = e.getAddress();

        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Event optionalMbBefore = mo.equals(Tag.Linux.MO_MB) ? newCoreMemoryBarrier() : null;
        Load load = eventFactory.newRMWLoadWithMo(dummy, address, Tag.Linux.loadMO(mo));
        Event optionalMbAfter = mo.equals(Tag.Linux.MO_MB) ? newCoreMemoryBarrier() : null;
        Expression storeValue = expressions.makeBinary(dummy, e.getOperator(), e.getOperand());

        return eventSequence(
                optionalMbBefore,
                load,
                eventFactory.newRMWStoreWithMo(load, address, storeValue, Tag.Linux.storeMO(mo)),
                eventFactory.newLocal(resultRegister, dummy),
                optionalMbAfter
        );
    }

    @Override
    public List<Event> visitLKMMOpNoReturn(LKMMOpNoReturn e) {
        Expression address = e.getAddress();

        Register dummy = e.getFunction().newRegister(e.getAccessType());
        Expression storeValue = expressions.makeBinary(dummy, e.getOperator(), e.getOperand());
        Load load = eventFactory.newRMWLoadWithMo(dummy, address, Tag.Linux.MO_ONCE);
        load.addTags(Tag.Linux.NORETURN);

        return eventSequence(
                load,
                eventFactory.newRMWStoreWithMo(load, address, storeValue, Tag.Linux.MO_ONCE)
        );
    }

    @Override
    public List<Event> visitLKMMOpAndTest(LKMMOpAndTest e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        Expression operand = e.getOperand();
        Register dummy = e.getFunction().newRegister(operand.getType());
        Load load = eventFactory.newRMWLoadWithMo(dummy, address, Tag.Linux.MO_ONCE);
        Expression testResult = expressions.makeNot(expressions.makeBooleanCast(dummy));

        return eventSequence(
                newCoreMemoryBarrier(),
                load,
                eventFactory.newLocal(dummy, expressions.makeBinary(dummy, e.getOperator(), operand)),
                eventFactory.newRMWStoreWithMo(load, address, dummy, Tag.Linux.MO_ONCE),
                newAssignment(resultRegister, testResult),
                newCoreMemoryBarrier()
        );
    }

    @Override
    public List<Event> visitLKMMOpReturn(LKMMOpReturn e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Load load = eventFactory.newRMWLoadWithMo(dummy, address, Tag.Linux.loadMO(mo));
        Event optionalMbBefore = mo.equals(Tag.Linux.MO_MB) ? newCoreMemoryBarrier() : null;
        Event optionalMbAfter = mo.equals(Tag.Linux.MO_MB) ? newCoreMemoryBarrier() : null;

        return eventSequence(
                optionalMbBefore,
                load,
                eventFactory.newLocal(dummy, expressions.makeBinary(dummy, e.getOperator(), e.getOperand())),
                eventFactory.newRMWStoreWithMo(load, address, dummy, Tag.Linux.storeMO(mo)),
                eventFactory.newLocal(resultRegister, dummy),
                optionalMbAfter
        );
    }

    @Override
    public List<Event> visitLKMMFence(LKMMFence e) {
        return eventSequence(
                eventFactory.newFence(e.getName())
        );
    }

    @Override
    public List<Event> visitLKMMLoad(LKMMLoad e) {
        return eventSequence(
                newCoreLoad(e.getResultRegister(), e.getAddress(), e.getMo())
        );
    }

    @Override
    public List<Event> visitLKMMStore(LKMMStore e) {
        return eventSequence(
                newCoreStore(e.getAddress(), e.getMemValue(), e.getMo())
        );
    }

    @Override
    public List<Event> visitLKMMXchg(LKMMXchg e) {
        Register resultRegister = e.getResultRegister();
        String mo = e.getMo();
        Expression address = e.getAddress();

        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Load load = eventFactory.newRMWLoadWithMo(dummy, address, Tag.Linux.loadMO(mo));
        Event optionalMbBefore = mo.equals(Tag.Linux.MO_MB) ? newCoreMemoryBarrier() : null;
        Event optionalMbAfter = mo.equals(Tag.Linux.MO_MB) ? newCoreMemoryBarrier() : null;

        return eventSequence(
                optionalMbBefore,
                load,
                eventFactory.newRMWStoreWithMo(load, address, e.getValue(), Tag.Linux.storeMO(mo)),
                eventFactory.newLocal(resultRegister, dummy),
                optionalMbAfter
        );
    }

    @Override
    public List<Event> visitLKMMLock(LKMMLock e) {
        Register dummy = e.getFunction().newRegister(e.getAccessType());
        Expression nonzeroDummy = expressions.makeBooleanCast(dummy);

        Load lockRead = newLockRead(dummy, e.getLock());
        // In litmus tests, spin locks are guaranteed to succeed, i.e. its read part gets value 0
        Event checkLockValue = e.getFunction().getProgram().getFormat().equals(LITMUS) ?
                eventFactory.newAssume(expressions.makeNot(nonzeroDummy)) :
                newTerminator(nonzeroDummy);
        return eventSequence(
                lockRead,
                checkLockValue,
                newLockWrite(lockRead, e.getLock())
        );
    }

    @Override
    public List<Event> visitLKMMUnlock(LKMMUnlock e) {
        Store lockRelease = eventFactory.newStoreWithMo(e.getAddress(), e.getMemValue(), e.getMo());
        lockRelease.addTags(Tag.Linux.UNLOCK);
        return eventSequence(
                lockRelease
        );
    }

    // ============================== Helper methods to lower LKMM events to core events ===========================
    /*
        The following helper methods are used to generate core-level events with additional metadata attached,
        for example, with custom printing capabilities.
     */

    private Event newCoreMemoryBarrier() {
        return eventFactory.newFence(Tag.Linux.MO_MB);
    }

    private Load newCoreLoad(Register reg, Expression addr, String mo) {
        return eventFactory.newLoadWithMo(reg, addr, mo);
    }

    private Store newCoreStore(Expression addr, Expression value, String mo) {
        return eventFactory.newStoreWithMo(addr, value, mo);
    }

    private Load newLockRead(Register dummy, Expression lockAddr) {
        Load lockRead = eventFactory.newRMWLoadWithMo(dummy, lockAddr, Tag.Linux.MO_ACQUIRE);
        lockRead.addTags(Tag.Linux.LOCK_READ);
        return lockRead;
    }

    private RMWStore newLockWrite(Load lockRead, Expression lockAddr) {
        Expression one = expressions.makeOne((IntegerType) lockRead.getAccessType());
        RMWStore lockWrite = eventFactory.newRMWStoreWithMo(lockRead, lockAddr, one, Tag.Linux.MO_ONCE);
        lockWrite.addTags(Tag.Linux.LOCK_WRITE);
        return lockWrite;
    }

    private static Function getNondetBoolFunction(Event e) {
        return e.getFunction().getProgram().getFunctionByName("__VERIFIER_nondet_bool")
                .orElseThrow(() -> new MalformedProgramException("Undeclared function \"__VERIFIER_nondet_bool\""));
    }

}