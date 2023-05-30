package com.dat3m.dartagnan.program.event.lang.pthread;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import static com.dat3m.dartagnan.program.event.Tag.C11.MO_SC;

public class End extends Store {

    public End(ExprInterface address){
    	super(address, ExpressionFactory.getInstance().makeZero(TypeFactory.getInstance().getArchType()), MO_SC);
    	addTags(Tag.C11.PTHREAD);
    }

    private End(End other){
    	super(other);
    }

    @Override
    public String toString() {
        return "end_thread()";
    }
	
    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public End getCopy(){
        return new End(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitEnd(this);
	}
}