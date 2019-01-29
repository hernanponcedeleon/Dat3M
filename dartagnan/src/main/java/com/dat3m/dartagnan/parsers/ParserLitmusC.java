package com.dat3m.dartagnan.parsers;

import com.dat3m.dartagnan.parsers.utils.ProgramBuilder;
import com.dat3m.dartagnan.parsers.visitors.VisitorLitmusC;
import com.dat3m.dartagnan.program.Program;
import org.antlr.v4.runtime.*;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

public class ParserLitmusC implements ParserInterface {

    @Override
    public Program parse(String inputFilePath) throws IOException {
        File file = new File(inputFilePath);
        FileInputStream stream = new FileInputStream(file);
        CharStream charStream = CharStreams.fromStream(stream);

        LitmusCLexer lexer = new LitmusCLexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        LitmusCParser parser = new LitmusCParser(tokenStream);
        parser.setErrorHandler(new BailErrorStrategy());
        ProgramBuilder pb = new ProgramBuilder();
        ParserRuleContext parserEntryPoint = parser.main();
        VisitorLitmusC visitor = new VisitorLitmusC(pb);


        Program program = (Program) parserEntryPoint.accept(visitor);
        program.setName(inputFilePath);
        return program;
    }
}
