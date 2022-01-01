package com.dat3m.dartagnan.program.event.rmw;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.exception.ProgramProcessingException;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.Store;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.recursion.RecursiveAction;
import com.google.common.base.Preconditions;

public class RMWStore extends Store implements RegReaderData {

    protected final Load loadEvent;

    public RMWStore(Load loadEvent, IExpr address, ExprInterface value, String mo) {
        super(address, value, mo);
        Preconditions.checkArgument(loadEvent.is(EType.RMW), "The provided load event " + loadEvent + " is not tagged RMW.");
        this.loadEvent = loadEvent;
        addFilters(EType.RMW);
    }

    public Load getLoadEvent(){
        return loadEvent;
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    protected RecursiveAction unrollRecursive(int bound, Event predecessor, int depth) {
        throw new ProgramProcessingException("RMWStore cannot be unrolled: event must be generated during compilation");
    }
}
