package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.event.core.Alloc;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;

import java.util.ArrayList;

public class Memory {

    private final ArrayList<MemoryObject> objects = new ArrayList<>();
    private final Type ptrType = TypeFactory.getInstance().getPointerType();
    private final IntegerType archType = TypeFactory.getInstance().getArchType();
    private final TypeFactory types = TypeFactory.getInstance();

    private int nextIndex = 1;

    // Generates a new, statically allocated memory object.
    public MemoryObject allocate(int size) {
        final Expression defaultAlignment = types.getDefaultAlignment();
        return allocate(size, defaultAlignment);
    }

    public MemoryObject allocate(int size, Expression defaultAlignment) {
        Preconditions.checkArgument(size > 0, "Illegal allocation. Size must be positive");
        final Expression sizeExpr = ExpressionFactory.getInstance().makeValue(size, archType);
        final MemoryObject memoryObject = new MemoryObject(nextIndex++, sizeExpr, defaultAlignment, null, ptrType);
        objects.add(memoryObject);
        return memoryObject;
    }

    // Generates a new, dynamically allocated memory object.
    public MemoryObject allocate(Alloc allocationSite) {
        Preconditions.checkNotNull(allocationSite);
        final MemoryObject memoryObject = new MemoryObject(nextIndex++, allocationSite.getAllocationSize(),
                allocationSite.getAlignment(), allocationSite, ptrType);
        objects.add(memoryObject);
        return memoryObject;
    }

    public VirtualMemoryObject allocateVirtual(int size, boolean generic, VirtualMemoryObject alias) {
        return allocateVirtual(size, generic, types.getDefaultAlignment(), alias);
    }

    public VirtualMemoryObject allocateVirtual(int size, boolean generic, Expression alignment,
                                               VirtualMemoryObject alias) {
        Preconditions.checkArgument(size > 0, "Illegal allocation. Size must be positive");
        final Expression sizeExpr = ExpressionFactory.getInstance().makeValue(size, archType);
        final VirtualMemoryObject address = new VirtualMemoryObject(nextIndex++, sizeExpr, alignment,
                generic, alias, ptrType);
        objects.add(address);
        return address;
    }

    public boolean deleteMemoryObject(MemoryObject obj) {
        return objects.remove(obj);
    }

    /**
     * Accesses all shared variables.
     *
     * @return Copy of the complete collection of allocated objects.
     */
    public ImmutableSet<MemoryObject> getObjects() {
        return ImmutableSet.copyOf(objects);
    }

}