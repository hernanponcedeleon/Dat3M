package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.RMWOpResultBase;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class LKMMOpAndTest extends RMWOpResultBase {

    public LKMMOpAndTest(Register register, Expression address, IOpBin op, Expression operand) {
        super(register, address, op, operand, Tag.Linux.MO_MB);
    }

    private LKMMOpAndTest(LKMMOpAndTest other){
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("%s := atomic_%s_and_test(%s, %s)\t### LKMM",
                resultRegister, operator.toLinuxName(), operand, address);
    }

    @Override
    public LKMMOpAndTest getCopy(){
        return new LKMMOpAndTest(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitLKMMOpAndTest(this);
    }
}