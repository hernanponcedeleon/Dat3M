package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.arch.vulkan.VulkanCmpXchg;
import com.dat3m.dartagnan.program.event.arch.vulkan.VulkanRMW;
import com.dat3m.dartagnan.program.event.arch.vulkan.VulkanRMWExtremum;
import com.dat3m.dartagnan.program.event.arch.vulkan.VulkanRMWOp;
import com.dat3m.dartagnan.program.event.core.ControlBarrier;
import com.dat3m.dartagnan.program.event.core.GenericVisibleEvent;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.lang.spirv.*;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import static com.dat3m.dartagnan.program.event.EventFactory.*;

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
        String mo = moToVulkanTag(Tag.Spirv.getMoTag(e.getTags()));
        Load load = newLoadWithMo(e.getResultRegister(), e.getAddress(), mo);
        load.setFunction(e.getFunction());
        load.addTags(Tag.Vulkan.ATOM);
        load.addTags(toVulkanTags(e.getTags()));
        replaceAcqRelTag(load, Tag.Vulkan.ACQUIRE);
        return eventSequence(load);
    }

    @Override
    public List<Event> visitSpirvStore(SpirvStore e) {
        e.addTags(Tag.Spirv.MEM_AVAILABLE, Tag.Spirv.MEM_NON_PRIVATE);
        String mo = moToVulkanTag(Tag.Spirv.getMoTag(e.getTags()));
        Store store = newStoreWithMo(e.getAddress(), e.getMemValue(), mo);
        store.setFunction(e.getFunction());
        store.addTags(Tag.Vulkan.ATOM);
        store.addTags(toVulkanTags(e.getTags()));
        replaceAcqRelTag(store, Tag.Vulkan.RELEASE);
        return eventSequence(store);
    }

    @Override
    public List<Event> visitSpirvXchg(SpirvXchg e) {
        e.addTags(Tag.Spirv.MEM_VISIBLE, Tag.Spirv.MEM_AVAILABLE, Tag.Spirv.MEM_NON_PRIVATE);
        String mo = moToVulkanTag(Tag.Spirv.getMoTag(e.getTags()));
        String scope = toVulkanTag(Tag.Spirv.getScopeTag(e.getTags()));
        VulkanRMW rmw = EventFactory.Vulkan.newRMW(e.getAddress(), e.getResultRegister(),
                e.getValue(), mo, scope);
        rmw.addTags(toVulkanTags(e.getTags()));
        rmw.setFunction(e.getFunction());
        return visitVulkanRMW(rmw);
    }

    @Override
    public List<Event> visitSpirvRMW(SpirvRmw e) {
        e.addTags(Tag.Spirv.MEM_VISIBLE, Tag.Spirv.MEM_AVAILABLE, Tag.Spirv.MEM_NON_PRIVATE);
        String mo = moToVulkanTag(Tag.Spirv.getMoTag(e.getTags()));
        String scope = toVulkanTag(Tag.Spirv.getScopeTag(e.getTags()));
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
        String scope = toVulkanTag(Tag.Spirv.getScopeTag(e.getTags()));
        eqTags.addAll(Set.of(Tag.Spirv.MEM_VISIBLE, Tag.Spirv.MEM_AVAILABLE, Tag.Spirv.MEM_NON_PRIVATE));
        VulkanCmpXchg cmpXchg = EventFactory.Vulkan.newVulkanCmpXchg(e.getAddress(), e.getResultRegister(),
                e.getExpectedValue(), e.getStoreValue(), moToVulkanTag(spvMoEq), scope);
        cmpXchg.setFunction(e.getFunction());
        cmpXchg.addTags(toVulkanTags(eqTags));

        return visitVulkanCmpXchg(cmpXchg);
    }

    @Override
    public List<Event> visitSpirvRmwExtremum(SpirvRmwExtremum e) {
        e.addTags(Tag.Spirv.MEM_VISIBLE, Tag.Spirv.MEM_AVAILABLE, Tag.Spirv.MEM_NON_PRIVATE);
        String mo = moToVulkanTag(Tag.Spirv.getMoTag(e.getTags()));
        String scope = toVulkanTag(Tag.Spirv.getScopeTag(e.getTags()));
        VulkanRMWExtremum rmw = EventFactory.Vulkan.newRMWExtremum(e.getAddress(), e.getResultRegister(),
                e.getOperator(), e.getValue(), mo, scope);
        rmw.setFunction(e.getFunction());
        rmw.addTags(toVulkanTags(e.getTags()));
        return visitVulkanRMWExtremum(rmw);
    }

    @Override
    public List<Event> visitGenericVisibleEvent(GenericVisibleEvent e) {
        Event fence = new GenericVisibleEvent(e.getName(), Tag.FENCE);
        fence.removeTags(fence.getTags());
        fence.addTags(toVulkanTags(e.getTags()));
        replaceAcqRelTag(fence, Tag.Vulkan.ACQUIRE, Tag.Vulkan.RELEASE);
        return eventSequence(fence);
    }

    @Override
    public List<Event> visitControlBarrier(ControlBarrier e) {
        Event barrier = EventFactory.newControlBarrier(e.getName(), e.getId());
        barrier.removeTags(barrier.getTags());
        barrier.addTags(toVulkanTags(e.getTags()));
        replaceAcqRelTag(barrier, Tag.Vulkan.ACQUIRE, Tag.Vulkan.RELEASE);
        return eventSequence(barrier);
    }

    private Set<String> toVulkanTags(Set<String> tags) {
        Set<String> vTags = new HashSet<>();
        tags.forEach(tag -> {
            if (Tag.Spirv.isSpirvTag(tag)) {
                String vTag = toVulkanTag(tag);
                if (vTag != null) {
                    vTags.add(vTag);
                }
            } else {
                vTags.add(tag);
            }
        });
        return adjustVulkanTags(tags, vTags);
    }

    private Set<String> adjustVulkanTags(Set<String> tags, Set<String> vTags) {
        if (tags.contains(Tag.MEMORY) && toVulkanTag(Tag.Spirv.getStorageClassTag(tags)) != null) {
            vTags.add(Tag.Vulkan.NON_PRIVATE);
            if (vTags.contains(Tag.READ)) {
                vTags.add(Tag.Vulkan.VISIBLE);
            }
            if (vTags.contains(Tag.WRITE)) {
                vTags.add(Tag.Vulkan.AVAILABLE);
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

    private void replaceAcqRelTag(Event e, String... tags) {
        if (e.getTags().contains(Tag.Vulkan.ACQ_REL)) {
            e.addTags(tags);
            e.removeTags(Tag.Vulkan.ACQ_REL);
        }
    }

    private String moToVulkanTag(String moSpv) {
        if (Tag.Spirv.RELAXED.equals(moSpv)) {
            return Tag.Vulkan.ATOM;
        }
        return toVulkanTag(moSpv);
    }

    private String toVulkanTag(String tag) {
        return switch (tag) {
            // Barriers
            case Tag.Spirv.CONTROL -> Tag.Vulkan.CBAR;

            // Memory order
            case Tag.Spirv.RELAXED -> null;
            case Tag.Spirv.ACQUIRE -> Tag.Vulkan.ACQUIRE;
            case Tag.Spirv.RELEASE -> Tag.Vulkan.RELEASE;
            case Tag.Spirv.ACQ_REL,
                    Tag.Spirv.SEQ_CST -> Tag.Vulkan.ACQ_REL;

            // Scope
            case Tag.Spirv.SUBGROUP -> Tag.Vulkan.SUB_GROUP;
            case Tag.Spirv.WORKGROUP -> Tag.Vulkan.WORK_GROUP;
            case Tag.Spirv.QUEUE_FAMILY -> Tag.Vulkan.QUEUE_FAMILY;
            // TODO: Refactoring of the cat model
            //  In the cat file AV/VISSHADER uses device domain,
            //  and device domain is mapped to AV/VISDEVICE
            case Tag.Spirv.INVOCATION,
                    Tag.Spirv.SHADER_CALL,
                    Tag.Spirv.DEVICE,
                    Tag.Spirv.CROSS_DEVICE -> Tag.Vulkan.DEVICE;

            // Memory access (non-atomic)
            case Tag.Spirv.MEM_VOLATILE,
                    Tag.Spirv.MEM_NONTEMPORAL -> null;
            case Tag.Spirv.MEM_NON_PRIVATE -> Tag.Vulkan.NON_PRIVATE;
            case Tag.Spirv.MEM_AVAILABLE -> Tag.Vulkan.AVAILABLE;
            case Tag.Spirv.MEM_VISIBLE -> Tag.Vulkan.VISIBLE;

            // Memory semantics
            case Tag.Spirv.SEM_VOLATILE -> null;
            case Tag.Spirv.SEM_AVAILABLE -> Tag.Vulkan.SEM_AVAILABLE;
            case Tag.Spirv.SEM_VISIBLE -> Tag.Vulkan.SEM_VISIBLE;

            // Memory semantics (storage class)
            case Tag.Spirv.SEM_UNIFORM, Tag.Spirv.SEM_OUTPUT -> Tag.Vulkan.SEMSC0;
            case Tag.Spirv.SEM_WORKGROUP -> Tag.Vulkan.SEMSC1;
            case Tag.Spirv.SEM_SUBGROUP,
                    Tag.Spirv.SEM_CROSS_WORKGROUP,
                    Tag.Spirv.SEM_ATOMIC_COUNTER,
                    Tag.Spirv.SEM_IMAGE -> throw new UnsupportedOperationException(
                    String.format("Spir-V memory semantics '%s' " +
                            "is not supported by Vulkan memory model", tag));

            // Storage class
            case Tag.Spirv.SC_UNIFORM_CONSTANT,
                    Tag.Spirv.SC_PUSH_CONSTANT -> null; // read-only
            case Tag.Spirv.SC_INPUT,
                    Tag.Spirv.SC_PRIVATE,
                    Tag.Spirv.SC_FUNCTION -> null; // private
            case Tag.Spirv.SC_UNIFORM,
                    Tag.Spirv.SC_OUTPUT,
                    Tag.Spirv.SC_STORAGE_BUFFER,
                    Tag.Spirv.SC_PHYS_STORAGE_BUFFER -> Tag.Vulkan.SC0;
            case Tag.Spirv.SC_WORKGROUP -> Tag.Vulkan.SC1;
            case Tag.Spirv.SC_CROSS_WORKGROUP,
                    Tag.Spirv.SC_GENERIC -> throw new UnsupportedOperationException(
                    String.format("Spir-V storage class '%s' " +
                            "is not supported by Vulkan memory model", tag));

            default -> throw new IllegalArgumentException(
                    String.format("Unexpected non Spir-V tag '%s'", tag));
        };
    }
}
