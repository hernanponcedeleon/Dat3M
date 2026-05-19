package com.dat3m.dartagnan;

import com.dat3m.dartagnan.configuration.OptionInfo;
import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Entrypoint;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.options.BaseOptions;
import com.dat3m.dartagnan.utils.printer.OutputLogger;
import com.dat3m.dartagnan.utils.printer.OutputLogger.ResultSummary;
import com.dat3m.dartagnan.verification.TaskResultAnalyzer;
import com.dat3m.dartagnan.verification.TaskSolver;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.VerificationTask.VerificationTaskBuilder;
import com.dat3m.dartagnan.wmm.Wmm;
import com.google.common.io.CharSource;
import org.apache.maven.model.io.xpp3.MavenXpp3Reader;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Options;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.configuration.OptionNames.TARGET;
import static com.dat3m.dartagnan.utils.ExitCode.NORMAL_TERMINATION;
import static com.dat3m.dartagnan.utils.GitInfo.*;

@Options
public class Dartagnan extends BaseOptions {

    private static final Logger logger = LoggerFactory.getLogger(Dartagnan.class);

    private Dartagnan(Configuration config) throws InvalidConfigurationException {
        config.recursiveInject(this);
    }

    public static void main(String[] args) throws Exception {

        initGitInfo();

        if (Arrays.asList(args).contains("--help")) {
            printOptions();
            return;
        } else if (Arrays.asList(args).contains("--version")) {
            printVersion();
            return;
        }

        logGitInfo();

        final Configuration config = loadConfigurationFromArgs(args);
        final Dartagnan o = new Dartagnan(config);

        final File catFile = getCatFileFromArgs(args);
        final List<File> progFiles = getProgramFilesFromArgs(args);
        final boolean isBatchMode = progFiles.size() > 1;

        final OutputLogger output = new OutputLogger(catFile, config);
        final TaskResultAnalyzer resultAnalyzer = TaskResultAnalyzer.create();
        ResultSummary summary = null;
        for (File progFile : progFiles) {
            try {
                // ----------- Generate verification task -----------
                final Program p = new ProgramParser().parse(progFile);
                if (o.overrideEntryFunction()) {
                    p.setEntrypoint(new Entrypoint.Simple(p.getFunctionByName(o.getEntryFunction()).orElseThrow(
                            () -> new MalformedProgramException(String.format("Program has no function named %s. Select a different entry point.", o.getEntryFunction())))));
                }
                final Wmm mcm = new ParserCat(Path.of(o.getCatIncludePath())).parse(catFile);
                final VerificationTaskBuilder builder = VerificationTask.builder()
                        .withConfig(config)
                        .withProgressModel(o.getProgressModel());
                // If the arch has been set during parsing (this only happens for litmus tests)
                // and the user did not explicitly add the target option, we use the one
                // obtained during parsing.
                if (p.getArch() != null && !config.hasProperty(TARGET)) {
                    builder.withTarget(p.getArch());
                }
                final VerificationTask task = builder.build(p, mcm, o.getProperty());

                // ----------- Solve task ----------
                final TaskSolver taskSolver = TaskSolver.create(task);
                taskSolver.run();

                // ----------- Generate output-----------
                summary = resultAnalyzer.getSummaryFromSolver(taskSolver, progFile.getPath());
            } catch (Exception e) {
                summary = resultAnalyzer.getSummaryFromException(e, progFile.getPath());
            }
            output.addResult(summary);
        }

        output.toStdOut();
        // Running batch mode results in normal termination independent of the individual results
        System.exit((isBatchMode ? NORMAL_TERMINATION : summary.code()).asInt());
    }

    // ----------------------------------------------------------------------------------------------------

    public static void printOptions() {
        OptionInfo.stream().sorted().forEach(System.out::print);
    }

    private static void printVersion() throws Exception {
        final MavenXpp3Reader mvnReader = new MavenXpp3Reader();
        final FileReader fileReader = new FileReader(System.getenv("DAT3M_HOME") + "/pom.xml");
        final String base = mvnReader.read(fileReader).getVersion();
        final String version = base.equals(getGitTags()) ? base : String.format("%s (commit %s)", base, getGitId());

        System.out.println(version);
    }

    private static Configuration loadConfigurationFromArgs(String[] args) throws InvalidConfigurationException, IOException {
        final var preamble = new StringBuilder();
        final var options = new StringBuilder();
        for (String argument : args) {
            if (argument.startsWith("--")) {
                options.append(argument.substring("--".length())).append("\n");
            } else if (argument.endsWith(".properties")) {
                preamble.append("#include ").append(argument).append("\n");
            }
        }
        final CharSource source = CharSource.concat(CharSource.wrap(preamble), CharSource.wrap(options));
        return Configuration.builder()
                .addConverter(ProgressModel.Hierarchy.class, ProgressModel.HIERARCHY_CONVERTER)
                .loadFromSource(source, ".", ".")
                .build();
    }

    private static File getCatFileFromArgs(String[] args) {
        File catFile = Arrays.stream(args)
                .filter(a -> a.endsWith(".cat"))
                .findFirst()
                .map(File::new)
                .orElseThrow(() -> new IllegalArgumentException("CAT model not given or format not recognized"));
        logger.info("CAT file path: {}", catFile);
        return catFile;
    }

    private static List<File> getProgramFilesFromArgs(String[] args) {
        final List<File> files = new ArrayList<>();
        Stream.of(args).map(Paths::get).filter(Files::exists)
                .forEach(path -> {
                    List<File> supported = getProgramFiles(path);
                    if (!supported.isEmpty()) {
                        logger.info("Program(s) path: {}", path.normalize());
                        files.addAll(supported);
                    }
                });
        if (files.isEmpty()) {
            throw new IllegalArgumentException("Path to input program(s) not given or format not recognized");
        }
        return files;
    }

    private static List<File> getProgramFiles(Path path) {
        try (Stream<Path> stream = Files.walk(path)) {
            return stream.filter(Files::isRegularFile)
                    .filter(ProgramParser::isSupported)
                    .sorted(Comparator.comparing(Path::toString))
                    .map(Path::toFile)
                    .toList();
        } catch (IOException e) {
            logger.error("There was an I/O error when accessing path {}", path);
            return List.of();
        }
    }
}
