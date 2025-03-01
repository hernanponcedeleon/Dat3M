package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.arch.opencl.OpenCLRMWExtremum;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.lang.catomic.AtomicFetchOp;
import com.dat3m.dartagnan.program.event.lang.catomic.AtomicXchg;
import com.dat3m.dartagnan.program.event.lang.spirv.*;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import static com.dat3m.dartagnan.program.event.EventFactory.*;

public class VisitorSpirvOpenCL extends VisitorC11 {

    @Override
    public List<Event> visitLoad(Load e) {
        Event load = EventFactory.newLoad(e.getResultRegister(), e.getAddress());
        load.addTags(toOpenCLTags(e.getTags()));
        return eventSequence(load);
    }

    @Override
    public List<Event> visitStore(Store e) {
        Event store = EventFactory.newStore(e.getAddress(), e.getMemValue());
        store.addTags(toOpenCLTags(e.getTags()));
        return eventSequence(store);
    }

    @Override
    public List<Event> visitSpirvLoad(SpirvLoad e) {
        String mo = moToOpenCLTag(Tag.Spirv.getMoTag(e.getTags()));
        Load load = newLoadWithMo(e.getResultRegister(), e.getAddress(), mo);
        load.setFunction(e.getFunction());
        load.addTags(Tag.C11.ATOMIC);
        load.addTags(toOpenCLTags(e.getTags()));
        return eventSequence(load);
    }

    @Override
    public List<Event> visitSpirvStore(SpirvStore e) {
        String mo = moToOpenCLTag(Tag.Spirv.getMoTag(e.getTags()));
        Store store = newStoreWithMo(e.getAddress(), e.getMemValue(), mo);
        store.setFunction(e.getFunction());
        store.addTags(Tag.C11.ATOMIC);
        store.addTags(toOpenCLTags(e.getTags()));
        return eventSequence(store);
    }

    @Override
    public List<Event> visitSpirvXchg(SpirvXchg e) {
        String mo = moToOpenCLTag(Tag.Spirv.getMoTag(e.getTags()));
        AtomicXchg rmw = Atomic.newExchange(e.getResultRegister(), e.getAddress(),
                e.getValue(), mo);
        rmw.addTags(toOpenCLTags(e.getTags()));
        rmw.setFunction(e.getFunction());
        return visitAtomicXchg(rmw);
    }

    @Override
    public List<Event> visitSpirvRMW(SpirvRmw e) {
        String mo = moToOpenCLTag(Tag.Spirv.getMoTag(e.getTags()));
        AtomicFetchOp rmwOp = Atomic.newFetchOp(e.getResultRegister(), e.getAddress(),
                e.getOperand(), e.getOperator(), mo);
        rmwOp.setFunction(e.getFunction());
        rmwOp.addTags(toOpenCLTags(e.getTags()));
        return visitAtomicFetchOp(rmwOp);
    }

    @Override
    public List<Event> visitSpirvCmpXchg(SpirvCmpXchg e) {
        Set<String> eqTags = new HashSet<>(e.getEqTags());
        Set<String> neqTags = new HashSet<>(e.getTags());
        String spvMoEq = Tag.Spirv.getMoTag(eqTags);
        String spvMoNeq = Tag.Spirv.getMoTag(neqTags);
        eqTags.remove(spvMoEq);
        neqTags.remove(spvMoNeq);
        if (!eqTags.equals(neqTags) ||
                spvMoNeq.equals(Tag.Spirv.RELAXED) && Set.of(Tag.Spirv.ACQUIRE, Tag.Spirv.ACQ_REL).contains(spvMoEq) ||
                spvMoNeq.equals(Tag.Spirv.ACQUIRE) && spvMoEq.equals(Tag.Spirv.RELEASE)) {
            throw new UnsupportedOperationException(
                    "Spir-V CmpXchg with unequal tag sets is not supported");
        }
        String scope = Tag.Spirv.toOpenCLTag(Tag.Spirv.getScopeTag(e.getTags()));
        String storageClass = Tag.Spirv.toOpenCLTag(Tag.Spirv.getStorageClassTag(e.getTags()));
        e.addTags(scope, storageClass);
        String mo = Tag.Spirv.toOpenCLTag(spvMoEq);
        if (mo == null) {
            mo = Tag.C11.MO_RELAXED;
        }
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        Expression expected = e.getExpectedValue();
        Expression value = e.getStoreValue();
        Register cmpResultRegister = e.getFunction().newRegister(types.getBooleanType());
        Label casEnd = newLabel("CAS_end");
        Load load = newRMWLoadWithMo(resultRegister, address, Tag.C11.loadMO(mo));
        RMWStore store = newRMWStoreWithMo(load, address, value, Tag.C11.storeMO(mo));
        Local local = newLocal(cmpResultRegister, expressions.makeEQ(resultRegister, expected));
        CondJump condJump = newJumpUnless(cmpResultRegister, casEnd);
        return tagList(e, eventSequence(
                load,
                local,
                condJump,
                store,
                casEnd
        ));
    }

    @Override
    public List<Event> visitSpirvRmwExtremum(SpirvRmwExtremum e) {
        String mo = moToOpenCLTag(Tag.Spirv.getMoTag(e.getTags()));
        OpenCLRMWExtremum rmw = Atomic.newRMWExtremum(e.getResultRegister(), e.getAddress(),
                e.getOperator(), e.getValue(), mo);
        rmw.setFunction(e.getFunction());
        rmw.addTags(toOpenCLTags(e.getTags()));
        return visitOpenCLRMWExtremum(rmw);
    }

    @Override
    public List<Event> visitGenericVisibleEvent(GenericVisibleEvent e) {
        Event fence = new GenericVisibleEvent(e.getName(), Tag.FENCE);
        fence.removeTags(fence.getTags());
        fence.addTags(toOpenCLTags(e.getTags()));
        return eventSequence(fence);
    }

    @Override
    public List<Event> visitControlBarrier(ControlBarrier e) {
        ControlBarrier barrier = new ControlBarrier(e.getName(), e.getInstanceId());
        barrier.addTags(toOpenCLTags(e.getTags()));
        return super.visitControlBarrier(barrier);
    }

    private static Set<String> toOpenCLTags(Set<String> tags) {
        Set<String> openclTags = new HashSet<>();
        tags.forEach(tag -> {
            if (Tag.Spirv.isSpirvTag(tag)) {
                String vTag = Tag.Spirv.toOpenCLTag(tag);
                if (vTag != null) {
                    openclTags.add(vTag);
                }
            } else {
                openclTags.add(tag);
            }
        });
        return openclTags;
    }

    private static String moToOpenCLTag(String moSpv) {
        if (Tag.Spirv.RELAXED.equals(moSpv)) {
            return Tag.C11.ATOMIC;
        }
        return Tag.Spirv.toOpenCLTag(moSpv);
    }
}
