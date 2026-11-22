package com.dat3m.dartagnan.program.event.lang.llvm;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.RMWOpBase;
import com.google.common.base.Preconditions;

/*
    A read-modify-write whose read value is not returned (e.g. C11 "atomic_store_add").
    Valid orders are relaxed, release and seq_cst, which all apply to the store part.
    The read part carries no memory order of its own; targets may exploit that the value is unused
    (e.g. ARMv8 compiles it to a "NoRet" RMW whose read is not ordered by load barriers).
 */
public class LlvmRMWNoReturn extends RMWOpBase {

    public LlvmRMWNoReturn(Expression address, IntBinaryOp operator, Expression operand, String mo) {
        // No value is read, so only orders for the store part are valid.
        Preconditions.checkArgument(mo.equals(Tag.C11.MO_RELAXED) || mo.equals(Tag.C11.MO_RELEASE) || mo.equals(Tag.C11.MO_SC),
                "No-return RMWs only support relaxed, release and seq_cst orders, not '%s'", mo);
        super(address, operator, operand, mo);
        addTags(Tag.C11.NORETURN);
    }

    private LlvmRMWNoReturn(LlvmRMWNoReturn other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("llvm_rmw_noret_%s(%s, %s, %s)",
                operator.getName().toLowerCase(), address, operand, mo);
    }

    @Override
    public LlvmRMWNoReturn getCopy() {
        return new LlvmRMWNoReturn(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitLlvmRMWNoReturn(this);
    }
}
