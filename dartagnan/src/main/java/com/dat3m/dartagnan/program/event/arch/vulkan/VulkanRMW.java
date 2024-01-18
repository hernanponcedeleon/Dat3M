package com.dat3m.dartagnan.program.event.arch.vulkan;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.RMWXchgBase;

public class VulkanRMW extends RMWXchgBase {

    public VulkanRMW(Register register, Expression address, Expression value, String mo, String scope) {
        super(register, address, value, mo);
        this.addTags(Tag.Vulkan.ATOM, scope);
    }

    private VulkanRMW(VulkanRMW other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("%s := rmw[%s](%s, %s)", resultRegister, mo, storeValue, address);
    }

    @Override
    public VulkanRMW getCopy() {
        return new VulkanRMW(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitVulkanRMW(this);
    }
}