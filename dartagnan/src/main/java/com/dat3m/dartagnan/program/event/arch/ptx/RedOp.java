package com.dat3m.dartagnan.program.event.arch.ptx;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.RMWAbstract;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class RedOp extends RMWAbstract {

    private final IOpBin op;
    public RedOp(IExpr address, Register register, IExpr value, IOpBin op, String mo) {
        super(address, register, value, mo);
        this.op = op;
    }

    protected RedOp(RedOp other) {
        super(other);
        this.op = other.op;
    }

    @Override
    public String toString() {
        return "red_" + op.toString() + "(" + value + ", " + address + ")";
    }

    public IOpBin getOp() {
        return op;
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public RedOp getCopy(){
        return new RedOp(this);
    }

    // Visitor
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitPtxRedOp(this);
    }
}
