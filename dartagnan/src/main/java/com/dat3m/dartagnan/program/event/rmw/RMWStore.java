package com.dat3m.dartagnan.program.event.rmw;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.Store;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.utils.EType;

public class RMWStore extends Store implements RegReaderData {

    protected final Load loadEvent;

    public RMWStore(Load loadEvent, IExpr address, ExprInterface value, String mo) {
        super(address, value, mo);
        if (!loadEvent.is(EType.RMW)) {
            throw new IllegalArgumentException("The provided load event " + loadEvent + " is not tagged RMW.");
        }
        this.loadEvent = loadEvent;
        addFilters(EType.RMW);
    }

    public Load getLoadEvent(){
        return loadEvent;
    }

}
