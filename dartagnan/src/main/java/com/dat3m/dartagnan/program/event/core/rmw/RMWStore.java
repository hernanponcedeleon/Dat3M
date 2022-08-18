package com.dat3m.dartagnan.program.event.core.rmw;

import com.dat3m.dartagnan.exception.ProgramProcessingException;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.base.Preconditions;

public class RMWStore extends Store {

    protected final Load loadEvent;

    public RMWStore(Load loadEvent, IExpr address, ExprInterface value, String mo) {
        super(address, value, mo);
        Preconditions.checkArgument(loadEvent.is(Tag.RMW), "The provided load event " + loadEvent + " is not tagged RMW.");
        this.loadEvent = loadEvent;
        addFilters(Tag.RMW);
    }

    public Load getLoadEvent(){
        return loadEvent;
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
	public RMWStore getCopy(){
        throw new ProgramProcessingException(getClass().getName() + " cannot be unrolled: event must be generated during compilation");
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitRMWStore(this);
	}
}