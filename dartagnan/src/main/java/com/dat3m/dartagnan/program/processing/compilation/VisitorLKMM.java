package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.RMWStore;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.lang.linux.*;

import java.util.List;

import static com.dat3m.dartagnan.program.Program.SourceLanguage.LITMUS;
import static com.dat3m.dartagnan.program.event.EventFactory.*;

public class VisitorLKMM extends VisitorBase {

    @Override
    public List<Event> visitLKMMAddUnless(LKMMAddUnless e) {
        Register resultRegister = e.getResultRegister();
        Expression operand = e.getOperand();
        Register dummy = e.getFunction().newRegister(operand.getType());
        Expression cmp = e.getCmp();
        Expression address = e.getAddress();
        Expression unexpected = expressions.makeNEQ(dummy, cmp);
        Register havocRegister = e.getFunction().getOrNewRegister("__guess", types.getBooleanType());

        Label success = newLabel("RMW_success");
        Label end = newLabel("RMW_end");
        Load rmwLoad;
        return eventSequence(
                EventFactory.Svcomp.newNonDetChoice(havocRegister),
                newJump(havocRegister, success),
                newCoreLoad(dummy, address, Tag.Linux.MO_ONCE),
                newAssume(expressions.makeEQ(dummy, cmp)),
                newGoto(end),
                success, // RMW success branch
                newCoreMemoryBarrier(),
                rmwLoad = newRMWLoadWithMo(dummy, address, Tag.Linux.MO_ONCE),
                newAssume(unexpected),
                newRMWStoreWithMo(rmwLoad, address, expressions.makeAdd(dummy, operand), Tag.Linux.MO_ONCE),
                newCoreMemoryBarrier(),
                end,
                newLocal(resultRegister, expressions.makeCast(unexpected, resultRegister.getType()))
        );
    }

    @Override
    public List<Event> visitLKMMCmpXchg(LKMMCmpXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression cmp = e.getExpectedValue();
        Expression address = e.getAddress();
        String mo = e.getMo();
        Register havocRegister = e.getFunction().getOrNewRegister("__guess", types.getBooleanType());

        Label success = newLabel("CAS_success");
        Label end = newLabel("CAS_end");
        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Load loadFail = newCoreLoad(dummy, address, Tag.Linux.MO_ONCE);
        loadFail.addTags(Tag.RMW);
        Load loadSuccess;
        return eventSequence(
                EventFactory.Svcomp.newNonDetChoice(havocRegister),
                newJump(havocRegister, success),
                // Cas failure branch
                loadFail,
                newAssume(expressions.makeNEQ(dummy, cmp)),
                newGoto(end),
                success,
                // CAS success branch
                mo.equals(Tag.Linux.MO_MB) ? newCoreMemoryBarrier() : null,
                loadSuccess = newRMWLoadWithMo(dummy, address, Tag.Linux.loadMO(mo)),
                newAssume(expressions.makeEQ(dummy, cmp)),
                newRMWStoreWithMo(loadSuccess, address, e.getStoreValue(), Tag.Linux.storeMO(mo)),
                mo.equals(Tag.Linux.MO_MB) ? newCoreMemoryBarrier() : null,
                end,
                newLocal(resultRegister, dummy)
        );
    }

    @Override
    public List<Event> visitLKMMFetchOp(LKMMFetchOp e) {
        Register resultRegister = e.getResultRegister();
        String mo = e.getMo();
        Expression address = e.getAddress();

        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Event optionalMbBefore = mo.equals(Tag.Linux.MO_MB) ? newCoreMemoryBarrier() : null;
        Load load = newRMWLoadWithMo(dummy, address, Tag.Linux.loadMO(mo));
        Event optionalMbAfter = mo.equals(Tag.Linux.MO_MB) ? newCoreMemoryBarrier() : null;
        Expression storeValue = expressions.makeIntBinary(dummy, e.getOperator(), e.getOperand());

        return eventSequence(
                optionalMbBefore,
                load,
                newRMWStoreWithMo(load, address, storeValue, Tag.Linux.storeMO(mo)),
                newLocal(resultRegister, dummy),
                optionalMbAfter
        );
    }

    @Override
    public List<Event> visitLKMMOpNoReturn(LKMMOpNoReturn e) {
        Expression address = e.getAddress();

        Register dummy = e.getFunction().newRegister(e.getAccessType());
        Expression storeValue = expressions.makeIntBinary(dummy, e.getOperator(), e.getOperand());
        Load load = newRMWLoadWithMo(dummy, address, Tag.Linux.MO_ONCE);
        load.addTags(Tag.Linux.NORETURN);

        return eventSequence(
                load,
                newRMWStoreWithMo(load, address, storeValue, Tag.Linux.MO_ONCE)
        );
    }

