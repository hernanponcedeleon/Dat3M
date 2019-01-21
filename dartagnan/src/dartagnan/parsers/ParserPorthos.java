package dartagnan.parsers;

import dartagnan.parsers.utils.ParserErrorListener;
import dartagnan.parsers.utils.ProgramBuilder;
import dartagnan.parsers.visitors.VisitorPorthos;
import dartagnan.program.Program;
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
