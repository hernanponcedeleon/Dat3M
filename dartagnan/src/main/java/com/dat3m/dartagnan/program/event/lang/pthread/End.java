package com.dat3m.dartagnan.program.event.lang.pthread;

import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.dat3m.dartagnan.program.memory.Address;
import static com.dat3m.dartagnan.program.event.lang.catomic.utils.Mo.SC;

public class End extends Store {

    public End(Address address){
    	super(address, IConst.ZERO, SC);
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
		return visitor.visit(this);
	}
}