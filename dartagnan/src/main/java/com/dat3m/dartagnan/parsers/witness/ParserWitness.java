package com.dat3m.dartagnan.parsers.witness;

import com.dat3m.dartagnan.parsers.XMLLexer;
import com.dat3m.dartagnan.parsers.XMLParser;
import com.dat3m.dartagnan.parsers.program.utils.ParserErrorListener;
import com.dat3m.dartagnan.parsers.witness.visitors.VisitorXML;
import com.dat3m.dartagnan.witness.Graph;

import org.antlr.v4.runtime.*;

public class ParserWitness {

    public Graph parse(CharStream charStream) {
    	XMLLexer lexer = new XMLLexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        XMLParser parser = new XMLParser(tokenStream);
        parser.addErrorListener(new ParserErrorListener());
        ParserRuleContext parserEntryPoint = parser.document();
        VisitorXML visitor = new VisitorXML();

        Graph graph = (Graph) parserEntryPoint.accept(visitor);
        return graph;
    }
    
    public Graph parse(String raw) {
    	return parse(CharStreams.fromString(raw));
    }
}
