package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.Relation;
import org.sosy_lab.java_smt.api.BooleanFormula;

/*
    The notion of edge aliasing (see EdgeAliasing): decides whether the edge r(e1, e2), which could soundly be
    substituted by the formula 'alias', is actually substituted or keeps its own variable.
 */
public interface EdgeAliasPolicy {

    enum Shape { CONSTANT, LITERAL, OTHER }

    boolean accept(Relation relation, Event e1, Event e2, BooleanFormula alias, Shape shape);

    enum Preset implements EdgeAliasPolicy {
        // No aliasing: every non-trivial edge gets its own variable.
        NONE {
            @Override
            public boolean accept(Relation r, Event e1, Event e2, BooleanFormula alias, Shape shape) {
                return false;
            }
        },
        // Edges whose definition is equivalent to a constant or a literal are substituted by it.
        // This only renames variables and never duplicates formulas.
        LITERALS {
            @Override
            public boolean accept(Relation r, Event e1, Event e2, BooleanFormula alias, Shape shape) {
                return shape != Shape.OTHER;
            }
        },
    }
}
