package com.dat3m.dartagnan.program.event.lang.pthread;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.dat3m.dartagnan.program.memory.Address;
import static com.dat3m.dartagnan.program.event.lang.catomic.utils.Mo.SC;

public class Join extends Load {

	private final Register pthread_t;
	private Label label;
    private Label label4Copy;

    public Join(Register pthread_t, Register reg, Address address, Label label) {
    	super(reg, address, SC);
        this.pthread_t = pthread_t;
        this.label = label;
        this.label.addListener(this);
    }

    public Join(Join other){
    	super(other);
        this.pthread_t = other.pthread_t;
		this.label = other.label4Copy;
		Event notifier = label != null ? label : other.label;
		notifier.addListener(this);
    }

    @Override
    public String toString() {
        return "pthread_join(" + pthread_t + ")";
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
    public Join getCopy(){
        return new Join(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visit(this);
	}
}