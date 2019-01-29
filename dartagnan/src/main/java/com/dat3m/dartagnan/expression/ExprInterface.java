package com.dat3m.dartagnan.expression;

import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import com.microsoft.z3.Model;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

public interface ExprInterface {

    IntExpr toZ3Int(Event e, Context ctx);

    BoolExpr toZ3Bool(Event e, Context ctx);

    IntExpr getLastValueExpr(Context ctx);

    int getIntValue(Event e, Context ctx, Model model);

    boolean getBoolValue(Event e, Context ctx, Model model);

    ImmutableSet<Register> getRegs();

    ExprInterface clone();
}
