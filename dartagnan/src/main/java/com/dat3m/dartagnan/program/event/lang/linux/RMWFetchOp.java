package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.RMWFetchOpBase;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class RMWFetchOp extends RMWFetchOpBase {

    public RMWFetchOp(Expression address, Register register, Expression value, IOpBin op, String mo) {
        super(register, address, op, value, mo);
    }

    private RMWFetchOp(RMWFetchOp other){
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("%s := atomic_fetch_%s%s(%s, %s)\t### LKMM",
                resultRegister, operator.toLinuxName(), Tag.Linux.toText(mo), operand, address);
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