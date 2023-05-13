package com.dat3m.dartagnan.program.event.arch.ptx;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.RMWAbstract;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class AtomOp extends RMWAbstract {
    private final IOpBin op;
    public AtomOp(IExpr address, Register register, IExpr value, IOpBin op, String mo) {
        super(address, register, value, mo);
        this.op = op;
    }

    protected AtomOp(AtomOp other) {
        super(other);
        this.op = other.op;
    }

    @Override
    public String toString() {
        return resultRegister + " := atom_" + op.toString() + Tag.PTX.RMWMO(mo) + "(" + value + ", " + address + ")";
    }

    public IOpBin getOp() {
        return op;
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public AtomOp getCopy(){
        return new AtomOp(this);
    }

    // Visitor
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitPTXRMWFetchOp(this);
    }

}
