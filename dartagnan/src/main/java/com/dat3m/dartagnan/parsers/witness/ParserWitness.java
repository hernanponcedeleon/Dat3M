package com.dat3m.dartagnan.parsers.witness;

import com.dat3m.dartagnan.parsers.XMLLexer;
import com.dat3m.dartagnan.parsers.XMLParser;
import com.dat3m.dartagnan.exception.AbortErrorListener;
import com.dat3m.dartagnan.parsers.witness.visitors.VisitorXML;
import com.dat3m.dartagnan.witness.WitnessGraph;
import org.antlr.v4.runtime.*;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

public class ParserWitness {

	private static final Logger logger = LogManager.getLogger(ParserWitness.class);  

    public WitnessGraph parse(CharStream charStream) {
    	XMLLexer lexer = new XMLLexer(charStream);
        lexer.addErrorListener(new AbortErrorListener());
        lexer.addErrorListener(new DiagnosticErrorListener(true));
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        XMLParser parser = new XMLParser(tokenStream);
        parser.addErrorListener(new AbortErrorListener());
        parser.addErrorListener(new DiagnosticErrorListener(true));
        ParserRuleContext parserEntryPoint = parser.document();
        VisitorXML visitor = new VisitorXML();

        WitnessGraph graph = (WitnessGraph) parserEntryPoint.accept(visitor);
		if(graph.hasAttributed("producer")) {
			logger.info("Witness graph produced by " + graph.getAttributed("producer"));
		}
		logger.info("Witness graph stats: #Nodes " + graph.getNodes().size());
		logger.info("Witness graph stats: #Edges " + graph.getEdges().size());

        return graph;
    }
    
    public WitnessGraph parse(String raw) {
    	return parse(CharStreams.fromString(raw));
    }
    
    public WitnessGraph parse(File file) throws IOException {
        CharStream charStream;
        try (FileInputStream stream = new FileInputStream(file)) {
            charStream = CharStreams.fromStream(stream);
        }
        return parse(charStream);
    }
}
