package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.AbstractEvent;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.google.common.base.Preconditions;
import org.sosy_lab.java_smt.api.BooleanFormula;

import java.math.BigInteger;
import java.util.HashSet;
import java.util.Set;

/*
    Alloc represents any dynamic allocation performed in the program, i.e., both heap and stack allocations.
    Each allocation has a type and an array size (equals 1 for simple allocations).
 */
public final class Alloc extends AbstractEvent implements RegReader, RegWriter {
    private Register resultRegister;
    private Type allocationType;
    private Expression arraySize;
    private boolean isHeapAllocation;
    private boolean doesZeroOutMemory;

    // This will be set at the end of the program processing.
    private transient MemoryObject allocatedObject;

    public Alloc(Register resultRegister, Type allocType, Expression arraySize, boolean isHeapAllocation,
                 boolean doesZeroOutMemory) {
        Preconditions.checkArgument(resultRegister.getType() == TypeFactory.getInstance().getArchType());
        Preconditions.checkArgument(arraySize.getType() instanceof IntegerType);
        this.resultRegister = resultRegister;
        this.arraySize = arraySize;
        this.allocationType = allocType;
        this.isHeapAllocation = isHeapAllocation;
        this.doesZeroOutMemory = doesZeroOutMemory;
    }

    private Alloc(Alloc other) {
        super(other);
        Preconditions.checkState(other.allocatedObject == null,
                "Cannot copy Alloc events after memory allocation was performed.");
        this.resultRegister = other.resultRegister;
        this.allocationType = other.allocationType;
        this.arraySize = other.arraySize;
        this.isHeapAllocation = other.isHeapAllocation;
        this.doesZeroOutMemory = other.doesZeroOutMemory;
    }

    @Override
    public Register getResultRegister() { return resultRegister; }
    @Override
    public void setResultRegister(Register reg) { this.resultRegister = reg; }

    public Type getAllocationType() { return allocationType; }
    public Expression getArraySize() { return arraySize; }
    public boolean isHeapAllocation() { return isHeapAllocation; }
    public boolean doesZeroOutMemory() { return doesZeroOutMemory; }

    public boolean isSimpleAllocation() { return (arraySize instanceof IntLiteral size && size.isOne()); }
    public boolean isArrayAllocation() { return !isSimpleAllocation(); }

    public void setAllocatedObject(MemoryObject obj) { this.allocatedObject = obj; }
    // WARNING: This should only be accessed after program processing.
    public MemoryObject getAllocatedObject() {
        Preconditions.checkState(allocatedObject != null,
                "Cannot access the allocated object of '%s': no memory object associated. " +
                        "This method shall only be called after program processing.");
        return allocatedObject;
    }


    public Expression getAllocationSize() {
        final ExpressionFactory expressions = ExpressionFactory.getInstance();
        final TypeFactory types = TypeFactory.getInstance();
        final Expression allocationSize;
        if (arraySize instanceof IntLiteral value) {
            allocationSize = expressions.makeValue(
                    BigInteger.valueOf(types.getMemorySizeInBytes(allocationType)).multiply(value.getValue()),
                    (IntegerType) arraySize.getType()
            );
        } else {
            allocationSize = expressions.makeMul(
                    expressions.makeValue(types.getMemorySizeInBytes(allocationType), (IntegerType) arraySize.getType()),
                    arraySize
            );
        }
        return allocationSize;
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(arraySize, Register.UsageType.DATA, new HashSet<>());
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        arraySize = arraySize.accept(exprTransformer);
    }

    @Override
    protected String defaultString() {
        return String.format("%s <- %salloc(%s, %s)",
                resultRegister, isHeapAllocation ? "heap" : "stack", allocationType, arraySize);
    }

    @Override
    public Alloc getCopy() { return new Alloc(this); }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitAlloc(this);
    }

    @Override
    public BooleanFormula encodeExec(EncodingContext ctx) {
        return ctx.getBooleanFormulaManager().and(
                super.encodeExec(ctx),
                ctx.equal(ctx.result(this), ctx.encodeExpressionAt(getAllocatedObject(), this))
        );
    }
}
