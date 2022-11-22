package com.dat3m.dartagnan.program.event.lang.pthread;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.dat3m.dartagnan.expression.IExpr;

public class Join extends Local {

    public Join(Register reg, IExpr expr) {
    	super(reg, expr);
        addFilters(Tag.C11.PTHREAD);
    }

    public Join(Join other){
    	super(other);
    }

    @Override
    public String toString() {
        return "pthread_join(" + expr + ")";
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
		return visitor.visitJoin(this);
	}
}