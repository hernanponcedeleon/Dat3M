package com.dat3m.dartagnan.program.event.arch.vulkan;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.integers.IntCmpOp;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.RMWExtremumBase;

public class VulkanRMWExtremum extends RMWExtremumBase {

    public VulkanRMWExtremum(Register register, Expression address, IntCmpOp op, Expression value, String mo, String scope) {
        super(register, address, op, value, mo);
        this.addTags(Tag.Vulkan.ATOM, scope);
    }

    private VulkanRMWExtremum(VulkanRMWExtremum other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("%s := rmw_ext[%s](%s, %s, %s)", resultRegister, mo, storeValue, address, operator.getName());
    }

    @Override
    public VulkanRMWExtremum getCopy() {
        return new VulkanRMWExtremum(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitVulkanRMWExtremum(this);
    }
}