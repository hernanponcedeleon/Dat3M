package com.dat3m.dartagnan.program.event;

public class Comment extends Event {

	String comment;
	
	public Comment(String comment) {
		this.comment = comment;
	}
	
    @Override
    public String toString(){
        return "===" + comment + "===";
    }

	// Unrolling
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public Comment getCopy(){
		return new Comment(comment);
	}
}
