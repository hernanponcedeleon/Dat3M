package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.exception.ParserErrorListener;
import com.dat3m.dartagnan.parsers.LitmusRISCVLexer;
import com.dat3m.dartagnan.parsers.LitmusRISCVParser;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorLitmusRISCV;
import com.dat3m.dartagnan.program.Program;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.DiagnosticErrorListener;
import org.antlr.v4.runtime.ParserRuleContext;

class ParserLitmusRISCV implements ParserInterface {

    @Override
    public Program parse(CharStream charStream) {
        LitmusRISCVLexer lexer = new LitmusRISCVLexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        LitmusRISCVParser parser = new LitmusRISCVParser(tokenStream);
        parser.addErrorListener(new DiagnosticErrorListener(true));
        parser.addErrorListener(new ParserErrorListener());
        ParserRuleContext parserEntryPoint = parser.main();
        VisitorLitmusRISCV visitor = new VisitorLitmusRISCV();

        Program program = (Program) parserEntryPoint.accept(visitor);
        return program;
    }
}
