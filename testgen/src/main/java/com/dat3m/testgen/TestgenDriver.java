package com.dat3m.testgen;

import java.math.BigInteger;

import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.ShutdownNotifier;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.log.BasicLogManager;
import org.sosy_lab.common.log.LogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.IntegerFormulaManager;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;

public class TestgenDriver {

    public static void main(String[] args) throws Exception {
        
        Configuration config = Configuration.defaultConfiguration();
        LogManager logger = LogManager.createNullLogManager();
        ShutdownNotifier shutdown = ShutdownNotifier.createDummy();

        SolverContext context = SolverContextFactory.createSolverContext(
            config, logger, shutdown, Solvers.SMTINTERPOL
        );

        FormulaManager fmgr = context.getFormulaManager();

        BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();
        IntegerFormulaManager imgr = fmgr.getIntegerFormulaManager();

        IntegerFormula
            a = imgr.makeVariable("a"),
            b = imgr.makeVariable("b"),
            c = imgr.makeVariable("c");

        BooleanFormula constraint = bmgr.and(
            bmgr.and(
                imgr.equal(
                    imgr.add(a, b), c
                ),
                imgr.greaterThan(
                    a, imgr.makeNumber(0)
                )
            ),
            imgr.equal(
                imgr.add(a, c), imgr.multiply(imgr.makeNumber(2), b)
            )
        );

        try( ProverEnvironment prover = context.newProverEnvironment(ProverOptions.GENERATE_MODELS) ) {
            prover.addConstraint( constraint );
            boolean isUnsat = prover.isUnsat();
            if( !isUnsat ){
                Model model = prover.getModel();
                BigInteger val_a = model.evaluate( a );
                BigInteger val_b = model.evaluate( b );
                BigInteger val_c = model.evaluate( c );
                System.out.println( "" + val_a + ", " + val_b + ", " + val_c );
            }
        }

    }

}