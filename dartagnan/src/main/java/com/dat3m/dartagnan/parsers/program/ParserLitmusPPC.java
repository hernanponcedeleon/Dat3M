package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.exception.ParserErrorListener;
import com.dat3m.dartagnan.parsers.LitmusPPCLexer;
import com.dat3m.dartagnan.parsers.LitmusPPCParser;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorLitmusPPC;
import com.dat3m.dartagnan.program.Program;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.DiagnosticErrorListener;
import org.antlr.v4.runtime.ParserRuleContext;

class ParserLitmusPPC implements ParserInterface {

    @Override
    public Program parse(CharStream charStream) {
        LitmusPPCLexer lexer = new LitmusPPCLexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        LitmusPPCParser parser = new LitmusPPCParser(tokenStream);
        parser.addErrorListener(new DiagnosticErrorListener(true));
        parser.addErrorListener(new ParserErrorListener());
        ParserRuleContext parserEntryPoint = parser.main();
        VisitorLitmusPPC visitor = new VisitorLitmusPPC();

        return (Program) parserEntryPoint.accept(visitor);
    }
}
