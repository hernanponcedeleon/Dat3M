package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.recursion.RecursiveAction;
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
		this.thread = exitEvent.getThread();
		addFilters(EType.ANY, EType.CMP, EType.REG_READER);
	}

	public ExprInterface getExpr(){
		return expr;
	}

	public Skip getExitEvent(){
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

	/*@Override
	public void unroll(int bound, Event predecessor) {
		if(successor != null){
			int currentBound = bound;

			while(currentBound > 0){
				Skip exitMainBranch = exitEvent.getCopy();
				Skip exitElseBranch = exitEvent.getCopy();
				If ifEvent = new If(expr, exitMainBranch, exitElseBranch);
				ifEvent.oId = oId;

				predecessor.setSuccessor(ifEvent);
				predecessor = copyPath(successor, exitEvent, ifEvent);
				predecessor.setSuccessor(exitMainBranch);
				exitMainBranch.setSuccessor(exitElseBranch);
				predecessor = exitElseBranch;

				ifEvent.successor.unroll(currentBound, ifEvent);
				currentBound--;
			}

			predecessor.setSuccessor(exitEvent.getSuccessor());
			if(predecessor.getSuccessor() != null){
				predecessor.getSuccessor().unroll(bound, predecessor);
			}
			return;
		}

		throw new RuntimeException("Malformed While event");
	}*/

	@Override
	public RecursiveAction unrollRecursive(int bound, Event predecessor, int depth) {
		// Note: For ease of implementation, the depth-parameter is not used (i.e. the call stack is always cleared)
		// But it can be incorporated if needed!
		if(successor != null){
			int currentBound = bound;

			RecursiveAction action = RecursiveAction.done();
			while(currentBound > 0){
				Skip exitMainBranch = exitEvent.getCopy();
				Skip exitElseBranch = exitEvent.getCopy();
				If ifEvent = new If(expr, exitMainBranch, exitElseBranch);
				ifEvent.oId = oId;

				predecessor.setSuccessor(ifEvent);
				predecessor = copyPath(successor, exitEvent, ifEvent);
				predecessor.setSuccessor(exitMainBranch);
				exitMainBranch.setSuccessor(exitElseBranch);
				predecessor = exitElseBranch;

				int finalCurrentBound = currentBound;
				action = action.then(() -> ifEvent.successor.unrollRecursive(finalCurrentBound, ifEvent, 0));
				currentBound--;
			}

			predecessor.setSuccessor(exitEvent.getSuccessor());
			if(predecessor.getSuccessor() != null){
				Event finalPredecessor = predecessor;
				action = action.then(() -> finalPredecessor.getSuccessor().unrollRecursive(bound, finalPredecessor, 0));
			}
			return action;
		}
		throw new RuntimeException("Malformed While event");
	}

	@Override
	public While getCopy(){
		Skip newExit = exitEvent.getCopy();
		While copy = new While(expr, newExit);
		copy.setOId(oId);
		Event ptr = copyPath(successor, exitEvent, copy);
		ptr.setSuccessor(newExit);
		return copy;
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