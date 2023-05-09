package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.INonDet;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.collect.ImmutableSet;
import org.sosy_lab.java_smt.api.BitvectorFormula;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.FormulaManager;

public class Local extends Event implements RegWriter, RegReaderData {

    protected final Register register;
    protected ExprInterface expr;

    public Local(Register register, ExprInterface expr) {
        this.register = register;
        this.expr = expr;
        addFilters(Tag.LOCAL, Tag.REG_WRITER, Tag.REG_READER);
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
        FormulaManager fmgr = context.getFormulaManager();
        BooleanFormula enc = super.encodeExec(context);
        if (expr instanceof INonDet) {
            enc = bmgr.and(enc, ((INonDet) expr).encodeBounds(expr.toIntFormula(this, fmgr) instanceof BitvectorFormula, fmgr));
        }
        return bmgr.and(enc, context.equal(context.result(this), expr.toIntFormula(this, fmgr)));
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