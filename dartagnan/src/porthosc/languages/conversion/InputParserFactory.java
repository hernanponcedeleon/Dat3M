package porthosc.languages.conversion;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.ParserRuleContext;
import porthosc.languages.common.InputLanguage;
import porthosc.languages.parsers.C11Lexer;
import porthosc.languages.parsers.C11Parser;
import porthosc.languages.parsers.CatLexer;
import porthosc.languages.parsers.CatParser;
import porthosc.utils.exceptions.ytree.YParserException;
import porthosc.utils.io.FileUtils;

import java.io.File;
import java.io.IOException;

import static porthosc.utils.StringUtils.wrap;


public class InputParserFactory {

    public static CommonTokenStream getTokenStream(File programFile, InputLanguage language) throws IOException {
        CharStream charStream = FileUtils.getFileCharStream(programFile);
        Lexer lexer;

        switch (language) {
            case C11:
                lexer = new C11Lexer(charStream);
                break;
            case Cat:
                lexer = new CatLexer(charStream);
                break;
            default:
                throw new IllegalArgumentException(language.name());
        }

        return new CommonTokenStream(lexer);
    }

    public static ParserRuleContext getParser(CommonTokenStream tokenStream, InputLanguage language) {
        SyntaxErrorListener errorListener = new SyntaxErrorListener();
        ParserRuleContext result;
        switch (language) {
            case C11: {
                C11Parser parser = new C11Parser(tokenStream);
                parser.addErrorListener(errorListener);
                result = parser.main();
                break;
            }
            case Cat: {
                CatParser parser = new CatParser(tokenStream);
                parser.addErrorListener(errorListener);
                result = parser.main();
                break;
            }
            default:
                throw new IllegalArgumentException(language.name());
        }
        if (errorListener.hasSyntaxErrors()) {
            throw new YParserException(result, "Syntax errors while parsing: " + wrap(errorListener));
        }
        return result;
    }
}
