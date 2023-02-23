package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.lang.catomic.AtomicFetchOp;

import java.util.List;
import java.util.Set;

import static com.dat3m.dartagnan.program.event.EventFactory.*;

public class VisitorPTX extends VisitorBase{

    protected VisitorPTX(boolean forceStart) {
        super(forceStart);
    }

    @Override
    public List<Event> visitAtomicFetchOp(AtomicFetchOp e) {
        Register resultRegister = e.getResultRegister();
        IOpBin op = e.getOp();
        IExpr address = e.getAddress();
        String mo = e.getMo();

        Register dummyReg = e.getThread().newRegister(resultRegister.getPrecision());
        Load load = newRMWLoad(resultRegister, address, mo);
        RMWStore store = newRMWStore(load, address, dummyReg, mo);

        Set<String> filters = e.getFilters();
        for (String filter : filters) {
            if (filter.contains(Tag.PTX.CTA) || filter.contains(Tag.PTX.GPU)
                    || filter.contains(Tag.PTX.SYS)) {
                load.addFilters(filter);
                store.addFilters(filter);
            }
        }
        return tagList(eventSequence(
                load,
                newLocal(dummyReg, new IExprBin(resultRegister, op, (IExpr) e.getMemValue())),
                store
        ));
    }

    private List<Event> tagList(List<Event> in) {
        for (Event e : in) {
            e.addFilters(Tag.RMW, Tag.PTX.ATOM);
        }
        return in;
    }
}
