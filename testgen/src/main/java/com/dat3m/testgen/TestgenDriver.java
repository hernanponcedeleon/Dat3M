package com.dat3m.testgen;

import java.util.*;

import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.FormulaType;
import org.sosy_lab.java_smt.api.FunctionDeclaration;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

import java.io.*;
import java.math.BigInteger;

import com.dat3m.testgen.explore.WmmExplorer;
import com.dat3m.testgen.generate.ProgramGenerator;
import com.dat3m.testgen.generate.SMTHandler;
import com.dat3m.testgen.util.Graph;

public class TestgenDriver {

    public static void main(
        String[] args
    ) throws Exception {
        // playground();
        WmmExplorer wmm_explorer = new WmmExplorer( new File( "../cat/sc.cat" ) );
        List <Graph> all_cycles = wmm_explorer.begin_exploration( 2 );
        for( final Graph cycle : all_cycles )
            new ProgramGenerator( cycle );
    }

    static void playground()
    throws Exception {
        SMTHandler smt = new SMTHandler();

        IntegerFormula x = smt.im.makeVariable( "x" );
        IntegerFormula y = smt.im.makeVariable( "y" );
        FunctionDeclaration <BooleanFormula> f_dec = smt.ufm.declareUF( "f", FormulaType.BooleanType, FormulaType.IntegerType, FormulaType.IntegerType );
        Formula formula = smt.ufm.callUF( f_dec, x, y );

        smt.prover.addConstraint( smt.im.lessThan( x, y ) );
        smt.prover.addConstraint( smt.im.equal( x, smt.im.makeNumber(47) ) );

        if( smt.prover.isUnsat() ) {
            throw new Exception( "D:" );
        }

        Model model = smt.prover.getModel();
        BigInteger val_x = model.evaluate(x);
        BigInteger val_y = model.evaluate(y);

        System.out.println( val_x + " = " + val_y  + ", f(): " + model.evaluate( formula ) );
    }

}