package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.parsers.LitmusCLexer;
import com.dat3m.dartagnan.parsers.LitmusCParser;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorLitmusC;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Program.SourceLanguage;

import org.antlr.v4.runtime.*;

class ParserLitmusC implements ParserInterface {

    @Override
    public Program parse(CharStream charStream) {
        LitmusCLexer lexer = new LitmusCLexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        LitmusCParser parser = new LitmusCParser(tokenStream);
        parser.setErrorHandler(new BailErrorStrategy());
        ProgramBuilder pb = new ProgramBuilder(SourceLanguage.LITMUS);
        ParserRuleContext parserEntryPoint = parser.main();
        VisitorLitmusC visitor = new VisitorLitmusC(pb);

        Program program = (Program) parserEntryPoint.accept(visitor);
        // C programs can be compiled to different targets,
        // thus we don't set the architectures.
        return program;
    }
}
