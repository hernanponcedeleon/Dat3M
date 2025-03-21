package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.exception.AbortErrorListener;
import com.dat3m.dartagnan.parsers.LitmusPTXLexer;
import com.dat3m.dartagnan.parsers.LitmusPTXParser;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorLitmusPTX;
import com.dat3m.dartagnan.program.Program;
import org.antlr.v4.runtime.*;

class ParserLitmusPTX implements ParserInterface {

    @Override
    public Program parse(CharStream charStream) {
        LitmusPTXLexer lexer = new LitmusPTXLexer(charStream);
        lexer.addErrorListener(new AbortErrorListener());
        lexer.addErrorListener(new DiagnosticErrorListener(true));
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        LitmusPTXParser parser = new LitmusPTXParser(tokenStream);
        parser.addErrorListener(new AbortErrorListener());
        parser.addErrorListener(new DiagnosticErrorListener(true));
        ParserRuleContext parserEntryPoint = parser.main();
        VisitorLitmusPTX visitor = new VisitorLitmusPTX();

        return (Program) parserEntryPoint.accept(visitor);
    }
}