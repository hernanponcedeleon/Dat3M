package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.expression.Expression;
import com.dat3m.dartagnan.program.NondeterministicExpression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.dat3m.dartagnan.program.expression.type.IntegerType;
import com.google.common.collect.ImmutableSet;
import org.sosy_lab.java_smt.api.*;

public class Local extends Event implements RegWriter, RegReaderData {

    protected final Register register;
    protected Expression expr;

    public Local(Register register, Expression expr) {
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
    public ImmutableSet<Register> getDataRegs() {
        return expr.getRegs();
    }

    @Override
    public String toString() {
        String str = register + " <- " + expr;
        if (this.is(Tag.Std.MALLOC)) {
            str = str + "\t### " + Tag.Std.MALLOC;
        }
        return str;
    }

    @Override
    public BooleanFormula encodeExec(EncodingContext context) {
        BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        BooleanFormula enc = super.encodeExec(context);
        Formula expression = context.encodeIntegerExpressionAt(expr, this);
        if (expr instanceof NondeterministicExpression) {
            NondeterministicExpression nonDet = (NondeterministicExpression) expr;
            if (expression instanceof BitvectorFormula) {
                boolean signed = nonDet.isSigned();
                BitvectorFormulaManager bvmgr = context.getFormulaManager().getBitvectorFormulaManager();
                IntegerType type = (IntegerType) nonDet.getType();
                enc = bmgr.and(enc,
                        nonDet.getMin().map(min -> bvmgr.greaterOrEquals((BitvectorFormula) expression, bvmgr.makeBitvector(type.getBitWidth(), min), signed)).orElseGet(bmgr::makeTrue),
                        nonDet.getMax().map(max -> bvmgr.lessOrEquals((BitvectorFormula) expression, bvmgr.makeBitvector(type.getBitWidth(), max), signed)).orElseGet(bmgr::makeTrue));
            } else {
                IntegerFormulaManager imgr = context.getFormulaManager().getIntegerFormulaManager();
                enc = bmgr.and(enc,
                        nonDet.getMin().map(min -> imgr.greaterOrEquals((NumeralFormula.IntegerFormula) expression, imgr.makeNumber(min))).orElseGet(bmgr::makeTrue),
                        nonDet.getMax().map(max -> imgr.lessOrEquals((NumeralFormula.IntegerFormula) expression, imgr.makeNumber(max))).orElseGet(bmgr::makeTrue));
            }
        }
        return bmgr.and(enc, context.equal(context.result(this), expression));
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public Local getCopy() {
        return new Local(this);
    }

    // Visitor
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitLocal(this);
    }
}