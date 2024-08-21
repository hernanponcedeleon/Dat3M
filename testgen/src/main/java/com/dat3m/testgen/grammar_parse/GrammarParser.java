package com.dat3m.testgen.grammar_parse;

import java.io.*;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.wmm.Wmm;

public class GrammarParser {
    
    public GrammarParser() {}

    static public void parse(
        final File memory_model_file
    ) throws Exception {
        Wmm memory_model = new ParserCat().parse( memory_model_file );
        System.out.println( "Axioms:\n" + memory_model.getAxioms() );
        System.out.println( "Class:\n" + memory_model.getClass() );
        System.out.println( "Config:\n" + memory_model.getConfig() );
        System.out.println( "Class:\n" + memory_model.getClass() );
        System.out.println( "Constraints:\n" + memory_model.getConstraints() );
        System.out.println( "Relations:\n" + memory_model.getRelations() );
        System.out.println( "\n\n\n" + memory_model );
    }

}
