package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.utils.RegReader;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.base.Preconditions;
import org.sosy_lab.java_smt.api.BooleanFormula;

import java.util.HashSet;
import java.util.Set;

public class Local extends AbstractEvent implements RegWriter, RegReader {

    protected Register register;
    protected Expression expr;

    public Local(Register register, Expression expr) {
        Preconditions.checkArgument(register.getType().equals(expr.getType()));
        this.register = register;
        this.expr = expr;
    }

    protected Local(Local other) {
        super(other);
        this.register = other.register;
        this.expr = other.expr;
    }

    public Expression getExpr() {
        return expr;
    }

    public void setExpr(Expression expr) {
        this.expr = expr;
    }

    @Override
    public Register getResultRegister() {
        return register;
    }

    @Override
    public void setResultRegister(Register reg) {
        this.register = reg;
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(expr, Register.UsageType.DATA, new HashSet<>());
    }

    @Override
    public String defaultString() {
        String str = register + " <- " + expr;
        if (this.hasTag(Tag.Std.MALLOC)) {
            str = str + "\t### " + Tag.Std.MALLOC;
        }
        return str;
    }

    @Override
    public BooleanFormula encodeExec(EncodingContext context) {
        return context.getBooleanFormulaManager().and(
                super.encodeExec(context),
                context.equal(context.result(this), context.encodeExpressionAt(expr, this)));
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        this.expr = expr.visit(exprTransformer);
    }

    @Override
    public Local getCopy() {
        return new Local(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitLocal(this);
    }
}