package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.arch.vulkan.VulkanCmpXchg;
import com.dat3m.dartagnan.program.event.arch.vulkan.VulkanRMW;
import com.dat3m.dartagnan.program.event.arch.vulkan.VulkanRMWExtremum;
import com.dat3m.dartagnan.program.event.arch.vulkan.VulkanRMWOp;
import com.dat3m.dartagnan.program.event.core.*;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.program.event.EventFactory.*;

public class VisitorVulkan extends VisitorBase {

    private static final Set<String> commonTags = Set.of(
            Tag.Vulkan.SUB_GROUP, Tag.Vulkan.WORK_GROUP,
            Tag.Vulkan.QUEUE_FAMILY, Tag.Vulkan.DEVICE,
            Tag.Vulkan.NON_PRIVATE, Tag.Vulkan.ATOM,
            Tag.Vulkan.SC0, Tag.Vulkan.SC1);

    private static final Set<String> semScTags = Set.of(Tag.Vulkan.SEMSC0, Tag.Vulkan.SEMSC1);

    private static final Set<String> loadTags = Set.of(
            Tag.Vulkan.ACQUIRE, Tag.Vulkan.VISIBLE, Tag.Vulkan.SEM_VISIBLE);

    private static final Set<String> storeTags = Set.of(
            Tag.Vulkan.RELEASE, Tag.Vulkan.AVAILABLE, Tag.Vulkan.SEM_AVAILABLE);

    private int labelIdx = 0;

    @Override
    public List<Event> visitGenericVisibleEvent(GenericVisibleEvent e) {
        return eventSequence(replaceAcqRelMemoryOrder(e));
    }

    @Override
    public List<Event> visitControlBarrier(ControlBarrier e) {
        return eventSequence(replaceAcqRelMemoryOrder(e));
    }

    @Override
    public List<Event> visitVulkanRMW(VulkanRMW e) {
        replaceAcqRelMemoryOrder(e);
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Load load = newRMWLoadWithMo(dummy, address, Tag.Vulkan.loadMO(e.getMo()));
        RMWStore store = newRMWStoreWithMo(load, address, e.getValue(), Tag.Vulkan.storeMO(e.getMo()));
        propagateLoadTags(e, load);
        propagateStoreTags(e, store);
        return eventSequence(
                load,
                store,
                newLocal(resultRegister, dummy)
        );
    }

    @Override
    public List<Event> visitVulkanRMWOp(VulkanRMWOp e) {
        replaceAcqRelMemoryOrder(e);
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Load load = newRMWLoadWithMo(dummy, address, Tag.Vulkan.loadMO(e.getMo()));
        RMWStore store = newRMWStoreWithMo(load, address,
                expressions.makeIntBinary(dummy, e.getOperator(), e.getOperand()), Tag.Vulkan.storeMO(e.getMo()));
        propagateLoadTags(e, load);
        propagateStoreTags(e, store);
        return eventSequence(
                load,
                store,
                newLocal(resultRegister, dummy)
        );
    }

    @Override
    public List<Event> visitVulkanRMWExtremum(VulkanRMWExtremum e) {
        replaceAcqRelMemoryOrder(e);
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Load load = newRMWLoadWithMo(dummy, address, Tag.Vulkan.loadMO(e.getMo()));
        Expression cmpExpr = expressions.makeIntCmp(dummy, e.getOperator(), e.getValue());
        Expression ite =  expressions.makeITE(cmpExpr, dummy, e.getValue());
        RMWStore store = newRMWStoreWithMo(load, address, ite, Tag.Vulkan.storeMO(e.getMo()));
        propagateLoadTags(e, load);
        propagateStoreTags(e, store);
        return eventSequence(
                load,
                store,
                newLocal(resultRegister, dummy)
        );
    }

    @Override
    public List<Event> visitVulkanCmpXchg(VulkanCmpXchg e) {
        replaceAcqRelMemoryOrder(e);
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        Expression expected = e.getExpectedValue();
        Expression value = e.getStoreValue();
        Register cmpResultRegister = e.getFunction().newRegister(types.getBooleanType());
        Label casEnd = newLabel("CAS_end_" + labelIdx++);
        Load load = newRMWLoadWithMo(resultRegister, address, Tag.Vulkan.loadMO(e.getMo()));
        RMWStore store = newRMWStoreWithMo(load, address, value, Tag.Vulkan.storeMO(e.getMo()));
        Local local = newLocal(cmpResultRegister, expressions.makeEQ(resultRegister, expected));
        CondJump condJump = newJumpUnless(cmpResultRegister, casEnd);
        propagateLoadTags(e, load);
        propagateStoreTags(e, store);
        return eventSequence(
                load,
                local,
                condJump,
                store,
                casEnd
        );
    }

    private Event replaceAcqRelMemoryOrder(Event event) {
        if (event.hasTag(Tag.Vulkan.ACQ_REL)) {
            event.removeTags(Tag.Vulkan.ACQ_REL);
            event.addTags(Tag.Vulkan.ACQUIRE, Tag.Vulkan.RELEASE);
        }
        return event;
    }

    private void propagateLoadTags(Event source, Event target) {
        boolean isAcq = source.hasTag(Tag.Vulkan.ACQUIRE);
        Set<String> tags = source.getTags().stream()
                .filter(t -> commonTags.contains(t) || loadTags.contains(t) || isAcq && semScTags.contains(t))
                .collect(Collectors.toSet());
        target.addTags(tags);
    }

    private void propagateStoreTags(Event source, Event target) {
        boolean isRel = source.hasTag(Tag.Vulkan.RELEASE);
        Set<String> tags = source.getTags().stream()
                .filter(t -> commonTags.contains(t) || storeTags.contains(t) || isRel && semScTags.contains(t))
                .collect(Collectors.toSet());
        target.addTags(tags);
    }
}
