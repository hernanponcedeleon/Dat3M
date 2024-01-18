package com.dat3m.dartagnan.program.event.lang.llvm;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.common.StoreBase;
import com.google.common.base.Preconditions;

import static com.dat3m.dartagnan.program.event.Tag.C11.MO_ACQUIRE;
import static com.dat3m.dartagnan.program.event.Tag.C11.MO_ACQUIRE_RELEASE;

public class LlvmStore extends StoreBase {

    public LlvmStore(Expression address, Expression value, String mo){
        super(address, value, mo);
        Preconditions.checkArgument(!mo.isEmpty(), "LLVM events cannot have empty memory order");
        Preconditions.checkArgument(!mo.equals(MO_ACQUIRE) && !mo.equals(MO_ACQUIRE_RELEASE),
                getClass().getName() + " cannot have memory order: " + mo);
    }

    private LlvmStore(LlvmStore other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return "llvm_store(*" + address + ", " + value + ", " + mo + ")\t### LLVM";
    }

    @Override
    public LlvmStore getCopy() {
        return new LlvmStore(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitLlvmStore(this);
    }
}