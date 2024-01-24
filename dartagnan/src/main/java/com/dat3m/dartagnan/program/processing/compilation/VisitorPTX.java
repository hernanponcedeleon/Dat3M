package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.arch.ptx.PTXAtomCAS;
import com.dat3m.dartagnan.program.event.arch.ptx.PTXAtomExch;
import com.dat3m.dartagnan.program.event.arch.ptx.PTXAtomOp;
import com.dat3m.dartagnan.program.event.arch.ptx.PTXRedOp;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.RMWStore;

import java.util.List;

import static com.dat3m.dartagnan.program.event.EventFactory.eventSequence;

public class VisitorPTX extends VisitorBase<EventFactory.PTX> {

    VisitorPTX(EventFactory events) {
        super(events.withPTX());
    }

    @Override
    public List<Event> visitPtxAtomOp(PTXAtomOp e) {
        Register resultRegister = e.getResultRegister();
        String mo = e.getMo();
        Expression address = e.getAddress();
        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Expression modifiedValue = expressions.makeBinary(dummy, e.getOperator(), e.getOperand());
        Load load = eventFactory.newRMWLoadWithMo(dummy, address, Tag.PTX.loadMO(mo));
        RMWStore store = eventFactory.newRMWStoreWithMo(load, address, modifiedValue, Tag.PTX.storeMO(mo));
        this.propagateTags(e, load);
        this.propagateTags(e, store);
        return eventSequence(
                load,
                store,
                eventFactory.newLocal(resultRegister, dummy)
        );
    }

    // PTX CAS semantics from
    // https://docs.nvidia.com/cuda/parallel-thread-execution/index.html#parallel-synchronization-and-communication-instructions-atom
    // atomic {
    //   d = *a;                    <-- destination/result register
    //   *a = (*a == b) ? c : *a    <-- we interpret this as a cmov
    // }
    @Override
    public List<Event> visitPtxAtomCAS(PTXAtomCAS e) {
        Register resultRegister = e.getResultRegister();
        String mo = e.getMo();
        Expression address = e.getAddress();
        Expression expected = e.getExpectedValue();
        Expression newValue = e.getStoreValue();
        Expression isExpectedValue = expressions.makeEQ(resultRegister, expected);
        Expression storeValue = expressions.makeITE(isExpectedValue, newValue, resultRegister);
        Load load = eventFactory.newRMWLoadWithMo(resultRegister, address, Tag.PTX.loadMO(mo));
        RMWStore store = eventFactory.newRMWStoreWithMo(load, address, storeValue, Tag.PTX.storeMO(mo));
        this.propagateTags(e, load);
        this.propagateTags(e, store);
        return eventSequence(
                load,
                store
        );
    }

    // PTX Exch semantics
    @Override
    public List<Event> visitPtxAtomExch(PTXAtomExch e) {
        Register resultRegister = e.getResultRegister();
        String mo = e.getMo();
        Expression address = e.getAddress();
        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Load load = eventFactory.newRMWLoadWithMo(dummy, address, Tag.PTX.loadMO(mo));
        RMWStore store = eventFactory.newRMWStoreWithMo(load, address, e.getValue(), Tag.PTX.storeMO(mo));
        this.propagateTags(e, load);
        this.propagateTags(e, store);
        return eventSequence(
                load,
                store,
                eventFactory.newLocal(resultRegister, dummy)
        );
    }

    @Override
    public List<Event> visitPtxRedOp(PTXRedOp e) {
        Expression address = e.getAddress();
        Register dummy = e.getFunction().newRegister(e.getAccessType());
        Expression modifiedValue = expressions.makeBinary(dummy, e.getOperator(), e.getOperand());
        Load load = eventFactory.newRMWLoadWithMo(dummy, address, Tag.PTX.loadMO(e.getMo()));
        RMWStore store = eventFactory.newRMWStoreWithMo(load, address, modifiedValue, Tag.PTX.storeMO(e.getMo()));
        this.propagateTags(e, load);
        this.propagateTags(e, store);
        return eventSequence(
                load,
                store
        );
    }

    private void propagateTags(Event source, Event target) {
        for (String tag : List.of(Tag.PTX.CTA, Tag.PTX.GPU, Tag.PTX.SYS, Tag.PTX.GEN, Tag.PTX.TEX, Tag.PTX.SUR, Tag.PTX.CON)) {
            if (source.hasTag(tag)) {
                target.addTags(tag);
            }
        }
    }
}
