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
import com.dat3m.dartagnan.program.event.lang.linux.cond.RMWStoreCond;
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

import static com.dat3m.dartagnan.configuration.Arch.POWER;
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
        Event pred = thread.getEntry();
        Event toBeCompiled = pred.getSuccessor();
        pred.setCId(nextId++);

        while (toBeCompiled != null) {
            List<Event> compiledEvents = toBeCompiled.accept(new Visitor(target));
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

    private class Visitor implements EventVisitor<List<Event>> {

    	private final Arch target;
    	
    	public Visitor(Arch target) {
        	Preconditions.checkNotNull(target, "Target cannot be null");
    		this.target = target;
    	}
    	
    	@Override
    	public List<Event> visit(Event e) {
    		return Collections.singletonList(e);
    	};

    	@Override
    	public List<Event> visit(CondJump e) {
        	Preconditions.checkState(e.getSuccessor() != null, "Malformed CondJump event");
    		return visit((Event)e);
    	}

    	@Override
    	public List<Event> visit(Create e) {

            Fence optionalBarrierBefore = null;
            Fence optionalBarrierAfter = null;
            Store store = newStore(e.getAddress(), e.getMemValue(), e.getMo(), e.getCLine());
            store.addFilters(C11.PTHREAD);

            switch (target){
                case NONE:
                    break;
                case TSO:
                    optionalBarrierAfter = X86.newMemoryFence();
                    break;
                case POWER:
                    optionalBarrierBefore = Power.newSyncBarrier();
                    break;
                case ARM8:
                    optionalBarrierBefore = AArch64.DMB.newISHBarrier();
                    optionalBarrierAfter = AArch64.DMB.newISHBarrier();
                    break;
                default:
                    throw new UnsupportedOperationException("Compilation to " + target + 
                    		" is not supported for " + getClass().getName());

            }

            return eventSequence(
                    optionalBarrierBefore,
                    store,
                    optionalBarrierAfter
            );
    	}

    	@Override
    	public List<Event> visit(End e) {
        	
            Fence optionalBarrierBefore = null;
            Fence optionalBarrierAfter = null;
            Store store = newStore(e.getAddress(), IConst.ZERO, e.getMo());

            switch (target){
                case NONE:
                    break;
                case TSO:
                    optionalBarrierAfter = X86.newMemoryFence();
                    break;
                case POWER:
                    optionalBarrierBefore = Power.newSyncBarrier();
                    break;
                case ARM8:
                    optionalBarrierBefore = AArch64.DMB.newISHBarrier();
                    optionalBarrierAfter = AArch64.DMB.newISHBarrier();
                    break;
                default:
                    throw new UnsupportedOperationException("Compilation to " + target + 
                    		" is not supported for " + getClass().getName());

            }

            return eventSequence(
                    optionalBarrierBefore,
                    store,
                    optionalBarrierAfter
            );
    	}

    	@Override
    	public List<Event> visit(InitLock e) {
    		return eventSequence(
                    newStore(e.getAddress(), e.getMemValue(), e.getMo())
            );
    	}

    	@Override
    	public List<Event> visit(Join e) {

            List<Event> events = new ArrayList<>();
            Register resultRegister = e.getResultRegister();
    		Load load = newLoad(resultRegister, e.getAddress(), e.getMo());
            load.addFilters(C11.PTHREAD);
            events.add(load);

            switch (target) {
                case NONE: case TSO:
                    break;
                case POWER:
                    Label label = newLabel("Jump_" + e.getOId());
                    events.addAll(eventSequence(
                            newFakeCtrlDep(resultRegister, label),
                            label,
                            Power.newISyncBarrier()
                    ));
                    break;
                case ARM8:
                    events.add(AArch64.DMB.newISHBarrier());
                    break;
                default:
                    throw new UnsupportedOperationException("Compilation to " + target + 
                    		" is not supported for " + getClass().getName());

            }
            events.add(newJumpUnless(new Atom(resultRegister, EQ, IConst.ZERO), e.getLabel()));
            return events;
    	}

    	@Override
    	public List<Event> visit(Lock e) {

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
    	public List<Event> visit(Start e) {

            List<Event> events = new ArrayList<>();
            Register resultRegister = e.getResultRegister();
    		Load load = newLoad(resultRegister, e.getAddress(), e.getMo());
            events.add(load);

            switch (target) {
                case NONE:
                case TSO:
                    break;
                case POWER:
                    Label label = newLabel("Jump_" + e.getOId());
                    events.addAll(eventSequence(
                            newFakeCtrlDep(resultRegister, label),
                            label,
                            Power.newISyncBarrier()
                    ));
                    break;
                case ARM8:
                    events.add(AArch64.DMB.newISHBarrier());
                    break;
                default:
                    throw new UnsupportedOperationException("Compilation to " + target + 
                    		" is not supported for " + getClass().getName());

            }

            events.add(newJumpUnless(new Atom(resultRegister, EQ, IConst.ONE), e.getLabel()));
            return events;
    	}

    	@Override
    	public List<Event> visit(Unlock e) {

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
    	public List<Event> visit(StoreExclusive e) {
            Preconditions.checkArgument(target == Arch.ARM8, 
            		"Compilation to " + target + " is not supported for " + getClass().getName());

            RMWStoreExclusive store = newRMWStoreExclusive(e.getAddress(), e.getMemValue(), e.getMo());
            ExecutionStatus status = newExecutionStatus(e.getResultRegister(), store);
            
            return eventSequence(
                    store,
                    status
            );
    	}

    	@Override
    	public List<Event> visit(RMWAddUnless e) {
            Preconditions.checkArgument(target == Arch.NONE, 
            		"Compilation to " + target + " is not supported for " + getClass().getName());

            Register resultRegister = e.getResultRegister();
    		Register dummy = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
            RMWReadCondUnless load = Linux.newRMWReadCondUnless(dummy, e.getCmp(), e.getAddress(), Tag.Linux.MO_RELAXED);
            RMWStoreCond store = Linux.newRMWStoreCond(load, e.getAddress(), 
            		new IExprBin(dummy, IOpBin.PLUS, (IExpr) e.getMemValue()), Tag.Linux.MO_RELAXED);
            Local local = newLocal(resultRegister, new Atom(dummy, COpBin.NEQ, e.getCmp()));

            return eventSequence(
                    Linux.newConditionalMemoryBarrier(load),
                    load,
                    store,
                    local,
                    Linux.newConditionalMemoryBarrier(load)
            );
    	}

    	@Override
    	public List<Event> visit(RMWCmpXchg e) {
    		Preconditions.checkArgument(target == Arch.NONE, 
    				"Compilation to " + target + " is not supported for " + getClass().getName());

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
            RMWStoreCond store = Linux.newRMWStoreCond(load, address, value, Tag.Linux.storeMO(mo));
            Local optionalUpdateReg = dummy != resultRegister ? newLocal(resultRegister, dummy) : null;
            Fence optionalMbBefore = mo.equals(Tag.Linux.MO_MB) ? Linux.newConditionalMemoryBarrier(load) : null;
            Fence optionalMbAfter = mo.equals(Tag.Linux.MO_MB) ? Linux.newConditionalMemoryBarrier(load) : null;

            return eventSequence(
                    optionalMbBefore,
                    load,
                    store,
                    optionalUpdateReg,
                    optionalMbAfter
            );
    	}

    	@Override
    	public List<Event> visit(RMWFetchOp e) {
            Preconditions.checkArgument(target == Arch.NONE, 
            		"Compilation to " + target + " is not supported for " + getClass().getName());

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
            RMWStore store = newRMWStore(load, address, 
            		new IExprBin(dummy, e.getOp(), (IExpr) value), Tag.Linux.storeMO(mo));
            Local optionalUpdateReg = dummy != resultRegister ? newLocal(resultRegister, dummy) : null;
            Fence optionalMbAfter = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;

            return eventSequence(
                    optionalMbBefore,
                    load,
                    store,
                    optionalUpdateReg,
                    optionalMbAfter
            );
    	}

    	@Override
    	public List<Event> visit(RMWOp e) {
            Preconditions.checkArgument(target == Arch.NONE, 
            		"Compilation to " + target + " is not supported for " + getClass().getName());

            IExpr address = e.getAddress();
            Register resultRegister = e.getResultRegister();
    		
            Load load = newRMWLoad(resultRegister, address, Tag.Linux.MO_RELAXED);
            RMWStore store = newRMWStore(load, address, 
            		new IExprBin(resultRegister, e.getOp(), (IExpr) e.getMemValue()), Tag.Linux.MO_RELAXED);
            load.addFilters(Tag.Linux.NORETURN);
            
            return eventSequence(
                    load,
                    store
            );
    	}

    	@Override
    	public List<Event> visit(RMWOpAndTest e) {
            Preconditions.checkArgument(target == Arch.NONE, 
            		"Compilation to " + target + " is not supported for " + getClass().getName());

            Register resultRegister = e.getResultRegister();
            IExpr address = e.getAddress();
            int precision = resultRegister.getPrecision();
            
    		Register dummy = new Register(null, resultRegister.getThreadId(), precision);
    		Load load = newRMWLoad(dummy, address, Tag.Linux.MO_RELAXED);
            Local localOp = newLocal(dummy, new IExprBin(dummy, e.getOp(), (IExpr) e.getMemValue()));
            RMWStore store = newRMWStore(load, address, dummy, Tag.Linux.MO_RELAXED);
            Local test = newLocal(resultRegister, 
            		new Atom(dummy, COpBin.EQ, new IConst(BigInteger.ZERO, precision)));

            //TODO: Are the memory barriers really unconditional?
            return eventSequence(
                    Linux.newMemoryBarrier(),
                    load,
                    localOp,
                    store,
                    test,
                    Linux.newMemoryBarrier()
            );
    	}

    	@Override
    	public List<Event> visit(RMWOpReturn e) {
            Preconditions.checkArgument(target == Arch.NONE, 
            		"Compilation to " + target + " is not supported for " + getClass().getName());

            Register resultRegister = e.getResultRegister();
            IExpr address = e.getAddress();
            String mo = e.getMo();
            
    		Register dummy = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
    		Fence optionalMbBefore = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;
    		Load load = newRMWLoad(dummy, address, Tag.Linux.loadMO(mo));
            Local localOp = newLocal(resultRegister, new IExprBin(dummy, e.getOp(), (IExpr) e.getMemValue()));
            RMWStore store = newRMWStore(load, address, resultRegister, Tag.Linux.storeMO(mo));
            Fence optionalMbAfter = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;

            return eventSequence(
                    optionalMbBefore,
                    load,
                    localOp,
                    store,
                    optionalMbAfter
            );
    	}

    	@Override
    	public List<Event> visit(RMWXchg e) {
            Preconditions.checkArgument(target == Arch.NONE, "Compilation to " + target + 
            		" is not supported for " + getClass().getName());

            Register resultRegister = e.getResultRegister();
            String mo = e.getMo();
            IExpr address = e.getAddress();

            Register dummy = resultRegister;
            if(resultRegister == e.getMemValue()){
                dummy = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
            }

    		Fence optionalMbBefore = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;
    		Load load = newRMWLoad(dummy, address, Tag.Linux.loadMO(mo));
            RMWStore store = newRMWStore(load, address, e.getMemValue(), Tag.Linux.storeMO(mo));
            Local optionalUpdateReg = dummy != resultRegister ? newLocal(resultRegister, dummy) : null;
            Fence optionalMbAfter = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;

            return eventSequence(
                    optionalMbBefore,
                    load,
                    store,
                    optionalUpdateReg,
                    optionalMbAfter
            );
    	}

    	@Override
    	public List<Event> visit(Xchg e) {
            Preconditions.checkArgument(target == Arch.TSO, "Compilation to " + target + 
            		" is not supported for " + getClass().getName());
            
            Register resultRegister = e.getResultRegister();
            IExpr address = e.getAddress();

            Register dummyReg = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
    		Load load = newRMWLoad(dummyReg, address, null);
            load.addFilters(Tag.TSO.ATOM);

            RMWStore store = newRMWStore(load, address, resultRegister, null);
            store.addFilters(Tag.TSO.ATOM);

            Local updateReg = newLocal(resultRegister, dummyReg);

            return eventSequence(
                    load,
                    store,
                    updateReg
            );
    	}

    	@Override
    	public List<Event> visit(AtomicAbstract e) {
    		throw new UnsupportedOperationException("Compilation to " + target + 
    				" is not supported for " + getClass().getName());
    	}

    	@Override
    	public List<Event> visit(AtomicCmpXchg e) {
    		Register resultRegister = e.getResultRegister();
    		IExpr address = e.getAddress();
    		ExprInterface value = e.getMemValue();
    		String mo = e.getMo();
    		IExpr expectedAddr = e.getExpectedAddr();
            int threadId = resultRegister.getThreadId();
    		int precision = resultRegister.getPrecision();

    		List<Event> events;

            // These events are common to all compilation schemes.
            // The difference of each architecture lies in the used Store/Load to/from <address>
            // and the fences that get inserted
    		Register regExpected = new Register(null, threadId, precision);
            Register regValue = new Register(null, threadId, precision);
            Load loadExpected = newLoad(regExpected, expectedAddr, null);
            Store storeExpected = newStore(expectedAddr, regValue, null);
            Label casFail = newLabel("CAS_fail");
            Label casEnd = newLabel("CAS_end");
            Local casCmpResult = newLocal(resultRegister, new Atom(regValue, EQ, regExpected));
            CondJump branchOnCasCmpResult = newJump(new Atom(resultRegister, NEQ, IConst.ONE), casFail);
            CondJump gotoCasEnd = newGoto(casEnd);

            switch(target) {
                case NONE:
                case TSO: {
                    Load loadValue = newRMWLoad(regValue, address, mo);
                    Store storeValue = newRMWStore(loadValue, address, value, mo);

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
                    break;
                }
                case POWER:
                case ARM8: {
                    String loadMo = Tag.ARMv8.extractLoadMoFromCMo(mo);
                    String storeMo = Tag.ARMv8.extractStoreMoFromCMo(mo);

                    Load loadValue = newRMWLoadExclusive(regValue, address, loadMo);
                    Store storeValue = newRMWStoreExclusive(address, value, storeMo, e.is(STRONG));
                    ExecutionStatus optionalExecStatus = null;
                    Local optionalUpdateCasCmpResult = null;
                    if (!e.is(STRONG)) {
                        Register statusReg = new Register("status(" + e.getOId() + ")", threadId, precision);
                        optionalExecStatus = newExecutionStatus(statusReg, storeValue);
                        optionalUpdateCasCmpResult = newLocal(resultRegister, new BExprUn(BOpUn.NOT, statusReg));
                    }

                    // --- Add Fence before under POWER ---
                    Fence optionalMemoryBarrier = null;
                    // if mo.equals(SC) then loadMo.equals(ACQ)
                    Fence optionalISyncBarrier = (target.equals(POWER) && loadMo.equals(Tag.ARMv8.MO_ACQ)) ? Power.newISyncBarrier() : null;
                    if(target.equals(POWER)) {
                        optionalMemoryBarrier = mo.equals(Tag.C11.MO_SC) ? Power.newSyncBarrier()
                                // if mo.equals(SC) then storeMo.equals(REL)
                                : storeMo.equals(Tag.ARMv8.MO_REL) ? Power.newLwSyncBarrier()
                                : null;
                    }

                    events = eventSequence(
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

                    break;
                }
                default:
                    throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + getClass().getName());
            }
            return events;
    	}

    	@Override
    	public List<Event> visit(AtomicFetchOp e) {
    		Register resultRegister = e.getResultRegister();
    		IOpBin op = e.getOp();
    		IExpr value = (IExpr) e.getMemValue();
    		IExpr address = e.getAddress();
    		String mo = e.getMo();
    		
            Register dummyReg = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
            Local localOp = newLocal(dummyReg, new IExprBin(resultRegister, op, value));
            List<Event> events;

            switch(target) {
                case NONE: case TSO: {
                    Load load = newRMWLoad(resultRegister, address, mo);
                    Store store = newRMWStore(load, address, dummyReg, mo);
                    events = eventSequence(
                            load,
                            localOp,
                            store
                    );
                    break;
                }
                case POWER:
                case ARM8:
                    String loadMo = Tag.ARMv8.extractLoadMoFromCMo(mo);
                    String storeMo = Tag.ARMv8.extractStoreMoFromCMo(mo);

                    Load load = newRMWLoadExclusive(resultRegister, address, loadMo);
                    Store store = newRMWStoreExclusive(address, dummyReg, storeMo, true);
                    Label label = newLabel("FakeDep");
                    Event fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

                    // Extra fences for POWER
                    Fence optionalMemoryBarrier = null;
                    // Academics papers normally say an isync barrier is enough
                    // However this makes benchmark linuxrwlocks.c fail
                    // Additionally, power compilers in godbolt.org use a lwsync
                    Fence optionalISyncBarrier = (target.equals(POWER) && loadMo.equals(Tag.ARMv8.MO_ACQ)) ? Power.newLwSyncBarrier() : null;
                    if(target.equals(POWER)) {
                        optionalMemoryBarrier = mo.equals(Tag.C11.MO_SC) ? Power.newSyncBarrier()
                                : storeMo.equals(Tag.ARMv8.MO_REL) ? Power.newLwSyncBarrier()
                                : null;
                    }

                    // All events for POWER and ARM8
                    events = eventSequence(
                            optionalMemoryBarrier,
                            load,
                            fakeCtrlDep,
                            label,
                            localOp,
                            store,
                            optionalISyncBarrier
                    );
                    break;
                default:
                    String tag = mo != null ? "_explicit" : "";
                    throw new UnsupportedOperationException("Compilation of atomic_fetch_" + op.toLinuxName() + tag + " is not implemented for " + target);
            }
            return events;
    	}

    	@Override
    	public List<Event> visit(AtomicLoad e) {
    		Register resultRegister = e.getResultRegister();
    		IExpr address = e.getAddress();
    		String mo = e.getMo();
    		
            List<Event> events;
            Load load = newLoad(resultRegister, address, mo);

            switch (target) {
                case NONE:
                case TSO:
                    events = eventSequence(
                            load
                    );
                    break;
                case POWER: {
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
                    events = eventSequence(
                            optionalMemoryBarrier,
                            load,
                            optionalFakeCtrlDep,
                            optionalLabel,
                            optionalISyncBarrier
                    );
                    break;
                }
                case ARM8:
                    String loadMo = Tag.ARMv8.extractLoadMoFromCMo(mo);
                    events = eventSequence(
                            newLoad(resultRegister, address, loadMo)
                    );
                    break;
                default:
                    throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + getClass().getName());
            }
            return events;
    	}

    	@Override
    	public List<Event> visit(AtomicStore e) {
    		ExprInterface value = e.getMemValue();
    		IExpr address = e.getAddress();
    		String mo = e.getMo();

            List<Event> events;
            Store store = newStore(address, value, mo);
            switch (target){
                case NONE:
                    events = eventSequence(
                            store
                    );
                    break;
                case TSO:
                    Fence optionalMFence = mo.equals(Tag.C11.MO_SC) ? X86.newMemoryFence() : null;
                    events = eventSequence(
                            store,
                            optionalMFence
                    );
                    break;
                case POWER:
                    Fence optionalMemoryBarrier = mo.equals(Tag.C11.MO_SC) ? Power.newSyncBarrier()
                            : mo.equals(Tag.C11.MO_RELEASE) ? Power.newLwSyncBarrier() : null;
                    events = eventSequence(
                            optionalMemoryBarrier,
                            store
                    );
                    break;
                case ARM8:
                    String storeMo = Tag.ARMv8.extractStoreMoFromCMo(mo);
                    events = eventSequence(
                            newStore(address, value, storeMo)
                    );
                    break;
                default:
                    throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + getClass().getName());
            }
            return events;
    	}

    	@Override
    	public List<Event> visit(AtomicThreadFence e) {
    		String mo = e.getMo();
            Fence fence = null;
            switch (target) {
                case NONE:
                    break;
                case TSO:
                    fence = mo.equals(Tag.C11.MO_SC) ? X86.newMemoryFence() : null;
                    break;
                case POWER:
                    fence = mo.equals(Tag.C11.MO_ACQUIRE) || mo.equals(Tag.C11.MO_RELEASE) || mo.equals(Tag.C11.MO_ACQUIRE_RELEASE) || mo.equals(Tag.C11.MO_SC) ?
                            Power.newLwSyncBarrier() : null;
                    break;
                case ARM8:
                    fence = mo.equals(Tag.C11.MO_RELEASE) || mo.equals(Tag.C11.MO_ACQUIRE_RELEASE) || mo.equals(Tag.C11.MO_SC) ? AArch64.DMB.newISHBarrier()
                            : mo.equals(Tag.C11.MO_ACQUIRE) ? AArch64.DSB.newISHLDBarrier() : null;
                    break;
                default:
                    throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + getClass().getName());
            }
            return eventSequence(
                    fence
            );
    	}

    	@Override
    	public List<Event> visit(AtomicXchg e) {
    		Register resultRegister = e.getResultRegister();
    		ExprInterface value = e.getMemValue();
    		IExpr address = e.getAddress();
    		String mo = e.getMo();

            List<Event> events;
            switch(target) {
                case NONE:
                case TSO: {
                    Load load = newRMWLoad(resultRegister, address, mo);
                    Store store = newRMWStore(load, address, value, mo);
                    events = eventSequence(
                            load,
                            store
                    );
                    break;
                }
                case POWER:
                case ARM8:
                    String loadMo = Tag.ARMv8.extractLoadMoFromCMo(mo);
                    String storeMo = Tag.ARMv8.extractStoreMoFromCMo(mo);

                    Load load = newRMWLoadExclusive(resultRegister, address, loadMo);
                    Store store = newRMWStoreExclusive(address, value, storeMo, true);
                    Label label = newLabel("FakeDep");
                    Event fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

                    Fence optionalMemoryBarrier = null;
                    Fence optionalISyncBarrier = (target.equals(POWER) && loadMo.equals(Tag.ARMv8.MO_ACQ)) ? Power.newISyncBarrier() : null;
                    if(target.equals(POWER)) {
                        optionalMemoryBarrier = mo.equals(Tag.C11.MO_SC) ? Power.newSyncBarrier()
                                : storeMo.equals(Tag.ARMv8.MO_REL) ? Power.newLwSyncBarrier()
                                : null;
                    }

                    // All events for POWER and ARM8
                    events = eventSequence(
                            optionalMemoryBarrier,
                            load,
                            fakeCtrlDep,
                            label,
                            store,
                            optionalISyncBarrier
                    );
                    break;
                default:
                    throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + getClass().getName());
            }
            return events;
    	}

    	@Override
    	public List<Event> visit(Dat3mCAS e) {
    		Register resultRegister = e.getResultRegister();
    		ExprInterface value = e.getMemValue();
    		IExpr address = e.getAddress();
    		String mo = e.getMo();
    		ExprInterface expectedValue = e.getExpectedValue();
            List<Event> events;

            // Events common for all compilation schemes.
            Register regValue = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
            Local casCmpResult = newLocal(resultRegister, new Atom(regValue, EQ, expectedValue));
            Label casEnd = newLabel("CAS_end");
            CondJump branchOnCasCmpResult = newJump(new Atom(resultRegister, NEQ, IConst.ONE), casEnd);

            switch(target) {
                case NONE: case TSO: {
                    Load load = newRMWLoad(regValue, address, mo);
                    Store store = newRMWStore(load, address, value, mo);

                    events = eventSequence(
                            // Indentation shows the branching structure
                            load,
                            casCmpResult,
                            branchOnCasCmpResult,
                                store,
                            casEnd
                    );
                    break;
                }
                case POWER:
                case ARM8: {
                    String loadMo = Tag.ARMv8.extractLoadMoFromCMo(mo);
                    String storeMo = Tag.ARMv8.extractStoreMoFromCMo(mo);

                    Load load = newRMWLoadExclusive(regValue, address, loadMo);
                    Store store = newRMWStoreExclusive(address, value, storeMo, true);

                    // --- Add Fence before under POWER ---
                    Fence optionalMemoryBarrier = null;
                    Fence optionalISyncBarrier = (target.equals(POWER) && loadMo.equals(Tag.ARMv8.MO_ACQ)) ? Power.newISyncBarrier() : null;
                    if(target.equals(POWER)) {
                        optionalMemoryBarrier = mo.equals(Tag.C11.MO_SC) ? Power.newSyncBarrier()
                                : storeMo.equals(Tag.ARMv8.MO_REL) ? Power.newLwSyncBarrier()
                                : null;
                    }
                    // --- Add success events ---
                    events = eventSequence(
                            // Indentation shows the branching structure
                            optionalMemoryBarrier,
                            load,
                            casCmpResult,
                            branchOnCasCmpResult,
                                store,
                            optionalISyncBarrier,
                            casEnd
                    );
                    break;
                }
                default:
                    throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + getClass().getName());
            }
            return events;
    	}
    }

}