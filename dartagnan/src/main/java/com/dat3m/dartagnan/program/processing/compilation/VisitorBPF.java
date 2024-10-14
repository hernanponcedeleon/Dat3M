package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.arch.bpf.*;
import com.dat3m.dartagnan.program.event.core.Label;
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

    @Override
    public List<Event> visitBPF_CAS(BPF_CAS e) {
        Register resultRegister = e.getResultRegister();
        Expression cmp = e.getExpectedValue();
        Expression address = e.getAddress();
        Register havocRegister = e.getFunction().getOrNewRegister("__guess", types.getBooleanType());

        Label success = newLabel("CAS_success");
        Label end = newLabel("CAS_end");
        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Load loadFail = EventFactory.newLoad(dummy, address);
        loadFail.addTags(Tag.RMW);
        Load loadSuccess;
        return eventSequence(
                EventFactory.Svcomp.newNonDetChoice(havocRegister),
                newJump(havocRegister, success),
                // Cas failure branch
                loadFail,
                newAssume(expressions.makeNEQ(dummy, cmp)),
                newGoto(end),
                success,
                // CAS success branch
                loadSuccess = newRMWLoadWithMo(dummy, address, Tag.BPF.SC),
                newAssume(expressions.makeEQ(dummy, cmp)),
                newRMWStoreWithMo(loadSuccess, address, e.getStoreValue(), Tag.BPF.SC),
                end,
                newLocal(resultRegister, dummy)
        );
    }

}
