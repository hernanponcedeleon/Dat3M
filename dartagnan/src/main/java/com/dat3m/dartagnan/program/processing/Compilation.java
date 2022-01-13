package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.BExprUn;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.op.BOpUn;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.EventFactory.AArch64;
import com.dat3m.dartagnan.program.event.EventFactory.Linux;
import com.dat3m.dartagnan.program.event.EventFactory.Power;
import com.dat3m.dartagnan.program.event.EventFactory.X86;
import com.dat3m.dartagnan.program.event.Tag.C11;
import com.dat3m.dartagnan.program.event.arch.aarch64.StoreExclusive;
import com.dat3m.dartagnan.program.event.arch.tso.Xchg;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.ExecutionStatus;
import com.dat3m.dartagnan.program.event.core.Fence;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStoreExclusive;
import com.dat3m.dartagnan.program.event.lang.catomic.AtomicAbstract;
import com.dat3m.dartagnan.program.event.lang.catomic.AtomicCmpXchg;
import com.dat3m.dartagnan.program.event.lang.catomic.AtomicFetchOp;
import com.dat3m.dartagnan.program.event.lang.catomic.AtomicLoad;
import com.dat3m.dartagnan.program.event.lang.catomic.AtomicStore;
import com.dat3m.dartagnan.program.event.lang.catomic.AtomicThreadFence;
import com.dat3m.dartagnan.program.event.lang.catomic.AtomicXchg;
import com.dat3m.dartagnan.program.event.lang.catomic.Dat3mCAS;
import com.dat3m.dartagnan.program.event.lang.linux.RMWAddUnless;
import com.dat3m.dartagnan.program.event.lang.linux.RMWCmpXchg;
import com.dat3m.dartagnan.program.event.lang.linux.RMWFetchOp;
import com.dat3m.dartagnan.program.event.lang.linux.RMWOp;
import com.dat3m.dartagnan.program.event.lang.linux.RMWOpAndTest;
import com.dat3m.dartagnan.program.event.lang.linux.RMWOpReturn;
import com.dat3m.dartagnan.program.event.lang.linux.RMWXchg;
import com.dat3m.dartagnan.program.event.lang.linux.cond.RMWReadCondCmp;
import com.dat3m.dartagnan.program.event.lang.linux.cond.RMWReadCondUnless;
import com.dat3m.dartagnan.program.event.lang.pthread.Create;
import com.dat3m.dartagnan.program.event.lang.pthread.End;
import com.dat3m.dartagnan.program.event.lang.pthread.InitLock;
import com.dat3m.dartagnan.program.event.lang.pthread.Join;
import com.dat3m.dartagnan.program.event.lang.pthread.Lock;
import com.dat3m.dartagnan.program.event.lang.pthread.Start;
import com.dat3m.dartagnan.program.event.lang.pthread.Unlock;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.base.Preconditions;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import static com.dat3m.dartagnan.configuration.OptionNames.TARGET;
import static com.dat3m.dartagnan.expression.op.COpBin.EQ;
import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;
import static com.dat3m.dartagnan.program.event.EventFactory.eventSequence;
import static com.dat3m.dartagnan.program.event.EventFactory.newExecutionStatus;
import static com.dat3m.dartagnan.program.event.EventFactory.newFakeCtrlDep;
import static com.dat3m.dartagnan.program.event.EventFactory.newGoto;
import static com.dat3m.dartagnan.program.event.EventFactory.newJump;
import static com.dat3m.dartagnan.program.event.EventFactory.newJumpUnless;
import static com.dat3m.dartagnan.program.event.EventFactory.newLabel;
import static com.dat3m.dartagnan.program.event.EventFactory.newLoad;
import static com.dat3m.dartagnan.program.event.EventFactory.newLocal;
import static com.dat3m.dartagnan.program.event.EventFactory.newRMWLoad;
import static com.dat3m.dartagnan.program.event.EventFactory.newRMWLoadExclusive;
import static com.dat3m.dartagnan.program.event.EventFactory.newRMWStore;
import static com.dat3m.dartagnan.program.event.EventFactory.newRMWStoreExclusive;
import static com.dat3m.dartagnan.program.event.EventFactory.newStore;
import static com.dat3m.dartagnan.program.event.Tag.RMW;
import static com.dat3m.dartagnan.program.event.Tag.STRONG;

@Options
public class Compilation implements ProgramProcessor {


    private static final Logger logger = LogManager.getLogger(Compilation.class);

    // =========================== Configurables ===========================

    @Option(name = TARGET,
            description = "The target architecture to which the program shall be compiled to.",
            secure = true,
            toUppercase = true)
    private Arch target = Arch.NONE;

    public Arch getTarget() { return target; }
    public void setTarget(Arch target) { this.target = target;}

    // =====================================================================

    private Compilation() { }

    private Compilation(Configuration config) throws InvalidConfigurationException {
        config.inject(this);
    }

    public static Compilation fromConfig(Configuration config) throws InvalidConfigurationException {
        return new Compilation(config);
    }

    public static Compilation newInstance() {
        return new Compilation();
    }


    @Override
    public void run(Program program) {
        if (program.isCompiled()) {
            logger.warn("Skipped compilation: Program is already compiled to {}", program.getArch());
            return;
        }
        Preconditions.checkArgument(program.isUnrolled(), "The program needs to be unrolled before compilation.");

        int nextId = 0;
        for(Thread thread : program.getThreads()){
            nextId = compileThread(thread, nextId);

            int fId = 0;
            for (Event e : thread.getEvents()) {
                e.setFId(fId++);
            }
        }

        program.setArch(target);
        program.clearCache(false);
        program.markAsCompiled();
        logger.info("Program compiled to {}", target);
    }

