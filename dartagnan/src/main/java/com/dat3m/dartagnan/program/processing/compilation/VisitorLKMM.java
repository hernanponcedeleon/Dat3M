package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.Tag.C11;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.lang.linux.*;
import com.dat3m.dartagnan.program.event.lang.pthread.Create;
import com.dat3m.dartagnan.program.event.lang.pthread.End;
import com.dat3m.dartagnan.program.event.lang.pthread.Join;
import com.dat3m.dartagnan.program.event.lang.pthread.Start;

import java.math.BigInteger;
import java.util.List;

import static com.dat3m.dartagnan.expression.op.COpBin.EQ;
import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;
import static com.dat3m.dartagnan.program.Program.SourceLanguage.LITMUS;
import static com.dat3m.dartagnan.program.event.EventFactory.*;

public class VisitorLKMM extends VisitorBase {

    protected VisitorLKMM(boolean forceStart) {
        super(forceStart);
    }

    @Override
    public List<Event> visitCreate(Create e) {
        Store store = newStoreWithMo(e.getAddress(), e.getMemValue(), Tag.Linux.MO_RELEASE);
        store.addTags(C11.PTHREAD);

        return eventSequence(
                store
        );
    }

    @Override
    public List<Event> visitEnd(End e) {
        return eventSequence(
                newStoreWithMo(e.getAddress(), IValue.ZERO, Tag.Linux.MO_RELEASE)
        );
    }

    @Override
    public List<Event> visitJoin(Join e) {
        Register resultRegister = e.getResultRegister();
        Load load = newLoadWithMo(resultRegister, e.getAddress(), Tag.Linux.MO_ACQUIRE);
        load.addTags(C11.PTHREAD);

        return eventSequence(
                load,
                newJumpUnless(new Atom(resultRegister, EQ, IValue.ZERO), (Label) e.getThread().getExit())
        );
    }

    @Override
    public List<Event> visitStart(Start e) {
        Register resultRegister = e.getResultRegister();
        Load load = newLoadWithMo(resultRegister, e.getAddress(), Tag.Linux.MO_ACQUIRE);
        load.addTags(Tag.STARTLOAD);

        return eventSequence(
                load,
                super.visitStart(e),
                newJumpUnless(new Atom(resultRegister, EQ, IValue.ONE), (Label) e.getThread().getExit())
        );
    }

    @Override
    public List<Event> visitRMWAddUnless(RMWAddUnless e) {
        Register resultRegister = e.getResultRegister();
        Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
        ExprInterface cmp = e.getCmp();
        ExprInterface value = e.getMemValue();
        IExpr address = e.getAddress();

        Label success = newLabel("RMW_success");
        Label end = newLabel("RMW_end");
        Load rmwLoad;
        return eventSequence(
                newJump(new BNonDet(), success),
                newLoadWithMo(dummy, address, Tag.Linux.MO_ONCE),
                newAssume(new Atom(dummy, EQ, cmp)),
                newGoto(end),
                success, // RMW success branch
                Linux.newMemoryBarrier(),
                rmwLoad = newRMWLoadWithMo(dummy, address, Tag.Linux.MO_ONCE),
                newAssume(new Atom(dummy, NEQ, cmp)),
                newRMWStoreWithMo(rmwLoad, address, new IExprBin(dummy, IOpBin.PLUS, (IExpr) value), Tag.Linux.MO_ONCE),
                Linux.newMemoryBarrier(),
                end,
                newLocal(resultRegister, new Atom(dummy, NEQ, cmp))
        );
    }

    @Override
    public List<Event> visitRMWCmpXchg(RMWCmpXchg e) {
        Register resultRegister = e.getResultRegister();
        ExprInterface cmp = e.getCmp();
        ExprInterface value = e.getMemValue();
        IExpr address = e.getAddress();
        String mo = e.getMo();

        Label success = newLabel("CAS_success");
        Label end = newLabel("CAS_end");
        Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
        Load casLoad;
        return eventSequence(
                newJump(new BNonDet(), success),
                newLoadWithMo(dummy, address, Tag.Linux.MO_ONCE),
                newAssume(new Atom(dummy, NEQ, cmp)),
                newGoto(end),
                success, // CAS success branch
                mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null,
                casLoad = newRMWLoadWithMo(dummy, address, Tag.Linux.loadMO(mo)),
                newAssume(new Atom(dummy, EQ, cmp)),
                newRMWStoreWithMo(casLoad, address, value, Tag.Linux.storeMO(mo)),
                mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null,
                end,
                newLocal(resultRegister, dummy)
        );
    }

