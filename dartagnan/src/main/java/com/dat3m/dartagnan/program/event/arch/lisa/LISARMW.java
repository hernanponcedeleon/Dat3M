package com.dat3m.dartagnan.program.event.arch.lisa;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.common.RMWXchgBase;

public class LISARMW extends RMWXchgBase {

    public LISARMW(Register register, Expression address, Expression value, String mo) {
        super(register, address, value, mo);
    }

    private LISARMW(LISARMW other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("%s := rmw[%s](%s, %s)", resultRegister, mo, storeValue, address);
    }

    @Override
    public LISARMW getCopy() {
        return new LISARMW(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitLISARMW(this);
    }
}