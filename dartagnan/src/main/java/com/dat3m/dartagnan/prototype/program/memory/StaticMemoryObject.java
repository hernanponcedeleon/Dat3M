package com.dat3m.dartagnan.prototype.program.memory;

import com.dat3m.dartagnan.prototype.expr.Type;
import com.dat3m.dartagnan.prototype.expr.integers.IntLiteral;
import com.dat3m.dartagnan.prototype.expr.types.IntegerType;
import com.dat3m.dartagnan.prototype.program.GlobalVariable;

public final class StaticMemoryObject extends MemoryObject {

    private GlobalVariable staticVariable;

    public StaticMemoryObject(GlobalVariable variable) {
        this.staticVariable = variable;
    }

    public GlobalVariable getVariable() { return staticVariable; }

    @Override
    public Type getAllocationType() {
        return staticVariable.getContentType();
    }

    @Override
    public IntLiteral getSize() {
        return IntegerType.ARCH_DEFAULT.createLiteral(getAllocationType().getMemorySize());
    }
}
