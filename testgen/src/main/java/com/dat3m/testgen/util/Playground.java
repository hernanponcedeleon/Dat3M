package com.dat3m.testgen.util;

import java.math.BigInteger;
import java.util.Arrays;

import org.sosy_lab.common.ShutdownNotifier;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.IntegerFormulaManager;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;


import org.sosy_lab.common.log.LogManager;

public class Playground {

    Configuration config;
    LogManager logger;
    ShutdownNotifier shutdown;
    SolverContext context;
    FormulaManager fm;
    IntegerFormulaManager im;
    BooleanFormulaManager bm;
    ProverEnvironment prover;
    
    public Playground()
    throws Exception {
        config   = Configuration.defaultConfiguration();
        logger   = LogManager.createNullLogManager();
        shutdown = ShutdownNotifier.createDummy();

        context = SolverContextFactory.createSolverContext(
            config, logger, shutdown, Solvers.Z3
        );

        fm = context.getFormulaManager();
        im = fm.getIntegerFormulaManager();
        bm = fm.getBooleanFormulaManager();
        
        prover = context.newProverEnvironment( ProverOptions.GENERATE_MODELS );
    }

    public void start()
    throws Exception {
        IntegerFormula x, y, z;
        x = im.makeVariable( "x" );
        y = im.makeVariable( "y" );
        z = im.makeVariable( "z" );

        prover.addConstraint(
            im.equal( x, im.makeNumber( 1 ) )
        );

        prover.addConstraint(
            im.equal( y, im.multiply( x, im.makeNumber(2) ) )
        );

        prover.addConstraint(
            im.equal( z, im.multiply( y, im.makeNumber(4) ) )
        );

        if( prover.isUnsat() )
            throw new Exception( "Program cannot exist!" ); 

        if( !prover.isUnsatWithAssumptions( Arrays.asList(
            im.equal( z, im.makeNumber(7) )
        ) ) )
        throw new Exception( "Program cannot exist with those assumptions!" );

        Model model = prover.getModel();
        BigInteger val_x = model.evaluate( x );
        BigInteger val_y = model.evaluate( y );
        BigInteger val_z = model.evaluate( z );

        System.out.println( val_x + ", " + val_y + ", " + val_z );
    }

}