    @Override
    public List<Event> visitLKMMOpAndTest(LKMMOpAndTest e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        Expression operand = e.getOperand();
        Register dummy = e.getFunction().newRegister(operand.getType());
        Load load = newRMWLoadWithMo(dummy, address, Tag.Linux.MO_ONCE);
        Expression testResult = expressions.makeNot(expressions.makeBooleanCast(dummy));

        return eventSequence(
                newCoreMemoryBarrier(),
                load,
                newLocal(dummy, expressions.makeIntBinary(dummy, e.getOperator(), operand)),
                newRMWStoreWithMo(load, address, dummy, Tag.Linux.MO_ONCE),
                newLocal(resultRegister, expressions.makeCast(testResult, resultRegister.getType())),
                newCoreMemoryBarrier()
        );
    }

    @Override
    public List<Event> visitLKMMOpReturn(LKMMOpReturn e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Load load = newRMWLoadWithMo(dummy, address, Tag.Linux.loadMO(mo));
        Event optionalMbBefore = mo.equals(Tag.Linux.MO_MB) ? newCoreMemoryBarrier() : null;
        Event optionalMbAfter = mo.equals(Tag.Linux.MO_MB) ? newCoreMemoryBarrier() : null;

        return eventSequence(
                optionalMbBefore,
                load,
                newLocal(dummy, expressions.makeIntBinary(dummy, e.getOperator(), e.getOperand())),
                newRMWStoreWithMo(load, address, dummy, Tag.Linux.storeMO(mo)),
                newLocal(resultRegister, dummy),
                optionalMbAfter
        );
    }

    @Override
    public List<Event> visitLKMMFence(LKMMFence e) {
        return eventSequence(
                newFence(e.getName())
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
        Load load = newRMWLoadWithMo(dummy, address, Tag.Linux.loadMO(mo));
        Event optionalMbBefore = mo.equals(Tag.Linux.MO_MB) ? newCoreMemoryBarrier() : null;
        Event optionalMbAfter = mo.equals(Tag.Linux.MO_MB) ? newCoreMemoryBarrier() : null;

        return eventSequence(
                optionalMbBefore,
                load,
                newRMWStoreWithMo(load, address, e.getValue(), Tag.Linux.storeMO(mo)),
                newLocal(resultRegister, dummy),
                optionalMbAfter
        );
    }

    @Override
    public List<Event> visitLKMMLock(LKMMLock e) {
        boolean litmusFormat = e.getFunction().getProgram().getFormat().equals(LITMUS);
        IntegerType type = (IntegerType) e.getAccessType(); // TODO: Boolean should be sufficient
        Register dummy = e.getFunction().newRegister(type);
        Expression zeroDummy = expressions.makeNot(expressions.makeBooleanCast(dummy));

        Load lockRead = newLockRead(dummy, e.getLock());
        Label spinLoopHead = litmusFormat ? null : newLabel("__spinloop_head");
        Label spinLoopEnd = litmusFormat ? null : newLabel("__spinloop_end");
        CondJump gotoHead = litmusFormat ? null : newGoto(spinLoopHead);
        // In litmus tests, spin locks are guaranteed to succeed, i.e. its read part gets value 0
        Event checkLockValue = litmusFormat ? newAssume(zeroDummy) : newJump(zeroDummy, spinLoopEnd);

        return eventSequence(
                spinLoopHead,
                lockRead,
                checkLockValue,
                gotoHead,
                spinLoopEnd,
                newLockWrite(lockRead, e.getLock())
        );
    }

    @Override
    public List<Event> visitLKMMUnlock(LKMMUnlock e) {
        Store lockRelease = newStoreWithMo(e.getAddress(), e.getMemValue(), e.getMo());
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

    private static Event newCoreMemoryBarrier() {
        return newFence(Tag.Linux.MO_MB);
    }

    private static Load newCoreLoad(Register reg, Expression addr, String mo) {
        return EventFactory.newLoadWithMo(reg, addr, mo);
    }

    private static Store newCoreStore(Expression addr, Expression value, String mo) {
        return EventFactory.newStoreWithMo(addr, value, mo);
    }

    private static Load newLockRead(Register dummy, Expression lockAddr) {
        Load lockRead = newRMWLoadWithMo(dummy, lockAddr, Tag.Linux.MO_ACQUIRE);
        lockRead.addTags(Tag.Linux.LOCK_READ);
        return lockRead;
    }

    private static RMWStore newLockWrite(Load lockRead, Expression lockAddr) {
        Expression one = ExpressionFactory.getInstance().makeOne((IntegerType) lockRead.getAccessType());
        RMWStore lockWrite = newRMWStoreWithMo(lockRead, lockAddr, one, Tag.Linux.MO_ONCE);
        lockWrite.addTags(Tag.Linux.LOCK_WRITE);
        return lockWrite;
    }

}