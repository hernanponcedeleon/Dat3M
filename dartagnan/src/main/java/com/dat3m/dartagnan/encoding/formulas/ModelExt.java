package com.dat3m.dartagnan.encoding.formulas;

import com.google.common.base.Preconditions;
import org.sosy_lab.java_smt.api.*;

import java.math.BigInteger;

public class ModelExt implements AutoCloseable {
    private final Evaluator evaluator;

    public ModelExt(Evaluator evaluator) {
        this.evaluator = Preconditions.checkNotNull(evaluator);
    }

    public Evaluator getUnderlyingEvaluator() { return evaluator; }

    public Object evaluate(Formula formula) {
        if (formula instanceof TupleFormula tupleFormula) {
            return this.evaluate(tupleFormula);
        }
        return evaluator.evaluate(formula);
    }

    public BigInteger evaluate(NumeralFormula.IntegerFormula formula) {
        return evaluator.evaluate(formula);
    }

    public BigInteger evaluate(BitvectorFormula formula) {
        return evaluator.evaluate(formula);
    }

    public Boolean evaluate(BooleanFormula formula) {
        return evaluator.evaluate(formula);
    }

    public TupleValue evaluate(TupleFormula tupleFormula) {
        return new TupleValue(tupleFormula.elements.stream().map(this::evaluate).toList());
    }

    @Override
    public void close() {
        this.evaluator.close();
    }
}
