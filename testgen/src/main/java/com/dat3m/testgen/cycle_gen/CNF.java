package com.dat3m.testgen.cycle_gen;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Takes a grammar and transforms it into a chomsky normal form grammar.
 * https://en.wikipedia.org/wiki/Chomsky_normal_form#
 * 
 * @param rules For each non-terminal, a list of rules.
 * @param starting_nt Starting non-terminal.
 * @param non_terminals List of non-terminal states.
 * @param terminals List of terminal states.
 * @param new_nonterminal_idx Next index for the auto-generated non-terminal states.
 */
public class CNF {
    
    Map <String, List <String>> rules;
    public String starting_nt;
    Set <String> non_terminals;
    Set <String> terminals;
    int new_nonterminal_idx = 1;

    /**
     * Constructor for CNF class.
     * 
     * @param r_starting_nt Starting non-terminal.
     * @throws Exception
     */
    public CNF(
        final String r_starting_nt
    ) throws Exception {
        starting_nt = r_starting_nt;
        rules = new HashMap<>();
        non_terminals = new HashSet<>();
        terminals = new HashSet<>();
        add_non_terminal( starting_nt );
    }

    /**
     * Add a new non-terminal state.
     * 
     * @param non_terminal Name of the non-terminal state.
     * @throws Exception
     */
    public void add_non_terminal(
        final String non_terminal
    ) throws Exception {
        if( non_terminals.contains( non_terminal ) )
            throw new Exception( "Non-terminal has already been added to set." );
        if( terminals.contains( non_terminal ) )
            throw new Exception( "Non-terminal found in terminal set." );
        non_terminals.add( non_terminal );
        rules.put( non_terminal, new ArrayList<>() );
    }

    /**
     * Add a new terminal state.
     * 
     * @param terminal Name of the terminal state.
     * @throws Exception
     */
    public void add_terminal(
        final String terminal
    ) throws Exception {
        if( terminals.contains( terminal ) )
            throw new Exception( "Terminal has already been added to set." );
        if( non_terminals.contains( terminal ) )
            throw new Exception( "Terminal found in non-terminal set." );
        terminals.add( terminal );
    }

    /**
     * Add a transformation rule to a terminal state.
     * 
     * @param NT Non-terminal state.
     * @param transformation Transformation rule to be added.
     * @throws Exception
     */
    public void add_rule(
        final String NT,
        final String transformation
    ) throws Exception {
        if( !non_terminals.contains( NT ) )
            throw new Exception( "Non-terminal not found in set." );
        for( final String item : transformation.split( ";" ) ) {
            if( !terminals.contains( item ) && !non_terminals.contains( item ) )
                throw new Exception( "Item in transformation not found in list of terminals and non-terminals." );
        }
        rules.get( NT ).add( transformation );
    }

    /**
     * Remove an existing rule from a non-terminal state.
     * 
     * @param NT Non-terminal state.
     * @param transformation Transformation rule to be removed.
     * @throws Exception
     */
    public void remove_rule(
        final String NT,
        final String transformation
    ) throws Exception {
        if( !non_terminals.contains( NT ) )
            throw new Exception( "Non-terminal not found in set." );
        if( !rules.get( NT ).contains( transformation ) )
            throw new Exception( "Rule for non-terminal not found." );
        rules.get( NT ).remove( transformation );
    }

    /**
     * Returns a list of all rules belonging to a non-terminal state.
     * 
     * @param NT Non-terminal state.
     * @return List of rules for the non-terminal state.
     * @throws Exception
     */
    public List <String> get_rules(
        final String NT
    ) throws Exception {
        if( !non_terminals.contains( NT ) )
            throw new Exception( "Non-terminal not found in set." );
        return rules.get( NT );
    }

    /**
     * Inplace transforms the defined grammar into a Chomsky Normal Form grammar.
     * 
     * @throws Exception
     */
    public void to_normal_form()
    throws Exception {
        transformation_start();
        transformation_bin();
        transformation_unit();
        transformation_term();
    }

    /**
     * Start phase of the CNF transformation.
     * https://en.wikipedia.org/wiki/Chomsky_normal_form#START:_Eliminate_the_start_symbol_from_right-hand_sides
     * 
     * @throws Exception
     */
    void transformation_start()
    throws Exception {
        String new_start = "S_CNF";
        add_non_terminal( new_start );
        add_rule( new_start, starting_nt );
        starting_nt = new_start;
    }

