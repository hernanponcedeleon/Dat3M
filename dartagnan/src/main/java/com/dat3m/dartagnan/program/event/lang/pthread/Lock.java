package com.dat3m.dartagnan.program.event.lang.pthread;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag.C11;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import static com.dat3m.dartagnan.program.event.Tag.C11.MO_SC;

public class Lock extends Store {
	
	private final String name;
	private final Register reg;
	private Label label;
    private Label label4Copy;

	public Lock(String name, IExpr address, Register reg, Label label){
		super(address, IValue.ONE, MO_SC);
		this.name = name;
        this.reg = reg;
        this.label = label;
        this.label.addListener(this);
        addFilters(C11.LOCK);
    }

	private Lock(Lock other){
		super(other);
		this.name = other.name;
        this.reg = other.reg;
		this.label = other.label4Copy;
		Event notifier = label != null ? label : other.label;
		notifier.addListener(this);
    }

    @Override
    public String toString() {
        return "pthread_mutex_lock(&" + name + ")";
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
    
    public Register getResultRegister() {
    	return reg;
    }
    
    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public Lock getCopy(){
        return new Lock(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitLock(this);
	}
}