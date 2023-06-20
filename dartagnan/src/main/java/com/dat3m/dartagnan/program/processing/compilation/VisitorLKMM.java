package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.BNonDet;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.Tag.C11;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.lang.linux.*;
import com.dat3m.dartagnan.program.event.lang.pthread.Create;
import com.dat3m.dartagnan.program.event.lang.pthread.End;
import com.dat3m.dartagnan.program.event.lang.pthread.Join;
import com.dat3m.dartagnan.program.event.lang.pthread.Start;

import java.util.List;

import static com.dat3m.dartagnan.program.Program.SourceLanguage.LITMUS;
import static com.dat3m.dartagnan.program.event.EventFactory.*;

public class VisitorLKMM extends VisitorBase {

    protected VisitorLKMM(boolean forceStart) {
        super(forceStart);
    }

    @Override
    public List<Event> visitCreate(Create e) {
        Store store = newCoreStore(e.getAddress(), e.getMemValue(), Tag.Linux.MO_RELEASE);
        store.addTags(C11.PTHREAD);

        return eventSequence(
                store
        );
    }

    @Override
    public List<Event> visitEnd(End e) {
        //TODO boolean
        return eventSequence(
                newCoreStore(e.getAddress(), expressions.makeZero(types.getArchType()), Tag.Linux.MO_RELEASE)
        );
    }

    @Override
    public List<Event> visitJoin(Join e) {
        Register resultRegister = e.getResultRegister();
        IValue zero = expressions.makeZero(resultRegister.getType());
        Load load = newCoreLoad(resultRegister, e.getAddress(), Tag.Linux.MO_ACQUIRE);
        load.addTags(C11.PTHREAD);

        return eventSequence(
                load,
                newJump(expressions.makeNEQ(resultRegister, zero), (Label) e.getThread().getExit())
        );
    }

    @Override
    public List<Event> visitStart(Start e) {
        Register resultRegister = e.getResultRegister();
        IValue one = expressions.makeOne(resultRegister.getType());
        Load load = newCoreLoad(resultRegister, e.getAddress(), Tag.Linux.MO_ACQUIRE);
        load.addTags(Tag.STARTLOAD);

        return eventSequence(
                load,
                super.visitStart(e),
                newJump(expressions.makeNEQ(resultRegister, one), (Label) e.getThread().getExit())
        );
    }

    @Override
    public List<Event> visitRMWAddUnless(RMWAddUnless e) {
        Register resultRegister = e.getResultRegister();
        Register dummy = e.getThread().newRegister(resultRegister.getType());
        Expression cmp = e.getCmp();
        Expression value = e.getMemValue();
        Expression address = e.getAddress();

        Label success = newLabel("RMW_success");
        Label end = newLabel("RMW_end");
        Load rmwLoad;
        return eventSequence(
                newJump(new BNonDet(), success),
                newCoreLoad(dummy, address, Tag.Linux.MO_ONCE),
                newAssume(expressions.makeEQ(dummy, cmp)),
                newGoto(end),
                success, // RMW success branch
                newCoreMemoryBarrier(),
                rmwLoad = newRMWLoadWithMo(dummy, address, Tag.Linux.MO_ONCE),
                newAssume(expressions.makeNEQ(dummy, cmp)),
                newRMWStoreWithMo(rmwLoad, address, expressions.makeADD(dummy, value), Tag.Linux.MO_ONCE),
                newCoreMemoryBarrier(),
                end,
                newLocal(resultRegister, expressions.makeNEQ(dummy, cmp))
        );
    }

    @Override
    public List<Event> visitRMWCmpXchg(RMWCmpXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression cmp = e.getCmp();
        Expression value = e.getMemValue();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Label success = newLabel("CAS_success");
        Label end = newLabel("CAS_end");
        Register dummy = e.getThread().newRegister(resultRegister.getType());
        Load casLoad;
        return eventSequence(
                newJump(new BNonDet(), success),
                newCoreLoad(dummy, address, Tag.Linux.MO_ONCE),
                newAssume(expressions.makeNEQ(dummy, cmp)),
                newGoto(end),
                success, // CAS success branch
                mo.equals(Tag.Linux.MO_MB) ? newCoreMemoryBarrier() : null,
                casLoad = newRMWLoadWithMo(dummy, address, Tag.Linux.loadMO(mo)),
                newAssume(expressions.makeEQ(dummy, cmp)),
                newRMWStoreWithMo(casLoad, address, value, Tag.Linux.storeMO(mo)),
                mo.equals(Tag.Linux.MO_MB) ? newCoreMemoryBarrier() : null,
                end,
                newLocal(resultRegister, dummy)
        );
    }

