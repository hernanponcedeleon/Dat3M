package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.program.utils.EType;

public class Comment extends Event {

	String comment;
	
	public Comment(String comment) {
		this.comment = comment;
        addFilters(EType.ANY);
	}
	
	protected Comment(Comment other){
		super(other);
		this.comment = other.comment;
	}

    @Override
    public String toString(){
        return "===" + comment + "===";
    }

	// Unrolling
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public Comment getCopy(){
		return new Comment(this);
	}
}