    private int compileThread(Thread thread, int nextId) {
        EventVisitor<List<Event>> visitor = null;
        switch(target) {
	    	case NONE:
	    		visitor = new VisitorNone();
	    	case TSO:
	    		visitor = new VisitorTSO();
	    	case POWER:
	    		visitor = new VisitorPower();
	    	case ARM8:
	    		visitor = new VisitorARM();
        }
        Preconditions.checkState(visitor != null, String.format("Compilation to %s is not supported.", target));

    	Event pred = thread.getEntry();
        Event toBeCompiled = pred.getSuccessor();
        pred.setCId(nextId++);

        while (toBeCompiled != null) {
			List<Event> compiledEvents = toBeCompiled.accept(visitor);
            for (Event e : compiledEvents) {
                e.setOId(toBeCompiled.getOId());
                e.setUId(toBeCompiled.getUId());
                e.setCId(nextId++);
                e.setThread(thread);
                e.setCLine(toBeCompiled.getCLine());
                pred.setSuccessor(e);
                pred = e;
            }

            toBeCompiled = toBeCompiled.getSuccessor();
        }

        thread.updateExit(thread.getEntry());
        thread.clearCache();
        return nextId;
    }

    private class VisitorARM implements EventVisitor<List<Event>> {

    	@Override
    	public List<Event> visitEvent(Event e) {
    		return Collections.singletonList(e);
    	};

    	@Override
    	public List<Event> visitCreate(Create e) {
            Store store = newStore(e.getAddress(), e.getMemValue(), e.getMo(), e.getCLine());
            store.addFilters(C11.PTHREAD);

            return eventSequence(
            		AArch64.DMB.newISHBarrier(),
                    store,
                    AArch64.DMB.newISHBarrier()
            );
    	}

    	@Override
    	public List<Event> visitEnd(End e) {
            return eventSequence(
            		AArch64.DMB.newISHBarrier(),
            		newStore(e.getAddress(), IConst.ZERO, e.getMo()),
                    AArch64.DMB.newISHBarrier()
            );
    	}

    	@Override
    	public List<Event> visitInitLock(InitLock e) {
    		return eventSequence(
                    newStore(e.getAddress(), e.getMemValue(), e.getMo())
            );
    	}

    	@Override
    	public List<Event> visitJoin(Join e) {
            List<Event> events = new ArrayList<>();
            Register resultRegister = e.getResultRegister();
    		Load load = newLoad(resultRegister, e.getAddress(), e.getMo());
            load.addFilters(C11.PTHREAD);
            events.add(load);
            events.add(AArch64.DMB.newISHBarrier());
            events.add(newJumpUnless(new Atom(resultRegister, EQ, IConst.ZERO), e.getLabel()));
            
            return events;
    	}

    	@Override
    	public List<Event> visitLock(Lock e) {
            Register resultRegister = e.getResultRegister();
    		String mo = e.getMo();
    		
    		List<Event> events = eventSequence(
                    newLoad(resultRegister, e.getAddress(), mo),
                    newJump(new Atom(resultRegister, NEQ, IConst.ZERO), e.getLabel()),
                    newStore(e.getAddress(), IConst.ONE, mo)
            );
            
    		for(Event child : events) {
                child.addFilters(C11.LOCK, RMW);
            }
            
    		return events;
    	}

    	@Override
    	public List<Event> visitStart(Start e) {
            List<Event> events = new ArrayList<>();
            Register resultRegister = e.getResultRegister();
            events.add(newLoad(resultRegister, e.getAddress(), e.getMo()));
            events.add(AArch64.DMB.newISHBarrier());
            events.add(newJumpUnless(new Atom(resultRegister, EQ, IConst.ONE), e.getLabel()));
            
            return events;
    	}

    	@Override
    	public List<Event> visitUnlock(Unlock e) {
            Register resultRegister = e.getResultRegister();
    		IExpr address = e.getAddress();
    		String mo = e.getMo();
    		
    		List<Event> events = eventSequence(
                    newLoad(resultRegister, address, mo),
                    newJump(new Atom(resultRegister, NEQ, IConst.ONE), e.getLabel()),
                    newStore(address, IConst.ZERO, mo)
            );
            
    		for(Event child : events) {
                child.addFilters(C11.LOCK, RMW);
            }
            
    		return events;
    	}

    	@Override
    	public List<Event> visitStoreExclusive(StoreExclusive e) {
            RMWStoreExclusive store = newRMWStoreExclusive(e.getAddress(), e.getMemValue(), e.getMo());
            
            return eventSequence(
                    store,
                    newExecutionStatus(e.getResultRegister(), store)
            );
    	}

    	@Override
    	public List<Event> visitAtomicAbstract(AtomicAbstract e) {
    		throw new UnsupportedOperationException("Compilation to " + target + 
    				" is not supported for " + getClass().getName());
    	}

    	@Override
    	public List<Event> visitAtomicCmpXchg(AtomicCmpXchg e) {
    		Register resultRegister = e.getResultRegister();
    		IExpr address = e.getAddress();
    		ExprInterface value = e.getMemValue();
    		String mo = e.getMo();
    		IExpr expectedAddr = e.getExpectedAddr();
            int threadId = resultRegister.getThreadId();
    		int precision = resultRegister.getPrecision();

    		Register regExpected = new Register(null, threadId, precision);
            Register regValue = new Register(null, threadId, precision);
            Load loadExpected = newLoad(regExpected, expectedAddr, null);
            Store storeExpected = newStore(expectedAddr, regValue, null);
            Label casFail = newLabel("CAS_fail");
            Label casEnd = newLabel("CAS_end");
            Local casCmpResult = newLocal(resultRegister, new Atom(regValue, EQ, regExpected));
            CondJump branchOnCasCmpResult = newJump(new Atom(resultRegister, NEQ, IConst.ONE), casFail);
            CondJump gotoCasEnd = newGoto(casEnd);

            Load loadValue = newRMWLoadExclusive(regValue, address, Tag.ARMv8.extractLoadMoFromCMo(mo));
            Store storeValue = newRMWStoreExclusive(address, value, Tag.ARMv8.extractStoreMoFromCMo(mo), e.is(STRONG));
            ExecutionStatus optionalExecStatus = null;
            Local optionalUpdateCasCmpResult = null;
            if (!e.is(STRONG)) {
                Register statusReg = new Register("status(" + e.getOId() + ")", threadId, precision);
                optionalExecStatus = newExecutionStatus(statusReg, storeValue);
                optionalUpdateCasCmpResult = newLocal(resultRegister, new BExprUn(BOpUn.NOT, statusReg));
            }

            return eventSequence(
                    // Indentation shows the branching structure
                    loadExpected,
                    loadValue,
                    casCmpResult,
                    branchOnCasCmpResult,
                        storeValue,
                        optionalExecStatus,
                        optionalUpdateCasCmpResult,
                        gotoCasEnd,
                    casFail,
                        storeExpected,
                    casEnd
            );
    	}

