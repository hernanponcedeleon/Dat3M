package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
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
        Load load = newLoadWithMo(e.getResultRegister(), e.getAddress(), moTagVulkan(e));
        load.setFunction(e.getFunction());
        load.addTags(Tag.Vulkan.ATOM, Tag.Vulkan.VISIBLE, Tag.Vulkan.NON_PRIVATE);
        load.addTags(toVulkanTags(e.getTags()));
        return eventSequence(load);
    }

    @Override
    public List<Event> visitSpirvStore(SpirvStore e) {
        Store store = newStoreWithMo(e.getAddress(), e.getMemValue(), moTagVulkan(e));
        store.setFunction(e.getFunction());
        store.addTags(Tag.Vulkan.ATOM, Tag.Vulkan.AVAILABLE, Tag.Vulkan.NON_PRIVATE);
        store.addTags(toVulkanTags(e.getTags()));
        return eventSequence(store);
    }

    @Override
    public List<Event> visitSpirvXchg(SpirvXchg e) {
        VulkanRMW rmw = EventFactory.Vulkan.newRMW(e.getAddress(), e.getResultRegister(),
                e.getValue(), moTagVulkan(e), scopeTagVulkan(e));
        rmw.addTags(Tag.Vulkan.ATOM, Tag.Vulkan.NON_PRIVATE);
        rmw.addTags(toVulkanTags(e.getTags()));
        rmw.setFunction(e.getFunction());
        return visitVulkanRMW(rmw);
    }

    @Override
    public List<Event> visitSpirvRMW(SpirvRmw e) {
        VulkanRMWOp rmwOp = EventFactory.Vulkan.newRMWOp(e.getAddress(), e.getResultRegister(),
                e.getOperand(), e.getOperator(), moTagVulkan(e), scopeTagVulkan(e));
        rmwOp.setFunction(e.getFunction());
        rmwOp.addTags(Tag.Vulkan.ATOM, Tag.Vulkan.NON_PRIVATE);
        rmwOp.addTags(toVulkanTags(e.getTags()));
        return visitVulkanRMWOp(rmwOp);
    }

    @Override
    public List<Event> visitSpirvCmpXchg(SpirvCmpXchg e) {
        if (!e.getTags().equals(e.getEqTags())) {
            throw new UnsupportedOperationException(
                    "Spir-V CmpXchg operations with unequal tag sets are not supported");
        }
        String mo = moTagVulkan(e);
        Set<String> tags = toVulkanTags(e.getEqTags());
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        Expression expected = e.getExpectedValue();
        Expression newValue = e.getStoreValue();
        Load load = newRMWLoadWithMo(resultRegister, address, Tag.Vulkan.loadMO(mo));
        load.addTags(tags);
        Expression storeValue = expressions.makeITE(expressions.makeEQ(resultRegister, expected),
                newValue, resultRegister);
        RMWStore store = newRMWStoreWithMo(load, address, storeValue, Tag.Vulkan.storeMO(mo));
        store.addTags(tags);
        this.propagateTags(e, load);
        this.propagateTags(e, store);
        return eventSequence(load, store);
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

    private String moTagVulkan(Event e) {
        // There is no dedicated Vulkan tag for relaxed memory order
        if (Tag.Spirv.RELAXED.equals(Tag.Spirv.getMoTag(e.getTags()))) {
            return Tag.Vulkan.ATOM;
        }
        return Tag.Spirv.toVulkan(Tag.Spirv.getMoTag(e.getTags()));
    }

    private String scopeTagVulkan(Event e) {
        return Tag.Spirv.toVulkan(Tag.Spirv.getScopeTag(e.getTags()));
    }

    private Event replaceTags(Event e) {
        Set<String> tags = new HashSet<>();
        for (String tag : e.getTags()) {
            if (Tag.Spirv.isSpirvTag(tag)) {
                String vTag = Tag.Spirv.toVulkan(tag);
                if (vTag != null) {
                    tags.add(vTag);
                }
            } else {
                tags.add(tag);
            }
        }
        if (e.getTags().contains(Tag.Spirv.MEM_AVAILABLE) && e.getTags().contains(Tag.Spirv.DEVICE)) {
            tags.add(Tag.Vulkan.AVDEVICE);
        }
        if (e.getTags().contains(Tag.Spirv.MEM_VISIBLE) && e.getTags().contains(Tag.Spirv.DEVICE)) {
            tags.add(Tag.Vulkan.VISDEVICE);
        }
        e.removeTags(e.getTags());
        e.addTags(tags);
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
        }
    }
}
