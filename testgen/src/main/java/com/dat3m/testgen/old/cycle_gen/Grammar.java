package com.dat3m.testgen.old.cycle_gen;

import java.util.*;

/**
 * Represents a grammar of a memory model description.
 */
public class Grammar {
    
    String starting_state;
    Map <String, List <String>> transformations;
    Set <String> nonterminal_set;
    Set <String> terminal_set;
    int next_nt_index = 1;

    public Grammar(
        final String r_starting_state
    ) throws Exception {
        starting_state  = r_starting_state;
        transformations = new HashMap<>();
        nonterminal_set = new HashSet<>();
        terminal_set    = new HashSet<>();
        add_nonterminal( starting_state );
    }

    public void add_nonterminal(
        final String nonterminal
    ) throws Exception {
        if( terminal_set.contains( nonterminal ) )
            throw new Exception( "Non-terminal found in terminal set." );
        if( nonterminal_set.contains( nonterminal ) )
            throw new Exception( "Non-terminal already exists." );
        nonterminal_set.add( nonterminal );
        transformations.put( nonterminal, new ArrayList<>() );
    }

    public void add_terminal(
        final String terminal
    ) throws Exception {
        if( nonterminal_set.contains( terminal ) )
            throw new Exception( "Terminal found in nonterminal set." );
        if( terminal_set.contains( terminal ) )
            throw new Exception( "Terminal already exists." );
        terminal_set.add( terminal );
    }

    public void add_rule(
        final String NT,
        final String transformation
    ) throws Exception {
        if( !nonterminal_set.contains( NT ) )
            throw new Exception( "Nonterminal does not exist." );
        for( final String item : transformation.split( ";" ) ) {
            if( !terminal_set.contains( item ) && !nonterminal_set.contains( item ) )
                throw new Exception( "State in transformation does not exist." );
        }
        transformations.get( NT ).add( transformation );
    }

    public void remove_rule(
        final String NT,
        final String transformation
    ) throws Exception {
        if( !nonterminal_set.contains( NT ) )
            throw new Exception( "Nonterminal does not exist." );
        if( !transformations.get( NT ).contains( transformation ) )
            throw new Exception( "Nonterminal does not have given transformation." );
        transformations.get( NT ).remove( transformation );
    }

    public List <String> get_rules(
        final String NT
    ) throws Exception {
        if( !nonterminal_set.contains( NT ) )
            throw new Exception( "Nonterminal does not exist." );
        return transformations.get( NT );
    }

    /**
     * Inplace transforms the defined grammar into a Chomsky Normal Form grammar.
     * https://en.wikipedia.org/wiki/Chomsky_normal_form#
     */
    void to_normal_form()
    throws Exception {
        transformation_start();
        transformation_bin();
        transformation_unit();
        transformation_term();
    }

    /**
     * Start phase of the CNF transformation.
     * https://en.wikipedia.org/wiki/Chomsky_normal_form#START:_Eliminate_the_start_symbol_from_right-hand_sides
     */
    void transformation_start()
    throws Exception {
        add_nonterminal( "S_CNF" );
        add_rule( "S_CNF", starting_state );
        starting_state = "S_CNF";
    }

    /**
     * Bin phase of the CNF transformation.
     * https://en.wikipedia.org/wiki/Chomsky_normal_form#BIN:_Eliminate_right-hand_sides_with_more_than_2_nonterminals
     */
    void transformation_bin()
    throws Exception {
        for( boolean modified = true ; modified ;  ) { modified = false; for( final String NT : nonterminal_set ) { for( final String rule : transformations.get( NT ) ) {
            final String items[] = rule.split( ";" );
            if( items.length <= 2 )
                continue;

            String new_nonterminal = "NT_" + next_nt_index++;
            add_nonterminal( new_nonterminal );
            add_rule( new_nonterminal, items[0] + ";" + items[1] );
            remove_rule( NT, rule );

            StringBuilder new_rule = new StringBuilder().append( new_nonterminal );
            for( int i = 2 ; i < items.length ; i++ )
                new_rule.append( ";" + items[i] );
            add_rule( NT, new_rule.toString() );
        modified = true; break; } if( modified ) break; } }
    }

