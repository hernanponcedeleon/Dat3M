package com.dat3m.dartagnan.solver.newcaat.reasoning;

import com.dat3m.dartagnan.utils.logic.Conjunction;
import com.dat3m.dartagnan.utils.logic.Literal;

/*
    A CAATLiteral either represents some unary ground atom "name(x)", a binary ground atom "name(x, y)"
    or a comparison atom "name(x) op name(y)" (not yet supported)
    Efficient implementations could store a literal in a single 64-bit integer with
    - 4 sign/op bits
    - 12 name bits (index into name table)
    - 2 x 24 event index bits (indices into an event table)
 */
public interface CAATLiteral extends Literal<CAATLiteral> {
    default Conjunction<CAATLiteral> toSingletonReason() {
        return new Conjunction<>(this);
    }
}
