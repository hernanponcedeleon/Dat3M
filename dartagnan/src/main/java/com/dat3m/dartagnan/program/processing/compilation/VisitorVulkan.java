package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.arch.vulkan.VulkanCmpXchg;
import com.dat3m.dartagnan.program.event.arch.vulkan.VulkanRMW;
import com.dat3m.dartagnan.program.event.arch.vulkan.VulkanRMWOp;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.lang.spirv.*;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import static com.dat3m.dartagnan.program.event.EventFactory.*;

public class VisitorVulkan extends VisitorBase {

    @Override
    public List<Event> visitLoad(Load e) {
        return eventSequence(replaceTags(e));
    }

    @Override
    public List<Event> visitStore(Store e) {
        return eventSequence(replaceTags(e));
    }

    @Override
    public List<Event> visitSpirvLoad(SpirvLoad e) {
        e.addTags(Tag.Spirv.MEM_VISIBLE, Tag.Spirv.MEM_NON_PRIVATE);
        String mo = moTagVulkan(Tag.Spirv.getMoTag(e.getTags()));
        Load load = newLoadWithMo(e.getResultRegister(), e.getAddress(), mo);
        load.setFunction(e.getFunction());
        load.addTags(Tag.Vulkan.ATOM);
        load.addTags(toVulkanTags(e.getTags()));
        return eventSequence(load);
    }

    @Override
    public List<Event> visitSpirvStore(SpirvStore e) {
        e.addTags(Tag.Spirv.MEM_AVAILABLE, Tag.Spirv.MEM_NON_PRIVATE);
        String mo = moTagVulkan(Tag.Spirv.getMoTag(e.getTags()));
        Store store = newStoreWithMo(e.getAddress(), e.getMemValue(), mo);
        store.setFunction(e.getFunction());
        store.addTags(Tag.Vulkan.ATOM);
        store.addTags(toVulkanTags(e.getTags()));
        return eventSequence(store);
    }

    @Override
    public List<Event> visitSpirvXchg(SpirvXchg e) {
        e.addTags(Tag.Spirv.MEM_VISIBLE, Tag.Spirv.MEM_AVAILABLE, Tag.Spirv.MEM_NON_PRIVATE);
        String mo = moTagVulkan(Tag.Spirv.getMoTag(e.getTags()));
        String scope = Tag.Spirv.toVulkan(Tag.Spirv.getScopeTag(e.getTags()));
        VulkanRMW rmw = EventFactory.Vulkan.newRMW(e.getAddress(), e.getResultRegister(),
                e.getValue(), mo, scope);
        rmw.addTags(toVulkanTags(e.getTags()));
        rmw.setFunction(e.getFunction());
        return visitVulkanRMW(rmw);
    }

    @Override
    public List<Event> visitSpirvRMW(SpirvRmw e) {
        e.addTags(Tag.Spirv.MEM_VISIBLE, Tag.Spirv.MEM_AVAILABLE, Tag.Spirv.MEM_NON_PRIVATE);
        String mo = moTagVulkan(Tag.Spirv.getMoTag(e.getTags()));
        String scope = Tag.Spirv.toVulkan(Tag.Spirv.getScopeTag(e.getTags()));
        VulkanRMWOp rmwOp = EventFactory.Vulkan.newRMWOp(e.getAddress(), e.getResultRegister(),
                e.getOperand(), e.getOperator(), mo, scope);
        rmwOp.setFunction(e.getFunction());
        rmwOp.addTags(toVulkanTags(e.getTags()));
        return visitVulkanRMWOp(rmwOp);
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
        String scope = Tag.Spirv.toVulkan(Tag.Spirv.getScopeTag(e.getTags()));
        eqTags.addAll(Set.of(Tag.Spirv.MEM_VISIBLE, Tag.Spirv.MEM_AVAILABLE, Tag.Spirv.MEM_NON_PRIVATE));
        VulkanCmpXchg cmpXchg = EventFactory.Vulkan.newVulkanCmpXchg(e.getAddress(), e.getResultRegister(),
                e.getExpectedValue(), e.getStoreValue(), moTagVulkan(spvMoEq), scope);
        cmpXchg.setFunction(e.getFunction());
        cmpXchg.addTags(toVulkanTags(eqTags));

        return visitVulkanCmpXchg(cmpXchg);
    }

    @Override
    public List<Event> visitGenericVisibleEvent(GenericVisibleEvent e) {
        if (e.getTags().contains(Tag.Spirv.ACQ_REL)) {
            e.addTags(Tag.Spirv.ACQUIRE, Tag.Spirv.RELEASE);
            e.removeTags(Tag.Spirv.ACQ_REL);
        }
        return eventSequence(replaceTags(e));
    }

    @Override
    public List<Event> visitFenceWithId(FenceWithId e) {
        if (e.getTags().contains(Tag.Spirv.ACQ_REL)) {
            e.addTags(Tag.Spirv.ACQUIRE, Tag.Spirv.RELEASE);
            e.removeTags(Tag.Spirv.ACQ_REL);
        }
        return eventSequence(replaceTags(e));
    }

    private String moTagVulkan(String moSpv) {
        // There is no dedicated Vulkan tag for relaxed memory order
        if (Tag.Spirv.RELAXED.equals(moSpv)) {
            return Tag.Vulkan.ATOM;
        }
        return Tag.Spirv.toVulkan(moSpv);
    }

    private Event replaceTags(Event e) {
        Set<String> vTags = toVulkanTags(e.getTags());
        e.removeTags(e.getTags());
        e.addTags(vTags);
        return e;
    }

