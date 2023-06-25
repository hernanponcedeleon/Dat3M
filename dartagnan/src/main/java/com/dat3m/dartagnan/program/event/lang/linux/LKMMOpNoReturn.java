package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.RMWOpBase;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class LKMMOpNoReturn extends RMWOpBase {

    public LKMMOpNoReturn(Expression address, IOpBin operator, Expression operand) {
        super(address, operator, operand, Tag.Linux.MO_ONCE);
        addTags(Tag.Linux.NORETURN);
    }

    private LKMMOpNoReturn(LKMMOpNoReturn other){
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("atomic_%s(%s, %s)\t### LKMM", operator.toLinuxName(), operand, address);
    }

    @Override
    public LKMMOpNoReturn getCopy(){
        return new LKMMOpNoReturn(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitRMWOp(this);
	}
}