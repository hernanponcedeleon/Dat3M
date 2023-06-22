package com.dat3m.dartagnan.program.event.arch.ptx;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.lang.RMWAbstract;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class AtomOp extends RMWAbstract {
    private final IOpBin op;
    public AtomOp(Expression address, Register register, Expression value, IOpBin op, String mo) {
        super(address, register, value, mo);
        this.op = op;
    }

    protected AtomOp(AtomOp other) {
        super(other);
        this.op = other.op;
    }

    @Override
    public String defaultString() {
        return resultRegister + " := atom_" + op.toString() + mo + "(" + value + ", " + address + ")";
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
        return visitor.visitPtxAtomOp(this);
    }

}
