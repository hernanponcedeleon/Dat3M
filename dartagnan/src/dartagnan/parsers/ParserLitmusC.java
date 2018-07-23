package dartagnan.parsers;

import dartagnan.LitmusCLexer;
import dartagnan.LitmusCParser;
import dartagnan.parsers.visitors.VisitorLitmusC;
import dartagnan.program.Program;
import org.antlr.v4.runtime.*;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

public class ParserLitmusC implements ParserInterface {

    public Program parse(String inputFilePath) throws IOException {
        File file = new File(inputFilePath);
        FileInputStream stream = new FileInputStream(file);
        CharStream charStream = CharStreams.fromStream(stream);

        LitmusCLexer lexer = new LitmusCLexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        LitmusCParser parser = new LitmusCParser(tokenStream);
        parser.setErrorHandler(new BailErrorStrategy());
        ParserRuleContext parserEntryPoint = parser.main();
        VisitorLitmusC visitor = new VisitorLitmusC();

        Program program = (Program) parserEntryPoint.accept(visitor);
        //program.setName(inputFilePath);
        return program;
    }
}