    @Override
    public List<Event> visitRMWFetchOp(RMWFetchOp e) {
        Register resultRegister = e.getResultRegister();
        String mo = e.getMo();
        IExpr address = e.getAddress();
        ExprInterface value = e.getMemValue();

        Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
        Fence optionalMbBefore = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;
        Load load = newRMWLoadWithMo(dummy, address, Tag.Linux.loadMO(mo));
        Fence optionalMbAfter = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;

        return eventSequence(
                optionalMbBefore,
                load,
                newRMWStoreWithMo(load, address, new IExprBin(dummy, e.getOp(), (IExpr) value), Tag.Linux.storeMO(mo)),
                newLocal(resultRegister, dummy),
                optionalMbAfter
        );
    }

    @Override
    public List<Event> visitRMWOp(RMWOp e) {
        IExpr address = e.getAddress();
        Register resultRegister = e.getResultRegister();

        Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
        Load load = newRMWLoadWithMo(dummy, address, Tag.Linux.MO_ONCE);
        load.addTags(Tag.Linux.NORETURN);

        return eventSequence(
                load,
                newRMWStoreWithMo(load, address, new IExprBin(dummy, e.getOp(), (IExpr) e.getMemValue()), Tag.Linux.MO_ONCE)
        );
    }

    @Override
    public List<Event> visitRMWOpAndTest(RMWOpAndTest e) {
        Register resultRegister = e.getResultRegister();
        IExpr address = e.getAddress();
        int precision = resultRegister.getPrecision();

        Register dummy = e.getThread().newRegister(precision);
        Load load = newRMWLoadWithMo(dummy, address, Tag.Linux.MO_ONCE);

        return eventSequence(
                Linux.newMemoryBarrier(),
                load,
                newLocal(dummy, new IExprBin(dummy, e.getOp(), (IExpr) e.getMemValue())),
                newRMWStoreWithMo(load, address, dummy, Tag.Linux.MO_ONCE),
                newLocal(resultRegister, new Atom(dummy, EQ, new IValue(BigInteger.ZERO, precision))),
                Linux.newMemoryBarrier()
        );
    }

    @Override
    public List<Event> visitRMWOpReturn(RMWOpReturn e) {
        Register resultRegister = e.getResultRegister();
        IExpr address = e.getAddress();
        String mo = e.getMo();

        Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
        Load load = newRMWLoadWithMo(dummy, address, Tag.Linux.loadMO(mo));
        Fence optionalMbBefore = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;
        Fence optionalMbAfter = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;

        return eventSequence(
                optionalMbBefore,
                load,
                newLocal(dummy, new IExprBin(dummy, e.getOp(), (IExpr) e.getMemValue())),
                newRMWStoreWithMo(load, address, dummy, Tag.Linux.storeMO(mo)),
                newLocal(resultRegister, dummy),
                optionalMbAfter
        );
    }

    @Override
    public List<Event> visitRMWXchg(RMWXchg e) {
        Register resultRegister = e.getResultRegister();
        String mo = e.getMo();
        IExpr address = e.getAddress();

        Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
        Load load = newRMWLoadWithMo(dummy, address, Tag.Linux.loadMO(mo));
        Fence optionalMbBefore = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;
        Fence optionalMbAfter = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;

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
        Register dummy = e.getThread().newRegister(GlobalSettings.getArchPrecision());
        // In litmus tests, spin locks are guaranteed to succeed, i.e. its read part gets value 0
        Load lockRead = Linux.newLockRead(dummy, e.getLock());
        Event middle = e.getThread().getProgram().getFormat().equals(LITMUS) ?
                newAssume(new Atom(dummy, EQ, IValue.ZERO)) :
                newJump(new Atom(dummy, NEQ, IValue.ZERO), (Label) e.getThread().getExit());
        return eventSequence(
                lockRead,
                middle,
                Linux.newLockWrite(lockRead, e.getLock())
        );
    }
}