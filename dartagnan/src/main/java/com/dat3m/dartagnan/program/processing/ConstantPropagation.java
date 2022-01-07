package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.IOpUn;
import com.dat3m.dartagnan.program.EventFactory;
import com.dat3m.dartagnan.program.EventFactory.*;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.arch.aarch64.event.StoreExclusive;
import com.dat3m.dartagnan.program.arch.linux.event.*;
import com.dat3m.dartagnan.program.arch.linux.utils.EType;
import com.dat3m.dartagnan.program.atomic.event.*;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.google.common.base.Preconditions;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Options;

import static com.dat3m.dartagnan.expression.op.IOpUn.*;

import java.util.HashMap;
import java.util.Map;

@Options
public class ConstantPropagation implements ProgramProcessor {
	
    private final static Logger logger = LogManager.getLogger(ConstantPropagation.class);

    private int propagations = 0;
    
	// TODO we need a proper class for lattices. The inner map is nothing more than a map lattice.
    private Map<Integer, Map<Register, IExpr>> propagationMap = new HashMap<Integer, Map<Register, IExpr>>();

    // =========================== Configurables ===========================

    // =====================================================================

    private ConstantPropagation() { }

    private ConstantPropagation(Configuration config) throws InvalidConfigurationException {
        config.inject(this);
    }

    public static ConstantPropagation fromConfig(Configuration config) throws InvalidConfigurationException {
        return new ConstantPropagation(config);
    }

    public static ConstantPropagation newInstance() {
        return new ConstantPropagation();
    }

    @Override
    public void run(Program program) {
        Preconditions.checkArgument(program.isUnrolled(), "The program needs to be unrolled before constant propagation.");
        Preconditions.checkArgument(!program.isCompiled(), "Constant propagation needs to be run before compilation.");
        for(Thread thread : program.getThreads()){
            run(thread);
        }
        logger.info(String.format("Propagations done: %s (out of %s events)", propagations, program.getEvents().size()));
    }

	private void run(Thread thread) {
		
		int currentThreadId = thread.getId();
		propagationMap.put(currentThreadId, new HashMap<Register, IExpr>());
		
        Event pred = thread.getEntry();
        Event current = pred.getSuccessor();

        while (current != null) {
        	Event e = current;

        	// Compute information to propagate. It cannot be computed before-hand
        	// because registers can be overwritten, thus the event creation has 
        	// to be done immediately after computing the information.
        	// For RegWriters interacting with memory, we assign TOP
        	if(current instanceof RegWriter) {
        		RegWriter rw = (RegWriter)e;
        		propagationMap.get(currentThreadId).put(rw.getResultRegister(), new ITop());
        	}
        	// For Locals, we update
        	if(current instanceof Local) {
        		Local l = (Local)e;
        		if(l.getExpr() instanceof IExpr) {
            		propagationMap.get(currentThreadId).put(l.getResultRegister(), evaluate((IExpr)l.getExpr(), currentThreadId));
        		}
        	}
        	
        	// Event creation
        	if(current instanceof MemEvent) {
        		MemEvent m = (MemEvent)current;
        		String mo = m.getMo();

        		// All events for which we use reg are RegWriters
        		Register reg = current instanceof RegWriter ? ((RegWriter)current).getResultRegister() : null;

        		IExpr oldAddress = m.getAddress();
        		IExpr newAddress = evaluate(oldAddress, currentThreadId);
        		newAddress = newAddress instanceof ITop ? oldAddress : newAddress;
        		Preconditions.checkState(newAddress != null, 
        				String.format("Expression %s got no value after constant propagation analysis", oldAddress));

        		IExpr oldValue = (IExpr) ((MemEvent)current).getMemValue();
        		IExpr newValue = evaluate(oldValue, currentThreadId);
        		newValue = newValue instanceof ITop ? oldValue : newValue; 
        		Preconditions.checkState(newValue != null, 
        				String.format("Expression %s got no value after constant propagation analysis", oldValue));
        		
        		// Atomic Events
        		if(current instanceof AtomicLoad) {
    				e = Atomic.newLoad(reg, newAddress, mo);
            	} else if(current instanceof AtomicStore) {
    				e = Atomic.newStore(newAddress, newValue, mo);
            	} else if(current instanceof AtomicCmpXchg) {
            		IExpr oldExpectedAddr = ((AtomicCmpXchg)current).getExpectedAddr();
            		IExpr newExpectedAddr = evaluate(oldExpectedAddr, currentThreadId);
                	Preconditions.checkState(newExpectedAddr != null, 
                			String.format("Register %s got no value after constant propagation analysis", oldExpectedAddr));
    				e = Atomic.newCompareExchange(reg, newAddress, newExpectedAddr, newValue, mo, current.is(EType.STRONG));
            	} else if(current instanceof AtomicXchg) {
    				e = Atomic.newExchange(reg, newAddress, newValue, mo);
            	} else if(current instanceof AtomicFetchOp) {
            		e = Atomic.newFetchOp(reg, newAddress, newValue, ((AtomicFetchOp)current).getOp(), mo);
            	}
        		// Linux Events
            	else if(current instanceof RMWAddUnless) {
            		e = Linux.newRMWAddUnless(newAddress, reg, ((RMWAddUnless)current).getCmp(), newValue);
            	} else if(current instanceof RMWCmpXchg) {
            		e = Linux.newRMWCompareExchange(newAddress, reg, ((RMWCmpXchg)current).getCmp(), newValue, mo);
            	} else if(current instanceof RMWFetchOp) {
            		e = Linux.newRMWFetchOp(newAddress, reg, newValue, ((RMWFetchOp)current).getOp(), mo);
            	} else if(current instanceof RMWOp) {
            		e = Linux.newRMWOp(newAddress, reg, newValue, ((RMWOp)current).getOp());
            	} else if(current instanceof RMWOpAndTest) {
            		e = Linux.newRMWOpAndTest(newAddress, reg, newValue, ((RMWOpAndTest)current).getOp());
            	} else if(current instanceof RMWOpReturn) {
            		e = Linux.newRMWOpReturn(newAddress, reg, newValue, ((RMWOpReturn)current).getOp(), mo);
            	} else if(current instanceof RMWXchg) {
            		e = Linux.newRMWExchange(newAddress, reg, newValue, mo);
            	}
        		// Exclusive events
            	else if(current.is(EType.EXCL)) {
            		if(current instanceof Load) {
            			e = EventFactory.newRMWLoadExclusive(reg, newAddress, mo);
            		} else if (current instanceof StoreExclusive) {
            			e = Arm8.newExclusiveStore(reg, newAddress, newValue, mo);
            		} else {
            			// Other EXCL events are generated during compilation (which have not yet occurred)
            			throw new UnsupportedOperationException(String.format("Exclusive event %s not supported by %s", 
            					current.getClass().getSimpleName(), getClass().getSimpleName()));
            		}
            	}
        		// Basic Events
            	else if(current instanceof Load) {
    				e = EventFactory.newLoad(reg, newAddress, mo);
            	} else if(current instanceof Store) {
    				e = EventFactory.newStore(newAddress, newValue, mo);
            	}
        	}
// Locals are still causing problems
        	
        	// Local events coming from assertions cause problems because the encoding of 
        	// AssertInline uses getResultRegisterExpr() which gets a value when calling
        	// Local.initialise() which is never the case for the new Event e below.
        	else if(current instanceof Local && ((Local)current).getExpr() instanceof IExpr && !current.is(EType.ASSERTION)) {
//        		Register reg = ((Local)current).getResultRegister();
//        		
//        		IExpr oldValue = (IExpr) ((Local)current).getExpr();
//        		IExpr newValue = evaluate(oldValue, currentThreadId);
//        		newValue = newValue instanceof ITop ? oldValue : newValue; 
//        		Preconditions.checkState(newValue != null, 
//        				String.format("Expression %s got no value after constant propagation analysis", oldValue));
//        		
//        		e = EventFactory.newLocal(reg, newValue);
        	}

        	// Update propagation counter
        	if(!current.equals(e)) { propagations++; }
        	
            e.setOId(current.getOId());
            e.setUId(current.getUId());
            e.setCId(current.getCId());
            e.setThread(thread);
            pred.setSuccessor(e);
            pred = e;

            current = current.getSuccessor();
        }

        thread.updateExit(thread.getEntry());
        thread.clearCache();
	}

