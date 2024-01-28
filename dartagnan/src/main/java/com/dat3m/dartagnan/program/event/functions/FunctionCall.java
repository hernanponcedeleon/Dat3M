package com.dat3m.dartagnan.program.event.functions;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Register.UsageType;
import com.dat3m.dartagnan.program.event.AbstractEvent;
import com.dat3m.dartagnan.program.event.RegReader;
import com.google.common.base.Preconditions;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

public abstract class FunctionCall extends AbstractEvent implements RegReader {

    protected FunctionType funcType;
    protected Expression callTarget;
    protected List<Expression> arguments;

    protected FunctionCall(FunctionType funcType, Expression funcPtr, List<Expression> arguments) {
        final List<Type> paramTypes = funcType.getParameterTypes();
        Preconditions.checkArgument(
                (!funcType.isVarArgs() && arguments.size() == paramTypes.size())
                        || (funcType.isVarArgs() && arguments.size() >= paramTypes.size())
        );
        for (int i = 0; i < paramTypes.size(); i++) {
            Preconditions.checkArgument(arguments.get(i).getType().equals(paramTypes.get(i)));
        }
        this.funcType = funcType;
        this.callTarget = funcPtr;
        this.arguments = new ArrayList<>(arguments);
    }

    protected FunctionCall(Function func, List<Expression> arguments) {
        this(func.getFunctionType(), func, arguments);
    }

    protected FunctionCall(FunctionCall other) {
        super(other);
        this.funcType = other.funcType;
        this.callTarget = other.callTarget;
        this.arguments = new ArrayList<>(other.arguments);
    }

    public boolean isDirectCall() { return callTarget instanceof Function; }
    public Function getCalledFunction() { return (Function) callTarget; }
    public FunctionType getCallType() { return funcType; }
    public Expression getCallTarget() { return callTarget; }
    public List<Expression> getArguments() { return arguments; }

    public void setArgument(int index, Expression argument) {
        arguments.set(index, argument);
    }

    public void setCallTarget(Expression callTarget) {
        if (callTarget instanceof Function func) {
            Preconditions.checkArgument(func.getFunctionType() == funcType,
                    "Call target %s has mismatching function type: expected %s", callTarget, funcType);
        }
        this.callTarget = callTarget;
    }

    @Override
    public abstract FunctionCall getCopy();

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
        callTarget = callTarget.accept(exprTransformer);
        arguments.replaceAll(expression -> expression.accept(exprTransformer));
    }
}
