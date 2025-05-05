package com.dat3m.dartagnan.program.event.functions;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Register.UsageType;
import com.dat3m.dartagnan.program.event.AbstractEvent;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.google.common.base.Preconditions;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

public class FunctionCall extends AbstractEvent implements RegReader, RegWriter {

    protected FunctionType funcType;
    protected Expression callTarget;
    protected List<Expression> arguments;
    protected Register resultRegister;

    public FunctionCall(Register resultRegister, FunctionType funcType, Expression funcPtr, List<Expression> arguments) {
        final List<Type> paramTypes = funcType.getParameterTypes();
        Preconditions.checkArgument(
                (!funcType.isVarArgs() && arguments.size() == paramTypes.size())
                        || (funcType.isVarArgs() && arguments.size() >= paramTypes.size())
        );
        Preconditions.checkArgument(resultRegister.getType().equals(funcType.getReturnType()));
        for (int i = 0; i < paramTypes.size(); i++) {
            Preconditions.checkArgument(arguments.get(i).getType().equals(paramTypes.get(i)));
        }
        this.resultRegister = resultRegister;
        this.funcType = funcType;
        this.callTarget = funcPtr;
        this.arguments = new ArrayList<>(arguments);
    }

    protected FunctionCall(Register resultRegister, Function func, List<Expression> arguments) {
        this(resultRegister, func.getFunctionType(), func, arguments);
    }

    protected FunctionCall(FunctionCall other) {
        super(other);
        this.resultRegister = other.resultRegister;
        this.funcType = other.funcType;
        this.callTarget = other.callTarget;
        this.arguments = new ArrayList<>(other.arguments);
    }

    @Override
    public Register getResultRegister() {
        return resultRegister;
    }

    @Override
    public void setResultRegister(Register reg) {
        this.resultRegister = reg;
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
    public FunctionCall getCopy() {
        return new FunctionCall(this);
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        final Set<Register.Read> regReads = new HashSet<>();
        arguments.forEach(arg -> Register.collectRegisterReads(arg, UsageType.DATA, regReads));
        return regReads;
    }

    @Override
    protected String defaultString() {
        final Object target = isDirectCall() ? ((Function)callTarget).getName() : callTarget;
        return String.format("%s <- call %s(%s)", resultRegister, target,
                arguments.stream().map(Expression::toString).collect(Collectors.joining(", ")));
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        callTarget = callTarget.accept(exprTransformer);
        arguments.replaceAll(expression -> expression.accept(exprTransformer));
    }
}
