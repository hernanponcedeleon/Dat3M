package com.dat3m.dartagnan;

import com.dat3m.dartagnan.configuration.OptionInfo;
import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.parsers.program.utils.Pipelines;
import com.dat3m.dartagnan.program.Entrypoint;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.ExitCode;
import com.dat3m.dartagnan.verification.TaskSolver;
import com.dat3m.dartagnan.verification.Task;
import com.dat3m.dartagnan.verification.Task.TaskBuilder;
import com.dat3m.dartagnan.wmm.Wmm;
import com.google.common.io.CharSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.NoSuchFileException;
import java.nio.file.Path;
import java.util.*;
import java.util.function.Predicate;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.utils.ExitCode.NORMAL_TERMINATION;
import static com.dat3m.dartagnan.utils.EnvironmentInfo.*;
import static com.dat3m.dartagnan.utils.Utils.getFileExtension;

public class Dartagnan {

    private static final Logger logger = LoggerFactory.getLogger(Dartagnan.class);

    public static void main(String[] args) throws Exception {

        // Enable custom exception handler to generate consistent exit code for errors
        Thread.currentThread().setUncaughtExceptionHandler((t, ex) -> {
            final Output output = OutputGenerator.getOutputFromException(ex);
            System.err.println(output.summary());
            exit(output.exitCode());
        });

        initEnvironmentInfo();

        if (Arrays.asList(args).contains("--help")) {
            printOptions();
            return;
        } else if (Arrays.asList(args).contains("--version")) {
            printVersion();
            return;
        }

        final Configuration config = loadConfigurationFromArgs(args);
        final DartagnanOptions o = new DartagnanOptions(config);
        final Pipelines pipelines = Pipelines.load(o.getCompilationPipelinePath());
        final ProgramParser programParser = new ProgramParser(pipelines);
        final Path catFile  = getCatFileFromArgs(args);
        final List<Path> progFiles = getProgramFilesFromArgs(args, programParser::isSupportedFile);
        final boolean isBatchMode = progFiles.size() > 1;
        final OutputGenerator outputGenerator = OutputGenerator.create(isBatchMode, config);

        final Set<String> neededTools = progFiles.stream()
                .map(file -> "." + getFileExtension(file))
                .distinct()
                .flatMap(extension -> pipelines.getTools(extension).stream())
                .collect(Collectors.toSet());
        logEnvironmentInfo(neededTools);

        logger.info("CAT file path: {}", catFile);

        final List<Output> outputs = new ArrayList<>();
        for (Path progFile : progFiles) {
            logger.info("Program path: {}", progFile.normalize());
            Output output;
            try {
                // ----------- Generate verification task -----------
                final Program p = programParser.parse(progFile);
                if (o.overrideEntryFunction()) {
                    p.setEntrypoint(new Entrypoint.Simple(p.getFunctionByName(o.getEntryFunction()).orElseThrow(
                            () -> new MalformedProgramException(String.format("Program has no function named %s. Select a different entry point.", o.getEntryFunction())))));
                }
                final Wmm mcm = new ParserCat(o.getCatIncludePath()).parse(catFile);
                final TaskBuilder builder = Task.builder()
                        .withConfig(config)
                        .withProgressModel(o.getProgressModel());
                // If the arch has been set during parsing (this only happens for litmus tests)
                // and the user did not explicitly add the target option, we use the one
                // obtained during parsing.
                if (p.getArch() != null && !config.hasProperty(TARGET)) {
                    builder.withTarget(p.getArch());
                }
                final Task task = builder.build(p, mcm, o.getProperty());

                // ----------- Solve task ----------
                final TaskSolver taskSolver = TaskSolver.create(task);
                taskSolver.run();

                // ----------- Generate output-----------
                output = outputGenerator.getOutputFromSolver(taskSolver);
            } catch (Exception e) {
                output = OutputGenerator.getOutputFromException(e, progFile.toString());
            }
            outputs.add(output);
        }

        printOutputs(outputs, catFile, config);
        // Running batch mode results in normal termination independent of the individual results
        final ExitCode exitCode = isBatchMode ? NORMAL_TERMINATION : outputs.get(0).exitCode();
        exit(exitCode);
    }

