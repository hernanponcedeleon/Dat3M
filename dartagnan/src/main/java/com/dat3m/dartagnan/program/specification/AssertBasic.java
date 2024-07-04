package com.dat3m.dartagnan.program.specification;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.integers.IntCmpOp;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.google.common.collect.Sets;
import org.sosy_lab.java_smt.api.BooleanFormula;

import java.util.Set;

public class AssertBasic extends AbstractAssert {

    private final Expression e1;
    private final Expression e2;
    private final IntCmpOp op;

    public AssertBasic(Expression e1, IntCmpOp op, Expression e2) {
        this.e1 = e1;
        this.e2 = e2;
        this.op = op;
    }

    public Expression getLeft() {
        return e1;
    }

    public Expression getRight() {
        return e2;
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
    public Set<Register> getRegisters() {
        return Sets.union(e1.getRegs(), e2.getRegs());
    }

    @Override
    public Set<MemoryObject> getMemoryObjects() {
        return Sets.union(e1.getMemoryObjects(), e2.getMemoryObjects());
    }
}
