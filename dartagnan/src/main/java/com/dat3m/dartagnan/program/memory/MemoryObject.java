package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.base.LeafExpressionBase;
import com.dat3m.dartagnan.program.event.core.Alloc;

import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkState;

/**
 * Associated with an array of memory locations.
 */
public class MemoryObject extends LeafExpressionBase<Type> {

    // TODO: (TH) I think <id> is mostly useless.
    //  Its only benefit is that we can have different memory objects with the same name (but why would we?)
    private final int id;
    // TODO: Generalize <size> to Expression
    private final int size;
    private final Alloc allocationSite;

    private String name = null;
    private boolean isThreadLocal = false;

    private final Map<Integer, Expression> initialValues = new TreeMap<>();

    MemoryObject(int id, int size, Alloc allocationSite, Type ptrType) {
        super(ptrType);
        this.id = id;
        this.size = size;
        this.allocationSite = allocationSite;
    }

    public boolean hasName() { return name != null; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public boolean isStaticallyAllocated() { return allocationSite == null; }
    public boolean isDynamicallyAllocated() { return !isStaticallyAllocated(); }
    public Alloc getAllocationSite() { return allocationSite; }

    public boolean isThreadLocal() { return this.isThreadLocal; }
    public void setIsThreadLocal(boolean value) { this.isThreadLocal = value;}

    /**
     * @return Number of fields in this array.
     */
    public int size() { return size; }

    public Set<Integer> getInitializedFields() {
        return initialValues.keySet();
    }

    /**
     * Initial value at a certain field of this array.
     *
     * @param offset Non-negative number of fields before the target.
     * @return Readable value at the start of each execution.
     */
    public Expression getInitialValue(int offset) {
        checkArgument(offset >= 0 && offset < size, "array index out of bounds");
        checkState(initialValues.containsKey(offset), "%s[%s] has no init value", this, offset);
        return initialValues.get(offset);
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
        final String name = this.name != null ? this.name : ("mem" + id);
        return String.format("&%s%s", name, isDynamicallyAllocated() ? "@E" + allocationSite.getGlobalId() : "");
    }

    @Override
    public int hashCode() { return id; }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        } else if (obj == null || getClass() != obj.getClass()) {
            return false;
        }

        return id == ((MemoryObject) obj).id;
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
