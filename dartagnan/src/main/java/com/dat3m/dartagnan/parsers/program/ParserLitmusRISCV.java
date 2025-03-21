package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.exception.AbortErrorListener;
import com.dat3m.dartagnan.parsers.LitmusRISCVLexer;
import com.dat3m.dartagnan.parsers.LitmusRISCVParser;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorLitmusRISCV;
import com.dat3m.dartagnan.program.Program;
import org.antlr.v4.runtime.*;

class ParserLitmusRISCV implements ParserInterface {

    @Override
    public Program parse(CharStream charStream) {
        LitmusRISCVLexer lexer = new LitmusRISCVLexer(charStream);
        lexer.addErrorListener(new AbortErrorListener());
        lexer.addErrorListener(new DiagnosticErrorListener(true));
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        LitmusRISCVParser parser = new LitmusRISCVParser(tokenStream);
        parser.addErrorListener(new AbortErrorListener());
        parser.addErrorListener(new DiagnosticErrorListener(true));
        ParserRuleContext parserEntryPoint = parser.main();
        VisitorLitmusRISCV visitor = new VisitorLitmusRISCV();

        return (Program) parserEntryPoint.accept(visitor);
    }
}
