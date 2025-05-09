package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.expression.Type;
import com.google.common.base.Preconditions;

/*
    TODO: This is a temporary solution and code should not be too dependent on this class.
     The issue is as follows: while TypedFormulas allow us to construct SMT encodings agnostic to the actual
     SMT types used in the encoding, the corresponding TypedValues generated from an SMT model
     exposes the underlying SMT types.
     What we rather want to have are Literal expressions, e.g., rather
     than TypedValue<IntegerType, BigInteger>, we should return IntLiteral.
     Similarly, rather than TypedValue<BooleanType, Boolean>, we should return BoolLiteral, etc.
 */
public record TypedValue<TType extends Type, TValue> (TType type, TValue value) {

    public TypedValue {
        Preconditions.checkNotNull(type);
        Preconditions.checkNotNull(value);
    }

    @Override
    public String toString() {
        return String.format("%s: %s", type, value);
    }

}
