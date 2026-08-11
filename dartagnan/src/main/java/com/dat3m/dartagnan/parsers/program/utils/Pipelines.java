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
import java.util.List;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.GlobalSettings.getHomeDirectory;
import static com.dat3m.dartagnan.GlobalSettings.getOutputDirectory;
import static com.fasterxml.jackson.databind.DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES;

public record Pipelines(String workdir, List<Pipeline> pipelines) {

    public static Pipeline getPipeline(Path yamlPath, String extension, String inputPath, String basename) throws IOException {
        final Pipelines abstractPipelines = parseYaml(yamlPath, inputPath, basename);
        final String workdir = abstractPipelines.workdir();
        final Pipeline abstractPipeline = abstractPipelines.pipelines().stream()
                .filter(p -> extension.equals(p.pipeline()))
                .findFirst()
                .orElseThrow(() -> new UnsupportedOperationException("Compilation pipeline not found for file extension: " + extension));

        final List<Pipeline.Command> concreteSteps = new ArrayList<>();
        for (Pipeline.Command cmd : abstractPipeline.commands()) {
            final String concreteInput = cmd.read_from_workdir()
                    ? Path.of(workdir, cmd.input()).toString()
                    : inputPath;
            final String concreteOutput = Path.of(workdir, cmd.output()).toString();
            final List<String> concreteArgs = cmd.args().stream()
                    .map(arg -> substituteTokens(arg, concreteInput, concreteOutput))
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
                Path.of(workdir, abstractPipeline.input()).toString(),
                Path.of(workdir, abstractPipeline.output()).toString(),
                concreteSteps
        );
    }

    public static boolean needsCompilation(Path yamlPath, String extension) throws IOException {
        return parseYaml(yamlPath, "", "").pipelines().stream()
                .map(Pipeline::pipeline)
                .anyMatch(e -> e.equals(extension));
    }

    private static Pipelines parseYaml(Path yamlPath, String inputPath, String basename) throws IOException {
        try (InputStream inputStream = Files.newInputStream(yamlPath)) {
            final String rawData = new String(inputStream.readAllBytes(), StandardCharsets.UTF_8)
                    .replace("$DAT3M_HOME", getHomeDirectory().toString())
                    .replace("$DAT3M_OUTPUT", getOutputDirectory().toString())
                    .replace("{pipeline_input}", inputPath)
                    .replace("{basename}", basename);
            final ObjectMapper mapper = new ObjectMapper();
            mapper.configure(FAIL_ON_UNKNOWN_PROPERTIES, false);
            return mapper.convertValue(new Yaml().load(rawData), Pipelines.class);
        } catch (ValueInstantiationException e) {
            // Unwrap wrapper to bubble up the clean validation message thrown by the Command constructor
            // TODO this does not work after introducing Yaml() for anchors
            Throwable cause = e.getCause();
            String message = (cause != null && cause.getMessage() != null) ? cause.getMessage() : e.getOriginalMessage();
            throw new IOException(message, e);
        }
    }

    private static String substituteTokens(String arg, String input, String output) {
        return arg.replace("{cmd_input}", input)
                .replace("{cmd_output}", output);
    }

    public record Pipeline(String pipeline, String input, String output, List<Command> commands) {

        private static final Logger logger = LoggerFactory.getLogger(Pipeline.class);

        public void execute() throws Exception {
            for (Command cmd : commands) {
                runCmd(Stream.concat(Stream.of(cmd.tool()), cmd.args().stream()).toList());
            }
        }

        private void runCmd(List<String> cmd) throws Exception {
            logger.debug(String.join(" ", cmd));
            final Path log = Files.createTempFile("log", null);
            final ProcessBuilder processBuilder = new ProcessBuilder(cmd);
            processBuilder.redirectErrorStream(true);
            processBuilder.redirectOutput(log.toFile());

            final Process proc = processBuilder.start();
            if (proc.waitFor() != 0) {
                final String logString = Files.readString(log, StandardCharsets.UTF_8);
                final String errorMsg = "'%s': %s".formatted(String.join(" ", cmd), logString);
                throw new IOException(errorMsg);
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
            }
        }
    }
}