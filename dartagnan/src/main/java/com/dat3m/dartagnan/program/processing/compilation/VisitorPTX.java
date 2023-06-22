package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.arch.ptx.AtomOp;
import com.dat3m.dartagnan.program.event.arch.ptx.RedOp;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStore;

import java.util.List;

import static com.dat3m.dartagnan.program.event.EventFactory.*;

public class VisitorPTX extends VisitorBase {

    protected VisitorPTX(boolean forceStart) {
        super(forceStart);
    }

    @Override
    public List<Event> visitPtxAtomOp(AtomOp e) {
        Register resultRegister = e.getResultRegister();
        String mo = e.getMo();
        Expression address = e.getAddress();
        Expression value = e.getMemValue();
        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Load load = newRMWLoadWithMo(dummy, address, Tag.PTX.loadMO(mo));
        RMWStore store = newRMWStoreWithMo(load, address,
                expressions.makeBinary(dummy, e.getOp(), value), Tag.PTX.storeMO(mo));
        load.addTags(Tag.PTX.getScopeTag(e), Tag.PTX.getProxyTag(e));
        store.addTags(Tag.PTX.getScopeTag(e), Tag.PTX.getProxyTag(e));
        return eventSequence(
                load,
                store,
                newLocal(resultRegister, dummy)
        );
    }

    @Override
    public List<Event> visitPtxRedOp(RedOp e) {
        Expression address = e.getAddress();
        Register resultRegister = e.getResultRegister();
        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Load load = newRMWLoadWithMo(dummy, address, Tag.PTX.loadMO(e.getMo()));
        RMWStore store = newRMWStoreWithMo(load, address,
                expressions.makeBinary(dummy, e.getOp(), e.getMemValue()), Tag.PTX.storeMO(e.getMo()));
        load.addTags(Tag.PTX.getScopeTag(e), Tag.PTX.getProxyTag(e));
        store.addTags(Tag.PTX.getScopeTag(e), Tag.PTX.getProxyTag(e));
        return eventSequence(
                load,
                store
        );
    }
}
