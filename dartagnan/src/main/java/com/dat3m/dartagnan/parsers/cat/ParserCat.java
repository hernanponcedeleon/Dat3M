package com.dat3m.dartagnan.parsers.cat;

import com.dat3m.dartagnan.parsers.CatParser;
import com.dat3m.dartagnan.parsers.CatLexer;
import com.dat3m.dartagnan.parsers.cat.visitors.VisitorBase;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import org.antlr.v4.runtime.*;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

public class ParserCat {

    public Wmm parse(String inputFilePath, Arch target) throws IOException {
        File file = new File(inputFilePath);
        FileInputStream stream = new FileInputStream(file);
        CharStream charStream = CharStreams.fromStream(stream);
        CatLexer lexer = new CatLexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);
        stream.close();

        CatParser parser = new CatParser(tokenStream);
        parser.setErrorHandler(new BailErrorStrategy());
        ParserRuleContext parserEntryPoint = parser.mcm();
        return (Wmm) parserEntryPoint.accept(new VisitorBase(target));
    }
}