    	@Override
    	public List<Event> visitAtomicFetchOp(AtomicFetchOp e) {
    		Register resultRegister = e.getResultRegister();
    		IOpBin op = e.getOp();
    		IExpr value = (IExpr) e.getMemValue();
    		IExpr address = e.getAddress();
    		String mo = e.getMo();
    		
            Register dummyReg = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
            Local localOp = newLocal(dummyReg, new IExprBin(resultRegister, op, value));

            Load load = newRMWLoadExclusive(resultRegister, address, Tag.ARMv8.extractLoadMoFromCMo(mo));
            Store store = newRMWStoreExclusive(address, dummyReg, Tag.ARMv8.extractStoreMoFromCMo(mo), true);
            Label label = newLabel("FakeDep");
            Event fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

            return eventSequence(
                    load,
                    fakeCtrlDep,
                    label,
                    localOp,
                    store
            );
    	}

    	@Override
    	public List<Event> visitAtomicLoad(AtomicLoad e) {
            return eventSequence(
                    newLoad(e.getResultRegister(), e.getAddress(), Tag.ARMv8.extractLoadMoFromCMo(e.getMo()))
            );
    	}

    	@Override
    	public List<Event> visitAtomicStore(AtomicStore e) {
            return eventSequence(
                    newStore(e.getAddress(), e.getMemValue(), Tag.ARMv8.extractStoreMoFromCMo(e.getMo()))
            );
    	}

    	@Override
    	public List<Event> visitAtomicThreadFence(AtomicThreadFence e) {
    		String mo = e.getMo();
            Fence fence = null;
                    fence = mo.equals(Tag.C11.MO_RELEASE) || mo.equals(Tag.C11.MO_ACQUIRE_RELEASE) || mo.equals(Tag.C11.MO_SC) ? AArch64.DMB.newISHBarrier()
                            : mo.equals(Tag.C11.MO_ACQUIRE) ? AArch64.DSB.newISHLDBarrier() : null;

        return eventSequence(
                    fence
            );
    	}

    	@Override
    	public List<Event> visitAtomicXchg(AtomicXchg e) {
    		Register resultRegister = e.getResultRegister();
    		ExprInterface value = e.getMemValue();
    		IExpr address = e.getAddress();
    		String mo = e.getMo();

            Load load = newRMWLoadExclusive(resultRegister, address, Tag.ARMv8.extractLoadMoFromCMo(mo));
            Store store = newRMWStoreExclusive(address, value, Tag.ARMv8.extractStoreMoFromCMo(mo), true);
            Label label = newLabel("FakeDep");
            Event fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

            return eventSequence(
                    load,
                    fakeCtrlDep,
                    label,
                    store
            );
    	}

    	@Override
    	public List<Event> visitDat3mCAS(Dat3mCAS e) {
    		Register resultRegister = e.getResultRegister();
    		ExprInterface value = e.getMemValue();
    		IExpr address = e.getAddress();
    		String mo = e.getMo();
    		ExprInterface expectedValue = e.getExpectedValue();

            // Events common for all compilation schemes.
            Register regValue = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
            Local casCmpResult = newLocal(resultRegister, new Atom(regValue, EQ, expectedValue));
            Label casEnd = newLabel("CAS_end");
            CondJump branchOnCasCmpResult = newJump(new Atom(resultRegister, NEQ, IConst.ONE), casEnd);

            Load load = newRMWLoadExclusive(regValue, address, Tag.ARMv8.extractLoadMoFromCMo(mo));
            Store store = newRMWStoreExclusive(address, value, Tag.ARMv8.extractStoreMoFromCMo(mo), true);

            // --- Add success events ---
            return eventSequence(
                    // Indentation shows the branching structure
                    load,
                    casCmpResult,
                    branchOnCasCmpResult,
                        store,
                    casEnd
            );
    	}
    }

    private class VisitorNone implements EventVisitor<List<Event>> {

    	@Override
    	public List<Event> visitEvent(Event e) {
    		return Collections.singletonList(e);
    	};

    	@Override
    	public List<Event> visitCreate(Create e) {

            Store store = newStore(e.getAddress(), e.getMemValue(), e.getMo(), e.getCLine());
            store.addFilters(C11.PTHREAD);

            return eventSequence(
                    store
            );
    	}

    	@Override
    	public List<Event> visitEnd(End e) {
            return eventSequence(
                    newStore(e.getAddress(), IConst.ZERO, e.getMo())
            );
    	}

    	@Override
    	public List<Event> visitInitLock(InitLock e) {
    		return eventSequence(
                    newStore(e.getAddress(), e.getMemValue(), e.getMo())
            );
    	}

    	@Override
    	public List<Event> visitJoin(Join e) {
            Register resultRegister = e.getResultRegister();
    		Load load = newLoad(resultRegister, e.getAddress(), e.getMo());
            load.addFilters(C11.PTHREAD);
            
            return eventSequence(
            		load,
            		newJumpUnless(new Atom(resultRegister, EQ, IConst.ZERO), e.getLabel())
            );
    	}

    	@Override
    	public List<Event> visitLock(Lock e) {
            Register resultRegister = e.getResultRegister();
    		IExpr address = e.getAddress();
    		String mo = e.getMo();
    		
			List<Event> events = eventSequence(
                    newLoad(resultRegister, address, mo),
                    newJump(new Atom(resultRegister, NEQ, IConst.ZERO), e.getLabel()),
                    newStore(address, IConst.ONE, mo)
            );
            
    		for(Event child : events) {
                child.addFilters(C11.LOCK, RMW);
            }
            
    		return events;
    	}

