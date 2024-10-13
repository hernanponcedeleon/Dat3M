package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.exception.AbortErrorListener;
import com.dat3m.dartagnan.parsers.LitmusBPFLexer;
import com.dat3m.dartagnan.parsers.LitmusBPFParser;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorLitmusBPF;
import com.dat3m.dartagnan.program.Program;
import org.antlr.v4.runtime.*;

class ParserLitmusBPF implements ParserInterface {

    @Override
    public Program parse(CharStream charStream) {
        LitmusBPFLexer lexer = new LitmusBPFLexer(charStream);
        lexer.addErrorListener(new AbortErrorListener());
        lexer.addErrorListener(new DiagnosticErrorListener(true));
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        LitmusBPFParser parser = new LitmusBPFParser(tokenStream);
        parser.addErrorListener(new AbortErrorListener());
        parser.addErrorListener(new DiagnosticErrorListener(true));
        ParserRuleContext parserEntryPoint = parser.main();
        VisitorLitmusBPF visitor = new VisitorLitmusBPF();

        return (Program) parserEntryPoint.accept(visitor);
    }
}
