package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.LeafExpressionBase;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;

import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

import static com.google.common.base.Preconditions.checkArgument;

/**
 * Associated with an array of memory locations.
 */
public class MemoryObject extends LeafExpressionBase<IntegerType> {

    private final int index;
    private final int size;
    private final boolean isStatic;

    private String name;
    private boolean isThreadLocal;

    private final Map<Integer, Expression> initialValues = new TreeMap<>();

    MemoryObject(int index, int size, boolean isStaticallyAllocated) {
        super(TypeFactory.getInstance().getArchType());
        this.index = index;
        this.size = size;
        this.isStatic = isStaticallyAllocated;
        this.isThreadLocal = false;

        if (isStaticallyAllocated) {
            // Static allocations are default-initialized
            initialValues.put(0, ExpressionFactory.getInstance().makeZero(TypeFactory.getInstance().getArchType()));
        }
    }

    public boolean hasName() { return name != null; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public boolean isStaticallyAllocated() { return isStatic; }
    public boolean isDynamicallyAllocated() { return !isStatic; }

    public Set<Integer> getInitializedFields() {
        return initialValues.keySet();
    }

    public boolean isThreadLocal() { return this.isThreadLocal; }
    public void setIsThreadLocal(boolean value) { this.isThreadLocal = value;}

    /**
     * @return Number of fields in this array.
     */
    public int size() { return size; }

    /**
     * Initial value at a certain field of this array.
     *
     * @param offset Non-negative number of fields before the target.
     * @return Readable value at the start of each execution.
     */
    public Expression getInitialValue(int offset) {
        checkArgument(offset >= 0 && offset < size, "array index out of bounds");
        return initialValues.getOrDefault(offset, ExpressionFactory.getInstance().makeZero(TypeFactory.getInstance().getArchType()));
    }

    /**
     * Defines the initial value at a certain field of this array.
     *
     * @param offset Non-negative number of fields before the target.
     * @param value  New value to be read at the start of each execution.
     */
    public void setInitialValue(int offset, Expression value) {
        checkArgument(offset >= 0 && offset < size, "array index out of bounds");
        initialValues.put(offset, value);
    }

    @Override
    public String toString() {
        return name != null ? "&" + name : ("&mem" + index);
    }

    @Override
    public int hashCode() { return index; }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        } else if (obj == null || getClass() != obj.getClass()) {
            return false;
        }

        return index == ((MemoryObject) obj).index;
    }

    @Override
    public ExpressionKind getKind() {
        return ExpressionKind.Other.MEMORY_ADDR;
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitMemoryObject(this);
    }
}
