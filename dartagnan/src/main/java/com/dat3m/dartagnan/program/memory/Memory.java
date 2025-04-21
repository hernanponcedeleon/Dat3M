package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.*;
import com.dat3m.dartagnan.program.event.core.Alloc;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;

import java.util.ArrayList;

public class Memory {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    private final ArrayList<MemoryObject> objects = new ArrayList<>();
    private final IntegerType archType = types.getArchType();
    private final Expression defaultAlignment = expressions.makeValue(8, archType);

    private int nextIndex = 1;

    // TODO: This should be a pointer too
    // Generates a new, statically allocated memory object.
    public MemoryObject allocate(int size) {
        Preconditions.checkArgument(size > 0, "Illegal allocation. Size must be positive");
        final Expression sizeExpr = expressions.makeValue(size, archType);
        final MemoryObject memoryObject = new MemoryObject(nextIndex++, sizeExpr, defaultAlignment, null,
                types.getPointerType(types.getVoidType()));
        objects.add(memoryObject);
        return memoryObject;
    }

    // Generates a new, dynamically allocated memory object.
    public MemoryObject allocate(Alloc allocationSite) {
        Preconditions.checkNotNull(allocationSite);
        final MemoryObject memoryObject = new MemoryObject(nextIndex++, allocationSite.getAllocationSize(),
                allocationSite.getAlignment(), allocationSite, types.getPointerType(types.getVoidType()));
        objects.add(memoryObject);
        return memoryObject;
    }

    public VirtualMemoryObject allocateVirtual(PointerType type, int size, boolean generic, VirtualMemoryObject alias) {
        Preconditions.checkArgument(size > 0, "Illegal allocation. Size must be positive");
        final Expression sizeExpr = expressions.makeValue(size, archType);
        final VirtualMemoryObject memoryObject = new VirtualMemoryObject(nextIndex++, sizeExpr,
                defaultAlignment, generic, alias, type);
        objects.add(memoryObject);
        return memoryObject;
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