package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.Tag;
import org.sosy_lab.java_smt.api.BooleanFormula;

import java.util.HashSet;
import java.util.Set;

public class ControlBarrier extends GenericVisibleEvent implements RegReader {
    private Expression id;

    public ControlBarrier(String name, Expression id) {
        super(name, Tag.FENCE);
        this.id = id;
    }

    protected ControlBarrier(ControlBarrier other) {
        super(other);
        this.id = other.id;
    }

    public Expression getId() {
        return id;
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        this.id = id.accept(exprTransformer);
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(id, Register.UsageType.OTHER, new HashSet<>());
    }

    @Override
    public String defaultString() {
        return String.format("%s := barrier_id[%s]", name, id);
    }

    @Override
    public ControlBarrier getCopy() {
        return new ControlBarrier(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitControlBarrier(this);
    }

    @Override
    public BooleanFormula encodeExec(EncodingContext ctx) {
        return ctx.getBooleanFormulaManager().implication(ctx.execution(this), ctx.controlFlow(this));
    }

    @Override
    public boolean cfImpliesExec() {
        return false;
    }
}
