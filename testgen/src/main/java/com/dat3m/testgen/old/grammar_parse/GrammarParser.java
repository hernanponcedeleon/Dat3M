package com.dat3m.testgen.old.grammar_parse;

import java.io.*;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;

public class GrammarParser {
    
    public GrammarParser() {}

    static public void parse(
        final File memory_model_file
    ) throws Exception {
        Wmm memory_model = new ParserCat().parse( memory_model_file );

        System.out.println( "Relations:" );
        for( Relation rel : memory_model.getRelations() ) {
            if( !rel.hasName() )
                continue;
            System.out.println( rel );
            for( Relation dep : rel.getDependencies() ) {
                System.out.println( "\t" + dep );
            }
        }

        System.out.println( "Axioms:" );
        for( Axiom axi : memory_model.getAxioms() ) {
            System.out.println( axi );
            System.out.println( axi.getRelation() );
        }

    }

}
