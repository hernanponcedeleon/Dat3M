package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.smt.FormulaManagerExt;
import com.dat3m.dartagnan.smt.ModelExt;
import com.dat3m.dartagnan.smt.SMTHelper;
import com.dat3m.dartagnan.smt.TupleValue;
import org.junit.Test;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.api.BitvectorFormula;
import org.sosy_lab.java_smt.api.BitvectorFormulaManager;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;

public class ExpressionDecoderTest {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    // Z3 leaves variables that do not occur in the constraints out of the model, so the tuple has a null element.
    @Test
    public void unconstrainedTupleElement() throws Exception {
        try (SolverContext context = SMTHelper.createSolverContext(Configuration.defaultConfiguration(),
                ShutdownManager.create().getNotifier(), SolverContextFactory.Solvers.Z3);
             ProverEnvironment prover = context.newProverEnvironment(SolverContext.ProverOptions.GENERATE_MODELS)) {
            final FormulaManagerExt fmgr = new FormulaManagerExt(context.getFormulaManager());
            final BitvectorFormulaManager bv = fmgr.getBitvectorFormulaManager();
            final BitvectorFormula x = bv.makeVariable(32, "constrained");
            final BitvectorFormula y = bv.makeVariable(32, "unconstrained");
            prover.addConstraint(bv.equal(x, bv.makeBitvector(32, 1)));
            assertFalse(prover.isUnsat());
            try (ModelExt model = new ModelExt(prover.getEvaluator())) {
                final TupleValue value = model.evaluate(fmgr.getTupleFormulaManager().makeTuple(List.of(x, y)));
                final IntegerType int32 = types.getIntegerType(32);
                final ArrayType arrayType = types.getArrayType(int32, 2);
                assertEquals(expressions.makeArray(arrayType, List.of(expressions.makeOne(int32), expressions.makeZero(int32))),
                        ExpressionDecoder.decode(arrayType, value));
            }
        }
    }
}
