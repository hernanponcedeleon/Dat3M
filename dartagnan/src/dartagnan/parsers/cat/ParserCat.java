package dartagnan.parsers.cat;

import dartagnan.parsers.CatLexer;
import dartagnan.parsers.CatParser;
import dartagnan.parsers.cat.visitors.VisitorBase;
import dartagnan.wmm.Wmm;
import org.antlr.v4.runtime.*;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

public class ParserCat {

    public Wmm parse(String inputFilePath, String target) throws IOException {
        File file = new File(inputFilePath);
        FileInputStream stream = new FileInputStream(file);
        CharStream charStream = CharStreams.fromStream(stream);
        CatLexer lexer = new CatLexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);
        CatParser parser = new CatParser(tokenStream);
        parser.setErrorHandler(new BailErrorStrategy());
        ParserRuleContext parserEntryPoint = parser.mcm();
        return (Wmm) parserEntryPoint.accept(new VisitorBase(target));
    }
}
