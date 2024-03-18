package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionInspector;
import com.dat3m.dartagnan.program.Register;
import com.google.common.collect.ImmutableSet;

import java.util.List;

public interface Expression {

    Type getType();
    List<Expression> getOperands();
    ExpressionKind getKind();
    <T> T accept(ExpressionVisitor<T> visitor);

    default ImmutableSet<Register> getRegs() {
        class RegisterCollector implements ExpressionInspector {
            private final ImmutableSet.Builder<Register> regs = ImmutableSet.builder();
            @Override
            public Expression visitRegister(Register reg) {
                regs.add(reg);
                return reg;
            }
        }

        final RegisterCollector collector = new RegisterCollector();
        this.accept(collector);
        return collector.regs.build();
    }

}
