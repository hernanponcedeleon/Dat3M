package com.dat3m.dartagnan.parsers.program.utils;

import com.google.common.base.Charsets;
import com.google.common.io.Files;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;

import static com.dat3m.dartagnan.GlobalSettings.getOrCreateOutputDirectory;
import static java.util.Arrays.asList;

public class Compilation {

    private static final Logger logger = LogManager.getLogger(Compilation.class);

    public static File compileWithClang(File file, String cflags) throws Exception {
        final String outputFileName = getOutputName(file, ".ll");

        ArrayList<String> cmd = new ArrayList<>(
                asList("clang", "-Xclang", "-disable-O0-optnone", "-S",
                        "-emit-llvm", "-g", "-gcolumn-info", "-o", outputFileName));
        // We use cflags when using the UI and fallback top CFLAGS otherwise
        cflags = cflags.isEmpty() ? System.getenv().getOrDefault("CFLAGS", "") : cflags;
        // Needed to handle more than one flag in CFLAGS
        Collections.addAll(cmd, cflags.split(" "));
        cmd.add(file.getAbsolutePath());

        runCmd(cmd);
        return new File(outputFileName);
    }

    public static File applyLlvmPasses(File file) throws IOException {
        final String outputFileName = getOutputName(file, "-opt.ll");
        ArrayList<String> cmd = new ArrayList<>();
        cmd.add("opt");
        String replaceOptions = System.getenv().getOrDefault("OPTFLAGS", "");
        if (!replaceOptions.isEmpty()) {
            Collections.addAll(cmd, replaceOptions.split(" "));
        }
        cmd.add(file.getAbsolutePath());
        cmd.add("-S");
        cmd.add("-o");
        cmd.add(outputFileName);
        try {
            runCmd(cmd);
        } catch (Exception e) {
            logger.warn("Failed to run opt (llvm optimizations). Continuing without optimizations.");
            return file;
        }
        return new File(outputFileName);
    }

    private static String getOutputName(File file, String postfix) throws IOException {
        return getOrCreateOutputDirectory() + "/" +
                file.getName().substring(0, file.getName().lastIndexOf('.')) + postfix;
    }

    private static void runCmd(ArrayList<String> cmd) throws Exception {
        logger.debug(String.join(" ", cmd));
        ProcessBuilder processBuilder = new ProcessBuilder(cmd);
        // "Unless the standard input and output streams are promptly written and read respectively
        // of the sub process, it may block or deadlock the sub process."
        //		https://www.developer.com/design/understanding-java-process-and-java-processbuilder/
        // The lines below take care of this.
        File log = File.createTempFile("log", null);
        processBuilder.redirectErrorStream(true);
        processBuilder.redirectOutput(log);
        Process proc = processBuilder.start();
        proc.waitFor();
        if(proc.exitValue() != 0) {
            String errorString =  Files.asCharSource(log, Charsets.UTF_8).read();
            throw new IOException("'" + String.join("' '", cmd) + "': " + errorString);
        }
    }
}
