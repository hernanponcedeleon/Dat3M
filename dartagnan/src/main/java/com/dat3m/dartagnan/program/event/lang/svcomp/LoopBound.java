package com.dat3m.dartagnan.program.event.lang.svcomp;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.core.annotations.CodeAnnotation;
import com.google.common.base.Preconditions;

import java.util.HashSet;
import java.util.Set;

public class LoopBound extends CodeAnnotation implements RegReader {

    private Expression bound;

    public Expression getBound() {
        return bound;
    }

    public int getConstantBound() {
        Preconditions.checkState(this.bound instanceof IntLiteral, "Non-literal bound: %s", bound);
        int bound = ((IntLiteral)this.bound).getValueAsInt();
        if (bound <= 0) {
            throw new MalformedProgramException("Non-positive loop bound annotation: " + this);
        }
        return bound;
    }

    public LoopBound(Expression bound) {
        Preconditions.checkArgument(bound.getType() instanceof IntegerType);
        this.bound = bound;
    }

    protected LoopBound(LoopBound other) {
        super(other);
        this.bound = other.bound;
    }

    @Override
    public String defaultString() {
        return String.format("#__VERIFIER_loop_bound(%s)", bound);
    }

    @Override
    public LoopBound getCopy() {
        return new LoopBound(this);
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(bound, Register.UsageType.OTHER, new HashSet<>());
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        this.bound = bound.accept(exprTransformer);
    }
}
