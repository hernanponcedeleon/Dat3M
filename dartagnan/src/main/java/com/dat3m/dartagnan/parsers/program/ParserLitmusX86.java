package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.parsers.LitmusX86Lexer;
import com.dat3m.dartagnan.parsers.LitmusX86Parser;
import com.dat3m.dartagnan.parsers.program.utils.ParserErrorListener;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorLitmusX86;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.wmm.utils.Arch;

import org.antlr.v4.runtime.*;

class ParserLitmusX86 implements ParserInterface {

    @Override
    public Program parse(CharStream charStream) {
        LitmusX86Lexer lexer = new LitmusX86Lexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        LitmusX86Parser parser = new LitmusX86Parser(tokenStream);
        parser.addErrorListener(new DiagnosticErrorListener(true));
        parser.addErrorListener(new ParserErrorListener());
        ProgramBuilder pb = new ProgramBuilder();
        ParserRuleContext parserEntryPoint = parser.main();
        VisitorLitmusX86 visitor = new VisitorLitmusX86(pb);

        Program program = (Program) parserEntryPoint.accept(visitor);
        program.setArch(Arch.TSO);
        return program;
    }
}