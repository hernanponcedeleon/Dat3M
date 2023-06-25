package com.dat3m.dartagnan.program.event.arch.ptx;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.common.RMWOpResultBase;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class PTXAtomOp extends RMWOpResultBase {

    public PTXAtomOp(Register register, Expression address, IOpBin op, Expression operand, String mo) {
        super(register, address, op, operand, mo);
    }

    protected PTXAtomOp(PTXAtomOp other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("%s := atom_%s%s(%s, %s)", resultRegister, operator, mo, operand, address);
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