    /**
     * Unit phase of the CNF transformation.
     * https://en.wikipedia.org/wiki/Chomsky_normal_form#UNIT:_Eliminate_unit_rules
     */
    void transformation_unit()
    throws Exception {
        for( boolean modified = true ; modified ;  ) { modified = false; for( final String NT : nonterminal_set ) { for( final String rule : transformations.get( NT ) ) {
            final String items[] = rule.split( ";" );
            if( items.length != 1 || terminal_set.contains( items[0] ) )
                continue;

            remove_rule( NT, rule );
            for( final String rules_in_unit : transformations.get( items[0] ) )
                add_rule( NT, rules_in_unit );
        modified = true; break; } if( modified ) break; } }
    }

    /**
     * Term phase of the CNF transformation.
     * https://en.wikipedia.org/wiki/Chomsky_normal_form#TERM:_Eliminate_rules_with_nonsolitary_terminals
     */
    void transformation_term()
    throws Exception {
        for( boolean modified = true ; modified ;  ) { modified = false; for( final String NT : nonterminal_set ) { for( final String rule : transformations.get( NT ) ) {
            String items[] = rule.split( ";" );
            if( items.length == 1 )
                continue;

            boolean has_terminal = false;
            for( final String item : items )
                if( terminal_set.contains( item ) )
                    has_terminal = true;
            if( !has_terminal )
                continue;

            StringBuilder new_rule = new StringBuilder();
            for( int i = 0 ; i < items.length ; i++ ) {
                if( nonterminal_set.contains( items[i] ) ) {
                    new_rule.append( ( i > 0 ? ";" : "" ) + items[i] );
                } else {
                    String new_nonterminal = "NT_" + next_nt_index++;
                    add_nonterminal( new_nonterminal );
                    add_rule( new_nonterminal, items[i] );
                    new_rule.append( ( i > 0 ? ";" : "" ) + new_nonterminal );
                }
            }

            remove_rule( NT, rule );
            add_rule( NT, new_rule.toString() );
        modified = true; break; } if( modified ) break; } }
    }

    public List <GrammarCycle> explore_cnf(
        final int cycle_length
    ) throws Exception {
        List <GrammarCycle> cycle_list = new ArrayList<>();
        Set <String> cycle_str_set = new HashSet<String>();
        Stack <String> st = new Stack<>();

        to_normal_form();
        st.push( starting_state );
        explore_cnf(
            cycle_str_set,
            cycle_list,
            st,
            new Stack<>(),
            cycle_length - 1
        );

        return cycle_list;
    }

    /**
     * Explores the grammar exaustively up to a given length.
     * Assumes the user already called to_normal_form(), and hasn't made any changes to the grammar since.
     * 
     * @param cycle_str_set Set of all the generated cycles (represented as String)
     * @param output List of unique cycle objects
     * @param states Current stack of states
     * @param cycle Current cycle
     * @param allowed_growth Amount of transformations of type NT;NT that can be taken
     */
    void explore_cnf(
        Set   <String> cycle_str_set,
        List  <GrammarCycle>  output,
        Stack <String> states,
        Stack <String> cycle,
        final int      allowed_growth
    ) throws Exception {
        if( states.isEmpty() || allowed_growth < 0 ) {
            if( allowed_growth == 0 && !cycle_str_set.contains( cycle.toString() ) ) {
                cycle_str_set.add( cycle.toString() );
                output.add( new GrammarCycle( cycle ) );
            }
            return;
        }

        String current_state = states.pop();

        if( terminal_set.contains( current_state ) ) {
            cycle.add( current_state );
            explore_cnf( cycle_str_set, output, states, cycle, allowed_growth );
            cycle.pop();
        } else {
            for( String rule : get_rules( current_state ) ) {
                if( is_nonterminal_rule( rule ) ) {
                    String state_1 = rule.split( ";" )[0];
                    String state_2 = rule.split( ";" )[1];
                    states.add( state_2 );
                    states.add( state_1 );
                    explore_cnf( cycle_str_set, output, states, cycle, allowed_growth - 1 );
                    states.pop();
                    states.pop();
                } else {
                    states.add( rule );
                    explore_cnf( cycle_str_set, output, states, cycle, allowed_growth );
                    states.pop();
                }
            }
        }

        states.add( current_state );
    }

    /**
     * Returns whether the given rule is of type NT;NT
     */
    boolean is_nonterminal_rule(
        final String rule
    ) {
        return rule.split( ";" ).length == 2;
    }

    @Override
    public String toString()
    {
        StringBuilder sb = new StringBuilder();

        try {
            for( final String NT : nonterminal_set )
                for( final String rule : get_rules( NT ) )
                    sb.append( NT + " -> " + rule + "\n" );
        } catch ( Exception ex ) {}

        return sb.toString();
    }

}
