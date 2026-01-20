package com.dat3m.dartagnan.program.event.lang.llvm;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.common.RMWCmpXchgBase;
import com.google.common.base.Preconditions;

public class LlvmCmpXchg extends RMWCmpXchgBase {

    public LlvmCmpXchg(Register oldValueSuccessRegister, Expression address, Expression expectedValue,
            Expression value, String mo, boolean isStrong) {
        super(oldValueSuccessRegister, address, expectedValue, value, isStrong, mo);
        Preconditions.checkArgument(!mo.isEmpty(), "LLVM events cannot have empty memory order");
        final var type = oldValueSuccessRegister.getType() instanceof AggregateType t ? t : null;
        Preconditions.checkArgument(type != null && type.getFields().size() == 2,
                "Non-aggregate result register of LlvmCmpXchg.");
    }

    private LlvmCmpXchg(LlvmCmpXchg other) {
        super(other);
    }

    @Override
    public String defaultString() {
        final String strongSuffix = isStrong ? "strong" : "weak";
        return String.format("%s = llvm_cmpxchg_%s(%s, %s, %s, %s)",
                resultRegister, strongSuffix, address, expectedValue, storeValue, mo);
    }

    @Override
    public LlvmCmpXchg getCopy() {
        return new LlvmCmpXchg(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitLlvmCmpXchg(this);
    }
}
