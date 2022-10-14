package com.dat3m.dartagnan.parsers.cat;

import com.dat3m.dartagnan.parsers.CatLexer;
import com.dat3m.dartagnan.parsers.CatParser;
import com.dat3m.dartagnan.exception.ParserErrorListener;
import com.dat3m.dartagnan.wmm.Wmm;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

public class ParserCat {

    public Wmm parse(File file) throws IOException {
        try (FileInputStream stream = new FileInputStream(file)) {
            return parse(CharStreams.fromStream(stream));
        }
    }

    public Wmm parse(String raw) {
        return parse(CharStreams.fromString(raw));
    }

    private Wmm parse(CharStream charStream){
        CatLexer lexer = new CatLexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        CatParser parser = new CatParser(tokenStream);
        parser.addErrorListener(new ParserErrorListener());
        ParserRuleContext parserEntryPoint = parser.mcm();
        return (Wmm) parserEntryPoint.accept(new VisitorBase());
    }
}
