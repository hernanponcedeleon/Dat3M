package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.program.Program;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;

import java.io.*;

import static com.dat3m.dartagnan.parsers.program.utils.Compilation.applyLlvmPasses;
import static com.dat3m.dartagnan.parsers.program.utils.Compilation.compileWithClang;
import static com.dat3m.dartagnan.parsers.program.utils.Compilation.applyDemangling;;

public class ProgramParser {

    private static final String TYPE_LITMUS_AARCH64 = "AARCH64";
    private static final String TYPE_LITMUS_PPC = "PPC";
    private static final String TYPE_LITMUS_RISCV = "RISCV";
    private static final String TYPE_LITMUS_X86 = "X86";
    private static final String TYPE_LITMUS_PTX = "PTX";
    private static final String TYPE_LITMUS_VULKAN = "VULKAN";
    private static final String TYPE_LITMUS_C = "C";

    public Program parse(File file) throws Exception {
        if (needsClang(file)) {
            file = compileWithClang(file, "");
            file = applyLlvmPasses(file);
            file = applyDemangling(file);
            return new ProgramParser().parse(file);
        }

        Program program;
        try (FileInputStream stream = new FileInputStream(file)) {
            ParserInterface parser = getConcreteParser(file);
            CharStream charStream = CharStreams.fromStream(stream);
            program = parser.parse(charStream);
        }
        program.setName(file.getName());
        return program;
    }

    private boolean needsClang(File f) {
        return f.getPath().endsWith(".c") || f.getPath().endsWith(".i") || f.getPath().endsWith(".cl");
    }

    public Program parse(String raw, String path, String format, String cflags) throws Exception {
        switch (format) {
            case "c", "i", "cl" -> {
                File file = path.isEmpty() ?
                        // This is for the case where the user fully typed the program instead of loading it
                        File.createTempFile("dat3m", format) :
                        // This is for the case where the user loaded the program
                        new File(path, "dat3m.c");
                try (FileWriter writer = new FileWriter(file)) {
                    writer.write(raw);
                }
                file = compileWithClang(file, cflags);
                file = applyLlvmPasses(file);
                Program p = new ProgramParser().parse(file);
                file.delete();
                return p;
            }
            case "ll" -> {
                return new ParserLlvm().parse(CharStreams.fromString(raw));
            }
            case "spv.dis" -> {
                return new ParserSpirv().parse(CharStreams.fromString(raw));
            }
            case "litmus" -> {
                return getConcreteLitmusParser(raw.toUpperCase()).parse(CharStreams.fromString(raw));
            }
        }
        throw new ParsingException("Unknown input file type");
    }

    private ParserInterface getConcreteParser(File file) throws IOException {
        String name = file.getName();
        if (name.endsWith(".ll")) {
            return new ParserLlvm();
        }
        if (name.endsWith(".spv.dis")) {
            return new ParserSpirv();
        }
        if (name.endsWith(".litmus")) {
            return getConcreteLitmusParser(readFirstLine(file).toUpperCase());
        }
        throw new ParsingException("Unknown input file type");
    }

    private ParserInterface getConcreteLitmusParser(String programText) {
        if (programText.indexOf(TYPE_LITMUS_AARCH64) == 0) {
            return new ParserLitmusAArch64();
        } else if (programText.indexOf(TYPE_LITMUS_C) == 0) {
            return new ParserLitmusC();
        } else if (programText.indexOf(TYPE_LITMUS_PPC) == 0) {
            return new ParserLitmusPPC();
        } else if (programText.indexOf(TYPE_LITMUS_X86) == 0) {
            return new ParserLitmusX86();
        } else if (programText.indexOf(TYPE_LITMUS_RISCV) == 0) {
            return new ParserLitmusRISCV();
        } else if (programText.indexOf(TYPE_LITMUS_PTX) == 0) {
            return new ParserLitmusPTX();
        } else if(programText.indexOf(TYPE_LITMUS_VULKAN) == 0) {
            return new ParserLitmusVulkan();
        }
        throw new ParsingException("Unknown input file type");
    }

    private String readFirstLine(File file) throws IOException {
        String line;
        try (BufferedReader bufferedReader = new BufferedReader(new FileReader(file))) {
            line = bufferedReader.readLine();
        }
        return line;
    }
}