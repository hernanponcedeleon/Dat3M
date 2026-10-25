package com.dat3m.dartagnan.frontend.litmus.ppc;

import com.dat3m.dartagnan.exception.AbortErrorListener;
import com.dat3m.dartagnan.parsers.LitmusPPCLexer;
import com.dat3m.dartagnan.parsers.LitmusPPCParser;
import com.dat3m.dartagnan.frontend.ParserInterface;
import com.dat3m.dartagnan.program.Program;
import org.antlr.v4.runtime.*;

public class ParserLitmusPPC implements ParserInterface {

    @Override
    public Program parse(CharStream charStream) {
        LitmusPPCLexer lexer = new LitmusPPCLexer(charStream);
        lexer.addErrorListener(new AbortErrorListener());
        lexer.addErrorListener(new DiagnosticErrorListener(true));
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        LitmusPPCParser parser = new LitmusPPCParser(tokenStream);
        parser.addErrorListener(new AbortErrorListener());
        parser.addErrorListener(new DiagnosticErrorListener(true));
        ParserRuleContext parserEntryPoint = parser.main();
        VisitorLitmusPPC visitor = new VisitorLitmusPPC();

        return (Program) parserEntryPoint.accept(visitor);
    }
}
