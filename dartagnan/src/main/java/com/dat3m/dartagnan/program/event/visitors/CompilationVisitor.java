package com.dat3m.dartagnan.program.event.visitors;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.*;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.EventFactory.*;
import com.dat3m.dartagnan.program.event.arch.tso.*;
import com.dat3m.dartagnan.program.event.arch.aarch64.*;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.rmw.*;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.linux.*;
import com.dat3m.dartagnan.program.event.lang.linux.cond.*;
import com.dat3m.dartagnan.program.event.lang.linux.utils.Mo;
import com.dat3m.dartagnan.program.event.lang.pthread.*;
import static com.dat3m.dartagnan.program.event.arch.aarch64.utils.Mo.*;
import static com.dat3m.dartagnan.program.event.arch.tso.utils.EType.*;
import static com.dat3m.dartagnan.program.event.lang.catomic.utils.Mo.*;
import static com.dat3m.dartagnan.program.event.lang.linux.utils.EType.*;

import com.google.common.base.Preconditions;

import static com.dat3m.dartagnan.configuration.Arch.POWER;
import static com.dat3m.dartagnan.expression.op.COpBin.EQ;
import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;
import static com.dat3m.dartagnan.program.EventFactory.*;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class CompilationVisitor implements EventVisitor<List<Event>> {

	Arch target;
	
	public CompilationVisitor(Arch target) {
		this.target = target;
	}
	
	@Override
	public List<Event> visit(Event e) {
		return Collections.singletonList(e);
	};

	@Override
	public List<Event> visit(CondJump e) {
    	Preconditions.checkNotNull(target, "Target cannot be null");
    	Preconditions.checkState(e.getSuccessor() != null, "Malformed CondJump event");
		return visit((Event)e);
	}

	@Override
	public List<Event> visit(Create e) {
    	Preconditions.checkNotNull(target, "Target cannot be null");

        Fence optionalBarrierBefore = null;
        Fence optionalBarrierAfter = null;
        Store store = newStore(e.getAddress(), e.getMemValue(), e.getMo(), e.getCLine());
        store.addFilters(PTHREAD);

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
                optionalBarrierBefore = Arm8.DMB.newISHBarrier();
                optionalBarrierAfter = Arm8.DMB.newISHBarrier();
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
    	Preconditions.checkNotNull(target, "Target cannot be null");
    	
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
                optionalBarrierBefore = Arm8.DMB.newISHBarrier();
                optionalBarrierAfter = Arm8.DMB.newISHBarrier();
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
    	Preconditions.checkNotNull(target, "Target cannot be null");
        return eventSequence(
                newStore(e.getAddress(), e.getMemValue(), e.getMo())
        );
	}

	@Override
	public List<Event> visit(Join e) {
    	Preconditions.checkNotNull(target, "Target cannot be null");

        List<Event> events = new ArrayList<>();
        Register resultRegister = e.getResultRegister();
		Load load = newLoad(resultRegister, e.getAddress(), e.getMo());
        load.addFilters(PTHREAD);
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
                events.add(Arm8.DMB.newISHBarrier());
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
    	Preconditions.checkNotNull(target, "Target cannot be null");

        Register resultRegister = e.getResultRegister();
		String mo = e.getMo();
		
		List<Event> events = eventSequence(
                newLoad(resultRegister, e.getAddress(), mo),
                newJump(new Atom(resultRegister, NEQ, IConst.ZERO), e.getLabel()),
                newStore(e.getAddress(), IConst.ONE, mo)
        );
        
		for(Event child : events) {
            child.addFilters(LOCK, RMW);
        }
        
		return events;
	}

	@Override
	public List<Event> visit(Start e) {
    	Preconditions.checkNotNull(target, "Target cannot be null");

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
                events.add(Arm8.DMB.newISHBarrier());
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
    	Preconditions.checkNotNull(target, "Target cannot be null");

        Register resultRegister = e.getResultRegister();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		
		List<Event> events = eventSequence(
                newLoad(resultRegister, address, mo),
                newJump(new Atom(resultRegister, NEQ, IConst.ONE), e.getLabel()),
                newStore(address, IConst.ZERO, mo)
        );
        
		for(Event child : events) {
            child.addFilters(LOCK, RMW);
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
        RMWReadCondUnless load = Linux.newRMWReadCondUnless(dummy, e.getCmp(), e.getAddress(), Mo.RELAXED);
        RMWStoreCond store = Linux.newRMWStoreCond(load, e.getAddress(), 
        		new IExprBin(dummy, IOpBin.PLUS, (IExpr) e.getMemValue()), Mo.RELAXED);
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
		Preconditions.checkArgument(target == Arch.NONE, "Compilation to " + target + " is not supported for " + getClass().getName());

		Register resultRegister = e.getResultRegister();
		ExprInterface cmp = e.getCmp();
		ExprInterface value = e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		
        Register dummy = resultRegister;
        if(resultRegister == value || resultRegister == cmp){
            dummy = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
        }

        RMWReadCondCmp load = Linux.newRMWReadCondCmp(dummy, cmp, address, Mo.loadMO(mo));
        RMWStoreCond store = Linux.newRMWStoreCond(load, address, value, Mo.storeMO(mo));
        Local optionalUpdateReg = dummy != resultRegister ? newLocal(resultRegister, dummy) : null;
        Fence optionalMbBefore = mo.equals(Mo.MB) ? Linux.newConditionalMemoryBarrier(load) : null;
        Fence optionalMbAfter = mo.equals(Mo.MB) ? Linux.newConditionalMemoryBarrier(load) : null;

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

		Fence optionalMbBefore = mo.equals(Mo.MB) ? Linux.newMemoryBarrier() : null;
		Load load = newRMWLoad(dummy, address, Mo.loadMO(mo));
        RMWStore store = newRMWStore(load, address, 
        		new IExprBin(dummy, e.getOp(), (IExpr) value), Mo.storeMO(mo));
        Local optionalUpdateReg = dummy != resultRegister ? newLocal(resultRegister, dummy) : null;
        Fence optionalMbAfter = mo.equals(Mo.MB) ? Linux.newMemoryBarrier() : null;

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
		
        Load load = newRMWLoad(resultRegister, address, Mo.RELAXED);
        RMWStore store = newRMWStore(load, address, 
        		new IExprBin(resultRegister, e.getOp(), (IExpr) e.getMemValue()), Mo.RELAXED);
        load.addFilters(NORETURN);
        
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
		Load load = newRMWLoad(dummy, address, Mo.RELAXED);
        Local localOp = newLocal(dummy, new IExprBin(dummy, e.getOp(), (IExpr) e.getMemValue()));
        RMWStore store = newRMWStore(load, address, dummy, Mo.RELAXED);
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
		Fence optionalMbBefore = mo.equals(Mo.MB) ? Linux.newMemoryBarrier() : null;
		Load load = newRMWLoad(dummy, address, Mo.loadMO(mo));
        Local localOp = newLocal(resultRegister, new IExprBin(dummy, e.getOp(), (IExpr) e.getMemValue()));
        RMWStore store = newRMWStore(load, address, resultRegister, Mo.storeMO(mo));
        Fence optionalMbAfter = mo.equals(Mo.MB) ? Linux.newMemoryBarrier() : null;

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

		Fence optionalMbBefore = mo.equals(Mo.MB) ? Linux.newMemoryBarrier() : null;
		Load load = newRMWLoad(dummy, address, Mo.loadMO(mo));
        RMWStore store = newRMWStore(load, address, e.getMemValue(), Mo.storeMO(mo));
        Local optionalUpdateReg = dummy != resultRegister ? newLocal(resultRegister, dummy) : null;
        Fence optionalMbAfter = mo.equals(Mo.MB) ? Linux.newMemoryBarrier() : null;

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
        load.addFilters(ATOM);

        RMWStore store = newRMWStore(load, address, resultRegister, null);
        store.addFilters(ATOM);

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
                String loadMo = extractLoadMo(mo);
                String storeMo = extractStoreMo(mo);

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
                Fence optionalISyncBarrier = (target.equals(POWER) && loadMo.equals(ACQ)) ? Power.newISyncBarrier() : null;
                if(target.equals(POWER)) {
                    optionalMemoryBarrier = mo.equals(SC) ? Power.newSyncBarrier()
                            // if mo.equals(SC) then storeMo.equals(REL)
                            : storeMo.equals(REL) ? Power.newLwSyncBarrier()
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
                String loadMo = extractLoadMo(mo);
                String storeMo = extractStoreMo(mo);

                Load load = newRMWLoadExclusive(resultRegister, address, loadMo);
                Store store = newRMWStoreExclusive(address, dummyReg, storeMo, true);
                Label label = newLabel("FakeDep");
                Event fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

                // Extra fences for POWER
                Fence optionalMemoryBarrier = null;
                // Academics papers normally say an isync barrier is enough
                // However this makes benchmark linuxrwlocks.c fail
                // Additionally, power compilers in godbolt.org use a lwsync
                Fence optionalISyncBarrier = (target.equals(POWER) && loadMo.equals(ACQ)) ? Power.newLwSyncBarrier() : null;
                if(target.equals(POWER)) {
                    optionalMemoryBarrier = mo.equals(SC) ? Power.newSyncBarrier()
                            : storeMo.equals(REL) ? Power.newLwSyncBarrier()
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
                Fence optionalMemoryBarrier = mo.equals(SC) ? Power.newSyncBarrier() : null;
                Label optionalLabel =
                        (mo.equals(SC) || mo.equals(ACQUIRE) || mo.equals(RELAXED)) ?
                                newLabel("FakeDep") :
                                null;
                CondJump optionalFakeCtrlDep =
                        (mo.equals(SC) || mo.equals(ACQUIRE) || mo.equals(RELAXED)) ?
                                newFakeCtrlDep(resultRegister, optionalLabel) :
                                null;
                Fence optionalISyncBarrier =
                        (mo.equals(SC) || mo.equals(ACQUIRE)) ?
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
                String loadMo = extractLoadMo(mo);
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
                Fence optionalMFence = mo.equals(SC) ? X86.newMemoryFence() : null;
                events = eventSequence(
                        store,
                        optionalMFence
                );
                break;
            case POWER:
                Fence optionalMemoryBarrier = mo.equals(SC) ? Power.newSyncBarrier()
                        : mo.equals(RELEASE) ? Power.newLwSyncBarrier() : null;
                events = eventSequence(
                        optionalMemoryBarrier,
                        store
                );
                break;
            case ARM8:
                String storeMo = extractStoreMo(mo);
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
                fence = mo.equals(SC) ? X86.newMemoryFence() : null;
                break;
            case POWER:
                fence = mo.equals(ACQUIRE) || mo.equals(RELEASE) || mo.equals(ACQUIRE_RELEASE) || mo.equals(SC) ?
                        Power.newLwSyncBarrier() : null;
                break;
            case ARM8:
                fence = mo.equals(RELEASE) || mo.equals(ACQUIRE_RELEASE) || mo.equals(SC) ? Arm8.DMB.newISHBarrier()
                        : mo.equals(ACQUIRE) ? Arm8.DSB.newISHLDBarrier() : null;
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
                String loadMo = extractLoadMo(mo);
                String storeMo = extractStoreMo(mo);

                Load load = newRMWLoadExclusive(resultRegister, address, loadMo);
                Store store = newRMWStoreExclusive(address, value, storeMo, true);
                Label label = newLabel("FakeDep");
                Event fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

                Fence optionalMemoryBarrier = null;
                Fence optionalISyncBarrier = (target.equals(POWER) && loadMo.equals(ACQ)) ? Power.newISyncBarrier() : null;
                if(target.equals(POWER)) {
                    optionalMemoryBarrier = mo.equals(SC) ? Power.newSyncBarrier()
                            : storeMo.equals(REL) ? Power.newLwSyncBarrier()
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
                String loadMo = extractLoadMo(mo);
                String storeMo = extractStoreMo(mo);

                Load load = newRMWLoadExclusive(regValue, address, loadMo);
                Store store = newRMWStoreExclusive(address, value, storeMo, true);

                // --- Add Fence before under POWER ---
                Fence optionalMemoryBarrier = null;
                Fence optionalISyncBarrier = (target.equals(POWER) && loadMo.equals(ACQ)) ? Power.newISyncBarrier() : null;
                if(target.equals(POWER)) {
                    optionalMemoryBarrier = mo.equals(SC) ? Power.newSyncBarrier()
                            : storeMo.equals(REL) ? Power.newLwSyncBarrier()
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