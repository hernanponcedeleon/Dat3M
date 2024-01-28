package com.dat3m.dartagnan.program.event.arch.tso;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.common.RMWXchgBase;

import static com.dat3m.dartagnan.program.event.Tag.TSO;

public class TSOXchg extends RMWXchgBase {

    public TSOXchg(Expression address, Register register) {
        super(register, address, register, "");
        addTags(TSO.ATOM);
    }

    private TSOXchg(TSOXchg other){
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("xchg(*%s, %s)", address, resultRegister);
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        this.address = address.accept(exprTransformer);
        // We deliberately do not update the "storeValue" because it must match with the target register.
    }

    @Override
    public void setResultRegister(Register reg) {
        super.setResultRegister(reg);
        this.storeValue = reg; // Store value always matches register
    }

    @Override
    public TSOXchg getCopy(){
        return new TSOXchg(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitTSOXchg(this);
    }
}