package com.dat3m.dartagnan.program.event.lang.llvm;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.common.RMWCmpXchgBase;
import com.google.common.base.Preconditions;

// FIXME: This instruction writes to two registers, which we cannot express right now.
public class LlvmCmpXchg extends RMWCmpXchgBase {

    private Register cmpRegister;

    public LlvmCmpXchg(Register oldValueRegister, Register cmpRegister, Expression address,
                       Expression expectedValue, Expression value, String mo, boolean isStrong) {
        super(oldValueRegister, address, expectedValue, value, isStrong, mo);
        Preconditions.checkArgument(!mo.isEmpty(), "LLVM events cannot have empty memory order");
        Preconditions.checkArgument(cmpRegister.getType() instanceof BooleanType,
                "Non-boolean result register of LlvmCmpXchg.");
        this.cmpRegister = cmpRegister;
    }

    private LlvmCmpXchg(LlvmCmpXchg other) {
        super(other);
        this.cmpRegister = other.cmpRegister;
    }

    // The llvm instructions actually returns a structure.
    // In most cases the structure is not used as a whole, 
    // but rather by accessing its members. Thus, there is
    // no need to support this method.
    // NOTE: we use the inherited "resultRegister" to store the old value
    @Override
    public Register getResultRegister() {
        throw new UnsupportedOperationException("getResultRegister() not supported for " + this);
    }

    public Register getStructRegister(int idx) {
        return switch (idx) {
            case 0 -> resultRegister;
            case 1 -> cmpRegister;
            default ->
                    throw new UnsupportedOperationException("Cannot access structure with id " + idx + " in " + getClass().getName());
        };
    }

    public void setStructRegister(int idx, Register newRegister) {
        switch (idx) {
            case 0 -> resultRegister = newRegister;
            case 1 -> cmpRegister = newRegister;
            default ->
                    throw new UnsupportedOperationException("Cannot access structure with id " + idx + " in " + getClass().getName());
        }
    }

    @Override
    public String defaultString() {
        final String strongSuffix = isStrong ? "strong" : "weak";
        return String.format("(%s, %s) := llvm_cmpxchg_%s(*%s, %s, %s, %s)\t### LLVM",
                resultRegister, cmpRegister, strongSuffix, address, expectedValue, storeValue, mo);
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
