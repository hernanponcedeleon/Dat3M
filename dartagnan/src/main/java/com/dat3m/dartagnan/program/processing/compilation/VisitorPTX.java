package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.configuration.Arch;
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
        Load load = newRMWLoad(dummy, address);
        RMWStore store = newRMWStore(load, address,
                expressions.makeBinary(dummy, e.getOperator(), e.getOperand()));
        Tag.propagateTags(Arch.PTX, e, load);
        Tag.propagateTags(Arch.PTX, e, store);
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
        Load load = newRMWLoad(dummy, address);
        RMWStore store = newRMWStore(load, address,
                expressions.makeBinary(dummy, e.getOperator(), e.getOperand()));
        Tag.propagateTags(Arch.PTX, e, load);
        Tag.propagateTags(Arch.PTX, e, store);
        return eventSequence(
                load,
                store
        );
    }
}