    	@Override
    	public List<Event> visitStart(Start e) {
            Register resultRegister = e.getResultRegister();

            return eventSequence(
            		newLoad(resultRegister, e.getAddress(), e.getMo()),
            		newJumpUnless(new Atom(resultRegister, EQ, IConst.ONE), e.getLabel())
            );
    	}

    	@Override
    	public List<Event> visitUnlock(Unlock e) {
            Register resultRegister = e.getResultRegister();
    		IExpr address = e.getAddress();
    		String mo = e.getMo();
    		
    		List<Event> events = eventSequence(
                    newLoad(resultRegister, address, mo),
                    newJump(new Atom(resultRegister, NEQ, IConst.ONE), e.getLabel()),
                    newStore(address, IConst.ZERO, mo)
            );
            
    		for(Event child : events) {
                child.addFilters(C11.LOCK, RMW);
            }
            
    		return events;
    	}

    	@Override
    	public List<Event> visitRMWAddUnless(RMWAddUnless e) {
            Register resultRegister = e.getResultRegister();
    		Register dummy = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
            RMWReadCondUnless load = Linux.newRMWReadCondUnless(dummy, e.getCmp(), e.getAddress(), Tag.Linux.MO_RELAXED);

            return eventSequence(
                    Linux.newConditionalMemoryBarrier(load),
                    load,
                    Linux.newRMWStoreCond(load, e.getAddress(), new IExprBin(dummy, IOpBin.PLUS, (IExpr) e.getMemValue()), Tag.Linux.MO_RELAXED),
                    newLocal(resultRegister, new Atom(dummy, COpBin.NEQ, e.getCmp())),
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
    		
            Register dummy = resultRegister;
            if(resultRegister == value || resultRegister == cmp){
                dummy = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
            }

            RMWReadCondCmp load = Linux.newRMWReadCondCmp(dummy, cmp, address, Tag.Linux.loadMO(mo));
            Local optionalUpdateReg = dummy != resultRegister ? newLocal(resultRegister, dummy) : null;
            Fence optionalMbBefore = mo.equals(Tag.Linux.MO_MB) ? Linux.newConditionalMemoryBarrier(load) : null;
            Fence optionalMbAfter = mo.equals(Tag.Linux.MO_MB) ? Linux.newConditionalMemoryBarrier(load) : null;

            return eventSequence(
                    optionalMbBefore,
                    load,
                    Linux.newRMWStoreCond(load, address, value, Tag.Linux.storeMO(mo)),
                    optionalUpdateReg,
                    optionalMbAfter
            );
    	}

    	@Override
    	public List<Event> visitRMWFetchOp(RMWFetchOp e) {
            Register resultRegister = e.getResultRegister();
            String mo = e.getMo();
            IExpr address = e.getAddress();
            ExprInterface value = e.getMemValue();

            Register dummy = resultRegister;
    		if(resultRegister == value){
                dummy = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
            }

    		Fence optionalMbBefore = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;
    		Load load = newRMWLoad(dummy, address, Tag.Linux.loadMO(mo));
            Local optionalUpdateReg = dummy != resultRegister ? newLocal(resultRegister, dummy) : null;
            Fence optionalMbAfter = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;

            return eventSequence(
                    optionalMbBefore,
                    load,
                    newRMWStore(load, address, new IExprBin(dummy, e.getOp(), (IExpr) value), Tag.Linux.storeMO(mo)),
                    optionalUpdateReg,
                    optionalMbAfter
            );
    	}

    	@Override
    	public List<Event> visitRMWOp(RMWOp e) {
            IExpr address = e.getAddress();
            Register resultRegister = e.getResultRegister();
    		
            Load load = newRMWLoad(resultRegister, address, Tag.Linux.MO_RELAXED);
            load.addFilters(Tag.Linux.NORETURN);
            
            return eventSequence(
                    load,
                    newRMWStore(load, address, new IExprBin(resultRegister, e.getOp(), (IExpr) e.getMemValue()), Tag.Linux.MO_RELAXED)
            );
    	}

    	@Override
    	public List<Event> visitRMWOpAndTest(RMWOpAndTest e) {
            Register resultRegister = e.getResultRegister();
            IExpr address = e.getAddress();
            int precision = resultRegister.getPrecision();
            
    		Register dummy = new Register(null, resultRegister.getThreadId(), precision);
    		Load load = newRMWLoad(dummy, address, Tag.Linux.MO_RELAXED);

            //TODO: Are the memory barriers really unconditional?
            return eventSequence(
                    Linux.newMemoryBarrier(),
                    load,
                    newLocal(dummy, new IExprBin(dummy, e.getOp(), (IExpr) e.getMemValue())),
                    newRMWStore(load, address, dummy, Tag.Linux.MO_RELAXED),
                    newLocal(resultRegister, new Atom(dummy, COpBin.EQ, new IConst(BigInteger.ZERO, precision))),
                    Linux.newMemoryBarrier()
            );
    	}

    	@Override
    	public List<Event> visitRMWOpReturn(RMWOpReturn e) {
            Register resultRegister = e.getResultRegister();
            IExpr address = e.getAddress();
            String mo = e.getMo();
            
    		Register dummy = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
    		Fence optionalMbBefore = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;
    		Load load = newRMWLoad(dummy, address, Tag.Linux.loadMO(mo));
            Fence optionalMbAfter = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;

            return eventSequence(
                    optionalMbBefore,
                    load,
                    newLocal(resultRegister, new IExprBin(dummy, e.getOp(), (IExpr) e.getMemValue())),
                    newRMWStore(load, address, resultRegister, Tag.Linux.storeMO(mo)),
                    optionalMbAfter
            );
    	}

    	@Override
    	public List<Event> visitRMWXchg(RMWXchg e) {
            Register resultRegister = e.getResultRegister();
            String mo = e.getMo();
            IExpr address = e.getAddress();

            Register dummy = resultRegister;
            if(resultRegister == e.getMemValue()){
                dummy = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
            }

    		Fence optionalMbBefore = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;
    		Load load = newRMWLoad(dummy, address, Tag.Linux.loadMO(mo));
            Local optionalUpdateReg = dummy != resultRegister ? newLocal(resultRegister, dummy) : null;
            Fence optionalMbAfter = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;

            return eventSequence(
                    optionalMbBefore,
                    load,
                    newRMWStore(load, address, e.getMemValue(), Tag.Linux.storeMO(mo)),
                    optionalUpdateReg,
                    optionalMbAfter
            );
    	}

    	@Override
    	public List<Event> visitAtomicAbstract(AtomicAbstract e) {
    		throw new UnsupportedOperationException("Compilation to " + target + 
    				" is not supported for " + getClass().getName());
    	}

    	@Override
    	public List<Event> visitAtomicCmpXchg(AtomicCmpXchg e) {
    		Register resultRegister = e.getResultRegister();
    		IExpr address = e.getAddress();
    		String mo = e.getMo();
    		IExpr expectedAddr = e.getExpectedAddr();
            int threadId = resultRegister.getThreadId();
    		int precision = resultRegister.getPrecision();

    		Register regExpected = new Register(null, threadId, precision);
            Register regValue = new Register(null, threadId, precision);
            Load loadExpected = newLoad(regExpected, expectedAddr, null);
            Store storeExpected = newStore(expectedAddr, regValue, null);
            Label casFail = newLabel("CAS_fail");
            Label casEnd = newLabel("CAS_end");
            Local casCmpResult = newLocal(resultRegister, new Atom(regValue, EQ, regExpected));
            CondJump branchOnCasCmpResult = newJump(new Atom(resultRegister, NEQ, IConst.ONE), casFail);
            CondJump gotoCasEnd = newGoto(casEnd);
            Load loadValue = newRMWLoad(regValue, address, mo);
            Store storeValue = newRMWStore(loadValue, address, e.getMemValue(), mo);

            return eventSequence(
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
            );
    	}

    	@Override
    	public List<Event> visitAtomicFetchOp(AtomicFetchOp e) {
    		Register resultRegister = e.getResultRegister();
    		IOpBin op = e.getOp();
    		IExpr address = e.getAddress();
    		String mo = e.getMo();
    		
            Register dummyReg = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
            Load load = newRMWLoad(resultRegister, address, mo);

            return eventSequence(
                    load,
                    newLocal(dummyReg, new IExprBin(resultRegister, op, (IExpr) e.getMemValue())),
                    newRMWStore(load, address, dummyReg, mo)
            );
    	}

    	@Override
    	public List<Event> visitAtomicLoad(AtomicLoad e) {
            return eventSequence(
            		newLoad(e.getResultRegister(), e.getAddress(), e.getMo())
            );
    	}

    	@Override
    	public List<Event> visitAtomicStore(AtomicStore e) {
            return eventSequence(
            		newStore(e.getAddress(), e.getMemValue(), e.getMo())
            );
    	}

    	@Override
    	public List<Event> visitAtomicThreadFence(AtomicThreadFence e) {
            return Collections.emptyList();
    	}

    	@Override
    	public List<Event> visitAtomicXchg(AtomicXchg e) {
    		IExpr address = e.getAddress();
    		String mo = e.getMo();

            Load load = newRMWLoad(e.getResultRegister(), address, mo);
            
            return eventSequence(
                    load,
                    newRMWStore(load, address, e.getMemValue(), mo)
            );
    	}

    	@Override
    	public List<Event> visitDat3mCAS(Dat3mCAS e) {
    		Register resultRegister = e.getResultRegister();
    		ExprInterface value = e.getMemValue();
    		IExpr address = e.getAddress();
    		String mo = e.getMo();
    		ExprInterface expectedValue = e.getExpectedValue();

            Register regValue = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
            Local casCmpResult = newLocal(resultRegister, new Atom(regValue, EQ, expectedValue));
            Label casEnd = newLabel("CAS_end");
            CondJump branchOnCasCmpResult = newJump(new Atom(resultRegister, NEQ, IConst.ONE), casEnd);

            Load load = newRMWLoad(regValue, address, mo);
            Store store = newRMWStore(load, address, value, mo);

            return eventSequence(
                    // Indentation shows the branching structure
                    load,
                    casCmpResult,
                    branchOnCasCmpResult,
                        store,
                    casEnd
            );
    	}
    }
    
