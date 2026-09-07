package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.parsers.program.utils.Pipelines;
import com.dat3m.dartagnan.parsers.program.utils.Pipelines.Pipeline;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Utils;
import com.google.common.collect.ImmutableSet;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.nio.file.*;
import java.util.Set;

import static com.dat3m.dartagnan.GlobalSettings.getCompilationPipelinePath;

public class ProgramParser {

    private static final Logger logger = LoggerFactory.getLogger(ProgramParser.class);
    private final Pipelines pipelines;
    private final ImmutableSet<String> supportedExtensions;

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
        supportedExtensions = ImmutableSet.<String>builder()
                .addAll(NATIVE_EXTENSIONS)
                .addAll(pipelines.getSupportedExtensions())
                .build();
    }

    public ImmutableSet<String> getSupportedExtensions() {
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
            return getParser(extension).parse(sourceCode);
        } catch (RuntimeException exception) {
            // Wrap into ParsingException.
            throw exception instanceof ParsingException
                    ? exception
                    : new ParsingException(exception, exception.getMessage());
        }
    }

    // =========================== Private Utility =====================================

    private ParserInterface getParser(String extension) {
        return switch (extension) {
            case EXTENSION_LL -> new ParserLlvm();
            case EXTENSION_SPV_DIS -> {
                logger.warn("Extension {} is deprecated. Please rename your file to {} instead.", EXTENSION_SPV_DIS, EXTENSION_SPVASM);
                yield new ParserSpirv();
            }
            case EXTENSION_SPVASM -> new ParserSpirv();
            case EXTENSION_LITMUS -> new ParserLitmus();
            default -> throw new ParsingException("Unknown input file type");
        };
    }

    private static String getFileExtension(Path path) {
        return "." + Utils.getFileExtension(path);
    }

}
