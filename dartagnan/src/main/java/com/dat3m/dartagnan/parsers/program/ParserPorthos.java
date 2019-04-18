package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.parsers.PorthosLexer;
import com.dat3m.dartagnan.parsers.PorthosParser;
import com.dat3m.dartagnan.parsers.program.utils.ParserErrorListener;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorPorthos;
import com.dat3m.dartagnan.program.Program;
import org.antlr.v4.runtime.*;

class ParserPorthos implements ParserInterface{

    @Override
    public Program parse(CharStream charStream) {
        PorthosLexer lexer = new PorthosLexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        PorthosParser parser = new PorthosParser(tokenStream);
        parser.addErrorListener(new DiagnosticErrorListener(true));
        parser.addErrorListener(new ParserErrorListener());
        ProgramBuilder pb = new ProgramBuilder();
        ParserRuleContext parserEntryPoint = parser.main();
        VisitorPorthos visitor = new VisitorPorthos(pb);

        return (Program) parserEntryPoint.accept(visitor);
    }
}
