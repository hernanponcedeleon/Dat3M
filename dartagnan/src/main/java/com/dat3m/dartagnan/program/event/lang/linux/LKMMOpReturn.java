package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.op.IntBinaryOp;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.RMWOpResultBase;

public class LKMMOpReturn extends RMWOpResultBase {

    public LKMMOpReturn(Register register, Expression address, IntBinaryOp op, Expression operand, String mo) {
        super(register, address, op, operand, mo);
    }

    private LKMMOpReturn(LKMMOpReturn other){
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("%s := atomic_%s_return%s(%s, %s)\t### LKMM",
                resultRegister, operator.getName(), Tag.Linux.toText(mo), operand, address);
    }

    @Override
    public LKMMOpReturn getCopy(){
        return new LKMMOpReturn(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitLKMMOpReturn(this);
	}
}