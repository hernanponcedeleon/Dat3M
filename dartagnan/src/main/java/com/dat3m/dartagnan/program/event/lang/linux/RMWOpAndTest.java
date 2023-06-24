package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.RMWFetchOpBase;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class RMWOpAndTest extends RMWFetchOpBase {

    public RMWOpAndTest(Expression address, Register register, Expression value, IOpBin op) {
        super(register, address, op, value, Tag.Linux.MO_MB);
    }

    private RMWOpAndTest(RMWOpAndTest other){
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("%s := atomic_%s_and_test(%s, %s)\t### LKMM",
                resultRegister, operator.toLinuxName(), operand, address);
    }

    @Override
    public RMWOpAndTest getCopy(){
        return new RMWOpAndTest(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitRMWOpAndTest(this);
    }
}