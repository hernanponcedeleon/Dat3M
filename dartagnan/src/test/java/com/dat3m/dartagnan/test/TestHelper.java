package com.dat3m.dartagnan.test;

import java.io.IOException;
import java.nio.file.Path;
import java.util.List;
import java.util.ArrayList;
import java.util.Arrays;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.wmm.Wmm;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static com.dat3m.dartagnan.GlobalSettings.getExecutablePath;

public class TestHelper {

    private static final Logger logger = LoggerFactory.getLogger(TestHelper.class);

    public static final String EXTENSION_LITMUS = ProgramParser.EXTENSION_LITMUS;
    public static final String EXTENSION_LL = ProgramParser.EXTENSION_LL;
    public static final String EXTENSION_SPVASM = ProgramParser.EXTENSION_SPVASM;
    public static final String EXTENSION_SPV_DIS = ProgramParser.EXTENSION_SPV_DIS;

    private TestHelper() {
    }

    public static Program parseProgram(Path path) throws Exception {
        return new ProgramParser().parse(path);
    }

    public static Wmm parseWmm(Path path) throws IOException {
        return new ParserCat().parse(path);
    }

    public static void runDartagnanApplication(Path programPath, Path catPath, String... options) throws Exception {
        final Path dat3mJar = getExecutablePath(true);
        final List<String> command = new ArrayList<>();
        command.add("java");
        command.add("-jar");
        command.add(dat3mJar.toAbsolutePath().toString());
        command.add(catPath.toAbsolutePath().toString());
        command.add(programPath.toAbsolutePath().toString());
        command.addAll(Arrays.asList(options));
        final ProcessBuilder pb = new ProcessBuilder(command);
        try (Process process = pb.start()) {
            final int exitCode = process.waitFor();
            if (exitCode != 0) {
                final String error = new String(process.getErrorStream().readAllBytes());
                logger.warn("Dartagnan finished with exit code {}. Error: {}", exitCode, error);
            }
        }
    }

}
