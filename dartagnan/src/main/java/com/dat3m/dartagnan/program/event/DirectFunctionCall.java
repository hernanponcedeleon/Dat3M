package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Register.UsageType;
import com.dat3m.dartagnan.program.event.core.AbstractEvent;
import com.dat3m.dartagnan.program.event.core.utils.RegReader;
import com.google.common.base.Preconditions;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

public abstract class DirectFunctionCall extends AbstractEvent implements RegReader {

    protected Function function; // TODO: Generalize to function pointer expressions
    protected List<Expression> arguments;

    protected DirectFunctionCall(Function func, List<Expression> arguments) {
        Preconditions.checkArgument(arguments.size() == func.getFunctionType().getParameterTypes().size());
        this.function = func;
        this.arguments = arguments;
    }

    protected DirectFunctionCall(DirectFunctionCall other) {
        this.function = other.function;
        this.arguments = other.arguments;
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        final Set<Register.Read> regReads = new HashSet<>();
        arguments.forEach(arg -> Register.collectRegisterReads(arg, UsageType.DATA, regReads));
        return regReads;
    }

    protected String argumentsToString() {
        return String.join(", ", arguments.stream().map(expr -> (CharSequence)expr.toString())::iterator);
    }

}
