package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.event.core.Alloc;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;

import java.util.ArrayList;

public class Memory {

    public static final int DEFAULT_ALIGNMENT = 8;
    private static final TypeFactory types = TypeFactory.getInstance();
    private final ExpressionFactory expressions = ExpressionFactory.getInstance();

    private final ArrayList<MemoryObject> objects = new ArrayList<>();
    private final IntegerType ptrType;
    private final boolean bigEndian;

    private int nextIndex = 1;

    public Memory() {
        this(false, types.getArchType().getBitWidth());
    }

    public Memory(boolean bigEndian, int pointerSizeInBits) {
        Preconditions.checkArgument(pointerSizeInBits > 0, "Pointer size must be positive");
        this.bigEndian = bigEndian;
        ptrType = types.getIntegerType(pointerSizeInBits);
    }

    public IntegerType getPointerType() {
        return ptrType;
    }

    public boolean isBigEndian() {
        return bigEndian;
    }

    public boolean isLittleEndian() {
        return !bigEndian;
    }

    // Generates a new, statically allocated memory object.
    public MemoryObject allocate(int size) {
        return allocate(size, DEFAULT_ALIGNMENT);
    }

    public MemoryObject allocate(int size, int alignment) {
        Preconditions.checkArgument(size > 0, "Illegal allocation. Size must be positive");
        Preconditions.checkArgument(alignment > 0 && (alignment & (alignment - 1)) == 0,
                "Alignment must be a positive power of two");
        final Expression sizeExpr = expressions.makeValue(size, ptrType);
        final Expression alignmentExpr = expressions.makeValue(alignment, ptrType);
        final MemoryObject memoryObject = new MemoryObject(nextIndex++, sizeExpr, alignmentExpr, null, ptrType);
        objects.add(memoryObject);
        return memoryObject;
    }

    // Generates a new, dynamically allocated memory object.
    public MemoryObject allocate(Alloc allocationSite) {
        Preconditions.checkNotNull(allocationSite);
        final Expression size = expressions.makeCast(allocationSite.getAllocationSize(), ptrType);
        final Expression alignment = expressions.makeCast(allocationSite.getAlignment(), ptrType);
        final MemoryObject memoryObject = new MemoryObject(nextIndex++, size, alignment, allocationSite, ptrType);
        objects.add(memoryObject);
        return memoryObject;
    }

    public VirtualMemoryObject allocateVirtual(int size, boolean generic, VirtualMemoryObject alias) {
        Preconditions.checkArgument(size > 0, "Illegal allocation. Size must be positive");
        final Expression sizeExpr = expressions.makeValue(size, ptrType);
        final Expression defaultAlignment = expressions.makeValue(DEFAULT_ALIGNMENT, ptrType);
        final VirtualMemoryObject address = new VirtualMemoryObject(nextIndex++, sizeExpr, defaultAlignment,
                generic, alias, ptrType);
        objects.add(address);
        return address;
    }

    public boolean deleteMemoryObject(MemoryObject obj) {
        return objects.remove(obj);
    }

    public ImmutableSet<MemoryObject> getObjects() {
        return ImmutableSet.copyOf(objects);
    }

}
