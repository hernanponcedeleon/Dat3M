package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.RMWCmpXchgBase;

public class LKMMCmpXchg extends RMWCmpXchgBase {

    public LKMMCmpXchg(Register register, Expression address, Expression cmp, Expression value, String mo) {
        super(register, address, cmp, value, true, mo);
    }

    private LKMMCmpXchg(LKMMCmpXchg other){
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("%s := atomic_cmpxchg%s(%s, %s, %s)\t### LKMM",
                resultRegister, Tag.Linux.toText(mo), address, expectedValue, storeValue);
    }

    @Override
    public LKMMCmpXchg getCopy(){
        return new LKMMCmpXchg(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitLKMMCmpXchg(this);
	}
}