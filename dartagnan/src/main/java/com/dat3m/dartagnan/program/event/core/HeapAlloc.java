package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.MemoryAccess;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.MemAlloc;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.util.List;


public class HeapAlloc extends AbstractMemoryCoreEvent implements RegWriter {
    private final MemAlloc allocationEvent;
    private Register resultRegister;

    public HeapAlloc(MemAlloc alloc, MemoryObject address, Register resultRegister) {
        super(address, TypeFactory.getInstance().getArchType());
        this.allocationEvent = alloc;
        this.resultRegister = resultRegister;
        removeTags(Tag.MEMORY);
        addTags(Tag.ALLOC);
    }

    protected HeapAlloc(HeapAlloc other) {
        super(other);
        this.allocationEvent = other.allocationEvent;
        this.resultRegister = other.resultRegister;
        removeTags(Tag.MEMORY);
        addTags(Tag.ALLOC);
    }

    public MemAlloc getAllocationEvent() {
        return allocationEvent;
    }

    @Override
    public MemoryObject getAddress() {
        return (MemoryObject)address;
    }

    @Override
    public Register getResultRegister() {
        return resultRegister;
    }

    @Override
    public void setResultRegister(Register reg) {
        this.resultRegister = reg;
    }

    @Override
    public HeapAlloc getCopy() {
        return new HeapAlloc(this);
    }

    @Override
    public String defaultString() {
        return String.format("%s <- alloc", address);
    }

    @Override
    public List<MemoryAccess> getMemoryAccesses() {
        return List.of(new MemoryAccess(address, accessType, MemoryAccess.Mode.OTHER));
    }
}
