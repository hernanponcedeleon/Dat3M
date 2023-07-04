package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.exception.ParserErrorListener;
import com.dat3m.dartagnan.parsers.LitmusPTXLexer;
import com.dat3m.dartagnan.parsers.LitmusPTXParser;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorLitmusPTX;
import com.dat3m.dartagnan.program.Program;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.DiagnosticErrorListener;
import org.antlr.v4.runtime.ParserRuleContext;

class ParserLitmusPTX implements ParserInterface {

    @Override
    public Program parse(CharStream charStream) {
        LitmusPTXLexer lexer = new LitmusPTXLexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        LitmusPTXParser parser = new LitmusPTXParser(tokenStream);
        parser.addErrorListener(new DiagnosticErrorListener(true));
        parser.addErrorListener(new ParserErrorListener());
        ParserRuleContext parserEntryPoint = parser.main();
        VisitorLitmusPTX visitor = new VisitorLitmusPTX();

        Program program = (Program) parserEntryPoint.accept(visitor);
        return program;
    }
}