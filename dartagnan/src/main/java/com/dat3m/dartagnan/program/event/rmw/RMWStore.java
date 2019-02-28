package com.dat3m.dartagnan.program.event.rmw;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.event.Store;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.utils.EType;

public class RMWStore extends Store implements RegReaderData {

    protected final RMWLoad loadEvent;

    public RMWStore(RMWLoad loadEvent, IExpr address, ExprInterface value, String mo) {
        super(address, value, mo);
        this.loadEvent = loadEvent;
        addFilters(EType.RMW);
    }

    protected RMWStore(RMWStore other){
        super(other);
        // Load event can be null for unpaired RMWStoreOpt
        this.loadEvent = other.loadEvent != null ? (RMWLoad)other.loadEvent.getCopy() : null;
    }

    public RMWLoad getLoadEvent(){
        return loadEvent;
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    protected RMWStore mkCopy(){
        return new RMWStore(this);
    }
}
