package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.lang.linux.RMWOp;

import java.util.List;
import java.util.Set;

import static com.dat3m.dartagnan.program.event.EventFactory.*;

public class VisitorPTX extends VisitorBase{

    protected VisitorPTX(boolean forceStart) {
        super(forceStart);
    }

    @Override
    public List<Event> visitRMWOp(RMWOp e) {
        Register resultRegister = e.getResultRegister();
        IExpr address = e.getAddress();
        String mo = e.getMo();
        Register dummyReg = e.getThread().newRegister(resultRegister.getPrecision());
        Load load = newRMWLoad(dummyReg, address, mo);
        RMWStore store = newRMWStore(load, address, new IExprBin(dummyReg, e.getOp(),
                (IExpr) e.getMemValue()), Tag.Linux.MO_ONCE);
        Set<String> filters = e.getFilters();
        for (String filter : filters) {
            if (filter.contains(Tag.PTX.CTA) || filter.contains(Tag.PTX.GPU)
                    || filter.contains(Tag.PTX.SYS)) {
                load.addFilters(filter);
            }
        }
        return eventSequence(
                load,
                store,
                newLocal(resultRegister, dummyReg)
        );
    }
//    public List<Event> visitRMWOp(RMWOp e) {
//        IExpr address = e.getAddress();
//        Register resultRegister = e.getResultRegister();
//
//        Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
//        Load load = newRMWLoad(dummy, address, Tag.Linux.MO_ONCE);
//        load.addFilters(Tag.Linux.NORETURN);
//        RMWStore store = newRMWStore(load, address, new IExprBin(dummy, e.getOp(),
//                (IExpr) e.getMemValue()), Tag.Linux.MO_ONCE);
//
//        Set<String> filters = e.getFilters();
//        for (String filter : filters) {
//            if (filter.contains(Tag.PTX.CTA) || filter.contains(Tag.PTX.GPU)
//                    || filter.contains(Tag.PTX.SYS)) {
//                load.addFilters(filter);
//            }
//        }
//
//        return eventSequence(load, store);
//    }

}
