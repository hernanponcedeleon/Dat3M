package com.dat3m.dartagnan.parsers.program.visitors.spirv.transformers;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.LeafExpression;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.program.Register;

import java.util.Map;

public class RegisterTransformer extends ExprTransformer {

    private final Map<Register, Register> mapping;

    public RegisterTransformer(Map<Register, Register> mapping) {
        this.mapping = mapping;
    }

    @Override
    public Expression visitLeafExpression(LeafExpression expr) {
        if (expr instanceof Register reg) {
            return mapping.get(reg);
        }
        return expr;
    }
}
