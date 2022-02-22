package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.IOpUn;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.EventFactory.AArch64;
import com.dat3m.dartagnan.program.event.EventFactory.Atomic;
import com.dat3m.dartagnan.program.event.EventFactory.Linux;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.arch.aarch64.StoreExclusive;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.linux.*;
import com.google.common.base.Preconditions;
import com.google.common.base.Verify;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.math.BigInteger;
import java.util.HashMap;
import java.util.Map;

import static com.dat3m.dartagnan.expression.op.IOpUn.BV2INT;
import static com.dat3m.dartagnan.expression.op.IOpUn.BV2UINT;


public class ConstantPropagation implements ProgramProcessor {
	
    private final static Logger logger = LogManager.getLogger(ConstantPropagation.class);

    private int propagations = 0;
    
    // =========================== Configurables ===========================

    // =====================================================================

    private ConstantPropagation() { }

    public static ConstantPropagation fromConfig(Configuration config) throws InvalidConfigurationException {
        return newInstance();
    }

    public static ConstantPropagation newInstance() {
        return new ConstantPropagation();
    }

    @Override
    public void run(Program program) {
        Preconditions.checkArgument(program.isUnrolled(), "The program needs to be unrolled before constant propagation.");
        Preconditions.checkArgument(!program.isCompiled(), "Constant propagation needs to be run before compilation.");
        for(Thread thread : program.getThreads()) {
            run(thread);
        }
        logger.info(String.format("Propagations done: %s (out of %s events)", propagations, program.getEvents().size()));
    }

	private void run(Thread thread) {
		
	    Map<Register, IExpr> propagationMap = new HashMap<>();
	    Map<Label, Map<Register, IExpr>> propagationMapLabel = new HashMap<>();

        Event pred = thread.getEntry();
        Event current = pred.getSuccessor();

        while (current != null) {
			boolean resetPropMap = false;
        	// Compute information to propagate. It cannot be computed before-hand
        	// because registers can be overwritten, thus the event creation has 
        	// to be done immediately after computing the information.
        	// For RegWriters interacting with memory, we assign TOP
        	if(current instanceof RegWriter) {
        		RegWriter rw = (RegWriter)current;
        		propagationMap.put(rw.getResultRegister(), new ITop());
        	}
        	// For Locals, we update
        	if(current instanceof Local) {
        		Local l = (Local)current;
        		// IfExpr may still contain registers (instead of the corresponding constant) in the guard, thus we don't consider them constants
        		if(l.getExpr() instanceof IExpr && !(l.getExpr() instanceof IfExpr)) {
            		propagationMap.put(l.getResultRegister(), evaluate((IExpr)l.getExpr(), propagationMap));
        		}
        	}
        	if(current instanceof CondJump) {
				CondJump jump = (CondJump)current;
        		propagationMapLabel.put(jump.getLabel(), merge(propagationMap, propagationMapLabel.getOrDefault(jump.getLabel(), new HashMap<>())));
				resetPropMap = jump.isGoto(); // A goto will cause the current map to not propagate to the successor
        	}
        	if(current instanceof Label) {
				// Merge current map with all possible jumps that target this label
        		propagationMap = merge(propagationMap, propagationMapLabel.getOrDefault(current, new HashMap<>()));
        	}

			Event copy = getSimplifiedCopy(current, propagationMap);
			if (copy != current) {
				propagations++; // Update propagation counter
			}

			pred.setSuccessor(copy);
			pred = copy;
            current = current.getSuccessor();

			if (resetPropMap) {
				propagationMap.clear();
			}
        }

        thread.updateExit(thread.getEntry());
        thread.clearCache();
	}

