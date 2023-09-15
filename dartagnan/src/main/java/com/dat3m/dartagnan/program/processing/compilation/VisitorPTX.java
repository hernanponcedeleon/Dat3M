package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.arch.ptx.PTXAtomOp;
import com.dat3m.dartagnan.program.event.arch.ptx.PTXRedOp;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStore;

import java.util.List;

import static com.dat3m.dartagnan.program.event.EventFactory.*;

public class VisitorPTX extends VisitorBase {

    @Override
    public List<Event> visitPtxAtomOp(PTXAtomOp e) {
        Register resultRegister = e.getResultRegister();
        String mo = e.getMo();
        Expression address = e.getAddress();
        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Load load = newRMWLoadWithMo(dummy, address, Tag.PTX.loadMO(mo));
        RMWStore store = newRMWStoreWithMo(load, address,
                expressions.makeBinary(dummy, e.getOperator(), e.getOperand()), Tag.PTX.storeMO(mo));
        Tag.PTX.propagateTags(e, load);
        Tag.PTX.propagateTags(e, store);
        return eventSequence(
                load,
                store,
                newLocal(resultRegister, dummy)
        );
    }

    @Override
    public List<Event> visitPtxRedOp(PTXRedOp e) {
        Expression address = e.getAddress();
        Register dummy = e.getFunction().newRegister(types.getArchType());
        Load load = newRMWLoadWithMo(dummy, address, Tag.PTX.loadMO(e.getMo()));
        RMWStore store = newRMWStoreWithMo(load, address,
                expressions.makeBinary(dummy, e.getOperator(), e.getOperand()), Tag.PTX.storeMO(e.getMo()));
        Tag.PTX.propagateTags(e, load);
        Tag.PTX.propagateTags(e, store);
        return eventSequence(
                load,
                store
        );
    }
}