    private class VisitorTSO implements EventVisitor<List<Event>> {

    	@Override
    	public List<Event> visitEvent(Event e) {
    		return Collections.singletonList(e);
    	};

    	@Override
    	public List<Event> visitCreate(Create e) {
            Store store = newStore(e.getAddress(), e.getMemValue(), e.getMo(), e.getCLine());
            store.addFilters(C11.PTHREAD);
            
            return eventSequence(
                    store,
                    X86.newMemoryFence()
            );
    	}

    	@Override
    	public List<Event> visitEnd(End e) {
            return eventSequence(
            		newStore(e.getAddress(), IConst.ZERO, e.getMo()),
                    X86.newMemoryFence()
            );
    	}

    	@Override
    	public List<Event> visitInitLock(InitLock e) {
    		return eventSequence(
                    newStore(e.getAddress(), e.getMemValue(), e.getMo())
            );
    	}

    	@Override
    	public List<Event> visitJoin(Join e) {
            Register resultRegister = e.getResultRegister();
    		Load load = newLoad(resultRegister, e.getAddress(), e.getMo());
            load.addFilters(C11.PTHREAD);
            
            return eventSequence(
            		load,
            		newJumpUnless(new Atom(resultRegister, EQ, IConst.ZERO), e.getLabel())
            );
    	}

    	@Override
    	public List<Event> visitLock(Lock e) {
            Register resultRegister = e.getResultRegister();
    		String mo = e.getMo();
    		
    		List<Event> events = eventSequence(
                    newLoad(resultRegister, e.getAddress(), mo),
                    newJump(new Atom(resultRegister, NEQ, IConst.ZERO), e.getLabel()),
                    newStore(e.getAddress(), IConst.ONE, mo)
            );
            
    		for(Event child : events) {
                child.addFilters(C11.LOCK, RMW);
            }
            
    		return events;
    	}

