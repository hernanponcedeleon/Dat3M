package com.dat3m.dartagnan.program.event.lang.pthread;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import static com.dat3m.dartagnan.program.event.Tag.C11.MO_SC;

public class Lock extends Store {
	
	private final String name;
	private final Register reg;

	public Lock(String name, IExpr address, Register reg){
		super(address, IValue.ONE, MO_SC);
		this.name = name;
        this.reg = reg;
    }

	private Lock(Lock other){
		super(other);
		this.name = other.name;
        this.reg = other.reg;
    }

    @Override
    public String toString() {
        return "pthread_mutex_lock(&" + name + ")";
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