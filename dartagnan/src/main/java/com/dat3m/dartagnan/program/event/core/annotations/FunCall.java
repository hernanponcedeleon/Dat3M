package com.dat3m.dartagnan.program.event.core.annotations;

public class FunCall extends StringAnnotation {

	private final String funName;
	
	public FunCall(String funName) {
		super("=== Calling " + funName + " ===");
		this.funName = funName;
	}
	
	protected FunCall(FunCall other){
		super(other);
		this.funName = other.funName;
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
}