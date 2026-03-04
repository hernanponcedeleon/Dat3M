package com.dat3m.dartagnan.program.event.arch;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.common.RMWOpBase;

public class RMWOp extends RMWOpBase {

    public RMWOp(Expression address, IntBinaryOp operator, Expression operand) {
        super(address, operator, operand, "");
    }

    private RMWOp(RMWOp other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("rmw_%s(%s, %s)", operator.getName().toLowerCase(), operand, address);
    }

    @Override
    public RMWOp getCopy(){
        return new RMWOp(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitRMWOp(this);
    }
}