    	@Override
    	public List<Event> visitStart(Start e) {
            Register resultRegister = e.getResultRegister();

            return eventSequence(
            		newLoad(resultRegister, e.getAddress(), e.getMo()),
            		newJumpUnless(new Atom(resultRegister, EQ, IConst.ONE), e.getLabel())
            );
    	}

    	@Override
    	public List<Event> visitUnlock(Unlock e) {
            Register resultRegister = e.getResultRegister();
    		IExpr address = e.getAddress();
    		String mo = e.getMo();
    		
    		List<Event> events = eventSequence(
                    newLoad(resultRegister, address, mo),
                    newJump(new Atom(resultRegister, NEQ, IConst.ONE), e.getLabel()),
                    newStore(address, IConst.ZERO, mo)
            );
            
    		for(Event child : events) {
                child.addFilters(C11.LOCK, RMW);
            }
            
    		return events;
    	}

    	@Override
    	public List<Event> visitXchg(Xchg e) {
            Register resultRegister = e.getResultRegister();
            IExpr address = e.getAddress();

            Register dummyReg = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
    		Load load = newRMWLoad(dummyReg, address, null);
            load.addFilters(Tag.TSO.ATOM);

            RMWStore store = newRMWStore(load, address, resultRegister, null);
            store.addFilters(Tag.TSO.ATOM);

            return eventSequence(
                    load,
                    store,
                    newLocal(resultRegister, dummyReg)
            );
    	}

    	@Override
    	public List<Event> visitAtomicAbstract(AtomicAbstract e) {
    		throw new UnsupportedOperationException("Compilation to " + target + 
    				" is not supported for " + getClass().getName());
    	}

    	@Override
    	public List<Event> visitAtomicCmpXchg(AtomicCmpXchg e) {
    		Register resultRegister = e.getResultRegister();
    		IExpr address = e.getAddress();
    		ExprInterface value = e.getMemValue();
    		String mo = e.getMo();
    		IExpr expectedAddr = e.getExpectedAddr();
            int threadId = resultRegister.getThreadId();
    		int precision = resultRegister.getPrecision();

    		List<Event> events;

    		Register regExpected = new Register(null, threadId, precision);
            Load loadExpected = newLoad(regExpected, expectedAddr, null);
            Register regValue = new Register(null, threadId, precision);
            Load loadValue = newRMWLoad(regValue, address, mo);
            Local casCmpResult = newLocal(resultRegister, new Atom(regValue, EQ, regExpected));
            Label casFail = newLabel("CAS_fail");
            CondJump branchOnCasCmpResult = newJump(new Atom(resultRegister, NEQ, IConst.ONE), casFail);
            Store storeValue = newRMWStore(loadValue, address, value, mo);
            Label casEnd = newLabel("CAS_end");
            CondJump gotoCasEnd = newGoto(casEnd);
            Store storeExpected = newStore(expectedAddr, regValue, null);

            events = eventSequence(
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
            );

            return events;
    	}

    	@Override
    	public List<Event> visitAtomicFetchOp(AtomicFetchOp e) {
    		Register resultRegister = e.getResultRegister();
    		IExpr address = e.getAddress();
    		String mo = e.getMo();
    		
            Register dummyReg = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
            Load load = newRMWLoad(resultRegister, address, mo);
            
            return eventSequence(
                    load,
                    newLocal(dummyReg, new IExprBin(resultRegister, e.getOp(), (IExpr)e.getMemValue())),
                    newRMWStore(load, address, dummyReg, mo)
            );
    	}

    	@Override
    	public List<Event> visitAtomicLoad(AtomicLoad e) {
            return eventSequence(
            		newLoad(e.getResultRegister(), e.getAddress(), e.getMo())
            );
    	}

    	@Override
    	public List<Event> visitAtomicStore(AtomicStore e) {
    		String mo = e.getMo();

            Fence optionalMFence = mo.equals(Tag.C11.MO_SC) ? X86.newMemoryFence() : null;

            return eventSequence(
            		newStore(e.getAddress(), e.getMemValue(), mo),
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
    		IExpr address = e.getAddress();
    		String mo = e.getMo();

            Load load = newRMWLoad(e.getResultRegister(), address, mo);

            return eventSequence(
                    load,
                    newRMWStore(load, address, e.getMemValue(), mo)
            );
    	}

    	@Override
    	public List<Event> visitDat3mCAS(Dat3mCAS e) {
    		Register resultRegister = e.getResultRegister();
    		IExpr address = e.getAddress();
    		String mo = e.getMo();

            Register regValue = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
            Local casCmpResult = newLocal(resultRegister, new Atom(regValue, EQ, e.getExpectedValue()));
            Label casEnd = newLabel("CAS_end");
            CondJump branchOnCasCmpResult = newJump(new Atom(resultRegister, NEQ, IConst.ONE), casEnd);
            Load load = newRMWLoad(regValue, address, mo);
            Store store = newRMWStore(load, address, e.getMemValue(), mo);

            return eventSequence(
                    // Indentation shows the branching structure
                    load,
                    casCmpResult,
                    branchOnCasCmpResult,
                        store,
                    casEnd
            );
    	}
    }
    
    private class VisitorPower implements EventVisitor<List<Event>> {

    	@Override
    	public List<Event> visitEvent(Event e) {
    		return Collections.singletonList(e);
    	};

    	@Override
    	public List<Event> visitCreate(Create e) {
            Store store = newStore(e.getAddress(), e.getMemValue(), e.getMo(), e.getCLine());
            store.addFilters(C11.PTHREAD);

            return eventSequence(
                    store,
                    Power.newSyncBarrier()
            );
    	}

    	@Override
    	public List<Event> visitEnd(End e) {
            return eventSequence(
            		Power.newSyncBarrier(),
            		newStore(e.getAddress(), IConst.ZERO, e.getMo())
            );
    	}

    	@Override
    	public List<Event> visitInitLock(InitLock e) {
    		return eventSequence(
                    newStore(e.getAddress(), e.getMemValue(), e.getMo())
            );
    	}

