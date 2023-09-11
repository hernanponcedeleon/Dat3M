package com.dat3m.dartagnan.prototype.program.memory;

import com.dat3m.dartagnan.prototype.expr.Expression;
import com.dat3m.dartagnan.prototype.expr.Type;
import com.dat3m.dartagnan.prototype.expr.types.ArrayType;
import com.dat3m.dartagnan.prototype.expr.types.IntegerType;
import com.dat3m.dartagnan.prototype.program.event.core.memory.Alloc;

public final class DynamicMemoryObject extends MemoryObject {

    private final Alloc allocationSite;

    public DynamicMemoryObject(Alloc allocationSite) {
        this.allocationSite = allocationSite;
    }

    public Alloc getAllocationSite() { return allocationSite; }

    @Override
    public Type getAllocationType() {
        return ArrayType.getWithUnknownSize(IntegerType.INT8);
    }

    @Override
    public Expression getSize() {
        return allocationSite.getAllocationSize();
    }
}