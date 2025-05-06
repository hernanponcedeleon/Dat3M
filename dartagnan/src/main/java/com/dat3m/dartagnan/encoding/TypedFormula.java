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

    TODO:
        The above examples showcase that IR Types should have a unifying bitwise(?) representation which becomes relevant
        when communicating over memory.
        We can give this representation an IR Type M = AbstractBytes<size> parametric in the bitsize.
        Then this type should satisfy the following properties:
            - Every standard IR Type T should be convertable to an appropriately-sized M
            - M should be convertable to other IR types (not necessarily all?)
            - A round trip T->M->T should be lossless.
        ======
        Stores of type T conceptually store Convert(T->M) in memory and loads of type T load sizeof(T) bits
        of type M and then convert them to T via Convert(M->T).
        The lossless roundtrip property guarantees that a T-load of a T-store reads precisely the correct value.
        For type-mismatches, i.e. T1-load reads T2-store, the intermediate M type gives the conversion T2 -> M -> T1.
        ======
        The type M should allow for only two operations: extraction and concatenation
        ======
        Values of type M<X> represent an X-bit value, but their underlying representations are allowed to carry arbitrary
        metadata, i.e., they may be of shape (metadata, bvX).
        This might be necessary to preserve metadata like pointer provenance over memory:
        PT (bv64 base, bv64 offset) would get converted to M (bv64 base, bv64 base + offset) so that a conversion back to
        PT is lossless.
        Similarly, the metadata could even carry the original type from which M was constructed if it helps in any way.
        Metadata then needs to be preserved even over extract/concatenation operations.
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
        return () -> "FORMULA";
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitLeafExpression(this);
    }
}