    @Override
    public List<Event> visitRMWFetchOp(RMWFetchOp e) {
        Register resultRegister = e.getResultRegister();
        String mo = e.getMo();
        Expression address = e.getAddress();
        Expression value = e.getMemValue();

        Register dummy = e.getThread().newRegister(resultRegister.getType());
        Fence optionalMbBefore = mo.equals(Tag.Linux.MO_MB) ? newCoreMemoryBarrier() : null;
        Load load = newRMWLoadWithMo(dummy, address, Tag.Linux.loadMO(mo));
        Fence optionalMbAfter = mo.equals(Tag.Linux.MO_MB) ? newCoreMemoryBarrier() : null;

        return eventSequence(
                optionalMbBefore,
                load,
                newRMWStoreWithMo(load, address, expressions.makeBinary(dummy, e.getOp(), value), Tag.Linux.storeMO(mo)),
                newLocal(resultRegister, dummy),
                optionalMbAfter
        );
    }

    @Override
    public List<Event> visitRMWOp(RMWOp e) {
        Expression address = e.getAddress();
        Register resultRegister = e.getResultRegister();

        Register dummy = e.getThread().newRegister(resultRegister.getType());
        Load load = newRMWLoadWithMo(dummy, address, Tag.Linux.MO_ONCE);
        load.addTags(Tag.Linux.NORETURN);

        return eventSequence(
                load,
                newRMWStoreWithMo(load, address, expressions.makeBinary(dummy, e.getOp(), e.getMemValue()), Tag.Linux.MO_ONCE)
        );
    }

    @Override
    public List<Event> visitRMWOpAndTest(RMWOpAndTest e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        IntegerType type = resultRegister.getType();

        Register dummy = e.getThread().newRegister(type);
        Load load = newRMWLoadWithMo(dummy, address, Tag.Linux.MO_ONCE);

        return eventSequence(
                newCoreMemoryBarrier(),
                load,
                newLocal(dummy, expressions.makeBinary(dummy, e.getOp(), e.getMemValue())),
                newRMWStoreWithMo(load, address, dummy, Tag.Linux.MO_ONCE),
                newLocal(resultRegister, expressions.makeEQ(dummy, expressions.makeZero(type))),
                newCoreMemoryBarrier()
        );
    }

    @Override
    public List<Event> visitRMWOpReturn(RMWOpReturn e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Register dummy = e.getThread().newRegister(resultRegister.getType());
        Load load = newRMWLoadWithMo(dummy, address, Tag.Linux.loadMO(mo));
        Fence optionalMbBefore = mo.equals(Tag.Linux.MO_MB) ? newCoreMemoryBarrier() : null;
        Fence optionalMbAfter = mo.equals(Tag.Linux.MO_MB) ? newCoreMemoryBarrier() : null;

        return eventSequence(
                optionalMbBefore,
                load,
                newLocal(dummy, expressions.makeBinary(dummy, e.getOp(), e.getMemValue())),
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
    public List<Event> visitRMWXchg(RMWXchg e) {
        Register resultRegister = e.getResultRegister();
        String mo = e.getMo();
        Expression address = e.getAddress();

        Register dummy = e.getThread().newRegister(resultRegister.getType());
        Load load = newRMWLoadWithMo(dummy, address, Tag.Linux.loadMO(mo));
        Fence optionalMbBefore = mo.equals(Tag.Linux.MO_MB) ? newCoreMemoryBarrier() : null;
        Fence optionalMbAfter = mo.equals(Tag.Linux.MO_MB) ? newCoreMemoryBarrier() : null;

        return eventSequence(
                optionalMbBefore,
                load,
                newRMWStoreWithMo(load, address, e.getMemValue(), Tag.Linux.storeMO(mo)),
                newLocal(resultRegister, dummy),
                optionalMbAfter
        );
    }

    @Override
    public List<Event> visitLKMMLock(LKMMLock e) {
        Register dummy = e.getThread().newRegister(types.getArchType());
        Expression zero = expressions.makeZero(dummy.getType());

        Load lockRead = newLockRead(e.getLock(), dummy);
        // In litmus tests, spin locks are guaranteed to succeed, i.e. its read part gets value 0
        Event checkLockValue = e.getThread().getProgram().getFormat().equals(LITMUS) ?
                newAssume(expressions.makeEQ(dummy, zero)) :
                newJump(expressions.makeNEQ(dummy, zero), (Label) e.getThread().getExit());
        return eventSequence(
                lockRead,
                checkLockValue,
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

    private static Fence newCoreMemoryBarrier() {
        return newFence(Tag.Linux.MO_MB);
    }

    private static Load newCoreLoad(Register reg, Expression addr, String mo) {
        return EventFactory.newLoadWithMo(reg, addr, mo);
    }

    private static Store newCoreStore(Expression addr, Expression value, String mo) {
        return EventFactory.newStoreWithMo(addr, value, mo);
    }

    private static Load newLockRead(Expression lock, Register dummy) {
        Load lockRead = newRMWLoadWithMo(dummy, lock, Tag.Linux.MO_ACQUIRE);
        lockRead.addTags(Tag.Linux.LOCK_READ);
        return lockRead;
    }

    private static RMWStore newLockWrite(Load lockRead, Expression lock) {
        Expression one = ExpressionFactory.getInstance().makeOne(TypeFactory.getInstance().getArchType());
        RMWStore lockWrite = newRMWStoreWithMo(lockRead, lock, one, Tag.Linux.MO_ONCE);
        lockWrite.addTags(Tag.Linux.LOCK_WRITE);
        return lockWrite;
    }

}