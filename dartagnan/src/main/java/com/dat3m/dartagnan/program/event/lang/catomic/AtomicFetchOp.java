package com.dat3m.dartagnan.program.event.lang.catomic;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.common.RMWOpResultBase;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.base.Preconditions;

public class AtomicFetchOp extends RMWOpResultBase {

    public AtomicFetchOp(Register register, Expression address, IOpBin operator, Expression operand, String mo) {
        super(register, address, operator, operand, mo);
        Preconditions.checkArgument(!mo.isEmpty(), "Atomic events cannot have empty memory order");
    }

    private AtomicFetchOp(AtomicFetchOp other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("%s := atomic_fetch_%s(*%s, %s, %s)\t### C11",
                resultRegister, operator.toLinuxName(), address, operand, mo);
    }

    @Override
    public AtomicFetchOp getCopy() {
        return new AtomicFetchOp(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitAtomicFetchOp(this);
    }
}