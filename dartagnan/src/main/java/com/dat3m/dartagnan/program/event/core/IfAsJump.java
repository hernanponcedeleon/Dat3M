package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.BExpr;
import com.dat3m.dartagnan.program.event.EType;
import com.google.common.base.Preconditions;

import java.util.ArrayList;
import java.util.List;

public class IfAsJump extends CondJump {

	private final Label end;
	
	public IfAsJump(BExpr expr, Label label, Label end) {
		super(expr, label);
		this.end = end;
		addFilters(EType.CMP);
	}
	
    protected IfAsJump(IfAsJump other) {
		super(other);
		this.end = other.end;
	}

	public Label getEndIf() { return end; }

    public List<Event> getBranchesEvents(){
    	// Because it is used for RelCtrlDirect
    	Preconditions.checkState(cId > -1, "getBranchesEvents() must be called after compilation");
		List<Event> events = new ArrayList<>();
		Event next = successor;
		// For IfAsJump events, getLabel() returns the label representing the else branch
		while(next != null && next.successor != getLabel()) {
			events.add(next);
			next = next.getSuccessor();
		}
		next = getLabel().successor;
		while(next != end && next != null) {
			events.add(next);
			next = next.getSuccessor();
		}
		return events;
    }

	@Override
	public IfAsJump getCopy() {
		return new IfAsJump(this);
	}
}