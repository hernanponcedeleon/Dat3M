package com.dat3m.dartagnan.programNew.memory;


import com.dat3m.dartagnan.expr.Constant;
import com.dat3m.dartagnan.expr.Expression;
import com.dat3m.dartagnan.expr.Type;

public sealed abstract class MemoryObject
        permits StaticMemoryObject, DynamicMemoryObject {

    // <address> can be a non-constant expression. This is the case if there are dynamic allocations with
    // non-constant size, so that we do not statically know at which address to place a new allocation.
    protected Expression address;

    public Expression getAddress() { return address; }
    public void setAddress(Expression address) { this.address = address; }

    public abstract Type getAllocationType(); // The type of this object at allocation time.
    public abstract Expression getSize();


    public boolean hasConstantSize() { return getSize() instanceof Constant; }
    public boolean hasConstantAddress() { return address instanceof Constant; }


}
