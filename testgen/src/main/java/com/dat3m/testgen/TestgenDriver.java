package com.dat3m.testgen;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import com.dat3m.testgen.smt_classes.CNF;

public class TestgenDriver {

    static Set <String> all_cycles;

    public static void main(String[] args) throws Exception {

        all_cycles = new TreeSet<>();
        
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

        final int cycle_length = 3;
        explore_cnf( cnf, new ArrayList<String>( Arrays.asList( cnf.starting_nt ) ), new ArrayList<>(), cycle_length - 1 );
        
        System.out.println( "Cycles of length " + cycle_length + ":" );
        for( String cycle : all_cycles )
            System.out.println( cycle );

    }

    static void explore_cnf(
        final CNF cnf,
        List <String> states,
        List <String> cycle,
        int allowed_growth
    ) throws Exception {
        // System.out.println( states + "\n" + cycle + "\n" + allowed_growth + "\n" );

        if( allowed_growth < 0 )
            return;

        if( states.isEmpty() ) {
            if( allowed_growth == 0 )
                all_cycles.add( cycle.toString() );
            return;
        }

        String current_state = states.get( 0 );
        states.remove( 0 );

        if( cnf.terminals.contains( current_state ) ) {
            cycle.add( current_state );
            explore_cnf( cnf, states, cycle, allowed_growth );
            cycle.remove( cycle.size() - 1 );
        } else {
            for( String rule : cnf.get_rules( current_state ) ) {
                if( is_nonterminal_rule( rule ) ) {
                    String state_1 = rule.split( ";" )[0];
                    String state_2 = rule.split( ";" )[1];
                    states.add( 0, state_2 );
                    states.add( 0, state_1 );
                    explore_cnf( cnf, states, cycle, allowed_growth - 1 );
                    states.remove( 0 );
                    states.remove( 0 );
                } else {
                    states.add( 0, rule );
                    explore_cnf( cnf, states, cycle, allowed_growth );
                    states.remove( 0 );
                }
            }
        }

        states.add( 0, current_state );
    }

    static boolean is_nonterminal_rule(
        final String rule
    ) {
        return rule.split( ";" ).length == 2;
    }

}