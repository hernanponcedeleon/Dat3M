package com.dat3m.dartagnan.model.events;

import com.dat3m.dartagnan.encoding.TypedValue;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.model.AbstractEventModel;
import com.dat3m.dartagnan.program.Register;

public final class AllocModel extends AbstractEventModel implements RegWriterModel {

    private final Register register;
    private final Type type;
    private final TypedValue<?, ?> address;
    private final TypedValue<?, ?> arraySize;
    private final TypedValue<?, ?> alignment;
    private final boolean isHeapAllocation;

    public AllocModel(Register register, Type type, TypedValue<?, ?> address, TypedValue<?, ?> arraySize, TypedValue<?, ?> alignment, boolean isHeapAllocation) {
        this.register = register;
        this.type = type;
        this.address = address;
        this.arraySize = arraySize;
        this.alignment = alignment;
        this.isHeapAllocation = isHeapAllocation;
    }

    public Type getAllocationType() { return type; }
    public TypedValue<?, ?> getArraySize() { return arraySize; }
    public TypedValue<?, ?> getAlignment() { return alignment; }
    public boolean isHeapAllocation() { return isHeapAllocation; }

    @Override
    public String toString() {
        final String allocName = isHeapAllocation ? "heapalloc" : "stackalloc";
        return String.format("%s {%s} <- %s(type=%s, size=%s, align=%s)",
                register, address, allocName, type, arraySize, alignment);
    }

    @Override
    public Register getResultRegister() {
        return register;
    }

    @Override
    public TypedValue<?, ?> getValue() {
        return address;
    }
}

