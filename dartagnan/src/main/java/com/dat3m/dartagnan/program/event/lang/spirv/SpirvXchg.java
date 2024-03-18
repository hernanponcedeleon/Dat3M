package com.dat3m.dartagnan.program.event.lang.spirv;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.common.RMWXchgBase;

import java.util.Set;

import static com.dat3m.dartagnan.program.event.Tag.Spirv.getMoTag;

public class SpirvXchg extends RMWXchgBase {

    private final String scope;

    public SpirvXchg(Register register, Expression address, Expression value, String scope, Set<String> tags) {
        super(register, address, value, getMoTag(tags));
        this.scope = scope;
        addTags(scope);
        addTags(tags);
    }

    private SpirvXchg(SpirvXchg other) {
        super(other);
        this.scope = other.scope;
    }

    @Override
    public String defaultString() {
        return String.format("%s := spirv_xchg[%s, %s](%s, %s)",
                resultRegister, mo, scope, address, storeValue);
    }

    @Override
    public SpirvXchg getCopy() {
        return new SpirvXchg(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitSpirvXchg(this);
    }
}
