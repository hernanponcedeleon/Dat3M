package com.dat3m.dartagnan.parsers.cat;

import com.dat3m.dartagnan.parsers.CatParser;
import com.dat3m.dartagnan.parsers.CatLexer;
import com.dat3m.dartagnan.parsers.cat.visitors.VisitorBase;
import com.dat3m.dartagnan.parsers.program.utils.ParserErrorListener;
import com.dat3m.dartagnan.wmm.Wmm;
import org.antlr.v4.runtime.*;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

public class ParserCat {

    public Wmm parse(File file) throws IOException {
        FileInputStream stream = new FileInputStream(file);
        Wmm wmm = parse(CharStreams.fromStream(stream));
        stream.close();
        return wmm;
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
