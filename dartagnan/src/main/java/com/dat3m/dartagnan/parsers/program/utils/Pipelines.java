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
        Preconditions.checkNotNull(workdir, "Missing workdir in the compilation pipeline configuration file");
        Preconditions.checkNotNull(pipelines, "Missing compilation pipelines in the configuration file");
        pipelines = List.copyOf(pipelines);
        final Set<String> extensions = new HashSet<>();
        for (Pipeline pipeline : pipelines) {
            for (String extension : pipeline.extensions()) {
                if (!extensions.add(extension)) {
                    throw new IllegalArgumentException("Duplicate compilation pipeline for file extension: " + extension);
                }
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
        return pipelines.stream().anyMatch(pipeline -> pipeline.matches(extension));
    }

    public Set<String> getTools() {
        return pipelines.stream()
                .flatMap(pipeline -> pipeline.commands().stream())
                .map(Pipeline.Command::tool)
                .collect(Collectors.toUnmodifiableSet());
    }

    public List<String> getSupportedExtensions() {
        return pipelines.stream()
                .flatMap(pipeline -> pipeline.extensions().stream())
                .toList();
    }

    public void validate(Set<String> supportedExtensions) throws IOException {
        for (Pipeline pipeline : pipelines) {
            if (pipeline.commands().isEmpty()) {
                throw new IOException("Compilation pipeline for '%s' has no commands".formatted(pipeline.pipeline()));
            }
            if (supportedExtensions.stream().noneMatch(pipeline.output()::endsWith)) {
                throw new IOException("Compilation pipeline for '%s' generates '%s', which is not a natively supported format"
                        .formatted(pipeline.pipeline(), pipeline.output()));
            }
            if (!pipeline.commands().get(pipeline.commands().size() - 1).output().equals(pipeline.output())) {
                throw new IOException("Final command of compilation pipeline for '%s' does not generate its declared output '%s'"
                        .formatted(pipeline.pipeline(), pipeline.output()));
            }
        }
    }

    public Pipeline getPipeline(String extension, Path inputPath, String basename) {
        final Pipeline abstractPipeline = pipelines.stream()
                .filter(p -> p.matches(extension))
                .findFirst()
                .orElseThrow(() -> new UnsupportedOperationException("Compilation pipeline not found for file extension: " + extension));

        final List<Pipeline.Command> concreteSteps = new ArrayList<>();
        for (Pipeline.Command cmd : abstractPipeline.commands()) {
            final String concreteInput = resolveInput(cmd.input(), inputPath, basename).toString();
            final String concreteOutput = resolveWorkdirPath(cmd.output(), inputPath, basename).toString();
            final List<String> concreteArgs = cmd.args().stream()
                    .map(arg -> substitutePipelineTokens(arg, inputPath, basename))
                    .map(arg -> substituteCommandTokens(arg, concreteInput, concreteOutput))
                    .toList();

            concreteSteps.add(new Pipeline.Command(
                    cmd.name(),
                    cmd.tool(),
                    concreteInput,
                    concreteOutput,
                    concreteArgs
            ));
        }

        return new Pipeline(
                abstractPipeline.pipeline(),
                abstractPipeline.aliases(),
                resolveWorkdirPath(abstractPipeline.output(), inputPath, basename).toString(),
                concreteSteps
        );
    }

    private Path resolveInput(String input, Path pipelineInput, String basename) {
        return input.equals("{pipeline_input}")
                ? pipelineInput
                : resolveWorkdirPath(input, pipelineInput, basename);
    }

    private Path resolveWorkdirPath(String path, Path pipelineInput, String basename) {
        final Path resolvedPath = Path.of(substitutePipelineTokens(path, pipelineInput, basename));
        return resolvedPath.isAbsolute() ? resolvedPath : Path.of(workdir).resolve(resolvedPath);
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

    public record Pipeline(String pipeline, List<String> aliases, String output, List<Command> commands) {

        public Pipeline {
                Preconditions.checkNotNull(pipeline, "Missing compilation pipeline extension in the configuration file");
                Preconditions.checkNotNull(output, "Missing compilation pipeline output for extension '%s'", pipeline);
                Preconditions.checkNotNull(commands, "Missing compilation pipeline commands for extension '%s'", pipeline);
            aliases = aliases == null ? List.of() : List.copyOf(aliases);
            commands = List.copyOf(commands);
        }

        public List<String> extensions() {
            return Stream.concat(Stream.of(pipeline), aliases.stream()).toList();
        }

        public boolean matches(String extension) {
            return extensions().contains(extension);
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
                    logger.warn("Could not remove file generated by compilation pipeline {}", file, exception);
                }
            }
        }

        public void removeOutputFile() {
            final Path outputFile = Path.of(output);
            try {
                Files.deleteIfExists(outputFile);
            } catch (IOException exception) {
                logger.warn("Could not remove compilation pipeline output {}", outputFile, exception);
            }
        }

        private void runCmd(List<String> cmd) throws Exception {
            logger.debug(String.join(" ", cmd));
            final Path log = Files.createTempFile("log", null);
            try {
                final ProcessBuilder processBuilder = new ProcessBuilder(cmd);
                processBuilder.redirectErrorStream(true);
                processBuilder.redirectOutput(log.toFile());

                final Process process = processBuilder.start();
                try {
                    if (process.waitFor() != 0) {
                        final String logString = Files.readString(log, StandardCharsets.UTF_8);
                        final String errorMsg = "'%s': %s".formatted(String.join(" ", cmd), logString);
                        throw new IOException(errorMsg);
                    }
                } catch (InterruptedException exception) {
                    process.destroyForcibly();
                    Thread.currentThread().interrupt();
                    throw exception;
                }
            } finally {
                try {
                    Files.deleteIfExists(log);
                } catch (IOException exception) {
                    logger.warn("Could not remove compilation pipeline log {}", log, exception);
                }
            }
        }

        public record Command(String name, String tool, String input, String output, List<String> args) {
            public Command {
                Preconditions.checkNotNull(name, "Missing name for step in the compilation pipeline configuration file");
                Preconditions.checkNotNull(tool, "Entry tool for step '%s' is mandatory in the compilation pipeline configuration file", name);
                Preconditions.checkNotNull(input, "Entry input for step '%s' is mandatory in the compilation pipeline configuration file", name);
                Preconditions.checkNotNull(output, "Entry output for step '%s' is mandatory in the compilation pipeline configuration file", name);
                Preconditions.checkNotNull(args, "Entry args for step '%s' is mandatory in the compilation pipeline configuration file", name);
                args = List.copyOf(args);
            }
        }
    }
}
