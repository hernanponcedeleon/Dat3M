package com.dat3m.dartagnan.programNew.event.lang;

import com.dat3m.dartagnan.expr.Expression;
import com.dat3m.dartagnan.expr.Type;
import com.dat3m.dartagnan.expr.types.ArrayType;
import com.dat3m.dartagnan.expr.types.IntegerType;
import com.dat3m.dartagnan.programNew.Register;
import com.dat3m.dartagnan.programNew.event.AbstractEvent;
import com.dat3m.dartagnan.programNew.event.MemoryAccess;
import com.dat3m.dartagnan.programNew.event.MemoryEvent;

import java.util.List;
import java.util.Set;

// TODO: "abstract" is only here to avoid providing a complete implementation for now
public abstract class MemCopy extends AbstractEvent implements MemoryEvent {
    private final MemoryAccess sourceAccess;
    private final MemoryAccess destinationAccess;
    private final Expression count;

    private MemCopy(Expression sourceAddress, Expression destinationAddress, Expression count) {
        //TODO: Possibly allow for different access types
        final Type accessType = ArrayType.getWithUnknownSize(IntegerType.INT8);
        this.sourceAccess = new MemoryAccess(sourceAddress, accessType, MemoryAccess.Mode.LOAD);
        this.destinationAccess = new MemoryAccess(destinationAddress, accessType, MemoryAccess.Mode.STORE);
        this.count = count;
    }

    public Expression getSourceAddress() {
        return sourceAccess.address();
    }
    public Expression getDestinationAddress() {
        return destinationAccess.address();
    }
    public Expression getCount() { return count; }

    @Override
    public List<MemoryAccess> getMemoryAccesses() {
        return List.of(sourceAccess, destinationAccess);
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        final Set<Register.Read> regReads = MemoryEvent.super.getRegisterReads();
        // Count affects the addresses accessed by MemCpy
        Register.collectRegisterReads(count, Register.UsageType.ADDR, regReads);
        return regReads;
    }
}
