package com.dat3m.dartagnan.prototype.program.event.core.memory;

import com.dat3m.dartagnan.prototype.expr.Expression;
import com.dat3m.dartagnan.prototype.expr.Type;
import com.dat3m.dartagnan.prototype.expr.integers.IntBinaryExpression;
import com.dat3m.dartagnan.prototype.expr.integers.IntLiteral;
import com.dat3m.dartagnan.prototype.expr.types.IntegerType;
import com.dat3m.dartagnan.prototype.program.Register;
import com.dat3m.dartagnan.prototype.program.event.AbstractEvent;
import com.google.common.base.Preconditions;

import java.util.HashSet;
import java.util.Set;

import static com.dat3m.dartagnan.prototype.expr.ExpressionKind.IntBinary.MUL;

/*
    Alloc represents any dynamic allocation performed in the program, i.e., both heap and stack allocations.
    Each allocation has a type and an array size (equals 1 for simple allocations).

    NOTE: A Malloc is considered a heap-allocated Array of Int8.
 */
// TODO: "abstract" is only here to avoid providing a complete implementation for now
public abstract class Alloc extends AbstractEvent implements Register.Writer, Register.Reader {
    private Register resultRegister;
    private Type allocationType;
    private Expression arraySize;
    private boolean isHeapAllocation;

    private Alloc(Register resultRegister, Type allocType, Expression arraySize, boolean isHeapAllocation) {
        // TODO: What type for array size do we expect? LLVM seems to use i64 for both malloc and alloca.
        Preconditions.checkArgument(arraySize.getType().equals(IntegerType.INT64));
        this.resultRegister = resultRegister;
        this.arraySize = arraySize;
        this.allocationType = allocType;
        this.isHeapAllocation = isHeapAllocation;
    }

    @Override
    public Register getResultRegister() { return resultRegister; }
    public Type getAllocationType() { return allocationType; }
    public Expression getArraySize() { return arraySize; }
    public Expression getAllocationSize() {
        final Expression typeSize = IntegerType.INT64.createLiteral(allocationType.getMemorySize());
        return isSimpleAllocation() ? typeSize : IntBinaryExpression.create(typeSize, MUL, arraySize);
    }
    public boolean isHeapAllocation() { return isHeapAllocation; }

    public boolean isSimpleAllocation() { return (arraySize instanceof IntLiteral size && size.isOne()); }
    public boolean isArrayAllocation() { return !isSimpleAllocation(); }

    @Override
    public Set<Register.Read> getRegisterReads() {
        final Set<Register.Read> regReads = new HashSet<>();
        Register.collectRegisterReads(arraySize, Register.UsageType.DATA, regReads);
        return regReads;
    }
}
