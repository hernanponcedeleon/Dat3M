package com.dat3m.dartagnan.frontend.litmus.c;

import com.dat3m.dartagnan.exception.AbortErrorListener;
import com.dat3m.dartagnan.parsers.LitmusCLexer;
import com.dat3m.dartagnan.parsers.LitmusCParser;
import com.dat3m.dartagnan.frontend.ParserInterface;
import com.dat3m.dartagnan.program.Program;
import org.antlr.v4.runtime.*;

public class ParserLitmusC implements ParserInterface<Program> {

    @Override
    public Program parse(CharStream charStream) {
        LitmusCLexer lexer = new LitmusCLexer(charStream);
        lexer.addErrorListener(new AbortErrorListener());
        lexer.addErrorListener(new DiagnosticErrorListener(true));
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        LitmusCParser parser = new LitmusCParser(tokenStream);
        parser.addErrorListener(new AbortErrorListener());
        ParserRuleContext parserEntryPoint = parser.main();
        VisitorLitmusC visitor = new VisitorLitmusC();

        // C programs can be compiled to different targets,
        // thus we don't set the architectures.
        return (Program) parserEntryPoint.accept(visitor);
    }
}
