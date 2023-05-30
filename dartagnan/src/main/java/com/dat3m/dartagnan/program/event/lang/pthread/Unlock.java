package com.dat3m.dartagnan.program.event.lang.pthread;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import static com.dat3m.dartagnan.program.event.Tag.C11.MO_SC;

public class Unlock extends Store {
	
	private final String name;
	private final Register reg;

	public Unlock(String name, ExprInterface address, Register reg) {
		super(address, ExpressionFactory.getInstance().makeZero(TypeFactory.getInstance().getArchType()), MO_SC);
		this.name = name;
        this.reg = reg;
    }

	private Unlock(Unlock other){
		super(other);
		this.name = other.name;
        this.reg = other.reg;
    }

    @Override
    public String toString() {
        return "pthread_mutex_unlock(&" + name + ")";
    }
    
    public Register getResultRegister() {
    	return reg;
    }
    
    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public Unlock getCopy(){
        return new Unlock(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitUnlock(this);
	}
}