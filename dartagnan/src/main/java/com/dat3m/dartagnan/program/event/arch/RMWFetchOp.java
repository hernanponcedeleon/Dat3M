package com.dat3m.dartagnan.program.event.arch;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.common.RMWOpResultBase;

public class RMWFetchOp extends RMWOpResultBase {

    public RMWFetchOp(Register result, Expression address, IntBinaryOp operator, Expression operand) {
        super(result, address, operator, operand, "");
    }

    private RMWFetchOp(RMWFetchOp other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("%s = rmw_fetch_%s(%s, %s)", resultRegister, operator.getName().toLowerCase(), operand, address);
    }

    @Override
    public RMWFetchOp getCopy(){
        return new RMWFetchOp(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitRMWFetchOp(this);
    }
}
