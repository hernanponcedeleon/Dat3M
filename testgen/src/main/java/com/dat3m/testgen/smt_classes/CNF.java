package com.dat3m.testgen.smt_classes;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class CNF {
    
    Map < String, List <String> > rules;
    String starting_nt;
    Set <String> non_terminals;
    Set <String> terminals;
    int new_nonterminal_idx = 1;

    public CNF(
        final String r_starting_nt
    ) throws Exception {
        starting_nt = r_starting_nt;
        rules = new HashMap<>();
        non_terminals = new HashSet<>();
        terminals = new HashSet<>();
        add_non_terminal( starting_nt );
    }

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

    public void add_terminal(
        final String terminal
    ) throws Exception {
        if( terminals.contains( terminal ) )
            throw new Exception( "Terminal has already been added to set." );
        if( non_terminals.contains( terminal ) )
            throw new Exception( "Terminal found in non-terminal set." );
        terminals.add( terminal );
    }

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

    public List <String> get_rules(
        final String NT
    ) throws Exception {
        if( !non_terminals.contains( NT ) )
            throw new Exception( "Non-terminal not found in set." );
        return rules.get( NT );
    }

    public void to_normal_form()
    throws Exception {

        transformation_start();

        transformation_bin();

    }

    void transformation_start()
    throws Exception {
        String new_start = "S_CNF";
        add_non_terminal( new_start );
        add_rule( new_start, starting_nt );
        starting_nt = new_start;
    }

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
