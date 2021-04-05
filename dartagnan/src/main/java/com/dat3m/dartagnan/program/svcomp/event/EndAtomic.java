package com.dat3m.dartagnan.program.svcomp.event;

import static com.dat3m.dartagnan.program.utils.EType.SVCOMPATOMIC;

import java.util.ArrayList;
import java.util.List;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.utils.EType;

public class EndAtomic extends Event {

	protected BeginAtomic begin;
	protected BeginAtomic begin4Copy;

    public EndAtomic(BeginAtomic begin) {
        this.begin = begin;
    	this.begin.addListener(this);
        addFilters(EType.RMW, SVCOMPATOMIC);
    	Event next = begin.getSuccessor();
    	while(next != null && next != this) {
    		next.addFilters(EType.RMW);
    		next = next.getSuccessor();
    	}
    }

    protected EndAtomic(EndAtomic other){
		super(other);
		this.begin = other.begin4Copy;
		Event notifier = begin != null ? begin : other.begin;
		notifier.addListener(this);
	}

    public BeginAtomic getBegin(){
    	return begin;
    }
    
    public List<Event> getBlock(){
    	List<Event> block = new ArrayList<Event>();
    	Event next = begin;
    	while(next != null && next != this) {
    		block.add(next);
    		next = next.getSuccessor();	
    	}
        return block;
    }

    @Override
    public String toString() {
    	return "end_atomic()";
    }
    
    @Override
    public void notify(Event begin) {
    	//TODO: create an interface for easy maintenance of the listeners logic
    	if(this.begin == null) {
    		this.begin = (BeginAtomic)begin;
    	} else if (oId > begin.getOId()) {
    		this.begin4Copy = (BeginAtomic)begin;
    	}
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
	public EndAtomic getCopy(){
		return new EndAtomic(this);
	}
}