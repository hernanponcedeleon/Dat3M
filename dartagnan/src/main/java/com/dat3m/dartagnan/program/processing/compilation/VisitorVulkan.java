package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.arch.vulkan.VulkanRMW;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStore;

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
        return eventSequence(
                load,
                store,
                newLocal(resultRegister, dummy)
        );
    }
}