package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.exception.AbortErrorListener;
import com.dat3m.dartagnan.parsers.LitmusVulkanLexer;
import com.dat3m.dartagnan.parsers.LitmusVulkanParser;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorLitmusVulkan;
import com.dat3m.dartagnan.program.Program;
import org.antlr.v4.runtime.*;

class ParserLitmusVulkan implements ParserInterface {

    @Override
    public Program parse(CharStream charStream) {
        LitmusVulkanLexer lexer = new LitmusVulkanLexer(charStream);
        lexer.addErrorListener(new AbortErrorListener());
        lexer.addErrorListener(new DiagnosticErrorListener(true));
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        LitmusVulkanParser parser = new LitmusVulkanParser(tokenStream);
        parser.addErrorListener(new AbortErrorListener());
        parser.addErrorListener(new DiagnosticErrorListener(true));
        ParserRuleContext parserEntryPoint = parser.main();
        VisitorLitmusVulkan visitor = new VisitorLitmusVulkan();

        return (Program) parserEntryPoint.accept(visitor);
    }
}