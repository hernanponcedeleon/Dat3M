package com.dat3m.dartagnan.program.event.core.special;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.AbstractEvent;
import com.dat3m.dartagnan.program.event.RegReader;

import java.util.*;
import java.util.stream.Collectors;

/*
    Currently, this event is only used to instrument loops for non-termination detection.
 */
public class StateSnapshot extends AbstractEvent implements RegReader {

    private final List<Expression> expressions;

    public StateSnapshot(Collection<? extends Expression> expressions) {
        this.expressions = new ArrayList<>(expressions);
    }

    private StateSnapshot(StateSnapshot stateSnapshot) {
        super(stateSnapshot);
        this.expressions = new ArrayList<>(stateSnapshot.expressions);
    }

    public List<Expression> getExpressions() {
        return expressions;
    }

    @Override
    protected String defaultString() {
        return String.format("StateSnapshot(%s)",
                expressions.stream().map(Expression::toString).collect(Collectors.joining(", ")));
    }

    @Override
    public StateSnapshot getCopy() {
        return new StateSnapshot(this);
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(expressions, Register.UsageType.OTHER, new HashSet<>());
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        expressions.replaceAll(expression -> expression.accept(exprTransformer));
    }
}
