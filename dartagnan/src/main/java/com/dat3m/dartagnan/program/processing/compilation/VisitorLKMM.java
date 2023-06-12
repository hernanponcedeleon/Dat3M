package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.BNonDet;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.Tag.C11;
import com.dat3m.dartagnan.program.event.core.*;
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
            Store store = newStore(e.getAddress(), e.getMemValue(), Tag.Linux.MO_RELEASE);
            store.addTags(C11.PTHREAD);

            return eventSequence(
                    store
            );
        }

        @Override
        public List<Event> visitEnd(End e) {
            //TODO boolean
            return eventSequence(
                    newStore(e.getAddress(), expressions.makeZero(types.getArchType()), Tag.Linux.MO_RELEASE)
            );
        }

    @Override
    public List<Event> visitJoin(Join e) {
        Register resultRegister = e.getResultRegister();
        IValue zero = expressions.makeZero(resultRegister.getType());
        Load load = newLoad(resultRegister, e.getAddress(), Tag.Linux.MO_ACQUIRE);
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
        Load load = newLoad(resultRegister, e.getAddress(), Tag.Linux.MO_ACQUIRE);
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
                    newLoad(dummy, address, Tag.Linux.MO_ONCE),
                    newAssume(expressions.makeEQ(dummy, cmp)),
                    newGoto(end),
                success, // RMW success branch
                    Linux.newMemoryBarrier(),
                    rmwLoad = newRMWLoad(dummy, address, Tag.Linux.MO_ONCE),
                    newAssume(expressions.makeNEQ(dummy, cmp)),
                    newRMWStore(rmwLoad, address, expressions.makeADD(dummy, value), Tag.Linux.MO_ONCE),
                    Linux.newMemoryBarrier(),
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
                    newLoad(dummy, address, Tag.Linux.MO_ONCE),
                    newAssume(expressions.makeNEQ(dummy, cmp)),
                    newGoto(end),
                success, // CAS success branch
                    mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null,
                    casLoad = newRMWLoad(dummy, address, Tag.Linux.loadMO(mo)),
                    newAssume(expressions.makeEQ(dummy, cmp)),
                    newRMWStore(casLoad, address, value, Tag.Linux.storeMO(mo)),
                    mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null,
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
        Fence optionalMbBefore = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;
        Load load = newRMWLoad(dummy, address, Tag.Linux.loadMO(mo));
        Fence optionalMbAfter = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;

        return eventSequence(
                optionalMbBefore,
                load,
                newRMWStore(load, address, expressions.makeBinary(dummy, e.getOp(), value), Tag.Linux.storeMO(mo)),
                newLocal(resultRegister, dummy),
                optionalMbAfter
        );
    }

    @Override
    public List<Event> visitRMWOp(RMWOp e) {
        Expression address = e.getAddress();
        Register resultRegister = e.getResultRegister();

        Register dummy = e.getThread().newRegister(resultRegister.getType());
        Load load = newRMWLoad(dummy, address, Tag.Linux.MO_ONCE);
        load.addTags(Tag.Linux.NORETURN);
        
        return eventSequence(
                load,
                newRMWStore(load, address, expressions.makeBinary(dummy, e.getOp(), e.getMemValue()), Tag.Linux.MO_ONCE)
        );
    }

    @Override
    public List<Event> visitRMWOpAndTest(RMWOpAndTest e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        IntegerType type = resultRegister.getType();

        Register dummy = e.getThread().newRegister(type);
        Load load = newRMWLoad(dummy, address, Tag.Linux.MO_ONCE);

        return eventSequence(
                Linux.newMemoryBarrier(),
                load,
                newLocal(dummy, expressions.makeBinary(dummy, e.getOp(), e.getMemValue())),
                newRMWStore(load, address, dummy, Tag.Linux.MO_ONCE),
                newLocal(resultRegister, expressions.makeEQ(dummy, expressions.makeZero(type))),
                Linux.newMemoryBarrier()
        );
    }

    @Override
    public List<Event> visitRMWOpReturn(RMWOpReturn e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Register dummy = e.getThread().newRegister(resultRegister.getType());
        Load load = newRMWLoad(dummy, address, Tag.Linux.loadMO(mo));
        Fence optionalMbBefore = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;
        Fence optionalMbAfter = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;

        return eventSequence(
                optionalMbBefore,
                load,
                newLocal(dummy, expressions.makeBinary(dummy, e.getOp(), e.getMemValue())),
                newRMWStore(load, address, dummy, Tag.Linux.storeMO(mo)),
                newLocal(resultRegister, dummy),
                optionalMbAfter
        );
    }

    @Override
    public List<Event> visitRMWXchg(RMWXchg e) {
        Register resultRegister = e.getResultRegister();
        String mo = e.getMo();
        Expression address = e.getAddress();

        Register dummy = e.getThread().newRegister(resultRegister.getType());
        Load load = newRMWLoad(dummy, address, Tag.Linux.loadMO(mo));
        Fence optionalMbBefore = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;
        Fence optionalMbAfter = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;

        return eventSequence(
                optionalMbBefore,
                load,
                newRMWStore(load, address, e.getMemValue(), Tag.Linux.storeMO(mo)),
                newLocal(resultRegister, dummy),
                optionalMbAfter
        );
    }

    @Override
    public List<Event> visitLKMMLock(LKMMLock e) {
        Register dummy = e.getThread().newRegister(types.getArchType());
        Expression zero = expressions.makeZero(dummy.getType());
        // In litmus tests, spin locks are guaranteed to succeed, i.e. its read part gets value 0
        Load lockRead = Linux.newLockRead(dummy, e.getLock());
        Event middle = e.getThread().getProgram().getFormat().equals(LITMUS) ?
                newAssume(expressions.makeEQ(dummy, zero)) :
                newJump(expressions.makeNEQ(dummy, zero), (Label)e.getThread().getExit());
        return eventSequence(
                lockRead,
                middle,
                Linux.newLockWrite(lockRead, e.getLock())
        );
    }
}