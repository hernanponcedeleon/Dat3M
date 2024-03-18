package com.dat3m.dartagnan.program.event.lang;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.AbstractEvent;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.google.common.base.Preconditions;

import java.math.BigInteger;
import java.util.HashSet;
import java.util.Set;

/*
    Alloc represents any dynamic allocation performed in the program, i.e., both heap and stack allocations.
    Each allocation has a type and an array size (equals 1 for simple allocations).

    NOTE: We consider this a "language" event rather than a "core" event, because we replace this event
    in the processing.
 */
public class Alloc extends AbstractEvent implements RegReader, RegWriter {
    private Register resultRegister;
    private Type allocationType;
    private Expression arraySize;
    private boolean isHeapAllocation;
    private boolean doesZeroOutMemory;

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

    protected Alloc(Alloc other) {
        super(other);
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


    public Expression getAllocationSize() {
        final ExpressionFactory expressions = ExpressionFactory.getInstance();
        final TypeFactory types = TypeFactory.getInstance();
        final Expression allocationSize;
        if (arraySize instanceof IntLiteral value) {
            allocationSize = expressions.makeValue(
                    BigInteger.valueOf(types.getMemorySizeInBytes(allocationType)).multiply(value.getValue()),
                    types.getArchType()
            );
        } else {
            allocationSize = expressions.makeMul(
                    expressions.makeValue(
                            BigInteger.valueOf(types.getMemorySizeInBytes(allocationType)),
                            (IntegerType) arraySize.getType()),
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
}
