package com.dat3m.dartagnan.prototype.expr;


/*
   A Literal is a constant that has a fixed and known value.
 */
public interface Literal<T> extends Constant {
   T getValue();
}
