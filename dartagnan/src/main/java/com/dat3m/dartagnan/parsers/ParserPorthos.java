package com.dat3m.dartagnan.parsers;

import com.dat3m.dartagnan.parsers.utils.ParserErrorListener;
import com.dat3m.dartagnan.parsers.utils.ProgramBuilder;
import com.dat3m.dartagnan.parsers.visitors.VisitorPorthos;
import com.dat3m.dartagnan.program.Program;
import org.antlr.v4.runtime.*;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

public class ParserPorthos implements ParserInterface{

    @Override
    public Program parse(String inputFilePath) throws IOException {
        File file = new File(inputFilePath);
        FileInputStream stream = new FileInputStream(file);
        CharStream charStream = CharStreams.fromStream(stream);
        PorthosLexer lexer = new PorthosLexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);
        stream.close();

        PorthosParser parser = new PorthosParser(tokenStream);
        parser.addErrorListener(new DiagnosticErrorListener(true));
        parser.addErrorListener(new ParserErrorListener());
        ProgramBuilder pb = new ProgramBuilder();
        ParserRuleContext parserEntryPoint = parser.main();
        VisitorPorthos visitor = new VisitorPorthos(pb);

        Program program = (Program) parserEntryPoint.accept(visitor);
        program.setName(inputFilePath);
        return program;
    }
}