    private Set<String> toVulkanTags(Set<String> tags) {
        Set<String> vTags = new HashSet<>();
        tags.forEach(tag -> {
            if (Tag.Spirv.isSpirvTag(tag)) {
                String vTag = Tag.Spirv.toVulkan(tag);
                if (vTag != null) {
                    vTags.add(vTag);
                }
            } else {
                vTags.add(tag);
            }
        });
        if (tags.contains(Tag.Spirv.MEM_AVAILABLE) && tags.contains(Tag.Spirv.DEVICE)) {
            vTags.add(Tag.Vulkan.AVDEVICE);
        }
        if (tags.contains(Tag.Spirv.MEM_VISIBLE) && tags.contains(Tag.Spirv.DEVICE)) {
            vTags.add(Tag.Vulkan.VISDEVICE);
        }
        if (tags.contains(Tag.Spirv.RELAXED)) {
            vTags.remove(Tag.Vulkan.SEMSC0);
            vTags.remove(Tag.Vulkan.SEMSC1);
            vTags.remove(Tag.Vulkan.SEM_VISIBLE);
            vTags.remove(Tag.Vulkan.SEM_AVAILABLE);
        }
        return vTags;
    }

    @Override
    public List<Event> visitVulkanRMW(VulkanRMW e) {
        Register resultRegister = e.getResultRegister();
        String mo = e.getMo();
        Expression address = e.getAddress();
        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Load load = newRMWLoadWithMo(dummy, address, Tag.Vulkan.loadMO(mo));
        RMWStore store = newRMWStoreWithMo(load, address, e.getValue(), Tag.Vulkan.storeMO(mo));
        this.propagateTags(e, load);
        this.propagateTags(e, store);
        return eventSequence(
                load,
                store,
                newLocal(resultRegister, dummy)
        );
    }

    @Override
    public List<Event> visitVulkanRMWOp(VulkanRMWOp e) {
        Register resultRegister = e.getResultRegister();
        String mo = e.getMo();
        Expression address = e.getAddress();
        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Load load = newRMWLoadWithMo(dummy, address, Tag.Vulkan.loadMO(mo));
        RMWStore store = newRMWStoreWithMo(load, address,
                expressions.makeIntBinary(dummy, e.getOperator(), e.getOperand()), Tag.Vulkan.storeMO(mo));
        this.propagateTags(e, load);
        this.propagateTags(e, store);
        return eventSequence(
                load,
                store,
                newLocal(resultRegister, dummy)
        );
    }

    @Override
    public List<Event> visitVulkanCmpXchg(VulkanCmpXchg e) {
        Register resultRegister = e.getResultRegister();
        String mo = e.getMo();
        Expression address = e.getAddress();
        Expression expected = e.getExpectedValue();
        Expression newValue = e.getStoreValue();
        Expression storeValue = expressions.makeITE(expressions.makeEQ(resultRegister, expected),
                newValue, resultRegister);
        Load load = newRMWLoadWithMo(resultRegister, address, Tag.Vulkan.loadMO(mo));
        RMWStore store = newRMWStoreWithMo(load, address, storeValue, Tag.Vulkan.storeMO(mo));
        this.propagateTags(e, load);
        this.propagateTags(e, store);
        return eventSequence(
                load,
                store
        );
    }

    private void propagateTags(Event source, Event target) {
        for (String tag : List.of(Tag.Vulkan.SUB_GROUP, Tag.Vulkan.WORK_GROUP, Tag.Vulkan.QUEUE_FAMILY, Tag.Vulkan.DEVICE,
                Tag.Vulkan.NON_PRIVATE, Tag.Vulkan.ATOM, Tag.Vulkan.SC0, Tag.Vulkan.SC1, Tag.Vulkan.SEMSC0, Tag.Vulkan.SEMSC1)) {
            if (source.hasTag(tag)) {
                target.addTags(tag);
            }
        }
        if (target instanceof Load) {
            // Atomic loads are always visible
            if (source.hasTag(Tag.Vulkan.ATOM)) {
                target.addTags(Tag.Vulkan.VISIBLE);
            }
            if (source.hasTag(Tag.Vulkan.SEM_VISIBLE)) {
                target.addTags(Tag.Vulkan.SEM_VISIBLE);
            }
            // If a RMW is a release, we do not propagate semscX to the read
            if (!(source.hasTag(Tag.Vulkan.ACQUIRE) || source.hasTag(Tag.Vulkan.ACQ_REL))) {
                if (target.hasTag(Tag.Vulkan.SEMSC0)) {
                    target.removeTags(Tag.Vulkan.SEMSC0);
                }
                if (target.hasTag(Tag.Vulkan.SEMSC1)) {
                    target.removeTags(Tag.Vulkan.SEMSC1);
                }
            }
            if (source.hasTag(Tag.Vulkan.VISDEVICE)) {
                target.addTags(Tag.Vulkan.VISDEVICE);
            }
        } else if (target instanceof Store) {
            // Atomic stores are always available
            if (source.hasTag(Tag.Vulkan.ATOM)) {
                target.addTags(Tag.Vulkan.AVAILABLE);
            }
            if (source.hasTag(Tag.Vulkan.SEM_AVAILABLE)) {
                target.addTags(Tag.Vulkan.SEM_AVAILABLE);
            }
            // If a RMW is an acquire, we do not propagate semscX to the write
            if (!(source.hasTag(Tag.Vulkan.RELEASE) || source.hasTag(Tag.Vulkan.ACQ_REL))) {
                if (target.hasTag(Tag.Vulkan.SEMSC0)) {
                    target.removeTags(Tag.Vulkan.SEMSC0);
                }
                if (target.hasTag(Tag.Vulkan.SEMSC1)) {
                    target.removeTags(Tag.Vulkan.SEMSC1);
                }
            }
            if (source.hasTag(Tag.Vulkan.AVDEVICE)) {
                target.addTags(Tag.Vulkan.AVDEVICE);
            }
        }
    }
}
