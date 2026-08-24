package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.configuration.Arch;
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
        program.setArch(dataLayout.targetArchitecture);
        VisitorLlvm visitor = new VisitorLlvm(program);

        visitor.visitCompilationUnit(parserEntryPoint);
        // LLVM programs can be compiled to different targets,
        // thus we don't set the architectures.
        return visitor.buildProgram();
    }

    private static final class DataLayout {
        Arch targetArchitecture;
        boolean bigEndian;
    }

    private static DataLayout parseDataLayout(CompilationUnitContext ctx) {
        final var layout = new DataLayout();
        for (TopLevelEntityContext topLevelEntity : ctx.topLevelEntity()) {
            final TargetDefContext targetDef = topLevelEntity.targetDef();
            final TargetTripleContext targetTriple = targetDef == null ? null : targetDef.targetTriple();
            final TargetDataLayoutContext targetDataLayout = targetDef == null ? null : targetDef.targetDataLayout();
            if (targetTriple != null) {
                final String architecture = VisitorLlvm.unescape(targetTriple.StringLit().getText()).split("-")[0];
                layout.targetArchitecture = switch (architecture) {
                    case "arm" -> Arch.ARM7;
                    case "arm64" -> Arch.ARM8;
                    case "riscv" -> Arch.RISCV;
                    case "x86", "x86_64" -> Arch.TSO;
                    default -> null;
                };
            }
            if (targetDataLayout != null) {
                for (String spec : VisitorLlvm.unescape(targetDataLayout.StringLit().getText()).split("-")) {
                    parseDataLayout(layout, spec);
                }
            }
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
