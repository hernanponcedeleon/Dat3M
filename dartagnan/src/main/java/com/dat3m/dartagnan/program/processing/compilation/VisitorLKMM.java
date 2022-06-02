package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.Tag.C11;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.lang.linux.*;
import com.dat3m.dartagnan.program.event.lang.linux.cond.RMWReadCondCmp;
import com.dat3m.dartagnan.program.event.lang.linux.cond.RMWReadCondUnless;
import com.dat3m.dartagnan.program.event.lang.pthread.Create;
import com.dat3m.dartagnan.program.event.lang.pthread.End;
import com.dat3m.dartagnan.program.event.lang.pthread.Join;
import com.dat3m.dartagnan.program.event.lang.pthread.Start;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import java.math.BigInteger;
import java.util.List;

import static com.dat3m.dartagnan.expression.op.COpBin.EQ;
import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;
import static com.dat3m.dartagnan.program.Program.SourceLanguage.LITMUS;
import static com.dat3m.dartagnan.program.event.EventFactory.*;

public class VisitorLKMM extends VisitorBase implements EventVisitor<List<Event>> {

	protected VisitorLKMM() {}
	
	@Override
	public List<Event> visitCreate(Create e) {

        Store store = newStore(e.getAddress(), e.getMemValue(), Tag.Linux.MO_RELEASE);
        store.addFilters(C11.PTHREAD);

        return eventSequence(
        		EventFactory.Linux.newMemoryBarrier(),
                store
        );
	}

	@Override
	public List<Event> visitEnd(End e) {
        return eventSequence(
        		EventFactory.Linux.newMemoryBarrier(),
                newStore(e.getAddress(), IValue.ZERO, Tag.Linux.MO_RELEASE)
        );
	}

	@Override
	public List<Event> visitJoin(Join e) {
        Register resultRegister = e.getResultRegister();
		Load load = newLoad(resultRegister, e.getAddress(), Tag.Linux.MO_ACQUIRE);
        load.addFilters(C11.PTHREAD);
        
        return eventSequence(
        		load,
        		newJumpUnless(new Atom(resultRegister, EQ, IValue.ZERO), (Label) e.getThread().getExit()),
        		EventFactory.Linux.newMemoryBarrier()
        );
	}

	@Override
	public List<Event> visitStart(Start e) {
        Register resultRegister = e.getResultRegister();

        return eventSequence(
        		newLoad(resultRegister, e.getAddress(), Tag.Linux.MO_ACQUIRE),
        		newJumpUnless(new Atom(resultRegister, EQ, IValue.ONE), (Label) e.getThread().getExit()),
            	EventFactory.Linux.newMemoryBarrier()
        );
	}

	@Override
	public List<Event> visitRMWAddUnless(RMWAddUnless e) {
        Register resultRegister = e.getResultRegister();
		Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
        RMWReadCondUnless load = Linux.newRMWReadCondUnless(dummy, e.getCmp(), e.getAddress(), Tag.Linux.MO_ONCE);

        return eventSequence(
                Linux.newConditionalMemoryBarrier(load),
                load,
                Linux.newRMWStoreCond(load, e.getAddress(), new IExprBin(dummy, IOpBin.PLUS, (IExpr) e.getMemValue()), Tag.Linux.MO_ONCE),
                newLocal(resultRegister, new Atom(dummy, NEQ, e.getCmp())),
                Linux.newConditionalMemoryBarrier(load)
        );
	}

	@Override
	public List<Event> visitRMWCmpXchg(RMWCmpXchg e) {
		Register resultRegister = e.getResultRegister();
		ExprInterface cmp = e.getCmp();
		ExprInterface value = e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		
        Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
        RMWReadCondCmp load = Linux.newRMWReadCondCmp(dummy, cmp, address, Tag.Linux.loadMO(mo));
        Fence optionalMbBefore = mo.equals(Tag.Linux.MO_MB) ? Linux.newConditionalMemoryBarrier(load) : null;
        Fence optionalMbAfter = mo.equals(Tag.Linux.MO_MB) ? Linux.newConditionalMemoryBarrier(load) : null;

        return eventSequence(
                optionalMbBefore,
                load,
                Linux.newRMWStoreCond(load, address, value, Tag.Linux.storeMO(mo)),
                newLocal(resultRegister, dummy),
                optionalMbAfter
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
                newRMWStore(load, address, new IExprBin(dummy, e.getOp(), (IExpr) value), Tag.Linux.storeMO(mo)),
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
                newRMWStore(load, address, new IExprBin(dummy, e.getOp(), (IExpr) e.getMemValue()), Tag.Linux.MO_ONCE)
        );
	}

	@Override
	public List<Event> visitRMWOpAndTest(RMWOpAndTest e) {
        Register resultRegister = e.getResultRegister();
        IExpr address = e.getAddress();
        int precision = resultRegister.getPrecision();
        
		Register dummy = e.getThread().newRegister(precision);
		Load load = newRMWLoad(dummy, address, Tag.Linux.MO_ONCE);

        //TODO: Are the memory barriers really unconditional?
        return eventSequence(
                Linux.newMemoryBarrier(),
                load,
                newLocal(dummy, new IExprBin(dummy, e.getOp(), (IExpr) e.getMemValue())),
                newRMWStore(load, address, dummy, Tag.Linux.MO_ONCE),
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
		Load load = newRMWLoad(dummy, address, Tag.Linux.loadMO(mo));
		Fence optionalMbBefore = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;
        Fence optionalMbAfter = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;

        return eventSequence(
                optionalMbBefore,
                load,
                newLocal(dummy, new IExprBin(dummy, e.getOp(), (IExpr) e.getMemValue())),
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
		Register dummy = e.getThread().newRegister(GlobalSettings.ARCH_PRECISION);
        // In litmus tests, spinlocks are guaranteed to success, i.e. its read part gets value 0
		Event middle = e.getThread().getProgram().getFormat().equals(LITMUS) ?
				newAssume(new Atom(dummy, COpBin.EQ, IValue.ZERO)) :
				newJump(new Atom(dummy, NEQ, IValue.ZERO), (Label)e.getThread().getExit());
		return eventSequence(
                Linux.newLockRead(dummy, e.getLock()),
                middle,
                Linux.newLockWrite(e.getLock())
        );
	}
}