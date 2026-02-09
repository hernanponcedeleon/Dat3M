package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.expression.*;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableList;
import org.sosy_lab.java_smt.api.Formula;

/*
    A TypedFormula carries a Formula describing a value of a given Type.
    This serves two purposes
        (1) It enriches the type system of the backend SMT solver with our IR Types.
        (2) It decouples representation (SMT formula type) from represented type (IR Type)

    To understand the benefit, consider the following examples:

    (1)
    Suppose we have a PointerType PT.
    There are two natural representations for values of PT: as single "bv64 address" or as a tuple "(bv64 base, bv64 offset)".
    Both representations use a different SMT type (BV vs Tuple) but still represent the same IR Type (PT).

    (2)
    Now consider the AggregateType AG = { bv64, bv64 } whose natural value representation is a tuple (bv64 a, bv64 b).
    Notice that on the formula level, AG and PT may have the exact same representation, i.e., they are indistinguishable.
    However, the occupied memory of both types differ: PT is still 64-bit sized whereas AG is 128-bit sized.
    Their bitwise representation is different: PT (bv64 a, bv64 b) becomes "bv64 a + b" whereas AG (bv64 a, bv64 b) becomes
    "bv128 a:b".
    This also affects the semantics of mixed-size access, e.g., imagine a Load that tries to read the first 64 bits of a PT/AG type.
    If the load reads the pointer (a, b), it will read "a + b" but if it reads the aggregate (a, b) it will read just "a".

    (3)
    Aggregates with the same underlying types but different offsets (i.e., a different layout) will be represented by the same
    type of tuple formula. However, as in point (2), their bitwise representation is different which may affect
    the semantics of MSA, or generally, the conversion to a BV type

 */
public record TypedFormula<TType extends Type, TFormula extends Formula>(TType type, TFormula formula)
    implements LeafExpression {

    public TypedFormula {
        Preconditions.checkNotNull(type);
        Preconditions.checkNotNull(formula);
    }

    @Override
    public String toString() {
        return String.format("(%s: %s)", type, formula);
    }

    @Override
    public TType getType() {
        return type;
    }

    @Override
    public ImmutableList<Expression> getOperands() {
        return ImmutableList.of();
    }

    @Override
    public ExpressionKind getKind() {
        return ExpressionKind.Other.FORMULA;
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitLeafExpression(this);
    }
}
