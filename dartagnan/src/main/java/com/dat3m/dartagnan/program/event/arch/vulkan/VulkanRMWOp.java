package com.dat3m.dartagnan.program.event.arch.vulkan;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.RMWOpResultBase;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class VulkanRMWOp extends RMWOpResultBase {

    public VulkanRMWOp(Register register, Expression address, IOpBin op, Expression operand, String mo, String scope) {
        super(register, address, op, operand, mo);
        this.addTags(Tag.Vulkan.ATOM, scope);
    }

    private VulkanRMWOp(VulkanRMWOp other) {
        super(other);
        this.addTags(Tag.Vulkan.ATOM);
    }

    @Override
    public String defaultString() {
        return String.format("%s := rmw[%s](%s, %s)", resultRegister, mo, operand, address);
    }

    @Override
    public VulkanRMWOp getCopy() {
        return new VulkanRMWOp(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitVulkanRMWOp(this);
    }
}