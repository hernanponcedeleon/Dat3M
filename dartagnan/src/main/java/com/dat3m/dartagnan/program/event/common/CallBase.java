package com.dat3m.dartagnan.program.event.common;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Register.UsageType;
import com.dat3m.dartagnan.program.event.AbstractEvent;
import com.dat3m.dartagnan.program.event.CallEvent;
import com.google.common.base.Preconditions;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

public abstract class CallBase extends AbstractEvent implements CallEvent {

    protected FunctionType funcType;
    protected Expression callTarget;
    protected List<Expression> arguments;

    protected CallBase(FunctionType funcType, Expression funcPtr, List<Expression> arguments) {
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

    protected CallBase(CallBase other) {
        super(other);
        this.funcType = other.funcType;
        this.callTarget = other.callTarget;
        this.arguments = new ArrayList<>(other.arguments);
    }

    public Function getCalledFunction() { return (Function) callTarget; }
    @Override
    public FunctionType getCallType() { return funcType; }
    @Override
    public Expression getCallTarget() { return callTarget; }
    @Override
    public List<Expression> getArguments() { return arguments; }

    @Override
    public void setArgument(int index, Expression argument) {
        arguments.set(index, argument);
    }

    @Override
    public void setCallTarget(Expression callTarget) {
        if (callTarget instanceof Function func) {
            Preconditions.checkArgument(func.getFunctionType() == funcType,
                    "Call target %s has mismatching function type: expected %s", callTarget, funcType);
        }
        this.callTarget = callTarget;
    }

    @Override
    public abstract CallEvent getCopy();

    @Override
    public Set<Register.Read> getRegisterReads() {
        final Set<Register.Read> regReads = new HashSet<>();
        Register.collectRegisterReads(callTarget, UsageType.CTRL, regReads);
        Register.collectRegisterReads(arguments, UsageType.DATA, regReads);
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
