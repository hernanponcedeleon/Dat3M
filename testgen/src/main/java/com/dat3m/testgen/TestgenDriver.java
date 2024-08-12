package com.dat3m.testgen;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Set;
import java.util.TreeSet;

import com.dat3m.testgen.cycle_gen.CNF;

public class TestgenDriver {

    public static void main(
        String[] args
    ) throws Exception {
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