package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

public class While extends Event implements RegReaderData {

    private final ExprInterface expr;
	private final Skip exitEvent;
    private final ImmutableSet<Register> dataRegs;

	public While(ExprInterface expr, Skip exitEvent) {
		if(expr == null){
			throw new IllegalArgumentException("If event requires non null expression");
		}
		if(exitEvent == null){
			throw new IllegalArgumentException("If event requires non null exit event");
		}
		this.expr = expr;
		this.exitEvent = exitEvent;
		this.dataRegs = expr.getRegs();
		addFilters(EType.ANY, EType.CMP, EType.REG_READER);
	}

	private While(While other){
	    super(other);
	    this.expr = other.expr;
	    this.exitEvent = (Skip)other.exitEvent.getCopy();
	    this.dataRegs = other.dataRegs;
    }

	public ExprInterface getExpr(){
		return expr;
	}

	public Event getExitEvent(){
		return exitEvent;
	}

	@Override
	public ImmutableSet<Register> getDataRegs(){
		return dataRegs;
	}

	@Override
	public String toString() {
		return "while(" + expr + ")";
	}


    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

	@Override
	public int unroll(int bound, int nextId, Event predecessor) {
		if(successor == null){
			throw new RuntimeException("Malformed \"while\" event");
		}

		int currentBound = bound;
		while(currentBound > 0){
			successor.resetCopy();

			Skip exitMainBranch = new Skip();
			Skip exitElseBranch = new Skip();
			If ifEvent = new If(expr, exitMainBranch, exitElseBranch);
			ifEvent.oId = oId;
			exitMainBranch.setOId(exitEvent.oId);
			exitElseBranch.setOId(exitEvent.oId);
			ifEvent.uId = nextId++;

			predecessor.setSuccessor(ifEvent);
			predecessor = ifEvent;

			Event next = successor;
			while(!next.equals(exitEvent)){
				Event nextCopy = next.getCopy();
				predecessor.successor = nextCopy;
				predecessor = nextCopy;
				next = next.getSuccessor();
			}

			predecessor.successor = exitMainBranch;
			exitMainBranch.successor = exitElseBranch;
			predecessor = exitElseBranch;

			nextId = ifEvent.successor.unroll(currentBound, nextId, ifEvent);
			currentBound--;
		}

		predecessor.successor = exitEvent.successor;
		if(predecessor.successor != null){
			nextId = predecessor.successor.unroll(bound, nextId, predecessor);
		}

		return nextId;
	}

    @Override
    protected While mkCopy(){
        return new While(this);
    }


    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public int compile(Arch target, int nextId, Event predecessor) {
        throw new RuntimeException("Event 'while' must be unrolled before compilation");
    }


	// Encoding
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public BoolExpr encodeCF(Context ctx, BoolExpr cond) {
		throw new RuntimeException("While event must be unrolled before encoding");
	}
}