	// TODO Once we have a lattice class this should be moved there.
    private IExpr evaluate(IExpr input, Integer threadId) {
    	// TODO If we extend this to BExpr too, we might reduce IfExprs further by also evaluating the guard.
    	
    	if(input instanceof IConst || input instanceof INonDet) {
    		return input;
    	}
    	if(input instanceof Register) {
    		// When pthread create passes arguments, the new thread starts with a Local
    		// where the RHS is a Register from the parent thread and thus we might not 
    		// have the key in the map.
    		if(propagationMap.get(threadId).containsKey(input)) {
    			return propagationMap.get(threadId).get(input);
    		} else {
    			return input;
    		}
    	}
    	if(input instanceof IExprUn) {
    		IExprUn un = (IExprUn)input;
    		IOpUn op = un.getOp();
    		// These two can cause problems
    		if(op.equals(BV2INT) || op.equals(BV2UINT)) {
    			return input;
    		}
			IExpr inner = evaluate(un.getInner(), threadId);
			return inner instanceof ITop ? inner : new IExprUn(op, inner);
    	}
    	if(input instanceof IExprBin) {
    		IExprBin bin = (IExprBin)input;
    		IExpr lhs = evaluate(bin.getLHS(), threadId);
			IExpr rhs = evaluate(bin.getRHS(), threadId);
			return lhs instanceof ITop ? lhs : rhs instanceof ITop ? rhs : new IExprBin(lhs, bin.getOp(), rhs);
    	}
    	if(input instanceof IfExpr) {
    		IfExpr ife = (IfExpr)input;
    		IExpr tbranch = evaluate(ife.getTrueBranch(), threadId);
			IExpr fbranch = evaluate(ife.getFalseBranch(), threadId);
			return tbranch instanceof ITop ? tbranch : fbranch instanceof ITop ? fbranch : new IfExpr(ife.getGuard(), tbranch, fbranch);
    	}
		throw new UnsupportedOperationException(String.format("IExpr %s not supported", input));
    }
}