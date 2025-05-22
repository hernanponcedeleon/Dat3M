package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.program.Program;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import java.io.*;
import java.util.List;

import static com.dat3m.dartagnan.parsers.program.utils.Compilation.applyLlvmPasses;
import static com.dat3m.dartagnan.parsers.program.utils.Compilation.compileWithClang;

public class ProgramParser {

    private static final Logger logger = LogManager.getLogger(ProgramParser.class);

    private static final String TYPE_LITMUS_AARCH64 = "AARCH64";
    private static final String TYPE_LITMUS_PPC = "PPC";
    private static final String TYPE_LITMUS_RISCV = "RISCV";
    private static final String TYPE_LITMUS_X86 = "X86";
    private static final String TYPE_LITMUS_PTX = "PTX";
    private static final String TYPE_LITMUS_VULKAN = "VULKAN";
    private static final String TYPE_LITMUS_C = "C";
    private static final String TYPE_LITMUS_OPENCL = "OPENCL";

    public static final String EXTENSION_C = ".c";
    public static final String EXTENSION_I = ".i";
    public static final String EXTENSION_LL = ".ll";
    public static final String EXTENSION_LITMUS = ".litmus";
    public static final String EXTENSION_SPV_DIS = ".spv.dis"; // Deprecated.
    public static final String EXTENSION_SPVASM = ".spvasm";
    public static final List<String> SUPPORTED_EXTENSIONS = List.of(
            EXTENSION_C, EXTENSION_I, EXTENSION_LL, EXTENSION_LITMUS, EXTENSION_SPV_DIS, EXTENSION_SPVASM);

    public Program parse(File file) throws Exception {
        if (needsClang(file)) {
            file = compileWithClang(file, "");
            file = applyLlvmPasses(file);
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
        return f.getPath().endsWith(EXTENSION_C) || f.getPath().endsWith(EXTENSION_I);
    }

    public Program parse(String raw, String path, String format, String cflags) throws Exception {
        switch (format) {
            case EXTENSION_C, EXTENSION_I -> {
                File file = path.isEmpty() ?
                        // This is for the case where the user fully typed the program instead of loading it
                        File.createTempFile("dat3m", EXTENSION_C) :
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
            case EXTENSION_LL -> {
                return new ParserLlvm().parse(CharStreams.fromString(raw));
            }
            case EXTENSION_SPVASM -> {
                return new ParserSpirv().parse(CharStreams.fromString(raw));
            }
            case EXTENSION_SPV_DIS -> {
                logger.warn(String.format("Extension %s is deprecated. Please rename your file to %s instead.", EXTENSION_SPV_DIS, EXTENSION_SPVASM));
                return new ParserSpirv().parse(CharStreams.fromString(raw));
            }
            case EXTENSION_LITMUS -> {
                return getConcreteLitmusParser(raw.toUpperCase()).parse(CharStreams.fromString(raw));
            }
        }
        throw new ParsingException("Unknown input file type");
    }

    private ParserInterface getConcreteParser(File file) throws IOException {
        String name = file.getName();
        if (name.endsWith(EXTENSION_LL)) {
            return new ParserLlvm();
        }
        if (name.endsWith(EXTENSION_SPV_DIS)) {
                logger.warn(String.format("Extension %s is deprecated. Please rename your file to %s instead.", EXTENSION_SPV_DIS, EXTENSION_SPVASM));
            return new ParserSpirv();
        }
        if (name.endsWith(EXTENSION_SPVASM)) {
            return new ParserSpirv();
        }
        if (name.endsWith(EXTENSION_LITMUS)) {
            return getConcreteLitmusParser(readFirstLine(file).toUpperCase());
        }
        throw new ParsingException("Unknown input file type");
    }

    private ParserInterface getConcreteLitmusParser(String programText) {
        if (programText.indexOf(TYPE_LITMUS_AARCH64) == 0) {
            return new ParserLitmusAArch64();
        } else if (programText.indexOf(TYPE_LITMUS_C) == 0 || programText.indexOf(TYPE_LITMUS_OPENCL) == 0) {
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
        final int spaceIndex = programText.indexOf(" ");
        final String litmusFormat = (spaceIndex != -1) ? " " + programText.substring(0, spaceIndex) : "";
        throw new ParsingException("Unknown litmus format" + litmusFormat);
    }

    private String readFirstLine(File file) throws IOException {
        String line;
        try (BufferedReader bufferedReader = new BufferedReader(new FileReader(file))) {
            line = bufferedReader.readLine();
        }
        return line;
    }
}