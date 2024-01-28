package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.arch.ptx.PTXAtomCAS;
import com.dat3m.dartagnan.program.event.arch.ptx.PTXAtomExch;
import com.dat3m.dartagnan.program.event.arch.ptx.PTXAtomOp;
import com.dat3m.dartagnan.program.event.arch.ptx.PTXRedOp;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.RMWStore;

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
        this.propagateTags(e, load);
        this.propagateTags(e, store);
        return eventSequence(
                load,
                store,
                newLocal(resultRegister, dummy)
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
        Expression storeValue = expressions.makeITE(expressions.makeEQ(resultRegister, expected),
                newValue, resultRegister);
        Load load = newRMWLoadWithMo(resultRegister, address, Tag.PTX.loadMO(mo));
        RMWStore store = newRMWStoreWithMo(load, address, storeValue, Tag.PTX.storeMO(mo));
        this.propagateTags(e, load);
        this.propagateTags(e, store);
        return eventSequence(
                load,
                store);
    }

    // PTX Exch semantics
    @Override
    public List<Event> visitPtxAtomExch(PTXAtomExch e) {
        Register resultRegister = e.getResultRegister();
        String mo = e.getMo();
        Expression address = e.getAddress();
        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Load load = newRMWLoadWithMo(dummy, address, Tag.PTX.loadMO(mo));
        RMWStore store = newRMWStoreWithMo(load, address, e.getValue(), Tag.PTX.storeMO(mo));
        this.propagateTags(e, load);
        this.propagateTags(e, store);
        return eventSequence(
                load,
                store,
                newLocal(resultRegister, dummy)
        );
    }

    @Override
    public List<Event> visitPtxRedOp(PTXRedOp e) {
        Expression address = e.getAddress();
        Register dummy = e.getFunction().newRegister(e.getAccessType());
        Load load = newRMWLoadWithMo(dummy, address, Tag.PTX.loadMO(e.getMo()));
        RMWStore store = newRMWStoreWithMo(load, address,
                expressions.makeBinary(dummy, e.getOperator(), e.getOperand()), Tag.PTX.storeMO(e.getMo()));
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
