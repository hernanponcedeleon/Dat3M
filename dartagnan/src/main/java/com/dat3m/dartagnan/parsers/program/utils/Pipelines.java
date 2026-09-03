package com.dat3m.dartagnan.parsers.program.utils;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.exc.ValueInstantiationException;
import com.google.common.base.Preconditions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.yaml.snakeyaml.Yaml;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.GlobalSettings.getHomeDirectory;
import static com.dat3m.dartagnan.GlobalSettings.getOutputDirectory;
import static com.fasterxml.jackson.databind.DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES;

public record Pipelines(String workdir, List<Pipeline> pipelines) {

    public Pipelines {
        Preconditions.checkNotNull(workdir, "Missing workdir in the pipeline configuration file");
        Preconditions.checkNotNull(pipelines, "Missing pipelines in the pipeline configuration file");
        pipelines = List.copyOf(pipelines);
        final Set<String> extensions = new HashSet<>();
        for (Pipeline pipeline : pipelines) {
            if (!extensions.add(pipeline.pipeline())) {
                throw new IllegalArgumentException("Duplicate pipeline for file extension: " + pipeline.pipeline());
            }
        }
    }

    public static Pipelines load(Path yamlPath) throws IOException {
        try (InputStream inputStream = Files.newInputStream(yamlPath)) {
            final String rawData = new String(inputStream.readAllBytes(), StandardCharsets.UTF_8)
                    .replace("$DAT3M_HOME", getHomeDirectory().toString())
                    .replace("$DAT3M_OUTPUT", getOutputDirectory().toString());
            final ObjectMapper mapper = new ObjectMapper();
            mapper.configure(FAIL_ON_UNKNOWN_PROPERTIES, false);
            return mapper.convertValue(new Yaml().load(rawData), Pipelines.class);
        } catch (IllegalArgumentException e) {
            if (e.getCause() instanceof ValueInstantiationException valueInstantiationException) {
                throw invalidConfiguration(valueInstantiationException);
            }
            throw e;
        }
    }

    public boolean needsCompilation(String extension) {
        return pipelines.stream().anyMatch(pipeline -> extension.equals(pipeline.pipeline()));
    }

    public Set<String> getTools() {
        return pipelines.stream()
                .flatMap(pipeline -> pipeline.commands().stream())
                .map(Pipeline.Command::tool)
                .collect(Collectors.toUnmodifiableSet());
    }

    public Pipeline getPipeline(String extension, Path inputPath, String basename) {
        final Pipeline abstractPipeline = pipelines.stream()
                .filter(p -> extension.equals(p.pipeline()))
                .findFirst()
                .orElseThrow(() -> new UnsupportedOperationException("Compilation pipeline not found for file extension: " + extension));

        final List<Pipeline.Command> concreteSteps = new ArrayList<>();
        for (Pipeline.Command cmd : abstractPipeline.commands()) {
            final String commandInput = substitutePipelineTokens(cmd.input(), inputPath, basename);
            final String commandOutput = substitutePipelineTokens(cmd.output(), inputPath, basename);
            final String concreteInput = cmd.read_from_workdir()
                    ? Path.of(workdir, commandInput).toString()
                    : inputPath.toString();
            final String concreteOutput = Path.of(workdir, commandOutput).toString();
            final List<String> concreteArgs = cmd.args().stream()
                    .map(arg -> substitutePipelineTokens(arg, inputPath, basename))
                    .map(arg -> substituteCommandTokens(arg, concreteInput, concreteOutput))
                    .toList();

            concreteSteps.add(new Pipeline.Command(
                    cmd.name(),
                    cmd.tool(),
                    concreteInput,
                    concreteOutput,
                    cmd.read_from_workdir(),
                    concreteArgs
            ));
        }

        return new Pipeline(
                abstractPipeline.pipeline(),
                Path.of(workdir, substitutePipelineTokens(abstractPipeline.input(), inputPath, basename)).toString(),
                Path.of(workdir, substitutePipelineTokens(abstractPipeline.output(), inputPath, basename)).toString(),
                concreteSteps
        );
    }

