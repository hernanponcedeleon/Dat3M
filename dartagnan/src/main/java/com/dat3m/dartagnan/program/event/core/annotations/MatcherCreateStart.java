package com.dat3m.dartagnan.program.event.core.annotations;

public class MatcherCreateStart extends CodeAnnotation {

	private final String cc;
	
	public MatcherCreateStart(String cc) {
		this.cc = cc;
	}
	
	protected MatcherCreateStart(MatcherCreateStart other){
		super(other);
		this.cc = other.cc;
	}

    @Override
    public String toString(){
        return "=== Matcher for " + cc + " ===";
    }

	// Unrolling
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public MatcherCreateStart getCopy(){
		return new MatcherCreateStart(this);
	}

}