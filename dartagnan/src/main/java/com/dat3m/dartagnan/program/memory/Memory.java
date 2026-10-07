package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.event.core.Alloc;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

public class Memory {

    public static final int DEFAULT_ALIGNMENT = 8;
    public static final int DEFAULT_POINTER_SIZE = 64;

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    private final boolean bigEndian;
    private final Type ptrType;
    private final IntegerType archType;
    private final Expression defaultAlignment;

    private final List<MemoryObject> objects = new ArrayList<>();
    private int nextIndex = 1;

    public Memory() {
        this(false);
    }

    public Memory(boolean bigEndian) {
        this(bigEndian, DEFAULT_POINTER_SIZE);
    }

    public Memory(boolean bigEndian, int pointerSizeInBits) {
        this.bigEndian = bigEndian;
        ptrType = createPointerType(pointerSizeInBits);
        archType = types.getIntegerType(pointerSizeInBits);
        defaultAlignment = expressions.makeValue(DEFAULT_ALIGNMENT, archType);
    }

    public Type getPointerType() {
        return ptrType;
    }

    public IntegerType getArchType() {
        return archType;
    }

    public boolean isBigEndian() {
        return bigEndian;
    }

    public boolean isLittleEndian() {
        return !bigEndian;
    }

    public ImmutableSet<MemoryObject> getObjects() {
        return ImmutableSet.copyOf(objects);
    }

    // Generates a new, statically allocated memory object.
    public MemoryObject allocate(long size) {
        return allocate(size, DEFAULT_ALIGNMENT);
    }

    public MemoryObject allocate(long size, long alignment) {
        final Expression sizeExpr = createSizeExpression(size);
        Preconditions.checkArgument(alignment > 0, "Alignment must be positive");
        Preconditions.checkArgument(archType.canContain(BigInteger.valueOf(alignment)),
                "Alignment does not fit the program's address width");
        final Expression alignmentExpr = expressions.makeValue(alignment, archType);
        final MemoryObject memoryObject = new MemoryObject(nextIndex++, sizeExpr, alignmentExpr, null, ptrType);
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

    public VirtualMemoryObject allocateVirtual(long size, boolean generic, VirtualMemoryObject alias) {
        final Expression sizeExpr = createSizeExpression(size);
        final VirtualMemoryObject memoryObject = new VirtualMemoryObject(nextIndex++, sizeExpr, defaultAlignment,
                generic, alias, ptrType);
        objects.add(memoryObject);
        return memoryObject;
    }

    public boolean deleteMemoryObject(MemoryObject obj) {
        return objects.remove(obj);
    }

    public static IntegerType getDefaultArchType() {
        return types.getIntegerType(DEFAULT_POINTER_SIZE);
    }

    public static boolean isPointerType(Type type) {
        return type.equals(createPointerType(types.getMemorySizeInBits(type)));
    }

    private Expression createSizeExpression(long size) {
        Preconditions.checkArgument(size > 0, "Illegal allocation. Size must be positive");
        Preconditions.checkArgument(archType.canContain(BigInteger.valueOf(size)),
                "Allocation size does not fit the program's address width");
        return expressions.makeValue(size, archType);
    }

    private static Type createPointerType(int bitWidth) {
        // TODO: Introduce a dedicated pointer type instead of its integer representation.
        return types.getIntegerType(bitWidth);
    }
}
