package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.RMWOpResultBase;

public class LKMMFetchOp extends RMWOpResultBase {

    public LKMMFetchOp(Register register, Expression address, IOpBin op, Expression operand, String mo) {
        super(register, address, op, operand, mo);
    }

    private LKMMFetchOp(LKMMFetchOp other){
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("%s := atomic_fetch_%s%s(%s, %s)\t### LKMM",
                resultRegister, operator.getName(), Tag.Linux.toText(mo), operand, address);
    }

    @Override
    public LKMMFetchOp getCopy(){
        return new LKMMFetchOp(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitLKMMFetchOp(this);
    }
}