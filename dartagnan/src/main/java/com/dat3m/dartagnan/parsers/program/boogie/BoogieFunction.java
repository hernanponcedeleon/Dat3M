package com.dat3m.dartagnan.parsers.program.boogie;

import com.dat3m.dartagnan.parsers.BoogieParser.ExprContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Var_or_typeContext;

import java.util.List;

public record BoogieFunction(String name, List<Var_or_typeContext> signature, ExprContext body) {

}
