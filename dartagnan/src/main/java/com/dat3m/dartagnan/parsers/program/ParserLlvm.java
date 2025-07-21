package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.exception.AbortErrorListener;
import com.dat3m.dartagnan.parsers.LLVMIRLexer;
import com.dat3m.dartagnan.parsers.LLVMIRParser;
import com.dat3m.dartagnan.parsers.LLVMIRParser.*;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorLlvm;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.memory.Memory;
import org.antlr.v4.runtime.*;

class ParserLlvm implements ParserInterface {

    @Override
    public Program parse(CharStream charStream) {
        LLVMIRLexer lexer = new LLVMIRLexer(charStream);
        lexer.addErrorListener(new AbortErrorListener());
        lexer.addErrorListener(new DiagnosticErrorListener(true));
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        LLVMIRParser parser = new LLVMIRParser(tokenStream);
        parser.addErrorListener(new AbortErrorListener());
        CompilationUnitContext parserEntryPoint = parser.compilationUnit();
        DataLayout dataLayout = parseDataLayout(parserEntryPoint);
        Program program = new Program(new Memory(dataLayout.bigEndian), Program.SourceLanguage.LLVM);
        VisitorLlvm visitor = new VisitorLlvm(program);

        visitor.visitCompilationUnit(parserEntryPoint);
        // LLVM programs can be compiled to different targets,
        // thus we don't set the architectures.
        return visitor.buildProgram();
    }

    private static final class DataLayout {
        boolean bigEndian;
    }

    private static DataLayout parseDataLayout(CompilationUnitContext ctx) {
        var layout = new DataLayout();
        for (TopLevelEntityContext topLevelEntity : ctx.topLevelEntity()) {
            TargetDefContext targetDef = topLevelEntity.targetDef();
            TargetDataLayoutContext targetDataLayout = targetDef == null ? null : targetDef.targetDataLayout();
            if (targetDataLayout == null) {
                continue;
            }
            for (String spec : targetDataLayout.StringLit().getText().split("-")) {
                parseDataLayout(layout, spec);
            }
            break;
        }
        return layout;
    }

    //Target Data Layout specifications are read left-to-right as they occur
    //see https://llvm.org/docs/LangRef.html#data-layout
    private static void parseDataLayout(DataLayout layout, String spec) {
        if (spec.equalsIgnoreCase("e")) {
            layout.bigEndian = spec.equals("E");
        }
    }
}
