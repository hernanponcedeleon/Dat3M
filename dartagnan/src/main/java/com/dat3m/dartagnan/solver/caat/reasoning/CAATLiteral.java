package com.dat3m.dartagnan.solver.caat.reasoning;

import com.dat3m.dartagnan.utils.logic.Conjunction;
import com.dat3m.dartagnan.utils.logic.Literal;

/*
    A CAATLiteral either represents some unary ground atom "name(x)", a binary ground atom "name(x, y)"
    or a comparison atom "name(x) op name(y)"
    Efficient implementations could store a literal in a single 64-bit long with
    - 4 sign/op bits
    - 12 name bits (index into name table)
    - 2 x 24 event index bits (indices into an event table)
 */
// TODO: Due to our current use-case, we only need EdgeLiterals.
public interface CAATLiteral extends Literal<CAATLiteral> {
    default Conjunction<CAATLiteral> toSingletonReason() {
        return new Conjunction<>(this);
    }
}
