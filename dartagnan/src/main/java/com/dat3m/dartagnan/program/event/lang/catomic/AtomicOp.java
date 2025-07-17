package com.dat3m.dartagnan.program.event.lang.catomic;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.common.RMWOpBase;
import com.dat3m.dartagnan.program.event.Tag;
import com.google.common.base.Preconditions;

public class AtomicOp extends RMWOpBase {

    public AtomicOp(Expression address, IntBinaryOp operator, Expression operand, String mo) {
        super(address, operator, operand, mo);
        Preconditions.checkArgument(!mo.isEmpty(), "Atomic events cannot have empty memory order");
        addTags(Tag.C11.NORETURN);
    }

    private AtomicOp(AtomicOp other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("atomic_store_%s(*%s, %s, %s)\t### C11", operator.getName(), address, operand, mo);
    }

    @Override
    public AtomicOp getCopy() {
        return new AtomicOp(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitAtomicOp(this);
    }
}