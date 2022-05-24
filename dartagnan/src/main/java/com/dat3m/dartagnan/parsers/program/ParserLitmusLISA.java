package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.parsers.LitmusLISALexer;
import com.dat3m.dartagnan.parsers.LitmusLISAParser;
import com.dat3m.dartagnan.exception.ParserErrorListener;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorLitmusLISA;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Program.SourceLanguage;

import org.antlr.v4.runtime.*;

class ParserLitmusLISA implements ParserInterface {

    @Override
    public Program parse(CharStream charStream) {
        LitmusLISALexer lexer = new LitmusLISALexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        LitmusLISAParser parser = new LitmusLISAParser(tokenStream);
        parser.addErrorListener(new DiagnosticErrorListener(true));
        parser.addErrorListener(new ParserErrorListener());
        ProgramBuilder pb = new ProgramBuilder(SourceLanguage.LITMUS);
        ParserRuleContext parserEntryPoint = parser.main();
        VisitorLitmusLISA visitor = new VisitorLitmusLISA(pb);

        Program program = (Program) parserEntryPoint.accept(visitor);
        return program;
    }
}
