package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.parsers.program.utils.Pipelines;
import com.dat3m.dartagnan.parsers.program.utils.Pipelines.Pipeline;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Utils;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.IntStream;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.nio.file.*;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.GlobalSettings.getCompilationPipelinePath;

public class ProgramParser {

    private static final Logger logger = LoggerFactory.getLogger(ProgramParser.class);
    private final Pipelines pipelines;
    private final Set<String> supportedExtensions;

    private static final String TYPE_LITMUS_AARCH64 = "AARCH64";
    private static final String TYPE_LITMUS_PPC = "PPC";
    private static final String TYPE_LITMUS_RISCV = "RISCV";
    private static final String TYPE_LITMUS_X86 = "X86";
    private static final String TYPE_LITMUS_PTX = "PTX";
    private static final String TYPE_LITMUS_VULKAN = "VULKAN";
    private static final String TYPE_LITMUS_C = "C";
    private static final String TYPE_LITMUS_OPENCL = "OPENCL";

    public static final String EXTENSION_LL = ".ll";
    public static final String EXTENSION_LITMUS = ".litmus";
    public static final String EXTENSION_SPV_DIS = ".spv.dis"; // Deprecated.
    public static final String EXTENSION_SPVASM = ".spvasm";
    public static final Set<String> NATIVE_EXTENSIONS = Set.of(
            EXTENSION_LL, EXTENSION_LITMUS, EXTENSION_SPV_DIS, EXTENSION_SPVASM
    );

    public ProgramParser() throws IOException {
        this(Pipelines.load(getCompilationPipelinePath()));
    }

    public ProgramParser(Pipelines pipelines) throws IOException {
        this.pipelines = pipelines;
        pipelines.validate(NATIVE_EXTENSIONS);
        supportedExtensions = Stream.concat(NATIVE_EXTENSIONS.stream(), pipelines.getSupportedExtensions().stream())
                .collect(Collectors.toUnmodifiableSet());
    }

    public Set<String> getSupportedExtensions() {
        return supportedExtensions;
    }

    public boolean isSupportedFile(Path filePath) {
        return supportedExtensions.contains(getFileExtension(filePath));
    }

    public Program parse(Path path) throws Exception {
        return parse(path, false);
    }

    public Program parseTemporary(Path path) throws Exception {
        return parse(path, true);
    }

    private Program parse(Path path, boolean removePipelineOutput) throws Exception {
        final String extension = getFileExtension(path);
        if (!pipelines.needsCompilation(extension)) {
            return parseFile(path);
        }

        final Pipeline pipeline = pipelines.getPipeline(extension, path, Utils.getNameWithoutExtension(path));
        try {
            pipeline.execute();
            return parseFile(Path.of(pipeline.output()));
        } finally {
            if (removePipelineOutput) {
                pipeline.removeOutputFile();
            }
        }
    }

    private Program parseFile(Path path) throws IOException {
        final Program program = parse(CharStreams.fromPath(path), getFileExtension(path));
        program.setName(path.getFileName().toString());
        return program;
    }

    private Program parse(CharStream sourceCode, String extension) {
        try {
            final ParserInterface parser = getParser(sourceCode, extension);
            return parser.parse(sourceCode);
        } catch (RuntimeException exception) {
            // Wrap into ParsingException.
            throw exception instanceof ParsingException
                    ? exception
                    : new ParsingException(exception, exception.getMessage());
        }
    }

    // =========================== Private Utility =====================================

    private ParserInterface getParser(CharStream sourceCode, String extension) {
        return switch (extension) {
            case EXTENSION_LL -> new ParserLlvm();
            case EXTENSION_SPV_DIS -> {
                logger.warn("Extension {} is deprecated. Please rename your file to {} instead.", EXTENSION_SPV_DIS, EXTENSION_SPVASM);
                yield new ParserSpirv();
            }
            case EXTENSION_SPVASM -> new ParserSpirv();
            case EXTENSION_LITMUS -> getParserForLitmus(sourceCode);
            default -> throw new ParsingException("Unknown input file type");
        };
    }

    private ParserInterface getParserForLitmus(CharStream sourceCode) {
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
