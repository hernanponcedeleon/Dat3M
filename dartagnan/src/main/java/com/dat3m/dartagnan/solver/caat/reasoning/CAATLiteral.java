package com.dat3m.dartagnan.solver.caat.reasoning;

import com.dat3m.dartagnan.solver.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.caat.predicates.Derivable;
import com.dat3m.dartagnan.utils.logic.Conjunction;
import com.dat3m.dartagnan.utils.logic.Literal;

import java.util.Objects;

/*
    A CAATLiteral either represents some unary ground atom "name(x)", a binary ground atom "name(x, y)"
    or a comparison atom "name(x) op name(y)" (not yet supported)
    Efficient implementations could store a literal in a single 64-bit integer with
    - 4 sign/op bits
    - 12 name bits (index into name table)
    - 2 x 24 event index bits (indices into an event table)
 */
public interface CAATLiteral extends Literal<CAATLiteral> {

    CAATPredicate getPredicate();
    Derivable getData();

    default Conjunction<CAATLiteral> toSingletonReason() {
        return new Conjunction<>(this);
    }
}


abstract class CAATLiteralBase<TPred extends CAATPredicate, TData extends Derivable> implements CAATLiteral {

    protected final TPred predicate;
    protected final TData data;
    protected final boolean isPositive;

    protected CAATLiteralBase(TPred pred, TData data, boolean isPositive) {
        this.predicate = pred;
        this.data = data;
        this.isPositive = isPositive;
    }

    @Override
    public int hashCode() {
        return Objects.hash(predicate, data, isPositive);
    }

    @Override
    public boolean equals(Object obj) {
        return (obj instanceof CAATLiteralBase<?,?> other && obj.getClass() == this.getClass()
        && predicate == other.predicate
        && data.equals(other.data)
        && isPositive == other.isPositive);
    }

    @Override
    public TPred getPredicate() {
        return predicate;
    }

    @Override
    public TData getData() {
        return data;
    }

    @Override
    public String getName() {
        return predicate.getName();
    }

    @Override
    public boolean isPositive() {
        return isPositive;
    }
}