	// Creates a copy of the provided event, using the <propagationMap> to simplify expressions.
	// Can return the original event if no simplifications are performed
	private Event getSimplifiedCopy(Event ev, Map<Register, IExpr> propagationMap) {
		Event copy = ev;
		if(ev instanceof MemEvent && !ev.is(Tag.C11.PTHREAD) && !ev.is(Tag.C11.LOCK)) {
			MemEvent m = (MemEvent) ev;
			String mo = m.getMo();

			// All events for which we use reg are RegWriters
			Register reg = ev instanceof RegWriter ? ((RegWriter) ev).getResultRegister() : null;

			IExpr oldAddress = m.getAddress();
			IExpr newAddress = evaluate(oldAddress, propagationMap);
			newAddress = newAddress instanceof ITop ? oldAddress : newAddress;
			Verify.verifyNotNull(newAddress,
					"Expression %s got no value after constant propagation analysis", oldAddress);

			IExpr oldValue = (IExpr) ((MemEvent) ev).getMemValue();
			IExpr newValue = evaluate(oldValue, propagationMap);
			newValue = newValue instanceof ITop ? oldValue : newValue;
			Verify.verifyNotNull(newValue,
					"Expression %s got no value after constant propagation analysis", oldValue);

			// Atomic Events
			if(ev instanceof AtomicLoad) {
				copy = Atomic.newLoad(reg, newAddress, mo);
			} else if(ev instanceof AtomicStore) {
				copy = Atomic.newStore(newAddress, newValue, mo);
			} else if(ev instanceof AtomicCmpXchg) {
				IExpr oldExpectedAddr = ((AtomicCmpXchg) ev).getExpectedAddr();
				IExpr newExpectedAddr = evaluate(oldExpectedAddr, propagationMap);
				Verify.verifyNotNull(newExpectedAddr,
						"Register %s got no value after constant propagation analysis", oldExpectedAddr);
				copy = Atomic.newCompareExchange(reg, newAddress, newExpectedAddr, newValue, mo, ev.is(Tag.STRONG));
			} else if(ev instanceof AtomicXchg) {
				copy = Atomic.newExchange(reg, newAddress, newValue, mo);
			} else if(ev instanceof AtomicFetchOp) {
				copy = Atomic.newFetchOp(reg, newAddress, newValue, ((AtomicFetchOp) ev).getOp(), mo);
			}
			// Linux Events
			else if(ev instanceof RMWAddUnless) {
				copy = Linux.newRMWAddUnless(newAddress, reg, ((RMWAddUnless) ev).getCmp(), newValue);
			} else if(ev instanceof RMWCmpXchg) {
				copy = Linux.newRMWCompareExchange(newAddress, reg, ((RMWCmpXchg) ev).getCmp(), newValue, mo);
			} else if(ev instanceof RMWFetchOp) {
				copy = Linux.newRMWFetchOp(newAddress, reg, newValue, ((RMWFetchOp) ev).getOp(), mo);
			} else if(ev instanceof RMWOp) {
				copy = Linux.newRMWOp(newAddress, reg, newValue, ((RMWOp) ev).getOp());
			} else if(ev instanceof RMWOpAndTest) {
				copy = Linux.newRMWOpAndTest(newAddress, reg, newValue, ((RMWOpAndTest) ev).getOp());
			} else if(ev instanceof RMWOpReturn) {
				copy = Linux.newRMWOpReturn(newAddress, reg, newValue, ((RMWOpReturn) ev).getOp(), mo);
			} else if(ev instanceof RMWXchg) {
				copy = Linux.newRMWExchange(newAddress, reg, newValue, mo);
			}
			// Exclusive events
			else if(ev.is(Tag.EXCL)) {
				if(ev instanceof Load) {
					copy = EventFactory.newRMWLoadExclusive(reg, newAddress, mo);
				} else if (ev instanceof StoreExclusive) {
					copy = AArch64.newExclusiveStore(reg, newAddress, newValue, mo);
				} else {
					// Other EXCL events are generated during compilation (which have not yet occurred)
					throw new UnsupportedOperationException(String.format("Exclusive event %s not supported by %s",
							ev.getClass().getSimpleName(), getClass().getSimpleName()));
				}
			}
			// Basic Events
			else if(ev instanceof Load) {
				copy = EventFactory.newLoad(reg, newAddress, mo);
			} else if(ev instanceof Store) {
				copy = EventFactory.newStore(newAddress, newValue, mo);
			}
		}
		// Local events coming from assertions cause problems because the encoding of
		// AssertInline uses getResultRegisterExpr() which gets a value when calling
		// Local.initialise() which is never the case for the new Event e below.
		else if(ev instanceof Local && ((Local) ev).getExpr() instanceof IExpr && !ev.is(Tag.ASSERTION)) {
			Register reg = ((Local) ev).getResultRegister();

			IExpr oldValue = (IExpr) ((Local) ev).getExpr();
			IExpr newValue = evaluate(oldValue, propagationMap);
			newValue = newValue instanceof ITop ? oldValue : newValue;
			Verify.verify(newValue != null,
					String.format("Expression %s got no value after constant propagation analysis", oldValue));

			copy = EventFactory.newLocal(reg, newValue);
		}

		if (copy != ev) {
			// We made a real copy
			copy.setOId(ev.getOId());
			copy.setUId(ev.getUId());
			copy.setCId(ev.getCId());
			copy.setCLine(ev.getCLine());
			copy.setThread(ev.getThread());
		}

		return copy;
	}

