package com.dat3m.dartagnan.frontend.spirv;

import com.dat3m.dartagnan.exception.AbortErrorListener;
import com.dat3m.dartagnan.frontend.ParserInterface;
import com.dat3m.dartagnan.parsers.SpirvLexer;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.program.Program;
import org.antlr.v4.runtime.*;

public class ParserSpirv implements ParserInterface {

    @Override
    public Program parse(CharStream charStream) {
        SpirvLexer lexer = new SpirvLexer(charStream);
        lexer.addErrorListener(new AbortErrorListener());
        lexer.addErrorListener(new DiagnosticErrorListener(true));
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        SpirvParser parser = new SpirvParser(tokenStream);
        parser.addErrorListener(new AbortErrorListener());
        parser.addErrorListener(new DiagnosticErrorListener(true));
        ParserRuleContext parserEntryPoint = parser.spv();
        VisitorSpirv visitor = new VisitorSpirv();

        return parserEntryPoint.accept(visitor);
    }
}
