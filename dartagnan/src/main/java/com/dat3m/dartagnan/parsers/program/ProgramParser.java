package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Utils;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.IntStream;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.nio.file.*;
import java.util.List;

import static com.dat3m.dartagnan.parsers.program.utils.Compilation.compileWithClang;

public class ProgramParser {

    private static final Logger logger = LoggerFactory.getLogger(ProgramParser.class);

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

    public static boolean isSupported(Path filePath) {
        return SUPPORTED_EXTENSIONS.contains(getFileExtension(filePath));
    }

    // TODO: Change call-sites to use Path instead of File
    public Program parse(File file) throws Exception {
        return parse(file.toPath());
    }

    public Program parse(Path path) throws Exception {
        if (needsClang(getFileExtension(path))) {
            final String cflags = System.getenv().getOrDefault("CFLAGS", "");
            path = compileWithClang(path, cflags);
        }

        final Program program = parse(CharStreams.fromPath(path), getFileExtension(path));
        program.setName(path.getFileName().toString());
        return program;
    }

    public Program parse(String rawSourceCode, String extension, String cflags) throws Exception {
        final CharStream sourceCode;
        if (needsClang(extension)) {
            sourceCode = CharStreams.fromPath(compileWithClang(rawSourceCode, cflags));
            extension = EXTENSION_LL;
        } else {
            sourceCode = CharStreams.fromString(rawSourceCode, "raw_input" + extension);
        }

        final Program program = parse(sourceCode, extension);
        program.setName("raw_input" + extension);
        return program;
    }

    private Program parse(CharStream sourceCode, String extension) {
        final ParserInterface parser = switch (extension) {
            case EXTENSION_LL -> new ParserLlvm();
            case EXTENSION_SPV_DIS -> {
                logger.warn("Extension {} is deprecated. Please rename your file to {} instead.", EXTENSION_SPV_DIS, EXTENSION_SPVASM);
                yield new ParserSpirv();
            }
            case EXTENSION_SPVASM -> new ParserSpirv();
            case EXTENSION_LITMUS -> inferLitmusParserFromCode(sourceCode);
            default -> throw new ParsingException("Unknown input file type");
        };

        try {
            return parser.parse(sourceCode);
        } catch (RuntimeException exception) {
            // Wrap into ParsingException.
            throw exception instanceof ParsingException
                    ? exception
                    : new ParsingException(exception, exception.getMessage());
        }
    }

    private ParserInterface inferLitmusParserFromCode(CharStream sourceCode) {
        final String litmusType = getFirstWord(peekFirstLine(sourceCode));
        return switch (litmusType.toUpperCase()) {
            case TYPE_LITMUS_AARCH64 -> new ParserLitmusAArch64();
            case TYPE_LITMUS_PPC -> new ParserLitmusPPC();
            case TYPE_LITMUS_X86 -> new ParserLitmusX86();
            case TYPE_LITMUS_RISCV -> new ParserLitmusRISCV();
            case TYPE_LITMUS_PTX -> new ParserLitmusPTX();
            case TYPE_LITMUS_VULKAN -> new ParserLitmusVulkan();
            case TYPE_LITMUS_C, TYPE_LITMUS_OPENCL -> new ParserLitmusC();
            default -> throw new ParsingException("Unknown litmus format" + litmusType);
        };
    }

    private static String getFileExtension(Path path) {
        return "." + Utils.getFileExtension(path);
    }

    private static boolean needsClang(String ext) {
        return ext.equals(EXTENSION_C) || ext.equals(EXTENSION_I);
    }

    private static String getFirstWord(String string) {
        string = string.stripLeading();
        int endOfFirstWord = string.indexOf(" ");
        return endOfFirstWord == -1 ? string : string.substring(0, endOfFirstWord);
    }

    private static String peekFirstLine(CharStream input) {
        StringBuilder sb = new StringBuilder();
        for (int i = 1;; i++) {
            int c = input.LA(i);

            if (c == IntStream.EOF || c == '\n') {
                break;
            }

            if (c != '\r') {
                sb.append((char) c);
            }
        }
        return sb.toString();

    }
}