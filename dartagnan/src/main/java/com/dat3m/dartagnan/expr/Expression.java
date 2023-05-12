package com.dat3m.dartagnan.expr;

import java.util.List;

/*
    TODO: Expressions are currently intended to be immutable and type-checked on construction.
     However, we might want to go with mutable expressions with delayed type-checking.
     This also allows us to more easily attach extra metadata and attributes.
 */
public interface Expression {

    Type getType();
    List<? extends Expression> getOperands();
    ExpressionKind getKind();
    <TRet> TRet accept(ExpressionVisitor<TRet> visitor);

}