	// TODO Once we have a lattice class this should be moved there.
    private IExpr evaluate(IExpr input, Map<Register, IExpr> map) {
    	// TODO If we extend this to BExpr too, we might reduce IfExprs further by also evaluating the guard.
    	
    	if(input instanceof INonDet) {
    		return new ITop();
    	}
    	if(input instanceof IConst) {
    		return input;
    	}
    	if(input instanceof Register) {
    		// When pthread create passes arguments, the new thread starts with a Local
    		// where the RHS is a Register from the parent thread and thus we might not 
    		// have the key in the map.
			return map.getOrDefault(input, input);
    	}
    	if(input instanceof IExprUn) {
    		IExprUn un = (IExprUn)input;
    		IOpUn op = un.getOp();
    		// These two can cause problems
    		if(op.equals(BV2INT) || op.equals(BV2UINT)) {
    			return input;
    		}
			IExpr inner = evaluate(un.getInner(), map);
			return inner instanceof ITop ? inner : new IExprUn(op, inner);
    	}
    	if(input instanceof IExprBin) {
    		IExprBin bin = (IExprBin)input;
    		IExpr lhs = evaluate(bin.getLHS(), map);
			IExpr rhs = evaluate(bin.getRHS(), map);
			return lhs instanceof ITop ? lhs : rhs instanceof ITop ? rhs : new IExprBin(lhs, bin.getOp(), rhs);
    	}
    	if(input instanceof IfExpr) {
    		IfExpr ife = (IfExpr)input;
    		IExpr tbranch = evaluate(ife.getTrueBranch(), map);
			IExpr fbranch = evaluate(ife.getFalseBranch(), map);
			return tbranch instanceof ITop ? tbranch : fbranch instanceof ITop ? fbranch : new IfExpr(ife.getGuard(), tbranch, fbranch);
    	}
		throw new UnsupportedOperationException(String.format("IExpr %s not supported", input));
    }
    
    private Map<Register, IExpr> merge (Map<Register, IExpr> x, Map<Register, IExpr> y) {
    	Preconditions.checkNotNull(x);
    	Preconditions.checkNotNull(y);

    	Map<Register, IExpr> merged = new HashMap<>(x);
    	
    	for(Register reg : y.keySet()) {
    		if(!merged.containsKey(reg)) {
        		merged.put(reg, y.get(reg));    			
    		} else if(!merged.get(reg).equals(y.get(reg))){
    			merged.put(reg, new ITop());
    		}
    	}

    	return merged;
		
    }
    
    private static class ITop extends IConst {

        @Override
        public BigInteger getValue() {
            return BigInteger.ZERO;
        }

        @Override
        public String toString() {
            return "T";
        }

        @Override
        public int getPrecision() {
            return -1;
        }

        @Override
        public <T> T visit(ExpressionVisitor<T> visitor) {
            throw new UnsupportedOperationException();
        }
    }
}