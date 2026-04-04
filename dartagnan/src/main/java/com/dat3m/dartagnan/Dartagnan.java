package com.dat3m.dartagnan;

import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.parsers.witness.ParserWitness;
import com.dat3m.dartagnan.program.Entrypoint;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.options.BaseOptions;
import com.dat3m.dartagnan.utils.printer.OutputLogger;
import com.dat3m.dartagnan.utils.printer.OutputLogger.ResultSummary;
import com.dat3m.dartagnan.verification.TaskResultAnalyzer;
import com.dat3m.dartagnan.verification.TaskSolver;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.VerificationTask.VerificationTaskBuilder;
import com.dat3m.dartagnan.witness.graphml.WitnessGraph;
import com.dat3m.dartagnan.wmm.Wmm;
import com.google.common.collect.ImmutableSet;
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
import java.util.*;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.configuration.OptionInfo.collectOptions;
import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.utils.ExitCode.*;
import static com.dat3m.dartagnan.utils.GitInfo.*;
import static com.dat3m.dartagnan.witness.graphviz.ExecutionGraphVisualizer.generateGraphvizFile;

@Options
public class Dartagnan extends BaseOptions {

    private static final Logger logger = LoggerFactory.getLogger(Dartagnan.class);

    private static final Set<String> supportedFormats = ImmutableSet.copyOf(ProgramParser.SUPPORTED_EXTENSIONS);

    private Dartagnan(Configuration config) throws InvalidConfigurationException {
        config.recursiveInject(this);
    }

    private static Configuration loadConfiguration(String[] args) throws InvalidConfigurationException, IOException {
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


    public static void main(String[] args) throws Exception {

        initGitInfo();

        if (Arrays.asList(args).contains("--help")) {
            collectOptions();
            return;
        }

        if (Arrays.asList(args).contains("--version")) {
            final MavenXpp3Reader mvnReader = new MavenXpp3Reader();
            final FileReader fileReader = new FileReader(System.getenv("DAT3M_HOME") + "/pom.xml");
            final String base = mvnReader.read(fileReader).getVersion();
            final String version = base.equals(getGitTags()) ? base : String.format("%s (commit %s)", base, getGitId());
            System.out.println(version);
            return;
        }

        logGitInfo();

        final Configuration config = loadConfiguration(args);
        final Dartagnan o = new Dartagnan(config);

        final File wmmFile = new File(Arrays.stream(args).filter(a -> a.endsWith(".cat")).findFirst()
                .orElseThrow(() -> new IllegalArgumentException("CAT model not given or format not recognized")));
        logger.info("CAT file path: {}", wmmFile);
        final OutputLogger output = new OutputLogger(wmmFile, config);

        final WitnessGraph witness;
        if (o.runValidator()) {
            logger.info("Witness path: {}", o.getWitnessPath());
            witness = new ParserWitness().parse(new File(o.getWitnessPath()));
        } else {
            witness = new WitnessGraph();
        }

        ResultSummary summary = null;
        final List<File> files = getProgramFilesFromArgs(args);
        final TaskResultAnalyzer resultAnalyzer = TaskResultAnalyzer.create();
        for (File f : files) {
            final String progFilePath = f.getPath();
            try {
                // ----------- Generate verification task -----------
                final Program p = new ProgramParser().parse(f);
                if (o.overrideEntryFunction()) {
                    p.setEntrypoint(new Entrypoint.Simple(p.getFunctionByName(o.getEntryFunction()).orElseThrow(
                            () -> new MalformedProgramException(String.format("Program has no function named %s. Select a different entry point.", o.getEntryFunction())))));
                }
                final Wmm mcm = new ParserCat(Path.of(o.getCatIncludePath())).parse(wmmFile);
                final VerificationTaskBuilder builder = VerificationTask.builder()
                        .withConfig(config)
                        .withProgressModel(o.getProgressModel())
                        .withWitness(witness);
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
                summary = resultAnalyzer.getSummaryFromSolver(taskSolver, f.getPath());
                // We only generate witnesses if we are not validating one.
                if (!o.runValidator()) {
                    final String progName = task.getProgram().getName();
                    final int fileSuffixIndex = progName.lastIndexOf('.');
                    final String filename = o.hasWitnessFilename() ?
                            o.getWitnessFilename() :
                            progName.isEmpty() ?
                                    "unnamed_program" :
                                    (fileSuffixIndex == -1) ? progName : progName.substring(0, fileSuffixIndex);

                    resultAnalyzer.generateWitnessIfAble(taskSolver, o.getWitnessType(), filename, summary.reason() + "\n" + summary.details(), o.generateWitnessForUnknown());
                }
            } catch (Exception e) {
                summary = resultAnalyzer.getSummaryFromException(e, progFilePath);
            }
            output.addResult(summary);
        }
        output.toStdOut(files.size() > 1);
        // Running batch mode results in normal termination independent of the individual results
        System.exit((files.size() > 1 ? NORMAL_TERMINATION : summary.code()).asInt());
    }

    private static List<File> getProgramFilesFromArgs(String[] args) {
        final List<File> files = new ArrayList<>();
        Stream.of(args)
            .map(File::new)
            .forEach(file -> {
                if (file.exists()) {
                    final String path = file.getAbsolutePath();
                    if (file.isDirectory()) {
                        logger.info("Programs path: {}", path);
                        files.addAll(getProgramFiles(path));
                    } else if (file.isFile() && supportedFormats.stream().anyMatch(file.getName()::endsWith)) {
                        logger.info("Program path: {}", path);
                        files.add(file);
                    }
                }
            });
        if (files.isEmpty()) {
            throw new IllegalArgumentException("Path to input program(s) not given or format not recognized");
        }
        return files;
    }

    private static List<File> getProgramFiles(String dirPath) {
        List<File> files = new ArrayList<>();
        try (Stream<Path> stream = Files.walk(Paths.get(dirPath))) {
            files = stream.filter(Files::isRegularFile)
                .filter(p -> supportedFormats.stream().anyMatch(p.toString()::endsWith))
                .map(Path::toFile)
                .sorted(Comparator.comparing(File::toString))
                .toList();
        } catch (IOException e) {
            logger.error("There was an I/O error when accessing path {}", dirPath);
            System.exit(UNKNOWN_ERROR.asInt());
        }
        return files;
    }


}
