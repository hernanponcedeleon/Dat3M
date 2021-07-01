package com.dat3m.dartagnan.program.event;

import java.util.ArrayList;
import java.util.List;

import com.dat3m.dartagnan.expression.BExpr;
import com.dat3m.dartagnan.program.utils.EType;

public class IfAsJump extends CondJump {

	private Label end;
	
	public IfAsJump(BExpr expr, Label label, Label end) {
		super(expr, label);
		this.end = end;
		addFilters(EType.CMP);
	}
	
    protected IfAsJump(IfAsJump other) {
		super(other);
		this.end = other.end;
	}
	
    public List<Event> getMainBranchEvents(){
        if(cId > -1){
    		List<Event> events = new ArrayList<>();
    		Event next = successor;
    		while(next != null && next.successor != getLabel()) {
    			events.add(next);
    			next = next.getSuccessor();
    		}
    		return events;
        }
        throw new RuntimeException("Not implemented");
    }

    public List<Event> getElseBranchEvents(){
        if(cId > -1){
        	List<Event> events = new ArrayList<>();
    		Event next = getLabel().successor;
    		while(next != end && next != null) {
    			events.add(next);
    			next = next.getSuccessor();
    		}
    		return events;
        }
        throw new RuntimeException("Not implemented");
    }
}