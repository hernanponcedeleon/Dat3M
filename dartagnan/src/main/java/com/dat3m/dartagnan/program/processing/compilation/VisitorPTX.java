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
            store.addFilters(Tag.PTX.storeMO(filter));
        }
        load.addFilters(getScopeMo(e));
        load.addFilters(getProxyMo(e));
        store.addFilters(getScopeMo(e));
        store.addFilters(getProxyMo(e));
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
            store.addFilters(Tag.PTX.storeMO(filter));
        }
        load.addFilters(getScopeMo(e));
        load.addFilters(getProxyMo(e));
        store.addFilters(getScopeMo(e));
        store.addFilters(getProxyMo(e));
        return eventSequence(
                load,
                store
        );
    }

    private static String getScopeMo(Event e) {
        if(e.is(Tag.PTX.SYS)) {
            return Tag.PTX.SYS;
        }
        if(e.is(Tag.PTX.GPU)) {
            return Tag.PTX.GPU;
        }
        if(e.is(Tag.PTX.CTA)) {
            return Tag.PTX.CTA;
        }
        return "";
    }

    private static String getProxyMo(Event e) {
        if(e.is(Tag.PTX.GEN)) {
            return Tag.PTX.GEN;
        }
        if(e.is(Tag.PTX.TEX)) {
            return Tag.PTX.TEX;
        }
        if(e.is(Tag.PTX.SUR)) {
            return Tag.PTX.SUR;
        }
        if(e.is(Tag.PTX.CON)) {
            return Tag.PTX.CON;
        }
        return "";
    }

}
