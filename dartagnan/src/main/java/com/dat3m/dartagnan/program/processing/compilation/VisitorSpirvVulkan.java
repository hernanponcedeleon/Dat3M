package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.exception.ParsingException;
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
        return eventSequence(addVulkanTags(e, load));
    }

    @Override
    public List<Event> visitStore(Store e) {
        Event store = EventFactory.newStore(e.getAddress(), e.getMemValue());
        return eventSequence(addVulkanTags(e, store));
    }

    @Override
    public List<Event> visitSpirvLoad(SpirvLoad e) {
        String mo = moToVulkanTag(Tag.Spirv.getMoTag(e.getTags()));
        Load load = newLoadWithMo(e.getResultRegister(), e.getAddress(), mo);
        load.addTags(Tag.Vulkan.ATOM, Tag.Vulkan.NON_PRIVATE, Tag.Vulkan.VISIBLE);
        return eventSequence(addVulkanTags(e, load));
    }

    @Override
    public List<Event> visitSpirvStore(SpirvStore e) {
        String mo = moToVulkanTag(Tag.Spirv.getMoTag(e.getTags()));
        Store store = newStoreWithMo(e.getAddress(), e.getMemValue(), mo);
        store.addTags(Tag.Vulkan.ATOM, Tag.Vulkan.NON_PRIVATE, Tag.Vulkan.AVAILABLE);
        return eventSequence(addVulkanTags(e, store));
    }

    @Override
    public List<Event> visitGenericVisibleEvent(GenericVisibleEvent e) {
        GenericVisibleEvent fence = new GenericVisibleEvent(e.getName(), Tag.FENCE);
        addVulkanTags(e, fence);
        return super.visitGenericVisibleEvent(fence);
    }

    @Override
    public List<Event> visitControlBarrier(ControlBarrier e) {
        ControlBarrier barrier = EventFactory.newControlBarrier(e.getName(), e.getInstanceId());
        addVulkanTags(e, barrier);
        if (!e.hasTag(Tag.FENCE)) {
            barrier.removeTags(Tag.FENCE);
        }
        return super.visitControlBarrier(barrier);
    }

    @Override
    public List<Event> visitSpirvXchg(SpirvXchg e) {
        String mo = moToVulkanTag(Tag.Spirv.getMoTag(e.getTags()));
        String scope = toVulkanTag(Tag.Spirv.getScopeTag(e.getTags()));
        VulkanRMW rmw = EventFactory.Vulkan.newRMW(e.getAddress(), e.getResultRegister(), e.getValue(), mo, scope);
        rmw.addTags(Tag.Vulkan.NON_PRIVATE, Tag.Vulkan.AVAILABLE, Tag.Vulkan.VISIBLE);
        addVulkanTags(e, rmw);
        return visitVulkanRMW(rmw);
    }

    @Override
    public List<Event> visitSpirvRMW(SpirvRmw e) {
        String mo = moToVulkanTag(Tag.Spirv.getMoTag(e.getTags()));
        String scope = toVulkanTag(Tag.Spirv.getScopeTag(e.getTags()));
        VulkanRMWOp rmwOp = EventFactory.Vulkan.newRMWOp(e.getAddress(), e.getResultRegister(), e.getOperand(),
                e.getOperator(), mo, scope);
        rmwOp.addTags(Tag.Vulkan.NON_PRIVATE, Tag.Vulkan.AVAILABLE, Tag.Vulkan.VISIBLE);
        addVulkanTags(e, rmwOp);
        return visitVulkanRMWOp(rmwOp);
    }

    @Override
    public List<Event> visitSpirvRmwExtremum(SpirvRmwExtremum e) {
        String mo = moToVulkanTag(Tag.Spirv.getMoTag(e.getTags()));
        String scope = toVulkanTag(Tag.Spirv.getScopeTag(e.getTags()));
        VulkanRMWExtremum rmw = EventFactory.Vulkan.newRMWExtremum(e.getAddress(), e.getResultRegister(),
                e.getOperator(), e.getValue(), mo, scope);
        addVulkanTags(e, rmw);
        rmw.addTags(Tag.Vulkan.NON_PRIVATE, Tag.Vulkan.AVAILABLE, Tag.Vulkan.VISIBLE);
        return visitVulkanRMWExtremum(rmw);
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
        VulkanCmpXchg cmpXchg = EventFactory.Vulkan.newVulkanCmpXchg(e.getAddress(), e.getResultRegister(),
                e.getExpectedValue(), e.getStoreValue(), moToVulkanTag(spvMoEq), scope);
        addVulkanTags(e, cmpXchg);
        cmpXchg.addTags(Tag.Vulkan.NON_PRIVATE, Tag.Vulkan.AVAILABLE, Tag.Vulkan.VISIBLE);
        return visitVulkanCmpXchg(cmpXchg);
    }

    private Event addVulkanTags(Event source, Event target) {
        source.getTags().forEach(tag -> {
            if (Tag.Spirv.isSpirvTag(tag)) {
                String vTag = toVulkanTag(tag);
                if (vTag != null) {
                    target.addTags(vTag);
                }
            } else {
                target.addTags(tag);
            }
        });
        target.setFunction(source.getFunction());
        validateSemanticsTags(target.getTags());
        return target;
    }

    private void validateSemanticsTags(Set<String> tags) {
        boolean hasMoTags = tags.contains(Tag.Vulkan.ACQUIRE) || tags.contains(Tag.Vulkan.RELEASE) || tags.contains(Tag.Vulkan.ACQ_REL);
        boolean hasSemScTags = tags.contains(Tag.Vulkan.SEMSC0) || tags.contains(Tag.Vulkan.SEMSC1);
        if (hasMoTags && !hasSemScTags) {
            throw new ParsingException("Non-relaxed semantics must have storage class semantics tags");
        }
        if (hasSemScTags && !hasMoTags) {
            throw new ParsingException("Storage class semantics requires memory order tags");
        }
        if (tags.contains(Tag.Vulkan.SEM_AVAILABLE) && !tags.contains(Tag.Vulkan.RELEASE) && !tags.contains(Tag.Vulkan.ACQ_REL)) {
            throw new ParsingException("Available semantics must have release tag");
        }
        if (tags.contains(Tag.Vulkan.SEM_VISIBLE) && !tags.contains(Tag.Vulkan.ACQUIRE) && !tags.contains(Tag.Vulkan.ACQ_REL)) {
            throw new ParsingException("Visible semantics must have acquire tag");
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
            // Control barrier
            case Tag.Spirv.CONTROL -> Tag.Vulkan.CBAR;

            // Storage class
            case Tag.Spirv.SC_UNIFORM_CONSTANT, Tag.Spirv.SC_PUSH_CONSTANT
                    -> null; // read-only
            case Tag.Spirv.SC_INPUT, Tag.Spirv.SC_PRIVATE, Tag.Spirv.SC_FUNCTION
                    -> null; // private
            case Tag.Spirv.SC_UNIFORM, Tag.Spirv.SC_OUTPUT, Tag.Spirv.SC_STORAGE_BUFFER, Tag.Spirv.SC_PHYS_STORAGE_BUFFER
                    -> Tag.Vulkan.SC0;
            case Tag.Spirv.SC_WORKGROUP
                    -> Tag.Vulkan.SC1;
            case Tag.Spirv.SC_CROSS_WORKGROUP, Tag.Spirv.SC_GENERIC
                    -> throw new UnsupportedOperationException(
                    String.format("Spir-V storage class '%s' is not supported by Vulkan memory model", tag));

            // Scope
            case Tag.Spirv.SUBGROUP -> Tag.Vulkan.SUB_GROUP;
            case Tag.Spirv.WORKGROUP -> Tag.Vulkan.WORK_GROUP;
            case Tag.Spirv.QUEUE_FAMILY -> Tag.Vulkan.QUEUE_FAMILY;
            // TODO: The model does not distinguish between these scopes
            case Tag.Spirv.INVOCATION, Tag.Spirv.SHADER_CALL, Tag.Spirv.DEVICE, Tag.Spirv.CROSS_DEVICE -> Tag.Vulkan.DEVICE;

            // Memory operands (non-atomic)
            case Tag.Spirv.MEM_VOLATILE, Tag.Spirv.MEM_NONTEMPORAL -> null;
            case Tag.Spirv.MEM_NON_PRIVATE -> Tag.Vulkan.NON_PRIVATE;
            case Tag.Spirv.MEM_AVAILABLE -> Tag.Vulkan.AVAILABLE;
            case Tag.Spirv.MEM_VISIBLE -> Tag.Vulkan.VISIBLE;

            // Memory semantics (misc)
            case Tag.Spirv.SEM_VOLATILE -> null;

            // Memory semantics (memory order)
            case Tag.Spirv.RELAXED -> null;
            case Tag.Spirv.ACQUIRE -> Tag.Vulkan.ACQUIRE;
            case Tag.Spirv.RELEASE -> Tag.Vulkan.RELEASE;
            case Tag.Spirv.ACQ_REL -> Tag.Vulkan.ACQ_REL;
            case Tag.Spirv.SEQ_CST -> throw new UnsupportedOperationException(
                    String.format("Spir-V memory order '%s' is not supported by Vulkan memory model", tag));

            // Memory semantics (storage class)
            case Tag.Spirv.SEM_UNIFORM, Tag.Spirv.SEM_OUTPUT -> Tag.Vulkan.SEMSC0;
            case Tag.Spirv.SEM_WORKGROUP -> Tag.Vulkan.SEMSC1;
            case Tag.Spirv.SEM_SUBGROUP, Tag.Spirv.SEM_CROSS_WORKGROUP, Tag.Spirv.SEM_ATOMIC_COUNTER, Tag.Spirv.SEM_IMAGE
                    -> throw new UnsupportedOperationException(
                            String.format("Spir-V memory semantics '%s' is not supported by Vulkan memory model", tag));

            // Memory semantics (av-vis)
            case Tag.Spirv.SEM_AVAILABLE -> Tag.Vulkan.SEM_AVAILABLE;
            case Tag.Spirv.SEM_VISIBLE -> Tag.Vulkan.SEM_VISIBLE;

            default -> throw new IllegalArgumentException(String.format("Unexpected non Spir-V tag '%s'", tag));
        };
    }
}