    	@Override
    	public List<Event> visitJoin(Join e) {
            List<Event> events = new ArrayList<>();
            Register resultRegister = e.getResultRegister();
    		Load load = newLoad(resultRegister, e.getAddress(), e.getMo());
            load.addFilters(C11.PTHREAD);
            events.add(load);
            Label label = newLabel("Jump_" + e.getOId());
            events.addAll(eventSequence(
                    newFakeCtrlDep(resultRegister, label),
                    label,
                    Power.newISyncBarrier()
            ));
            events.add(newJumpUnless(new Atom(resultRegister, EQ, IConst.ZERO), e.getLabel()));
            
            return events;
    	}

    	@Override
    	public List<Event> visitLock(Lock e) {
            Register resultRegister = e.getResultRegister();
    		String mo = e.getMo();
    		
    		List<Event> events = eventSequence(
                    newLoad(resultRegister, e.getAddress(), mo),
                    newJump(new Atom(resultRegister, NEQ, IConst.ZERO), e.getLabel()),
                    newStore(e.getAddress(), IConst.ONE, mo)
            );
            
    		for(Event child : events) {
                child.addFilters(C11.LOCK, RMW);
            }
            
    		return events;
    	}

    	@Override
    	public List<Event> visitStart(Start e) {
            List<Event> events = new ArrayList<>();
            Register resultRegister = e.getResultRegister();
    		Load load = newLoad(resultRegister, e.getAddress(), e.getMo());
            events.add(load);
            Label label = newLabel("Jump_" + e.getOId());
            events.addAll(eventSequence(
                    newFakeCtrlDep(resultRegister, label),
                    label,
                    Power.newISyncBarrier()
            ));
            events.add(newJumpUnless(new Atom(resultRegister, EQ, IConst.ONE), e.getLabel()));
            
            return events;
    	}

    	@Override
    	public List<Event> visitUnlock(Unlock e) {
            Register resultRegister = e.getResultRegister();
    		IExpr address = e.getAddress();
    		String mo = e.getMo();
    		
    		List<Event> events = eventSequence(
                    newLoad(resultRegister, address, mo),
                    newJump(new Atom(resultRegister, NEQ, IConst.ONE), e.getLabel()),
                    newStore(address, IConst.ZERO, mo)
            );
            
    		for(Event child : events) {
                child.addFilters(C11.LOCK, RMW);
            }
            
    		return events;
    	}

    	@Override
    	public List<Event> visitAtomicAbstract(AtomicAbstract e) {
    		throw new UnsupportedOperationException("Compilation to " + target + 
    				" is not supported for " + getClass().getName());
    	}

    	@Override
    	public List<Event> visitAtomicCmpXchg(AtomicCmpXchg e) {
    		Register resultRegister = e.getResultRegister();
    		IExpr address = e.getAddress();
    		ExprInterface value = e.getMemValue();
    		String mo = e.getMo();
    		IExpr expectedAddr = e.getExpectedAddr();
            int threadId = resultRegister.getThreadId();
    		int precision = resultRegister.getPrecision();

    		Register regExpected = new Register(null, threadId, precision);
            Register regValue = new Register(null, threadId, precision);
            Load loadExpected = newLoad(regExpected, expectedAddr, null);
            Store storeExpected = newStore(expectedAddr, regValue, null);
            Label casFail = newLabel("CAS_fail");
            Label casEnd = newLabel("CAS_end");
            Local casCmpResult = newLocal(resultRegister, new Atom(regValue, EQ, regExpected));
            CondJump branchOnCasCmpResult = newJump(new Atom(resultRegister, NEQ, IConst.ONE), casFail);
            CondJump gotoCasEnd = newGoto(casEnd);

            // Power does not have mo tags, thus we use null
            Load loadValue = newRMWLoadExclusive(regValue, address, null);
            Store storeValue = newRMWStoreExclusive(address, value, null, e.is(STRONG));
            ExecutionStatus optionalExecStatus = null;
            Local optionalUpdateCasCmpResult = null;
            if (!e.is(STRONG)) {
                Register statusReg = new Register("status(" + e.getOId() + ")", threadId, precision);
                optionalExecStatus = newExecutionStatus(statusReg, storeValue);
                optionalUpdateCasCmpResult = newLocal(resultRegister, new BExprUn(BOpUn.NOT, statusReg));
            }

            Fence optionalMemoryBarrier = mo.equals(Tag.C11.MO_SC) ? Power.newSyncBarrier()
                    : mo.equals(C11.MO_RELEASE) || mo.equals(C11.MO_ACQUIRE_RELEASE) ? Power.newLwSyncBarrier()
                    : null;
            Fence optionalISyncBarrier = mo.equals(C11.MO_SC) || mo.equals(C11.MO_ACQUIRE) || mo.equals(C11.MO_ACQUIRE_RELEASE) ? Power.newISyncBarrier() : null;

            return eventSequence(
                    // Indentation shows the branching structure
                    optionalMemoryBarrier,
                    loadExpected,
                    loadValue,
                    casCmpResult,
                    branchOnCasCmpResult,
                        storeValue,
                        optionalExecStatus,
                        optionalUpdateCasCmpResult,
                        gotoCasEnd,
                    casFail,
                        storeExpected,
                    casEnd,
                    optionalISyncBarrier
            );
    	}

    	@Override
    	public List<Event> visitAtomicFetchOp(AtomicFetchOp e) {
    		Register resultRegister = e.getResultRegister();
    		IOpBin op = e.getOp();
    		IExpr value = (IExpr) e.getMemValue();
    		IExpr address = e.getAddress();
    		String mo = e.getMo();
    		
            Register dummyReg = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
            Local localOp = newLocal(dummyReg, new IExprBin(resultRegister, op, value));

            // Power does not have mo tags, thus we use null
            Load load = newRMWLoadExclusive(resultRegister, address, null);
            Store store = newRMWStoreExclusive(address, dummyReg, null, true);
            Label label = newLabel("FakeDep");
            Event fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

            Fence optionalMemoryBarrier = null;
            // Academics papers normally say an isync barrier is enough
            // However this makes benchmark linuxrwlocks.c fail
            // Additionally, power compilers in godbolt.org use a lwsync
            Fence optionalISyncBarrier = mo.equals(C11.MO_SC) || mo.equals(C11.MO_ACQUIRE) || mo.equals(C11.MO_ACQUIRE_RELEASE) ? Power.newLwSyncBarrier() : null;
            optionalMemoryBarrier = mo.equals(Tag.C11.MO_SC) ? Power.newSyncBarrier()
                    : mo.equals(C11.MO_RELEASE) || mo.equals(C11.MO_ACQUIRE_RELEASE) ? Power.newLwSyncBarrier()
                    : null;

            return eventSequence(
                    optionalMemoryBarrier,
                    load,
                    fakeCtrlDep,
                    label,
                    localOp,
                    store,
                    optionalISyncBarrier
            );
    	}

