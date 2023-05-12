package com.dat3m.dartagnan.expr;

/*
    A constant is a special type of leaf expression whose value is constant at all times, i.e., no matter where it is
    evaluated.
    The value of a constant may not be statically known though, for example,
    global variables have constant but possibly unknown addresses.
 */
public interface Constant extends LeafExpression { }
