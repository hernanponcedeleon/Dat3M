package dartagnan.parsers;

import dartagnan.LitmusX86Lexer;
import dartagnan.LitmusX86Parser;
import dartagnan.parsers.visitors.VisitorLitmusX86;
import dartagnan.program.Program;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.DiagnosticErrorListener;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

public class ParserLitmusX86 implements ParserAssertableInterface {

    private boolean allowEmptyAssertFlag = false;

    public void setAllowEmptyAssertFlag(boolean flag){
        allowEmptyAssertFlag = flag;
    }

    public Program parse(String inputFilePath) throws IOException {

        File file = new File(inputFilePath);
        FileInputStream stream = new FileInputStream(file);
        CharStream charStream = CharStreams.fromStream(stream);

        LitmusX86Lexer lexer = new LitmusX86Lexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        LitmusX86Parser parser = new LitmusX86Parser(tokenStream);
        parser.addErrorListener(new DiagnosticErrorListener(true));
        parser.addErrorListener(new ParserErrorListener());
        ParserRuleContext parserEntryPoint = parser.main();
        VisitorLitmusX86 visitor = new VisitorLitmusX86();
        visitor.setAllowEmptyAssertFlag(allowEmptyAssertFlag);

        Program program = (Program) parserEntryPoint.accept(visitor);
        program.setName(inputFilePath);
        return program;
    }
}