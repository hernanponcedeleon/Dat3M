package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.BOpUn;
import com.dat3m.dartagnan.expression.op.IOpUn;
import com.dat3m.dartagnan.expression.processing.ExprSimplifier;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.arch.tso.Xchg;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.lang.catomic.AtomicCmpXchg;
import com.dat3m.dartagnan.program.event.lang.catomic.AtomicLoad;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.base.Preconditions;
import com.google.common.base.Verify;

import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.math.BigInteger;
import java.util.HashMap;
import java.util.Map;

import static com.dat3m.dartagnan.expression.op.IOpUn.BV2INT;
import static com.dat3m.dartagnan.expression.op.IOpUn.BV2UINT;

public class ConstantPropagation implements ProgramProcessor {
	
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
    }

	private void run(Thread thread) {
		
	    Map<Register, ExprInterface> propagationMap = new HashMap<>();
	    Map<Label, Map<Register, ExprInterface>> propagationMapLabel = new HashMap<>();
	    
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
            	propagationMap.put(l.getResultRegister(), evaluate(l.getExpr(), propagationMap));
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

        	current.accept(new ConstantPropagationVisitor(propagationMap));
            current = current.getSuccessor();

			if (resetPropMap) {
				propagationMap.clear();
			}
        }

        thread.updateExit(thread.getEntry());
        thread.clearCache();
	}

	// TODO Once we have a lattice class this should be moved there.
	private ExprInterface evaluate(ExprInterface input, Map<Register, ExprInterface> map) {
		ExprSimplifier simplifier = new ExprSimplifier();

    	if(input instanceof INonDet || input instanceof BNonDet) {
    		return new ITop();
    	}
    	if(input instanceof IConst || input instanceof BConst) {
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
			IExpr inner = (IExpr) evaluate(un.getInner(), map);
			return inner instanceof ITop ? inner : new IExprUn(op, inner).visit(simplifier);
    	}
    	if(input instanceof IExprBin) {
    		IExprBin bin = (IExprBin)input;
    		IExpr lhs = (IExpr) evaluate(bin.getLHS(), map);
			IExpr rhs = (IExpr) evaluate(bin.getRHS(), map);
			return lhs instanceof ITop || rhs instanceof ITop ? 
					new ITop() :
					new IExprBin(lhs, bin.getOp(), rhs).visit(simplifier);
    	}
    	if(input instanceof IfExpr) {
    		IfExpr ife = (IfExpr)input;
    		ExprInterface guard = evaluate(ife.getGuard(), map);
    		IExpr tbranch = (IExpr) evaluate(ife.getTrueBranch(), map);
			IExpr fbranch = (IExpr) evaluate(ife.getFalseBranch(), map);
			return tbranch instanceof ITop || fbranch instanceof ITop || guard instanceof ITop ? 
					new ITop() :
					new IfExpr((BExpr) guard, tbranch, fbranch).visit(simplifier);
    	}
    	if(input instanceof Atom) {
    		Atom atom = (Atom)input;
    		ExprInterface lhs = evaluate(atom.getLHS(), map);
    		ExprInterface rhs = evaluate(atom.getRHS(), map);
			return (lhs instanceof ITop | rhs instanceof ITop) ? new ITop() : new Atom(lhs, atom.getOp(), rhs).visit(simplifier);
    	}
    	if(input instanceof BExprUn) {
    		BExprUn un = (BExprUn)input;
    		BOpUn op = un.getOp();
    		ExprInterface inner = evaluate(un.getInner(), map);
			return inner instanceof ITop ? new ITop() : new BExprUn(op, inner).visit(simplifier);
    	}
    	if(input instanceof BExprBin) {
    		BExprBin bin = (BExprBin)input;
    		ExprInterface lhs = evaluate(bin.getLHS(), map);
    		ExprInterface rhs = evaluate(bin.getRHS(), map);
    		return (lhs instanceof ITop | rhs instanceof ITop) ? new ITop() : new BExprBin(lhs, bin.getOp(), rhs).visit(simplifier);
    	}
		throw new UnsupportedOperationException(String.format("Expression %s not supported", input));
    }
    
    private Map<Register, ExprInterface> merge (Map<Register, ExprInterface> x, Map<Register, ExprInterface> y) {
    	Preconditions.checkNotNull(x);
    	Preconditions.checkNotNull(y);

    	Map<Register, ExprInterface> merged = new HashMap<>(x);
    	
    	for(Register reg : y.keySet()) {
    		if(!merged.containsKey(reg)) {
        		merged.put(reg, y.get(reg));    			
    		} else if(!merged.get(reg).equals(y.get(reg))){
    			merged.put(reg, new ITop());
    		}
    	}

    	return merged;
		
    }
    
    private class ITop extends IConst {

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
    
    private class ConstantPropagationVisitor implements EventVisitor<Event> {

    	private Map<Register, ExprInterface> map;
    	
    	protected ConstantPropagationVisitor(Map<Register, ExprInterface> map) {
    		this.map = map;
    	}
    	
    	@Override
    	public Event visitEvent(Event e) {
    		return e;
    	};
    	
    	@Override
    	public Event visitLoad(Load e) {
    		setAddress(e);
    		return e;
    	};
    	
    	@Override
    	public Event visitMemEvent(MemEvent e) {
    		setAddress(e);
    		setMemValue(e);
    		return e;
    	};

    	@Override
    	public Event visitLocal(Local e) {
    		ExprInterface oldExpr = e.getExpr();
    		ExprInterface newExpr = evaluate(oldExpr, map);
    		Verify.verifyNotNull(newExpr,
    				"Expression %s got no value after constant propagation analysis", oldExpr);
    		if(!(newExpr instanceof ITop) && !e.is(Tag.ASSERTION)) {
    			e.setExpr(newExpr);
    		}
    		return e;
    	};
    	
    	@Override
    	public Event visitCondJump(CondJump e) {
    		ExprInterface oldGuard = e.getGuard();
    		ExprInterface newGuard = evaluate(oldGuard, map);
    		Verify.verifyNotNull(newGuard,
    				"Expression %s got no value after constant propagation analysis", oldGuard);
    		if(!(newGuard instanceof ITop)) {
    			e.setGuard((BExpr) newGuard);
    		}
    		return e;
    	};
    	
    	@Override
    	public Event visitXchg(Xchg e) {
    		setAddress(e);
    		return e;
    	};
    	
    	@Override
    	public Event visitAtomicLoad(AtomicLoad e) {
    		setAddress(e);
    		return e;
    	};
    	
    	@Override
    	public Event visitAtomicCmpXchg(AtomicCmpXchg e) {
    		setAddress(e);
    		setMemValue(e);
    		IExpr oldExpectedAddr = e.getExpectedAddr();
    		IExpr newExpectedAddr = (IExpr) evaluate(oldExpectedAddr, map);
    		Verify.verifyNotNull(newExpectedAddr,
    				"Expression %s got no value after constant propagation analysis", oldExpectedAddr);
    		if(!(newExpectedAddr instanceof ITop)) {
    			e.setExpectedAddr(newExpectedAddr);
    		}
    		return e;
    	}
    	
    	private void setAddress(MemEvent e) {
    		IExpr oldAddress = e.getAddress();
    		IExpr newAddress = (IExpr) evaluate(oldAddress, map);
    		Verify.verifyNotNull(newAddress,
    				"Expression %s got no value after constant propagation analysis", oldAddress);
    		if(!(newAddress instanceof ITop)) {
    			e.setAddress(newAddress);
    		}
    	}

    	private void setMemValue(MemEvent e) {
    		ExprInterface oldValue = e.getMemValue();
    		ExprInterface newValue = evaluate(oldValue, map);
    		Verify.verifyNotNull(newValue,
    				"Expression %s got no value after constant propagation analysis", oldValue);
    		if(!(newValue instanceof ITop)) {
    			e.setMemValue(newValue);;
    		}
    	}
    }
}