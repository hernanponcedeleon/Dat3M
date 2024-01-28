package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.exception.AbortErrorListener;
import com.dat3m.dartagnan.parsers.LitmusLISALexer;
import com.dat3m.dartagnan.parsers.LitmusLISAParser;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorLitmusLISA;
import com.dat3m.dartagnan.program.Program;
import org.antlr.v4.runtime.*;

class ParserLitmusLISA implements ParserInterface {

    @Override
    public Program parse(CharStream charStream) {
        LitmusLISALexer lexer = new LitmusLISALexer(charStream);
        lexer.addErrorListener(new AbortErrorListener());
        lexer.addErrorListener(new DiagnosticErrorListener(true));
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        LitmusLISAParser parser = new LitmusLISAParser(tokenStream);
        parser.addErrorListener(new AbortErrorListener());
        parser.addErrorListener(new DiagnosticErrorListener(true));
        ParserRuleContext parserEntryPoint = parser.main();
        VisitorLitmusLISA visitor = new VisitorLitmusLISA();

        return (Program) parserEntryPoint.accept(visitor);
    }
}
