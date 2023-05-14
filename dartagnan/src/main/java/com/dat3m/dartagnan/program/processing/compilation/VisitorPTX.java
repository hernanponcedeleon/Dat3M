package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.arch.ptx.RedOp;
import com.dat3m.dartagnan.program.event.arch.ptx.AtomOp;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStore;

import java.util.List;

import static com.dat3m.dartagnan.program.event.EventFactory.newRMWLoad;
import static com.dat3m.dartagnan.program.event.EventFactory.newRMWStore;
import static com.dat3m.dartagnan.program.event.EventFactory.eventSequence;
import static com.dat3m.dartagnan.program.event.EventFactory.newLocal;

public class VisitorPTX extends VisitorBase {

    protected VisitorPTX(boolean forceStart) {
        super(forceStart);
    }

    @Override
    public List<Event> visitPtxAtomOp(AtomOp e) {
        Register resultRegister = e.getResultRegister();
        String mo = e.getMo();
        IExpr address = e.getAddress();
        ExprInterface value = e.getMemValue();
        Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
        Load load = newRMWLoad(dummy, address, Tag.PTX.loadMO(mo));
        RMWStore store = newRMWStore(load, address,
                new IExprBin(dummy, e.getOp(), (IExpr) value), Tag.PTX.storeMO(mo));
        for (String filter : e.getFilters()) {
            load.addFilters(Tag.PTX.loadMO(filter));
            load.addFilters(Tag.PTX.scopeMo(filter));
            load.addFilters(Tag.PTX.proxyMo(filter));
            store.addFilters(Tag.PTX.storeMO(filter));
            store.addFilters(Tag.PTX.scopeMo(filter));
            store.addFilters(Tag.PTX.proxyMo(filter));
        }
        return eventSequence(
                load,
                store,
                newLocal(resultRegister, dummy)
        );
    }

    @Override
    public List<Event> visitPtxRedOp(RedOp e) {
        IExpr address = e.getAddress();
        Register resultRegister = e.getResultRegister();
        Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
        Load load = newRMWLoad(dummy, address, Tag.PTX.loadMO(e.getMo()));
        RMWStore store = newRMWStore(load, address,
                new IExprBin(dummy, e.getOp(), (IExpr) e.getMemValue()), Tag.PTX.storeMO(e.getMo()));
        for (String filter : e.getFilters()) {
            load.addFilters(Tag.PTX.loadMO(filter));
            load.addFilters(Tag.PTX.scopeMo(filter));
            load.addFilters(Tag.PTX.proxyMo(filter));
            store.addFilters(Tag.PTX.storeMO(filter));
            store.addFilters(Tag.PTX.scopeMo(filter));
            store.addFilters(Tag.PTX.proxyMo(filter));
        }
        return eventSequence(
                load,
                store
        );
    }

}
