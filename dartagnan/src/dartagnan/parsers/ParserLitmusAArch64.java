package dartagnan.parsers;

import dartagnan.parsers.utils.ParserErrorListener;
import dartagnan.parsers.utils.ProgramBuilder;
import dartagnan.parsers.visitors.VisitorLitmusAArch64;
import dartagnan.program.Program;
import org.antlr.v4.runtime.*;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

public class ParserLitmusAArch64 implements ParserInterface {

    public Program parse(String inputFilePath) throws IOException {
        File file = new File(inputFilePath);
        FileInputStream stream = new FileInputStream(file);
        CharStream charStream = CharStreams.fromStream(stream);

        LitmusAArch64Lexer lexer = new LitmusAArch64Lexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        LitmusAArch64Parser parser = new LitmusAArch64Parser(tokenStream);
        parser.addErrorListener(new DiagnosticErrorListener(true));
        parser.addErrorListener(new ParserErrorListener());
        ProgramBuilder pb = new ProgramBuilder();
        ParserRuleContext parserEntryPoint = parser.main();
        VisitorLitmusAArch64 visitor = new VisitorLitmusAArch64(pb);

        Program program = (Program) parserEntryPoint.accept(visitor);
        program.setName(inputFilePath);
        return program;
    }
}