    	@Override
    	public List<Event> visitAtomicLoad(AtomicLoad e) {
    		Register resultRegister = e.getResultRegister();
    		IExpr address = e.getAddress();
    		String mo = e.getMo();
    		
            Load load = newLoad(resultRegister, address, mo);
            Fence optionalMemoryBarrier = mo.equals(Tag.C11.MO_SC) ? Power.newSyncBarrier() : null;
            Label optionalLabel =
                    (mo.equals(Tag.C11.MO_SC) || mo.equals(Tag.C11.MO_ACQUIRE) || mo.equals(Tag.C11.MO_RELAXED)) ?
                            newLabel("FakeDep") :
                            null;
            CondJump optionalFakeCtrlDep =
                    (mo.equals(Tag.C11.MO_SC) || mo.equals(Tag.C11.MO_ACQUIRE) || mo.equals(Tag.C11.MO_RELAXED)) ?
                            newFakeCtrlDep(resultRegister, optionalLabel) :
                            null;
            Fence optionalISyncBarrier =
                    (mo.equals(Tag.C11.MO_SC) || mo.equals(Tag.C11.MO_ACQUIRE)) ?
                            Power.newISyncBarrier() :
                            null;
            
            return eventSequence(
                    optionalMemoryBarrier,
                    load,
                    optionalFakeCtrlDep,
                    optionalLabel,
                    optionalISyncBarrier
            );
    	}

    	@Override
    	public List<Event> visitAtomicStore(AtomicStore e) {
    		ExprInterface value = e.getMemValue();
    		IExpr address = e.getAddress();
    		String mo = e.getMo();

            Store store = newStore(address, value, mo);
            Fence optionalMemoryBarrier = mo.equals(Tag.C11.MO_SC) ? Power.newSyncBarrier()
                    : mo.equals(Tag.C11.MO_RELEASE) ? Power.newLwSyncBarrier() : null;
            
            return eventSequence(
                    optionalMemoryBarrier,
                    store
            );
    	}

    	@Override
    	public List<Event> visitAtomicThreadFence(AtomicThreadFence e) {
    		String mo = e.getMo();
            Fence fence = mo.equals(Tag.C11.MO_ACQUIRE) || mo.equals(Tag.C11.MO_RELEASE) || mo.equals(Tag.C11.MO_ACQUIRE_RELEASE) || mo.equals(Tag.C11.MO_SC) ?
                            Power.newLwSyncBarrier() : null;

            return eventSequence(
                    fence
            );
    	}

    	@Override
    	public List<Event> visitAtomicXchg(AtomicXchg e) {
    		Register resultRegister = e.getResultRegister();
    		ExprInterface value = e.getMemValue();
    		IExpr address = e.getAddress();
    		String mo = e.getMo();

            // Power does not have mo tags, thus we use null
            Load load = newRMWLoadExclusive(resultRegister, address, null);
            Store store = newRMWStoreExclusive(address, value, null, true);
            Label label = newLabel("FakeDep");
            Event fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

            Fence optionalMemoryBarrier = mo.equals(Tag.C11.MO_SC) ? Power.newSyncBarrier()
                    : mo.equals(C11.MO_RELEASE) || mo.equals(C11.MO_ACQUIRE_RELEASE) ? Power.newLwSyncBarrier()
                    : null;

            Fence optionalISyncBarrier = mo.equals(C11.MO_SC) || mo.equals(C11.MO_ACQUIRE) || mo.equals(C11.MO_ACQUIRE_RELEASE) ? Power.newISyncBarrier() : null;

            return eventSequence(
                    optionalMemoryBarrier,
                    load,
                    fakeCtrlDep,
                    label,
                    store,
                    optionalISyncBarrier
            );
    	}

    	@Override
    	public List<Event> visitDat3mCAS(Dat3mCAS e) {
    		Register resultRegister = e.getResultRegister();
    		ExprInterface value = e.getMemValue();
    		IExpr address = e.getAddress();
    		String mo = e.getMo();
    		ExprInterface expectedValue = e.getExpectedValue();

            Register regValue = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
            Local casCmpResult = newLocal(resultRegister, new Atom(regValue, EQ, expectedValue));
            Label casEnd = newLabel("CAS_end");
            CondJump branchOnCasCmpResult = newJump(new Atom(resultRegister, NEQ, IConst.ONE), casEnd);
            Load load = newRMWLoadExclusive(regValue, address, null);
            Store store = newRMWStoreExclusive(address, value, null, true);

            Fence optionalMemoryBarrier = mo.equals(Tag.C11.MO_SC) ? Power.newSyncBarrier()
                    : mo.equals(C11.MO_RELEASE) || mo.equals(C11.MO_ACQUIRE_RELEASE) ? Power.newLwSyncBarrier()
                    : null;
            Fence optionalISyncBarrier = mo.equals(C11.MO_SC) || mo.equals(C11.MO_ACQUIRE) || mo.equals(C11.MO_ACQUIRE_RELEASE) ? Power.newISyncBarrier() : null;
            
            // --- Add success events ---
            return eventSequence(
                    // Indentation shows the branching structure
                    optionalMemoryBarrier,
                    load,
                    casCmpResult,
                    branchOnCasCmpResult,
                        store,
                    optionalISyncBarrier,
                    casEnd
            );
    	}
    }
}