package com.dat3m.dartagnan.program.event.lang.pthread;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import static com.dat3m.dartagnan.program.event.Tag.C11.MO_SC;

public class Start extends Load {

	private Label label;
    private Label label4Copy;

	public Start(Register reg, MemoryObject address, Label label){
		super(reg, address, MO_SC);
        this.label = label;
        this.label.addListener(this);
        addFilters(Tag.C11.PTHREAD);
    }

	private Start(Start other){
		super(other);
		this.label = other.label4Copy;
		Event notifier = label != null ? label : other.label;
		notifier.addListener(this);
    }

    @Override
    public String toString() {
        return "start_thread()";
    }
	
    @Override
    public void notify(Event label) {
    	if(this.label == null) {
        	this.label = (Label)label;
    	} else if (oId > label.getOId()) {
    		this.label4Copy = (Label)label;
    	}
    }

    public Label getLabel() {
    	return label;
    }
    
    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public Start getCopy(){
        return new Start(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitStart(this);
	}
}