package com.dat3m.dartagnan.program.event.lang.llvm;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.common.RMWCmpXchgBase;
import com.dat3m.dartagnan.program.event.core.utils.MultiRegWriter;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.base.Preconditions;

import java.util.List;

// FIXME: This event implements both RegWriter (due to inheritance) and MultiRegWriter, however, the former should not be used.
public class LlvmCmpXchg extends RMWCmpXchgBase implements MultiRegWriter {

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

    @Override
    public List<Register> getResultRegisters() {
        return List.of(resultRegister, cmpRegister);
    }

    @Override
    public void setResultRegister(int index, Register newRegister) {
        switch (index) {
            case 0 -> resultRegister = newRegister;
            case 1 -> cmpRegister = newRegister;
            default ->
                    throw new UnsupportedOperationException("Cannot access register with id " + index + " in " + getClass().getName());
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
