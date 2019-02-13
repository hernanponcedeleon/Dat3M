package com.dat3m.dartagnan.parsers;

import com.dat3m.dartagnan.parsers.utils.ParserErrorListener;
import com.dat3m.dartagnan.parsers.utils.ProgramBuilder;
import com.dat3m.dartagnan.parsers.visitors.VisitorLitmusX86;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.wmm.utils.Arch;

import org.antlr.v4.runtime.*;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

public class ParserLitmusX86 implements ParserInterface {

    @Override
    public Program parse(String inputFilePath) throws IOException {
        File file = new File(inputFilePath);
        FileInputStream stream = new FileInputStream(file);
        CharStream charStream = CharStreams.fromStream(stream);
        LitmusX86Lexer lexer = new LitmusX86Lexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);
        stream.close();

        LitmusX86Parser parser = new LitmusX86Parser(tokenStream);
        parser.addErrorListener(new DiagnosticErrorListener(true));
        parser.addErrorListener(new ParserErrorListener());
        ProgramBuilder pb = new ProgramBuilder();
        ParserRuleContext parserEntryPoint = parser.main();
        VisitorLitmusX86 visitor = new VisitorLitmusX86(pb);

        Program program = (Program) parserEntryPoint.accept(visitor);
        program.setName(inputFilePath);
        program.setArch(Arch.TSO);
        return program;
    }
}