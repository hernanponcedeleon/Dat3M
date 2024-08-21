package com.dat3m.testgen;

import java.util.*;
import java.io.*;

import com.dat3m.testgen.cycle_gen.Cycle;
import com.dat3m.testgen.cycle_gen.Grammar;
import com.dat3m.testgen.grammar_parse.GrammarParser;
import com.dat3m.testgen.program_gen.SMTCycle;
import com.dat3m.testgen.program_gen.SMTProgramGenerator;
import com.dat3m.testgen.program_gen.SMTRelation;
import com.dat3m.testgen.program_out.ProgramParser;
import com.dat3m.testgen.util.Playground;

public class TestgenDriver {

    public static void main(
        String[] args
    ) throws Exception {
        example_grammar_parser();
    }

    static void playground()
    throws Exception {
        Playground playground = new Playground();
        playground.start();
    }

    static void example_grammar_parser()
    throws Exception {
        File memory_model = new File( "../cat/sc.cat" );
        GrammarParser.parse( memory_model );
    }

    static void example_program_generation()
    throws Exception {
        SMTCycle cycle = new SMTCycle( 10 );

        /*
        cycle.create_relation( 0, SMTRelation.relation_t.po, 1 );
        cycle.create_relation( 1, SMTRelation.relation_t.rf, 2 );
        cycle.create_relation( 2, SMTRelation.relation_t.po, 3 );
        cycle.create_relation( 3, SMTRelation.relation_t.rf, 0 ); // */

        // /*
        cycle.create_relation( 0, SMTRelation.relation_t.po, 1 );
        cycle.create_relation( 1, SMTRelation.relation_t.co, 2 );
        cycle.create_relation( 2, SMTRelation.relation_t.po, 3 );
        cycle.create_relation( 3, SMTRelation.relation_t.co, 0 ); // */

        /*
        cycle.create_relation( 0, SMTRelation.relation_t.po, 1 );
        cycle.create_relation( 1, SMTRelation.relation_t.rf, 2 );
        cycle.create_relation( 2, SMTRelation.relation_t.rf_inv, 3 );
        cycle.create_relation( 3, SMTRelation.relation_t.co, 0 ); // */

        /*
        cycle.create_relation( 0, SMTRelation.relation_t.co, 1 );
        cycle.create_relation( 1, SMTRelation.relation_t.po, 2 );
        cycle.create_relation( 2, SMTRelation.relation_t.rf, 3 );
        cycle.create_relation( 3, SMTRelation.relation_t.rf_inv, 4 );
        cycle.create_relation( 4, SMTRelation.relation_t.co, 0 ); // */

        /*
        cycle.create_relation( 0, SMTRelation.relation_t.po, 1 );
        cycle.create_relation( 1, SMTRelation.relation_t.rf_inv, 2 );
        cycle.create_relation( 2, SMTRelation.relation_t.co, 3 );
        cycle.create_relation( 3, SMTRelation.relation_t.po, 4 );
        cycle.create_relation( 4, SMTRelation.relation_t.rf_inv, 5 );
        cycle.create_relation( 5, SMTRelation.relation_t.co, 0 ); // */

        SMTProgramGenerator smt = new SMTProgramGenerator( cycle );

        ProgramParser parser = new ProgramParser( smt.generate_program() );
        
        System.out.println( parser.print_program() );
    }

    static void example_cycles()
    throws Exception {        
        Grammar cnf = new Grammar( "HB_SC" );

        cnf.add_nonterminal( "FR" );

        cnf.add_terminal( "po" );
        cnf.add_terminal( "rf" );
        cnf.add_terminal( "co" );
        cnf.add_terminal( "rf_inv" );

        cnf.add_rule( "HB_SC", "po" );
        cnf.add_rule( "HB_SC", "rf" );
        cnf.add_rule( "HB_SC", "co" );
        cnf.add_rule( "HB_SC", "FR" );
        cnf.add_rule( "HB_SC", "HB_SC;HB_SC" );
        cnf.add_rule( "FR",    "rf_inv;co" );

        final int cycle_length = 4;
        List <Cycle> all_cycles = cnf.explore_cnf( cycle_length );        
        
        System.out.println( "Cycles of length " + cycle_length + ":" );
        for( Cycle cycle : all_cycles )
            System.out.println( cycle );
    }

}