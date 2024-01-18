package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.AbstractEvent;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.RegReader;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.util.HashSet;
import java.util.Set;

public class Assume extends AbstractEvent implements RegReader {

    protected Expression expr;

    public Assume(Expression expr) {
        super();
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
                bmgr.implication(ctx.execution(this), ctx.encodeExpressionAsBooleanAt(expr, this)));
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