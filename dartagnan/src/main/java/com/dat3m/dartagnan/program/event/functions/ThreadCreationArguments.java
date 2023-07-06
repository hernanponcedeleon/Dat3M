package com.dat3m.dartagnan.program.event.functions;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.AbstractEvent;
import com.dat3m.dartagnan.program.event.core.utils.RegReader;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

public class ThreadCreationArguments extends AbstractEvent implements RegReader {

    protected List<Expression> arguments;

    public ThreadCreationArguments(List<Expression> arguments) {
        this.arguments = new ArrayList<>(arguments);
    }

    protected ThreadCreationArguments(ThreadCreationArguments other) {
        super(other);
        this.arguments = new ArrayList<>(other.arguments);
    }

    public List<Expression> getArguments() { return arguments; }

    @Override
    protected String defaultString() {
        return "ThreadArguments" +
                arguments.stream().map(Expression::toString).collect(Collectors.joining(", ", "(", ")"));
    }

    @Override
    public ThreadCreationArguments getCopy() {
        return new ThreadCreationArguments(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        // TODO
        return visitor.visitEvent(this);
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        final Set<Register.Read> regReads = new HashSet<>();
        arguments.forEach(arg -> Register.collectRegisterReads(arg, Register.UsageType.DATA, regReads));
        return regReads;
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        arguments.replaceAll(expression -> expression.visit(exprTransformer));
    }
}
