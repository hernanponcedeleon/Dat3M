package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.RMWFetchOpBase;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class RMWOpReturn extends RMWFetchOpBase {

    public RMWOpReturn(Expression address, Register register, Expression value, IOpBin op, String mo) {
        super(register, address, op, value, mo);
    }

    private RMWOpReturn(RMWOpReturn other){
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("%s := atomic_%s_return%s(%s, %s)\t### LKMM",
                resultRegister, operator.toLinuxName(), Tag.Linux.toText(mo), operand, address);
    }

    @Override
    public RMWOpReturn getCopy(){
        return new RMWOpReturn(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitRMWOpReturn(this);
	}
}