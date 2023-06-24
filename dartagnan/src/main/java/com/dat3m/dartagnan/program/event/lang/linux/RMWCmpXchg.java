package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.RMWCmpXchgBase;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class RMWCmpXchg extends RMWCmpXchgBase {

    public RMWCmpXchg(Expression address, Register register, Expression cmp, Expression value, String mo) {
        super(register, address, cmp, value, true, mo);
    }

    private RMWCmpXchg(RMWCmpXchg other){
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("%s := atomic_cmpxchg%s(%s, %s, %s)\t### LKMM",
                resultRegister, Tag.Linux.toText(mo), address, expectedValue, storeValue);
    }

    @Override
    public RMWCmpXchg getCopy(){
        return new RMWCmpXchg(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitRMWCmpXchg(this);
	}
}