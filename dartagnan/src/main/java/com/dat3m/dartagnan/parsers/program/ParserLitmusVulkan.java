package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.exception.ParserErrorListener;
import com.dat3m.dartagnan.parsers.LitmusVulkanLexer;
import com.dat3m.dartagnan.parsers.LitmusVulkanParser;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorLitmusVulkan;
import com.dat3m.dartagnan.program.Program;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.DiagnosticErrorListener;
import org.antlr.v4.runtime.ParserRuleContext;

class ParserLitmusVulkan implements ParserInterface {

    @Override
    public Program parse(CharStream charStream) {
        LitmusVulkanLexer lexer = new LitmusVulkanLexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        LitmusVulkanParser parser = new LitmusVulkanParser(tokenStream);
        parser.addErrorListener(new DiagnosticErrorListener(true));
        parser.addErrorListener(new ParserErrorListener());
        ParserRuleContext parserEntryPoint = parser.main();
        VisitorLitmusVulkan visitor = new VisitorLitmusVulkan();

        return (Program) parserEntryPoint.accept(visitor);
    }
}