package com.dat3m.dartagnan.parsers.program.boogie;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.parsers.BoogieParser.Var_exprContext;
import com.google.common.collect.Lists;

import java.util.List;

public class BoogieFunctionCall {

    private final BoogieFunction function;
    private final BoogieFunctionCall parent;
    private final List<Expression> callArguments;

    public BoogieFunctionCall(BoogieFunction function, List<Expression> callArguments, BoogieFunctionCall caller) {
        if (!(function.signature().size() == callArguments.size())) {
            throw new ParsingException("The number of arguments in the function call does not match " + function.name() + "'s signature");
        }
        this.function = function;
        this.callArguments = callArguments;
        this.parent = caller;
    }

    public BoogieFunctionCall getParent() {
        return parent;
    }

    public BoogieFunction getFunction() {
        return function;
    }

    public List<Expression> getCallArguments() {
        return callArguments;
    }

    public Expression replaceParamByArgument(Var_exprContext ctx) {
        final List<String> signature = Lists.transform(function.signature(), s -> s.Ident().getText());
        final String paramName = ctx.getText();
        final int index = signature.indexOf(paramName);
        if (index == -1) {
            throw new ParsingException("Input " + paramName + " is not part of " + function.name() + " signature");
        }

        //TODO: I don't understand why we can go the topmost caller like this without updating the index in any way
        // I guess it is wrong and only works because functions are either not nested or just pass their arguments
        //  forward?
        BoogieFunctionCall caller = this;
        while (caller.getParent() != null) {
            caller = caller.getParent();
        }
        return caller.callArguments.get(index);
    }
}
