package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.INonDet;
import com.dat3m.dartagnan.expression.INonDetTypes;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.collect.ImmutableSet;
import org.sosy_lab.java_smt.api.*;

import static com.dat3m.dartagnan.expression.INonDetTypes.*;

public class Local extends Event implements RegWriter, RegReaderData {

    protected final Register register;
    protected ExprInterface expr;

    public Local(Register register, ExprInterface expr) {
        this.register = register;
        this.expr = expr;
        addFilters(Tag.ANY, Tag.LOCAL, Tag.REG_WRITER, Tag.REG_READER);
    }

    protected Local(Local other) {
        super(other);
        this.register = other.register;
        this.expr = other.expr;
    }

    public ExprInterface getExpr() {
        return expr;
    }

    public void setExpr(ExprInterface expr) {
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
        Formula expression = context.encodeIntegerExpression(this, expr);
        if (expr instanceof INonDet) {
            long min = ((INonDet) expr).getMin();
            long max = ((INonDet) expr).getMax();
            if (expression instanceof BitvectorFormula) {
                INonDetTypes type = ((INonDet) expr).getType();
                boolean signed = type.equals(INT) || type.equals(LONG) || type.equals(SHORT) || type.equals(CHAR);
                BitvectorFormulaManager bvmgr = context.getFormulaManager().getBitvectorFormulaManager();
                enc = bmgr.and(enc,
                        bvmgr.greaterOrEquals((BitvectorFormula) expression, bvmgr.makeBitvector(((INonDet) expr).getPrecision(), min), signed),
                        bvmgr.lessOrEquals((BitvectorFormula) expression, bvmgr.makeBitvector(((INonDet) expr).getPrecision(), max), signed));
            } else {
                IntegerFormulaManager imgr = context.getFormulaManager().getIntegerFormulaManager();
                enc = bmgr.and(enc,
                        imgr.greaterOrEquals((NumeralFormula.IntegerFormula) expression, imgr.makeNumber(min)),
                        imgr.lessOrEquals((NumeralFormula.IntegerFormula) expression, imgr.makeNumber(max)));
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