package com.dat3m.dartagnan.parsers.program.utils;

import com.dat3m.dartagnan.utils.Utils;
import com.google.common.base.Charsets;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

import static com.dat3m.dartagnan.GlobalSettings.getOrCreateOutputDirectory;
import static com.dat3m.dartagnan.GlobalSettings.getIncludeDirectory;
import static java.util.Arrays.asList;

public class Compilation {

    private static final Logger logger = LoggerFactory.getLogger(Compilation.class);

    public static Path compileWithClang(String rawCSource, String cflags) throws Exception {
        final Path tempFilePath = Files.createTempFile("dat3m", ".c");
        Files.writeString(tempFilePath, rawCSource);

        final Path outputFile = compileWithClang(tempFilePath, cflags);
        Files.delete(tempFilePath);
        return outputFile;
    }

    public static Path compileWithClang(Path sourceFile, String cflags) throws Exception {
        final String outputFileName = getOutputName(sourceFile, ".ll");

        final List<String> clangCmd = new ArrayList<>(List.of(
                "clang",
                "-I", getIncludeDirectory().toString(),
                "-Xclang", "-disable-O0-optnone", "-S", "-emit-llvm", "-g", "-gcolumn-info",
                "-o", outputFileName
        ));
        clangCmd.addAll(asList(cflags.split(" ")));
        clangCmd.add(sourceFile.toAbsolutePath().toString());

        runCmd(clangCmd);
        return Path.of(outputFileName);
    }

    private static String getOutputName(Path path, String postfix) throws IOException {
        return getOrCreateOutputDirectory()
                .resolve(Utils.getNameWithoutExtension(path) + postfix)
                .toString();

    }

    private static void runCmd(List<String> cmd) throws Exception {
        logger.debug(String.join(" ", cmd));
        // "Unless the standard input and output streams are promptly written and read respectively
        // of the sub process, it may block or deadlock the sub process."
        //      https://www.developer.com/design/understanding-java-process-and-java-processbuilder/
        // The lines below take care of this.
        final Path log = Files.createTempFile("log", null);
        final ProcessBuilder processBuilder = new ProcessBuilder(cmd);
        processBuilder.redirectErrorStream(true);
        processBuilder.redirectOutput(log.toFile());

        final Process proc = processBuilder.start();
        if (proc.waitFor() != 0) {
            final String logString = Files.readString(log, Charsets.UTF_8);
            final String errorMsg = "'%s': %s".formatted(String.join("' '", cmd), logString);
            throw new IOException(errorMsg);
        }
    }
}
