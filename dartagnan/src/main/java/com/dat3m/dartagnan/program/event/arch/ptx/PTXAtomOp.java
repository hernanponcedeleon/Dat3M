package com.dat3m.dartagnan.program.event.arch.ptx;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.common.RMWOpResultBase;

public class PTXAtomOp extends RMWOpResultBase {

    public PTXAtomOp(Register register, Expression address, IntBinaryOp op, Expression operand, String mo) {
        super(register, address, op, operand, mo);
    }

    protected PTXAtomOp(PTXAtomOp other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("%s := atom_%s_%s(%s, %s)", resultRegister, operator.getName(), mo, operand, address);
    }

    @Override
    public PTXAtomOp getCopy(){
        return new PTXAtomOp(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitPtxAtomOp(this);
    }

}
