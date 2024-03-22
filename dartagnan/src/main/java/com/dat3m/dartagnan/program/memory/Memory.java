package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.event.core.Alloc;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;

import java.util.ArrayList;

public class Memory {

    private final ArrayList<MemoryObject> objects = new ArrayList<>();
    private final Type ptrType = TypeFactory.getInstance().getPointerType();

    private int nextIndex = 1;

    // Generates a new, statically allocated memory object.
    public MemoryObject allocate(int size) {
        Preconditions.checkArgument(size > 0, "Illegal allocation. Size must be positive");
        final MemoryObject memoryObject = new MemoryObject(nextIndex++, size, null, ptrType);
        objects.add(memoryObject);
        return memoryObject;
    }

    // Generates a new, dynamically allocated memory object.
    public MemoryObject allocate(Alloc allocationSite) {
        Preconditions.checkNotNull(allocationSite);
        // TODO: Add support for dynamically-sized allocations.
        final int size = getStaticAllocSize(allocationSite);
        final MemoryObject memoryObject = new MemoryObject(nextIndex++, size, allocationSite, ptrType);
        objects.add(memoryObject);
        return memoryObject;
    }

    public VirtualMemoryObject allocateVirtual(int size, boolean generic, VirtualMemoryObject alias) {
        Preconditions.checkArgument(size > 0, "Illegal allocation. Size must be positive");
        final VirtualMemoryObject address = new VirtualMemoryObject(nextIndex++, size, generic, alias, ptrType);
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

    private int getStaticAllocSize(Alloc alloc) {
        try {
            return ((IntLiteral)alloc.getAllocationSize()).getValueAsInt();
        } catch (Exception e) {
            final String error = String.format("Variable-sized alloc '%s' is not supported", alloc);
            throw new MalformedProgramException(error);
        }
    }

}