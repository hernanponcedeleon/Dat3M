package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.parsers.LitmusAArch64Lexer;
import com.dat3m.dartagnan.parsers.LitmusAArch64Parser;
import com.dat3m.dartagnan.parsers.program.utils.ParserErrorListener;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorLitmusAArch64;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.wmm.utils.Arch;

import org.antlr.v4.runtime.*;

class ParserLitmusAArch64 implements ParserInterface {

    @Override
    public Program parse(CharStream charStream) {
        LitmusAArch64Lexer lexer = new LitmusAArch64Lexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        LitmusAArch64Parser parser = new LitmusAArch64Parser(tokenStream);
        parser.addErrorListener(new DiagnosticErrorListener(true));
        parser.addErrorListener(new ParserErrorListener());
        ProgramBuilder pb = new ProgramBuilder();
        ParserRuleContext parserEntryPoint = parser.main();
        VisitorLitmusAArch64 visitor = new VisitorLitmusAArch64(pb);

        Program program = (Program) parserEntryPoint.accept(visitor);
        program.setArch(Arch.ARM8);
        return program;
    }
}
