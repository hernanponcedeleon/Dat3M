package com.dat3m.dartagnan.program.specification;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.program.Register;
import org.sosy_lab.java_smt.api.BooleanFormula;

import java.util.ArrayList;
import java.util.List;

public class AssertBasic extends AbstractAssert {

    private final Expression e1;
    private final Expression e2;
    private final COpBin op;

    public AssertBasic(Expression e1, COpBin op, Expression e2) {
        this.e1 = e1;
        this.e2 = e2;
        this.op = op;
    }

    @Override
    public BooleanFormula encode(EncodingContext context) {
        return context.encodeComparison(op,
                context.encodeFinalExpression(e1),
                context.encodeFinalExpression(e2));
    }

    @Override
    public String toString() {
        return valueToString(e1) + op + valueToString(e2);
    }

    private String valueToString(Expression value) {
        if (value instanceof Register register) {
            return register.getFunction().getId() + ":" + value;
        }
        return value.toString();
    }

    @Override
    public List<Register> getRegs() {
        List<Register> regs = new ArrayList<>();
        if (e1 instanceof Register r1) {
            regs.add(r1);
        }
        if (e2 instanceof Register r2) {
            regs.add(r2);
        }
        return regs;
    }
}
