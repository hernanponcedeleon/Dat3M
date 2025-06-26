package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.AbstractEvent;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.RegReader;
import com.google.common.base.Preconditions;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.util.HashSet;
import java.util.Set;

public class Assume extends AbstractEvent implements RegReader {

    protected Expression expr;

    public Assume(Expression expr) {
        Preconditions.checkArgument(expr.getType() instanceof BooleanType);
        this.expr = expr;
    }

    protected Assume(Assume other) {
        super(other);
        this.expr = other.expr;
    }


    public Expression getExpr() {
        return expr;
    }


    @Override
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(expr, Register.UsageType.OTHER, new HashSet<>());
    }

    @Override
    public String defaultString() {
        return "assume(" + expr + ")";
    }

    @Override
    public BooleanFormula encodeExec(EncodingContext ctx) {
        BooleanFormulaManager bmgr = ctx.getBooleanFormulaManager();
        return bmgr.and(
                super.encodeExec(ctx),
                bmgr.implication(ctx.execution(this), ctx.getExpressionEncoder().encodeBooleanAt(expr, this).formula()));
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        this.expr = expr.accept(exprTransformer);
    }

    @Override
    public Assume getCopy() {
        return new Assume(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitAssume(this);
    }
}