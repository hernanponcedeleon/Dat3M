package com.dat3m.dartagnan.program.event.arch.ptx;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.event.common.RMWOpBase;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class PTXRedOp extends RMWOpBase {

    public PTXRedOp(Expression address, Expression value, IOpBin op, String mo) {
        super(address, op, value, mo);
    }

    protected PTXRedOp(PTXRedOp other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("red_%s(%s, %s)", operator.toLinuxName(), operand, address);
    }

    @Override
    public PTXRedOp getCopy(){
        return new PTXRedOp(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitPtxRedOp(this);
    }
}
