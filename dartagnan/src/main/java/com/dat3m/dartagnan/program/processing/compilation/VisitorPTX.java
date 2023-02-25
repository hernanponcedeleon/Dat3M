package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.lang.linux.RMWFetchOp;
import com.dat3m.dartagnan.program.event.lang.linux.RMWOp;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import static com.dat3m.dartagnan.program.event.EventFactory.*;

public class VisitorPTX extends VisitorBase{

    protected VisitorPTX(boolean forceStart) {
        super(forceStart);
    }

    @Override
    public List<Event> visitRMWFetchOp(RMWFetchOp e) {
        Register resultRegister = e.getResultRegister();
        String mo = e.getMo();
        IExpr address = e.getAddress();
        ExprInterface value = e.getMemValue();

        Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
        Fence optionalMbBefore = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;
        Load load = newRMWLoad(dummy, address, Tag.Linux.loadMO(mo));
        Fence optionalMbAfter = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;
        RMWStore store = newRMWStore(load, address, new IExprBin(dummy, e.getOp(), (IExpr) value), Tag.Linux.storeMO(mo));

        Set<String> scopeFilters = getScopeFilters(e);
        load.addFilters(scopeFilters);
        store.addFilters(scopeFilters);
        addSemFilters(e, load);
        addSemFilters(e, store);

        return eventSequence(
                optionalMbBefore,
                load,
                store,
                newLocal(resultRegister, dummy),
                optionalMbAfter
        );
    }

    @Override
    public List<Event> visitRMWOp(RMWOp e) {
        IExpr address = e.getAddress();
        Register resultRegister = e.getResultRegister();

        Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
        Load load = newRMWLoad(dummy, address, Tag.Linux.MO_ONCE);
        load.addFilters(Tag.Linux.NORETURN);
        RMWStore store = newRMWStore(load, address,
                new IExprBin(dummy, e.getOp(), (IExpr) e.getMemValue()), Tag.Linux.MO_ONCE);

        Set<String> scopeFilters = getScopeFilters(e);
        load.addFilters(scopeFilters);
        store.addFilters(scopeFilters);
        addSemFilters(e, load);
        addSemFilters(e, store);

        return eventSequence(
                load,
                store
        );
    }

    private Set<String> getScopeFilters(Event e) {
        Set<String> filters = e.getFilters();
        Set<String> scopeFilters = new HashSet<>();
        for (String filter : filters) {
            if (filter.contains(Tag.PTX.CTA) || filter.contains(Tag.PTX.GPU)
                    || filter.contains(Tag.PTX.SYS)) {
                scopeFilters.add(filter);
            }
        }
        return scopeFilters;
    }

    private void addSemFilters(Event e, Load load) {
        if (e.is(Tag.PTX.ACQ_REL)) {
            load.addFilters(Tag.PTX.ACQ);
        } else if (e.is(Tag.PTX.RLX)) {
            load.addFilters(Tag.PTX.RLX);
        }
    }
    private void addSemFilters(Event e, Store store) {
        if (e.is(Tag.PTX.ACQ_REL)) {
            store.addFilters(Tag.PTX.REL);
        } else if (e.is(Tag.PTX.RLX)) {
            store.addFilters(Tag.PTX.RLX);
        }
    }

}
