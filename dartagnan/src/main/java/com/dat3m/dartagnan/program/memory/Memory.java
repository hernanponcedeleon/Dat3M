package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.expression.type.IntegerType;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;

import java.util.ArrayList;

public class Memory {

    private final IntegerType pointerType;

    private final ArrayList<MemoryObject> objects = new ArrayList<>();

    private int nextIndex = 1;

    public Memory(IntegerType t) {
        pointerType = t;
    }

    /**
     * Creates a new object.
     * @return
     * Points to the created location.
     */
    public MemoryObject allocate(int size, boolean isStatic) {
        Preconditions.checkArgument(size > 0, "Illegal malloc. Size must be positive");
        MemoryObject address = new MemoryObject(nextIndex++, pointerType, size, isStatic);
        objects.add(address);
        return address;
    }

    public VirtualMemoryObject allocateVirtual(int size, boolean isStatic, boolean generic, VirtualMemoryObject alias) {
        Preconditions.checkArgument(size > 0, "Illegal malloc. Size must be positive");
        VirtualMemoryObject address = new VirtualMemoryObject(nextIndex++, pointerType, size, isStatic, generic, alias);
        objects.add(address);
        return address;
    }

    public boolean deleteMemoryObject(MemoryObject obj) {
        return objects.remove(obj);
    }

    /**
     * Accesses all shared variables.
     * @return
     * Copy of the complete collection of allocated objects.
     */
    public ImmutableSet<MemoryObject> getObjects() {
        return ImmutableSet.copyOf(objects);
    }

}