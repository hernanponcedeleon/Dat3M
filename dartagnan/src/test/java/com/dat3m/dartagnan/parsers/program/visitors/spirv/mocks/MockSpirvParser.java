package com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks;

import com.dat3m.dartagnan.exception.AbortErrorListener;
import com.dat3m.dartagnan.parsers.SpirvLexer;
import com.dat3m.dartagnan.parsers.SpirvParser;
import org.antlr.v4.runtime.*;

public class MockSpirvParser extends SpirvParser {
    public MockSpirvParser(String input) {
        super(mockTokenStream(input));
        addErrorListener(new DiagnosticErrorListener(true));
        addErrorListener(new AbortErrorListener());
    }

    private static TokenStream mockTokenStream(String input) {
        CharStream charStream = CharStreams.fromString(input);
        SpirvLexer lexer = new SpirvLexer(charStream);
        lexer.addErrorListener(new DiagnosticErrorListener(true));
        lexer.addErrorListener(new AbortErrorListener());
        return new CommonTokenStream(lexer);
    }
}
