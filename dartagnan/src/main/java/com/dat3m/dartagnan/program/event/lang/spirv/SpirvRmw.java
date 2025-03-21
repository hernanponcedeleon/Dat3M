package com.dat3m.dartagnan.program.event.lang.spirv;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.common.RMWOpResultBase;

import java.util.Set;

import static com.dat3m.dartagnan.program.event.Tag.Spirv.getMoTag;

public class SpirvRmw extends RMWOpResultBase {

    private final String scope;

    public SpirvRmw(Register register, Expression address, IntBinaryOp op, Expression operand, String scope, Set<String> tags) {
        super(register, address, op, operand, getMoTag(tags));
        this.scope = scope;
        addTags(scope);
        addTags(tags);
    }

    private SpirvRmw(SpirvRmw other) {
        super(other);
        this.scope = other.scope;
    }

    @Override
    public String defaultString() {
        return String.format("%s := spirv_rmw_%s[%s, %s](%s, %s)",
                resultRegister, operator.getName(), mo, scope, address, operand);
    }

    @Override
    public SpirvRmw getCopy() {
        return new SpirvRmw(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitSpirvRMW(this);
    }
}
