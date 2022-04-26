package com.dat3m.dartagnan.program.event.core.annotations;

import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;


public class FunCall extends CodeAnnotation {

	private final String funName;
	
	public FunCall(String funName) {
		this.funName = funName;
        addFilters(Tag.ANY);
	}
	
	protected FunCall(FunCall other){
		super(other);
		this.funName = other.funName;
	}

    @Override
    public String toString(){
        return "=== Calling " + funName + " ===";
    }

    public String getFunctionName() {
    	return funName;
    }

	// Unrolling
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public FunCall getCopy(){
		return new FunCall(this);
	}

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitFunCall(this);
	}
}