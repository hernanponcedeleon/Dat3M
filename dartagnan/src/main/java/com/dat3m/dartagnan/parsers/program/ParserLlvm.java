package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.parsers.LLVMIRLexer;
import com.dat3m.dartagnan.parsers.LLVMIRParser;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorLlvm;
import com.dat3m.dartagnan.program.Program;
import org.antlr.v4.runtime.BailErrorStrategy;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;

class ParserLlvm implements ParserInterface {

    @Override
    public Program parse(CharStream charStream) {
        LLVMIRLexer lexer = new LLVMIRLexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        LLVMIRParser parser = new LLVMIRParser(tokenStream);
        parser.setErrorHandler(new BailErrorStrategy());
        ParserRuleContext parserEntryPoint = parser.compilationUnit();
        VisitorLlvm visitor = new VisitorLlvm();

        parserEntryPoint.accept(visitor);
        // LLVM programs can be compiled to different targets,
        // thus we don't set the architectures.
        return visitor.buildProgram();
    }
}
