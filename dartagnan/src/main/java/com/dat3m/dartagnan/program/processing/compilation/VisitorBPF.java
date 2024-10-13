package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.arch.bpf.*;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.RMWStore;

import java.util.List;

import static com.dat3m.dartagnan.program.event.EventFactory.*;

public class VisitorBPF extends VisitorBase {

    @Override
    public List<Event> visitBPF_RMWOp(BPF_RMWOp e) {
        Expression address = e.getAddress();
        Register dummy = e.getFunction().newRegister(e.getAccessType());
        Load load = newRMWLoad(dummy, address);
        RMWStore store = newRMWStore(load, address, expressions.makeIntBinary(dummy, e.getOperator(), e.getOperand()));
        return eventSequence(
                load,
                store
        );
    }

    @Override
    public List<Event> visitBPF_RMWOpReturn(BPF_RMWOpReturn e) {
        Register resultRegister = e.getResultRegister();
        String mo = e.getMo();
        Expression address = e.getAddress();
        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Load load = newRMWLoadWithMo(dummy, address, mo);
        RMWStore store = newRMWStoreWithMo(load, address, expressions.makeIntBinary(dummy, e.getOperator(), e.getOperand()), mo);
        return eventSequence(
                load,
                store,
                newLocal(resultRegister, dummy)
        );
    }
}
