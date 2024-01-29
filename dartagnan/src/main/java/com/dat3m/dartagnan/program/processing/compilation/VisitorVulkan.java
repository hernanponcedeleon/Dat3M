package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.arch.vulkan.VulkanRMW;
import com.dat3m.dartagnan.program.event.arch.vulkan.VulkanRMWOp;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.RMWStore;
import com.dat3m.dartagnan.program.event.core.Store;

import java.util.List;

import static com.dat3m.dartagnan.program.event.EventFactory.*;

public class VisitorVulkan extends VisitorBase {

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
            // If a RMW is a acquire, we do not propagate semscX to the write
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