    // ----------------------------------------------------------------------------------------------------

    public static void exit(ExitCode exitCode) {
        System.exit(exitCode.asInt());
    }

    public static void printOptions() {
        OptionInfo.stream().sorted().forEach(System.out::print);
    }

    private static void printVersion() {
        System.out.println(getVersion());
    }

    private static void printOutputs(List<Output> outputs, Path catFile, Configuration config) {
        if (outputs.isEmpty()) {
            return;
        }

        if (outputs.size() == 1) {
            System.out.println(outputs.get(0));
        } else {
            System.out.println("================ Configuration ==================");
            System.out.println("cat = " + catFile);
            System.out.print(config.asPropertiesString()); // it already contains its own \n
            System.out.println("=================================================");
            for (Output output : outputs) {
                System.out.println();
                System.out.println(output);
            }
        }
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

    private static Path getCatFileFromArgs(String[] args) throws IOException {
        final Path catFile = Arrays.stream(args)
                .filter(a -> a.endsWith(".cat"))
                .findFirst()
                .map(Path::of)
                .orElseThrow(() -> new IOException("CAT model not given or format not recognized"));
        if (!Files.exists(catFile)) {
            throw new NoSuchFileException("CAT file %s does not exist".formatted(catFile));
        }
        return catFile;
    }

    private static List<Path> getProgramFilesFromArgs(String[] args, Predicate<Path> isSupportedFile) throws IOException {
        final List<Path> files = Stream.of(args)
                .map(Path::of)
                .filter(Files::exists)
                .flatMap(path -> getProgramFiles(path, isSupportedFile).stream())
                .toList();
        if (files.isEmpty()) {
            throw new IOException("Path to input program(s) not given or format not recognized");
        }
        return files;
    }

    private static List<Path> getProgramFiles(Path path, Predicate<Path> isSupportedFile) {
        try (Stream<Path> stream = Files.walk(path)) {
            return stream.filter(Files::isRegularFile)
                    .filter(isSupportedFile)
                    .sorted(Comparator.comparing(Path::toString))
                    .toList();
        } catch (IOException e) {
            logger.error("There was an I/O error when accessing path {}", path);
            return List.of();
        }
    }

    // ========================================== Options ==========================================

    @Options
    public static class DartagnanOptions {

        public DartagnanOptions(Configuration config) throws InvalidConfigurationException {
            config.inject(this, DartagnanOptions.class);
        }

        @Option(
                name = PROPERTY,
                description = "A combination of properties to check for: program_spec, termination, cat_spec (defaults to all).",
                toUppercase = true)
        private EnumSet<Property> property = Property.getDefault();

        public EnumSet<Property> getProperty() {
            return property;
        }

        @Option(
                name = PROGRESSMODEL,
                description = """
                            The progress model to assume: fair (default), hsa, obe, unfair.
                            To specify progress models per scope, use [<scope>=<progressModel>,...].
                            Defaults to "fair" for unspecified scopes unless "default=<progressModel>" is specified.
                            """,
                toUppercase = true)
        private ProgressModel.Hierarchy progressModel = ProgressModel.defaultHierarchy();

        public ProgressModel.Hierarchy getProgressModel() {
            return this.progressModel;
        }

        @Option(
                name = CAT_INCLUDE,
                description = "The directory used to resolve cat include statements. Defaults to $DAT3M_HOME/cat."
        )
        private String catIncludePath = GlobalSettings.getCatDirectory().toString();

        public Path getCatIncludePath() {
            return Path.of(catIncludePath);
        }

        @Option(
                name = ENTRY,
                description = "Name of the entry point function."
        )
        private String entryFunction = "";

        public String getEntryFunction() {
            return entryFunction;
        }

        public boolean overrideEntryFunction() {
            return !entryFunction.isEmpty();
        }

        @Option(
                name = COMPILATION_PIPELINE,
                description = "Path to the yaml file defining the compilation pipeline."
        )
        private String compilationPipelinePath = GlobalSettings.getCompilationPipelinePath().toString();

        public Path getCompilationPipelinePath() {
            return Path.of(compilationPipelinePath);
        }
    }

}
