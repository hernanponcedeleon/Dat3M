package com.dat3m.dartagnan.program.event.functions;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Register.UsageType;
import com.dat3m.dartagnan.program.event.core.AbstractEvent;
import com.dat3m.dartagnan.program.event.core.utils.RegReader;
import com.google.common.base.Preconditions;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

public abstract class DirectFunctionCall extends AbstractEvent implements RegReader {

    protected Function callTarget; // TODO: Generalize to function pointer expressions
    protected List<Expression> arguments;

    protected DirectFunctionCall(Function func, List<Expression> arguments) {
        final List<Type> paramTypes = func.getFunctionType().getParameterTypes();
        Preconditions.checkArgument(
                (!func.isVarArgs() && arguments.size() == paramTypes.size())
                        || (func.isVarArgs() && arguments.size() >= paramTypes.size())
                );
        for (int i = 0; i < paramTypes.size(); i++) {
            Preconditions.checkArgument(arguments.get(i).getType().equals(paramTypes.get(i)));
        }
        this.callTarget = func;
        this.arguments = new ArrayList<>(arguments);
    }

    protected DirectFunctionCall(DirectFunctionCall other) {
        super(other);
        this.callTarget = other.callTarget;
        this.arguments = new ArrayList<>(other.arguments);
    }

    public Function getCallTarget() { return callTarget; }
    public List<Expression> getArguments() { return arguments; }

    @Override
    public Set<Register.Read> getRegisterReads() {
        final Set<Register.Read> regReads = new HashSet<>();
        arguments.forEach(arg -> Register.collectRegisterReads(arg, UsageType.DATA, regReads));
        return regReads;
    }

    protected String argumentsToString() {
        return arguments.stream().map(Expression::toString).collect(Collectors.joining(", "));
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        arguments.replaceAll(expression -> expression.accept(exprTransformer));
    }

}
