package com.dat3m.dartagnan.program.event.arch.vulkan;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.RMWCmpXchgBase;

public class VulkanCmpXchg extends RMWCmpXchgBase {

    public VulkanCmpXchg(Register register, Expression address, Expression expected, Expression value,
                         String mo, String scope) {
        super(register, address, expected, value, true, mo);
        this.addTags(Tag.Vulkan.ATOM, scope);
    }

    private VulkanCmpXchg(VulkanCmpXchg other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("%s := cmp_xchg[%s](%s, %s, %s)", resultRegister, mo, storeValue, expectedValue, address);
    }

    @Override
    public VulkanCmpXchg getCopy() {
        return new VulkanCmpXchg(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitVulkanCmpXchg(this);
    }
}
