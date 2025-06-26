package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.aggregates.ConstructExpr;
import com.dat3m.dartagnan.expression.base.LeafExpressionBase;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.*;
import com.dat3m.dartagnan.program.event.core.MemAlloc;
import com.google.common.base.Preconditions;

import java.util.*;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkState;

/**
 * Associated with an array of memory locations.
 */
public class MemoryObject extends LeafExpressionBase<Type> {

    // TODO: (TH) I think <id> is mostly useless.
    //  Its only benefit is that we can have different memory objects with the same name (but why would we?)
    private final int id;
    private final Expression size;
    private final Expression alignment;
    private final MemAlloc allocationSite;

    private String name = null;
    private boolean isThreadLocal = false;
    private final Set<String> featureTags = new HashSet<>();

    private final Map<Integer, Expression> initialValues = new TreeMap<>();

    MemoryObject(int id, Expression size, Expression alignment, MemAlloc allocationSite, Type ptrType) {
        super(ptrType);
        final TypeFactory types = TypeFactory.getInstance();
        Preconditions.checkArgument(size.getType() instanceof IntegerType, "Size %s must be of integer type.", size);
        Preconditions.checkArgument(alignment.getType() == size.getType(),
                "Size %s and alignment %s must have matching types.", size, alignment);
        Preconditions.checkArgument(types.getMemorySizeInBytes(size.getType()) == types.getMemorySizeInBytes(ptrType),
                "Size expression %s should be of a type whose size matches the pointer type %s.", size, ptrType);
        this.id = id;
        this.alignment = alignment;
        this.size = size;
        this.allocationSite = allocationSite;
    }

    public boolean hasName() { return name != null; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public boolean isStaticallyAllocated() { return allocationSite == null; }
    public boolean isDynamicallyAllocated() { return !isStaticallyAllocated(); }
    public MemAlloc getAllocationSite() { return allocationSite; }

    public boolean isThreadLocal() { return this.isThreadLocal; }
    public void setIsThreadLocal(boolean value) { this.isThreadLocal = value;}

    public void addFeatureTag(String tag) { featureTags.add(tag); }
    public Set<String> getFeatureTags() { return featureTags; }

    public Expression size() { return size; }
    public boolean hasKnownSize() { return size instanceof IntLiteral; }
    public int getKnownSize() {
        Preconditions.checkState(hasKnownSize(), "Cannot call method getKnownSize() for object %s with unknown size", this);
        return ((IntLiteral)size).getValueAsInt();
    }

    public Expression alignment() { return alignment; }
    public boolean hasKnownAlignment() { return alignment instanceof IntLiteral; }
    public int getKnownAlignment() {
        Preconditions.checkState(hasKnownAlignment());
        return ((IntLiteral)alignment).getValueAsInt();
    }

    public boolean isInRange(int offset) {
        return hasKnownSize() && offset >= 0 && offset < getKnownSize();
    }

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
        checkState(hasKnownSize());
        checkArgument(isInRange(offset), "array index out of bounds");
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
        checkState(hasKnownSize());
        final TypeFactory types = TypeFactory.getInstance();
        if (value.getType() instanceof ArrayType arrayType) {
            checkArgument(value instanceof ConstructExpr);
            final ConstructExpr constArray = (ConstructExpr) value;
            final List<Expression> arrayElements = constArray.getOperands();
            for (int i = 0; i < arrayElements.size(); i++) {
                final int innerOffset = types.getOffsetInBytes(arrayType, i);
                setInitialValue(offset + innerOffset, arrayElements.get(i));
            }
        } else if (value.getType() instanceof AggregateType aggregateType) {
            checkArgument(value instanceof ConstructExpr);
            final ConstructExpr constStruct = (ConstructExpr) value;
            final List<Expression> structElements = constStruct.getOperands();
            for (int i = 0; i < structElements.size(); i++) {
                int innerOffset = aggregateType.getFields().get(i).offset();
                setInitialValue(offset + innerOffset, structElements.get(i));
            }
        } else if (value.getType() instanceof IntegerType
                || value.getType() instanceof BooleanType) {
            checkArgument(isInRange(offset), "array index out of bounds");
            initialValues.put(offset, value);
        } else {
            throw new UnsupportedOperationException("Unrecognized constant value: " + value);
        }
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
