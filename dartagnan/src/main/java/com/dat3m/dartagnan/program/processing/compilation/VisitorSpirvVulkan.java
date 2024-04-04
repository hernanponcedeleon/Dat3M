package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.arch.vulkan.VulkanCmpXchg;
import com.dat3m.dartagnan.program.event.arch.vulkan.VulkanRMW;
import com.dat3m.dartagnan.program.event.arch.vulkan.VulkanRMWOp;
import com.dat3m.dartagnan.program.event.core.FenceWithId;
import com.dat3m.dartagnan.program.event.core.GenericVisibleEvent;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.lang.spirv.*;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static com.dat3m.dartagnan.program.event.EventFactory.eventSequence;

public class VisitorSpirvVulkan extends VisitorVulkan {

    @Override
    public List<Event> visitLoad(Load e) {
        Event load = EventFactory.newLoad(e.getResultRegister(), e.getAddress());
        load.removeTags(load.getTags());
        load.addTags(toVulkanTags(e.getTags()));
        return eventSequence(load);
    }

    @Override
    public List<Event> visitStore(Store e) {
        Event store = EventFactory.newStore(e.getAddress(), e.getMemValue());
        store.removeTags(store.getTags());
        store.addTags(toVulkanTags(e.getTags()));
        return eventSequence(store);
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
        Event fence = new GenericVisibleEvent(e.getName(), Tag.FENCE);
        fence.removeTags(fence.getTags());
        fence.addTags(toVulkanTags(e.getTags()));
        if (fence.getTags().contains(Tag.Vulkan.ACQ_REL)) {
            fence.addTags(Tag.Vulkan.ACQUIRE, Tag.Vulkan.RELEASE);
            fence.removeTags(Tag.Vulkan.ACQ_REL);
        }
        return eventSequence(fence);
    }

    @Override
    public List<Event> visitFenceWithId(FenceWithId e) {
        Event fence = EventFactory.newFenceWithId(e.getName(), e.getFenceID());
        fence.removeTags(fence.getTags());
        fence.addTags(toVulkanTags(e.getTags()));
        if (fence.getTags().contains(Tag.Vulkan.ACQ_REL)) {
            fence.addTags(Tag.Vulkan.ACQUIRE, Tag.Vulkan.RELEASE);
            fence.removeTags(Tag.Vulkan.ACQ_REL);
        }
        return eventSequence(fence);
    }

    private String moTagVulkan(String moSpv) {
        // There is no dedicated Vulkan tag for relaxed memory order
        if (Tag.Spirv.RELAXED.equals(moSpv)) {
            return Tag.Vulkan.ATOM;
        }
        return Tag.Spirv.toVulkan(moSpv);
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
        if (tags.contains(Tag.MEMORY)) {
            String scTag = Tag.Spirv.toVulkan(Tag.Spirv.getStorageClassTag(tags));
            if (scTag != null) {
                vTags.add(Tag.Vulkan.NON_PRIVATE);
            }
        }
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
}