    private static IOException invalidConfiguration(ValueInstantiationException exception) {
        final Throwable cause = exception.getCause();
        final String message = cause != null && cause.getMessage() != null
                ? cause.getMessage()
                : exception.getOriginalMessage();
        return new IOException(message, exception);
    }

    private static String substitutePipelineTokens(String value, Path input, String basename) {
        return value.replace("{pipeline_input}", input.toString())
                .replace("{basename}", basename);
    }

    private static String substituteCommandTokens(String arg, String input, String output) {
        return arg.replace("{cmd_input}", input)
                .replace("{cmd_output}", output);
    }

    public record Pipeline(String pipeline, String input, String output, List<Command> commands) {

        public Pipeline {
            Preconditions.checkNotNull(pipeline, "Missing pipeline extension in the pipeline configuration file");
            Preconditions.checkNotNull(input, "Missing pipeline input for extension '%s'", pipeline);
            Preconditions.checkNotNull(output, "Missing pipeline output for extension '%s'", pipeline);
            Preconditions.checkNotNull(commands, "Missing pipeline commands for extension '%s'", pipeline);
            commands = List.copyOf(commands);
        }

        private static final Logger logger = LoggerFactory.getLogger(Pipeline.class);

        public void execute() throws Exception {
            final Path outputDirectory = Path.of(output).getParent();
            if (outputDirectory != null) {
                // Make sure parent directory exists.
                Files.createDirectories(outputDirectory);
            }
            try {
                for (Command cmd : commands) {
                    runCmd(Stream.concat(Stream.of(cmd.tool()), cmd.args().stream()).toList());
                }
            } finally {
                removeIntermediateFiles();
            }
        }

        public void removeIntermediateFiles() {
            final Set<Path> generatedFiles = commands.stream()
                    .map(Command::output)
                    .map(Path::of)
                    .filter(file -> !file.equals(Path.of(output)))
                    .collect(Collectors.toSet());

            for (Path file : generatedFiles) {
                try {
                    Files.deleteIfExists(file);
                } catch (IOException exception) {
                    logger.warn("Could not remove generated pipeline file {}", file, exception);
                }
            }
        }

        private void runCmd(List<String> cmd) throws Exception {
            logger.debug(String.join(" ", cmd));
            final Path log = Files.createTempFile("log", null);
            try {
                final ProcessBuilder processBuilder = new ProcessBuilder(cmd);
                processBuilder.redirectErrorStream(true);
                processBuilder.redirectOutput(log.toFile());

                final Process proc = processBuilder.start();
                if (proc.waitFor() != 0) {
                    final String logString = Files.readString(log, StandardCharsets.UTF_8);
                    final String errorMsg = "'%s': %s".formatted(String.join(" ", cmd), logString);
                    throw new IOException(errorMsg);
                }
            } finally {
                try {
                    Files.deleteIfExists(log);
                } catch (IOException exception) {
                    logger.warn("Could not remove pipeline log {}", log, exception);
                }
            }
        }

        public record Command(String name, String tool, String input, String output, Boolean read_from_workdir, List<String> args) {
            public Command {
                Preconditions.checkNotNull(name, "Missing name for step in the pipeline configuration file");
                Preconditions.checkNotNull(tool, "Entry tool for step '%s' is mandatory in the pipeline configuration file", name);
                Preconditions.checkNotNull(input, "Entry input for step '%s' is mandatory in the pipeline configuration file", name);
                Preconditions.checkNotNull(output, "Entry output for step '%s' is mandatory in the pipeline configuration file", name);
                Preconditions.checkNotNull(read_from_workdir, "Entry read_from_workdir for step '%s' is mandatory in the pipeline configuration file", name);
                Preconditions.checkNotNull(args, "Entry args for step '%s' is mandatory in the pipeline configuration file", name);
                args = List.copyOf(args);
            }
        }
    }
}
