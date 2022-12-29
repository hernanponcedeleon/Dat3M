package com.dat3m.dartagnan.program.event.core.annotations;

public class StringAnnotation extends CodeAnnotation {

	private final String annotation;
	
	public StringAnnotation(String annotation) {
		this.annotation = annotation;
	}
	
	protected StringAnnotation(StringAnnotation other){
		super(other);
		this.annotation = other.annotation;
	}

    @Override
    public String toString(){
        return annotation;
    }

	// Unrolling
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public StringAnnotation getCopy(){
		return new StringAnnotation(this);
	}

}