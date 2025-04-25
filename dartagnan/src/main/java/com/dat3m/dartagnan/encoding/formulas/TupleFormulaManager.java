package com.dat3m.dartagnan.encoding.formulas;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.encoding.EncodingHelper;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.Iterables;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.Formula;

import java.util.List;
import java.util.stream.IntStream;


/*
    Note: This class cannot actually create variables of tuple type and merely gives the illusion of
    a proper tuple theory.
    To simulate tuple variables, the user instead has to construct tuples of variables.
 */
public final class TupleFormulaManager {

    private final EncodingContext context;

    public TupleFormulaManager(EncodingContext context) {
        this.context = context;

    }

    public BooleanFormula equal(TupleFormula x, TupleFormula y) {
        return new EncodingHelper(context).equal(x, y);
    }

    public Formula extract(TupleFormula f, int index) {
        Preconditions.checkArgument(0 <= index && index < f.elements.size());
        return f.elements.get(index);
    }

    public Formula extract(TupleFormula f, Iterable<Integer> indices) {
        Formula extract = f;
        for (int i : indices) {
            if (extract instanceof TupleFormula tuple) {
                extract = tuple.elements.get(i);
            } else {
                throw new IllegalArgumentException("Cannot extract from a non-tuple formula '%s'");
            }
        }
        return extract;
    }

    public TupleFormula insert(TupleFormula f, Formula value, Iterable<Integer> indices) {
        final int index = Iterables.getFirst(indices, -1);
        Preconditions.checkArgument(0 <= index && index < f.elements.size());
        final Iterable<Integer> subindices = Iterables.skip(indices, 1);
        final boolean recurse = !Iterables.isEmpty(subindices);
        final List<Formula> newElements = IntStream.range(0, f.elements.size())
                .mapToObj(i -> i != index ?
                        f.elements.get(i)
                        : !recurse ? value
                        : insert((TupleFormula) f.elements.get(i), value, subindices)
                )
                .collect(ImmutableList.toImmutableList());
        return makeTuple(newElements);
    }

    public TupleFormula makeTuple(List<Formula> elements) {
        return new TupleFormula(elements);
    }
}
