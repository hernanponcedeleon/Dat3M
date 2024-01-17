package com.dat3m.dartagnan.parsers.cat;

import com.dat3m.dartagnan.parsers.CatLexer;
import com.dat3m.dartagnan.parsers.CatParser;
import com.dat3m.dartagnan.exception.AbortErrorListener;
import com.dat3m.dartagnan.wmm.Wmm;
import org.antlr.v4.runtime.*;

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
        lexer.addErrorListener(new AbortErrorListener());
        lexer.addErrorListener(new DiagnosticErrorListener(true));
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        CatParser parser = new CatParser(tokenStream);
        parser.addErrorListener(new AbortErrorListener());
        parser.addErrorListener(new DiagnosticErrorListener(true));
        ParserRuleContext parserEntryPoint = parser.mcm();
        return (Wmm) parserEntryPoint.accept(new VisitorBase());
    }
}
