package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.parsers.LitmusRISCVLexer;
import com.dat3m.dartagnan.parsers.LitmusRISCVParser;
import com.dat3m.dartagnan.exception.ParserErrorListener;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorLitmusRISCV;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Program.SourceLanguage;
import com.dat3m.dartagnan.configuration.Arch;

import org.antlr.v4.runtime.*;

class ParserLitmusRISCV implements ParserInterface {

    @Override
    public Program parse(CharStream charStream) {
        LitmusRISCVLexer lexer = new LitmusRISCVLexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        LitmusRISCVParser parser = new LitmusRISCVParser(tokenStream);
        parser.addErrorListener(new DiagnosticErrorListener(true));
        parser.addErrorListener(new ParserErrorListener());
        ProgramBuilder pb = new ProgramBuilder(SourceLanguage.LITMUS);
        ParserRuleContext parserEntryPoint = parser.main();
        VisitorLitmusRISCV visitor = new VisitorLitmusRISCV(pb);

        Program program = (Program) parserEntryPoint.accept(visitor);
        program.setArch(Arch.RISCV);
        return program;
    }
}
