package com.dat3m.dartagnan.program.event.lang.spirv;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.integers.IntCmpOp;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.common.RMWXchgBase;

import java.util.Set;

import static com.dat3m.dartagnan.program.event.Tag.Spirv.getMoTag;

public class SpirvRmwExtremum extends RMWXchgBase {

    private final String scope;
    private final IntCmpOp operator;

    public SpirvRmwExtremum(Register register, Expression address, IntCmpOp op, Expression value, String scope, Set<String> tags) {
        super(register, address, value, getMoTag(tags));
        this.scope = scope;
        this.operator = op;
        addTags(scope);
        addTags(tags);
    }

    private SpirvRmwExtremum(SpirvRmwExtremum other) {
        super(other);
        this.scope = other.scope;
        this.operator = other.operator;
    }

    public IntCmpOp getOperator() {
        return operator;
    }

    @Override
    public String defaultString() {
        return String.format("%s := spirv_rmw_ext%s[%s, %s](%s, %s, %s)",
                resultRegister, operator.getName(), mo, scope, address, storeValue, operator.getName());
    }

    @Override
    public SpirvRmwExtremum getCopy() {
        return new SpirvRmwExtremum(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitSpirvRmwExtremum(this);
    }
}
