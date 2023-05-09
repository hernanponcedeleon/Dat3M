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
            Store store = newStore(e.getAddress(), e.getMemValue(), Tag.Linux.MO_RELEASE);
            store.addFilters(C11.PTHREAD);

            return eventSequence(
                    store
            );
        }

        @Override
        public List<Event> visitEnd(End e) {
            //TODO boolean
            return eventSequence(
                    newStore(e.getAddress(), expressions.makeZero(GlobalSettings.getArchPrecision()), Tag.Linux.MO_RELEASE)
            );
        }

    @Override
    public List<Event> visitJoin(Join e) {
        Register resultRegister = e.getResultRegister();
        IValue zero = expressions.makeZero(resultRegister.getPrecision());
        Load load = newLoad(resultRegister, e.getAddress(), Tag.Linux.MO_ACQUIRE);
        load.addFilters(C11.PTHREAD);
        
        return eventSequence(
                load,
                newJump(expressions.makeBinary(resultRegister, NEQ, zero), (Label) e.getThread().getExit())
        );
    }

    @Override
    public List<Event> visitStart(Start e) {
        Register resultRegister = e.getResultRegister();
        IValue one = expressions.makeOne(resultRegister.getPrecision());
        Load load = newLoad(resultRegister, e.getAddress(), Tag.Linux.MO_ACQUIRE);
        load.addFilters(Tag.STARTLOAD);

        return eventSequence(
                load,
                super.visitStart(e),
                newJump(expressions.makeBinary(resultRegister, NEQ, one), (Label) e.getThread().getExit())
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
                    newLoad(dummy, address, Tag.Linux.MO_ONCE),
                    newAssume(expressions.makeBinary(dummy, EQ, cmp)),
                    newGoto(end),
                success, // RMW success branch
                    Linux.newMemoryBarrier(),
                    rmwLoad = newRMWLoad(dummy, address, Tag.Linux.MO_ONCE),
                    newAssume(expressions.makeBinary(dummy, NEQ, cmp)),
                    newRMWStore(rmwLoad, address, expressions.makeBinary(dummy, IOpBin.PLUS, (IExpr) value), Tag.Linux.MO_ONCE),
                    Linux.newMemoryBarrier(),
                end,
                newLocal(resultRegister, expressions.makeBinary(dummy, NEQ, cmp))
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
                    newLoad(dummy, address, Tag.Linux.MO_ONCE),
                    newAssume(expressions.makeBinary(dummy, NEQ, cmp)),
                    newGoto(end),
                success, // CAS success branch
                    mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null,
                    casLoad = newRMWLoad(dummy, address, Tag.Linux.loadMO(mo)),
                    newAssume(expressions.makeBinary(dummy, EQ, cmp)),
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
        IExpr address = e.getAddress();
        ExprInterface value = e.getMemValue();

        Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
        Fence optionalMbBefore = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;
        Load load = newRMWLoad(dummy, address, Tag.Linux.loadMO(mo));
        Fence optionalMbAfter = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;

        return eventSequence(
                optionalMbBefore,
                load,
                newRMWStore(load, address, expressions.makeBinary(dummy, e.getOp(), (IExpr) value), Tag.Linux.storeMO(mo)),
                newLocal(resultRegister, dummy),
                optionalMbAfter
        );
    }

    @Override
    public List<Event> visitRMWOp(RMWOp e) {
        IExpr address = e.getAddress();
        Register resultRegister = e.getResultRegister();

        Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
        Load load = newRMWLoad(dummy, address, Tag.Linux.MO_ONCE);
        load.addFilters(Tag.Linux.NORETURN);
        
        return eventSequence(
                load,
                newRMWStore(load, address, expressions.makeBinary(dummy, e.getOp(), (IExpr) e.getMemValue()), Tag.Linux.MO_ONCE)
        );
    }

    @Override
    public List<Event> visitRMWOpAndTest(RMWOpAndTest e) {
        Register resultRegister = e.getResultRegister();
        IExpr address = e.getAddress();
        int precision = resultRegister.getPrecision();

        Register dummy = e.getThread().newRegister(precision);
        Load load = newRMWLoad(dummy, address, Tag.Linux.MO_ONCE);

        return eventSequence(
                Linux.newMemoryBarrier(),
                load,
                newLocal(dummy, expressions.makeBinary(dummy, e.getOp(), (IExpr) e.getMemValue())),
                newRMWStore(load, address, dummy, Tag.Linux.MO_ONCE),
                newLocal(resultRegister, expressions.makeBinary(dummy, EQ, expressions.makeZero(precision))),
                Linux.newMemoryBarrier()
        );
    }

    @Override
    public List<Event> visitRMWOpReturn(RMWOpReturn e) {
        Register resultRegister = e.getResultRegister();
        IExpr address = e.getAddress();
        String mo = e.getMo();

        Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
        Load load = newRMWLoad(dummy, address, Tag.Linux.loadMO(mo));
        Fence optionalMbBefore = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;
        Fence optionalMbAfter = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;

        return eventSequence(
                optionalMbBefore,
                load,
                newLocal(dummy, expressions.makeBinary(dummy, e.getOp(), (IExpr) e.getMemValue())),
                newRMWStore(load, address, dummy, Tag.Linux.storeMO(mo)),
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
        Register dummy = e.getThread().newRegister(GlobalSettings.getArchPrecision());
        IExpr zero = expressions.makeZero(dummy.getPrecision());
        // In litmus tests, spin locks are guaranteed to succeed, i.e. its read part gets value 0
        Load lockRead = Linux.newLockRead(dummy, e.getLock());
		Event middle = e.getThread().getProgram().getFormat().equals(LITMUS) ?
				newAssume(expressions.makeBinary(dummy, EQ, zero)) :
                newJump(expressions.makeBinary(dummy, NEQ, zero), (Label)e.getThread().getExit());
        return eventSequence(
                lockRead,
                middle,
                Linux.newLockWrite(lockRead, e.getLock())
        );
    }
}