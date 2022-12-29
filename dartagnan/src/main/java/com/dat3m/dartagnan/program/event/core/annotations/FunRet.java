package com.dat3m.dartagnan.program.event.core.annotations;

public class FunRet extends StringAnnotation {

	private final String funName;
	
	public FunRet(String funName) {
		super("=== Returning from " + funName + " ===");
		this.funName = funName;
	}
	
	protected FunRet(FunRet other){
		super(other);
		this.funName = other.funName;
	}

    public String getFunctionName() {
    	return funName;
    }

	// Unrolling
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public FunRet getCopy(){
		return new FunRet(this);
	}
}
