package com.dat3m.dartagnan.expression;

import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Model;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

public interface ExprInterface {

	IConst reduce();
	
    Expr toZ3NumExpr(Event e, Context ctx, boolean bp);

    BoolExpr toZ3Bool(Event e, Context ctx, boolean bp);

    Expr getLastValueExpr(Context ctx, boolean bp);

    int getIntValue(Event e, Context ctx, Model model, boolean bp);

    boolean getBoolValue(Event e, Context ctx, Model model, boolean bp);

    ImmutableSet<Register> getRegs();
    
}
