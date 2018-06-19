package dartagnan.parsers;

import dartagnan.program.Program;
import dartagnan.LitmusLexer;
import dartagnan.LitmusParser;
import dartagnan.utils.ParserErrorListener;
import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.apache.commons.io.FileUtils;

import java.io.File;
import java.io.IOException;

public class ParserLitmusX86 implements ParserInterface {

    public Program parse(String inputFilePath) throws IOException {
        File file = new File(inputFilePath);
        String programRaw = FileUtils.readFileToString(file, "UTF-8");
        ANTLRInputStream input = new ANTLRInputStream(programRaw);
        LitmusLexer lexer = new LitmusLexer(input);
        CommonTokenStream tokens = new CommonTokenStream(lexer);

        ParserErrorListener listener = new ParserErrorListener();

        LitmusParser parser = new LitmusParser(tokens);
        parser.addErrorListener(listener);
        return parser.program(inputFilePath).p;
    }
}
