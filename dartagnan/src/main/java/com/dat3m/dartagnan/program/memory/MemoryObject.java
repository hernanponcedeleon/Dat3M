package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.expression.ExpressionFactory;
import com.dat3m.dartagnan.program.expression.type.TypeFactory;

import java.math.BigInteger;
import java.util.HashMap;
import java.util.Set;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkState;

/**
 * Associated with an array of memory locations.
 */
//TODO initial values are untyped
public class MemoryObject extends IConst {

    private final int index;
    private int size;
    BigInteger address;
    private String cVar;
    // TODO
    // Right now we assume that either the whole object is atomic or it is not.
    // Generally, this is no necessarily true for structs, but right now we
    // don't have a way of marking anything as atomic for bpl files. 
    private boolean atomic = false;

    private final boolean isStatic;

    private final HashMap<Integer, IConst> initialValues = new HashMap<>();

    MemoryObject(int index, int size, boolean isStaticallyAllocated) {
        super(TypeFactory.getInstance().getPointerType());
        this.index = index;
        this.size = size;
        this.isStatic = isStaticallyAllocated;

        if (isStaticallyAllocated) {
            // Static allocations are default-initialized
            initialValues.put(0, ExpressionFactory.getInstance().makeZero(TypeFactory.getInstance().getPointerType()));
        }
    }

    public String getCVar() { return cVar; }
    public void setCVar(String name) { this.cVar = name; }

    public boolean isStaticallyAllocated() { return isStatic; }
    public boolean isDynamicallyAllocated() { return !isStatic; }

    // Should only be called for statically allocated objects.
    public Set<Integer> getStaticallyInitializedFields() {
        checkState(this.isStaticallyAllocated());
        return initialValues.keySet();
    }

    public BigInteger getAddress() { return this.address; }
    public void setAddress(BigInteger addr) { this.address = addr; }

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
    public IConst getInitialValue(int offset) {
        checkArgument(offset >= 0 && offset < size, "array index out of bounds");
        return initialValues.getOrDefault(offset, ExpressionFactory.getInstance().makeZero(TypeFactory.getInstance().getPointerType()));
    }

    /**
     * Defines the initial value at a certain field of this array.
     *
     * @param offset Non-negative number of fields before the target.
     * @param value  New value to be read at the start of each execution.
     */
    public void setInitialValue(int offset, IConst value) {
        checkArgument(offset >= 0 && offset < size, "array index out of bounds");
        initialValues.put(offset, value);
    }

    /**
     * Updates the initial value at a certain field of this array.
     * Resizes this array if the index exceeds the bounds.
     *
     * @param offset Non-negative number of fields before the target.
     * @param value  New value to be read at the start of each execution.
     */
    public void appendInitialValue(int offset, IConst value) {
        checkArgument(offset >= 0, "array index out of bounds");
        //The current implementation of Smack does not provide proper size information on static arrays.
        //Instead, it indicates the size in the Boogie file by initializing each of the fields in a special procedure.
        if (size <= offset) {
            size = offset + 1;
        }
        initialValues.put(offset, value);
    }

    public boolean isAtomic() {
        return atomic;
    }
    public void markAsAtomic() {
        this.atomic = true;
    }

    @Override
    public BigInteger getValue() {
        return address != null ? address : BigInteger.valueOf(index);
    }

    @Override
    public <T> T visit(ExpressionVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public String toString() {
        return cVar != null ? cVar : ("&mem" + index);
    }

    @Override
    public int hashCode() {
        return index;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        } else if (obj == null || getClass() != obj.getClass()) {
            return false;
        }
        return index == ((MemoryObject) obj).index;
    }
}
