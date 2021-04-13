package com.dat3m.dartagnan.parsers.witness;

import com.dat3m.dartagnan.parsers.XMLLexer;
import com.dat3m.dartagnan.parsers.XMLParser;
import com.dat3m.dartagnan.parsers.program.utils.ParserErrorListener;
import com.dat3m.dartagnan.parsers.witness.visitors.VisitorXML;
import com.dat3m.dartagnan.witness.WitnessGraph;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import org.antlr.v4.runtime.*;

public class ParserWitness {

    public WitnessGraph parse(CharStream charStream) {
    	XMLLexer lexer = new XMLLexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        XMLParser parser = new XMLParser(tokenStream);
        parser.addErrorListener(new ParserErrorListener());
        ParserRuleContext parserEntryPoint = parser.document();
        VisitorXML visitor = new VisitorXML();

        WitnessGraph graph = (WitnessGraph) parserEntryPoint.accept(visitor);
        return graph;
    }
    
    public WitnessGraph parse(String raw) {
    	return parse(CharStreams.fromString(raw));
    }
    
    public WitnessGraph parse(File file) throws IOException {
        FileInputStream stream = new FileInputStream(file);
        CharStream charStream = CharStreams.fromStream(stream);
        return parse(charStream);
    }
}
