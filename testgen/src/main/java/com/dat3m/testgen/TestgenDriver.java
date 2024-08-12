package com.dat3m.testgen;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Set;
import java.util.TreeSet;

import com.dat3m.testgen.cycle_gen.CNF;
import com.dat3m.testgen.program_gen.SMTProgramGenerator;
import com.dat3m.testgen.util.Cycle;
import com.dat3m.testgen.util.Relation;

public class TestgenDriver {

    public static void main(
        String[] args
    ) throws Exception {
        
        example_program_generation();

    }

    static void example_program_generation()
    throws Exception {
        Cycle cycle = new Cycle( 10 );;

        /*
        cycle.create_relation( 0, Relation.relation_t.po, 1 );
        cycle.create_relation( 1, Relation.relation_t.co, 2 );
        cycle.create_relation( 2, Relation.relation_t.po, 3 );
        cycle.create_relation( 3, Relation.relation_t.co, 0 ); // */

        /*
        cycle.create_relation( 0, Relation.relation_t.po, 1 );
        cycle.create_relation( 1, Relation.relation_t.rf, 2 );
        cycle.create_relation( 2, Relation.relation_t.rf_inv, 3 );
        cycle.create_relation( 3, Relation.relation_t.co, 0 ); // */

        // /*
        cycle.create_relation( 0, Relation.relation_t.co, 1 );
        cycle.create_relation( 1, Relation.relation_t.po, 2 );
        cycle.create_relation( 2, Relation.relation_t.rf, 3 );
        cycle.create_relation( 3, Relation.relation_t.rf_inv, 4 );
        cycle.create_relation( 4, Relation.relation_t.co, 0 ); // */

        /*
        cycle.create_relation( 0, Relation.relation_t.po, 1 );
        cycle.create_relation( 1, Relation.relation_t.rf_inv, 2 );
        cycle.create_relation( 2, Relation.relation_t.co, 3 );
        cycle.create_relation( 3, Relation.relation_t.po, 4 );
        cycle.create_relation( 4, Relation.relation_t.rf_inv, 5 );
        cycle.create_relation( 5, Relation.relation_t.co, 0 ); // */

        SMTProgramGenerator smt = new SMTProgramGenerator( cycle );

        System.out.println( smt.generate_program() );
    }

    static void example_cycles()
    throws Exception {
        Set <String> all_cycles = new TreeSet<>();
        
        CNF cnf = new CNF( "HB_SC" );

        cnf.add_non_terminal( "FR" );

        cnf.add_terminal( "po" );
        cnf.add_terminal( "rf" );
        cnf.add_terminal( "co" );
        cnf.add_terminal( "rf_inv" );

        cnf.add_rule( "HB_SC", "po" );
        cnf.add_rule( "HB_SC", "rf" );
        cnf.add_rule( "HB_SC", "co" );
        cnf.add_rule( "HB_SC", "FR" );
        cnf.add_rule( "HB_SC", "HB_SC;HB_SC" );
        cnf.add_rule( "FR", "rf_inv;co" );

        cnf.to_normal_form();

        final int cycle_length = 4;
        cnf.explore_cnf(
            all_cycles,
            new ArrayList<String>( Arrays.asList( cnf.starting_nt ) ),
            new ArrayList<>(),
            cycle_length - 1
        );
        
        System.out.println( "Cycles of length " + cycle_length + ":" );
        for( String cycle : all_cycles )
            System.out.println( cycle );
    }

}