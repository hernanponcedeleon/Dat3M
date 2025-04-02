package com.dat3m.dartagnan.program.event.functions;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.event.CallEvent;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.common.CallBase;

import java.util.List;

public abstract class FunctionCall extends CallBase implements RegReader, CallEvent {

    protected FunctionCall(FunctionType funcType, Expression funcPtr, List<Expression> arguments) {
        super(funcType, funcPtr, arguments);
    }

    protected FunctionCall(Function func, List<Expression> arguments) {
        this(func.getFunctionType(), func, arguments);
    }

    protected FunctionCall(CallBase other) {
        super(other);
    }

    @Override
    public abstract FunctionCall getCopy();

}