    /**
     * Bin phase of the CNF transformation.
     * https://en.wikipedia.org/wiki/Chomsky_normal_form#BIN:_Eliminate_right-hand_sides_with_more_than_2_nonterminals
     * 
     * @throws Exception
     */
    void transformation_bin()
    throws Exception {
        boolean rules_modified = true;
        while( rules_modified ) {
            rules_modified = false;
            for( final String NT : non_terminals ) {
                for( final String rule : rules.get( NT ) ) {
                    String items[] = rule.split( ";" );
                    if( items.length <= 2 )
                        continue;
                    String new_nonterminal = "NT_" + new_nonterminal_idx;
                    new_nonterminal_idx++;
                    add_non_terminal( new_nonterminal );
                    add_rule( new_nonterminal, items[0] + ";" + items[1] );
                    remove_rule( NT, rule );
                    StringBuilder new_rule = new StringBuilder();
                    new_rule.append( new_nonterminal );
                    for( int i = 2 ; i < items.length ; i++ )
                        new_rule.append( ";" + items[i] );
                    add_rule( NT, new_rule.toString() );
                    rules_modified = true;
                    break;
                }
                if( rules_modified )
                    break;
            }
        }
    }

    /**
     * Unit phase of the CNF transformation.
     * https://en.wikipedia.org/wiki/Chomsky_normal_form#UNIT:_Eliminate_unit_rules
     * 
     * @throws Exception
     */
    void transformation_unit()
    throws Exception {
        boolean rules_modified = true;
        while( rules_modified ) {
            rules_modified = false;
            for( final String NT : non_terminals ) {
                for( final String rule : rules.get( NT ) ) {
                    String items[] = rule.split( ";" );
                    if( items.length != 1 )
                        continue;
                    if( !non_terminals.contains( items[0] ) )
                        continue;
                    remove_rule( NT, rule );
                    for( final String rules_in_unit : rules.get( items[0] ) )
                        add_rule( NT, rules_in_unit );
                    rules_modified = true;
                    break;
                }
                if( rules_modified )
                    break;
            }
        }
    }

    /**
     * Term phase of the CNF transformation.
     * https://en.wikipedia.org/wiki/Chomsky_normal_form#TERM:_Eliminate_rules_with_nonsolitary_terminals
     * 
     * @throws Exception
     */
    void transformation_term()
    throws Exception {
        boolean rules_modified = true;
        while( rules_modified ) {
            rules_modified = false;
            for( final String NT : non_terminals ) {
                for( final String rule : rules.get( NT ) ) {
                    String items[] = rule.split( ";" );
                    if( items.length == 1 )
                        continue;
                    boolean has_terminal = false;
                    for( final String item : items )
                        if( terminals.contains( item ) )
                            has_terminal = true;
                    if( !has_terminal )
                        continue;
                    remove_rule( NT, rule );
                    StringBuilder new_rule = new StringBuilder();
                    for( int i = 0 ; i < items.length ; i++ ) {
                        if( !terminals.contains( items[i] ) ) {
                            new_rule.append( ( i > 0 ? ";" : "" ) + items[i] );
                        } else {
                            String new_nonterminal = "NT_" + new_nonterminal_idx;
                            new_nonterminal_idx++;
                            add_non_terminal( new_nonterminal );
                            add_rule( new_nonterminal, items[i] );
                            new_rule.append( ( i > 0 ? ";" : "" ) + new_nonterminal );
                        }
                    }
                    add_rule( NT, new_rule.toString() );
                    rules_modified = true;
                    break;
                }
                if( rules_modified )
                    break;
            }
        }
    }

    /**
     * Explores the grammar (after being transformed into cnf) exaustively up to a given length.
     * 
     * @param all_cycles Set of all the generated cycles
     * @param states Current stack of states
     * @param cycle Current cycle
     * @param allowed_growth Rules of type NT;NT that can be taken
     * @throws Exception
     */
    public void explore_cnf(
        Set <String> all_cycles,
        List <String> states,
        List <String> cycle,
        int allowed_growth
    ) throws Exception {
        if( allowed_growth < 0 )
            return;

        if( states.isEmpty() ) {
            if( allowed_growth == 0 )
                all_cycles.add( cycle.toString() );
            return;
        }

        String current_state = states.get( 0 );
        states.remove( 0 );

        if( terminals.contains( current_state ) ) {
            cycle.add( current_state );
            explore_cnf( all_cycles, states, cycle, allowed_growth  );
            cycle.remove( cycle.size() - 1 );
        } else {
            for( String rule : get_rules( current_state ) ) {
                if( is_nonterminal_rule( rule ) ) {
                    String state_1 = rule.split( ";" )[0];
                    String state_2 = rule.split( ";" )[1];
                    states.add( 0, state_2 );
                    states.add( 0, state_1 );
                    explore_cnf( all_cycles, states, cycle, allowed_growth - 1 );
                    states.remove( 0 );
                    states.remove( 0 );
                } else {
                    states.add( 0, rule );
                    explore_cnf( all_cycles, states, cycle, allowed_growth );
                    states.remove( 0 );
                }
            }
        }

        states.add( 0, current_state );
    }

    /**
     * Returns whether the given rule is of type NT;NT
     * 
     * @param rule
     * @return
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
            for( final String NT : non_terminals )
                for( final String rule : get_rules( NT ) )
                    sb.append( NT + " -> " + rule + "\n" );
        } catch ( Exception ex ) {}

        return sb.toString();
    }

}
