package com.dat3m.dartagnan.parsers.program.utils;

import org.junit.Test;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertThrows;
import static org.junit.Assert.assertTrue;

public class PipelinesTest {

    private static final Path TEST_WORKDIR = Path.of("build").toAbsolutePath().normalize();

    @Test
    public void loadAndPreparePipeline() throws Exception {
        final Path yaml = writeConfiguration("""
                workdir: build
                x-common_commands:
                  upgrade_cmd: &upgrade_cmd
                    name: "Upgrade to Vulkan memory model"
                    tool: "spirv-opt"
                    input: "{basename}.spv"
                    output: "{basename}-vulkan.spv"
                    args: ["--upgrade-memory-model", "{cmd_input}", "-o", "{cmd_output}"]
                  disassemble_cmd: &disassemble_cmd
                    name: "Disassemble"
                    tool: "spirv-dis"
                    input: "{basename}-vulkan.spv"
                    output: "{basename}.spvasm"
                    args: ["{cmd_input}", "-o", "{cmd_output}"]
                pipelines:
                  - pipeline: ".cl"
                    aliases: [".i"]
                    output: "{basename}.spvasm"
                    commands:
                      - name: "Compile"
                        tool: "clspv"
                        input: "{pipeline_input}"
                        output: "{basename}.spv"
                        args: ["{cmd_input}", "--cl-std=CL2.0", "-o", "{cmd_output}", "-g"]
                      - *upgrade_cmd
                      - *disassemble_cmd
                """);

        final Pipelines pipelines = Pipelines.load(yaml);
        final Pipelines.Pipeline pipeline = pipelines.getPipeline(".cl", Path.of("sources", "example.cl"), "example");
        final Pipelines.Pipeline aliasPipeline = pipelines.getPipeline(".i", Path.of("sources", "example.i"), "example");
        final Pipelines.Pipeline.Command compile = pipeline.commands().get(0); // clspv
        final Pipelines.Pipeline.Command upgradeMemoryModel = pipeline.commands().get(1); // spirv-opt
        final Pipelines.Pipeline.Command disassemble = pipeline.commands().get(2); // spirv-dis

        assertTrue(pipelines.needsCompilation(".cl"));
        assertTrue(pipelines.needsCompilation(".i"));
        assertFalse(pipelines.needsCompilation(".litmus"));
        assertEquals(3, pipelines.getTools().size());
        assertEquals(TEST_WORKDIR.resolve("example.spvasm").toString(), pipeline.output());
        assertEquals(pipeline.output(), aliasPipeline.output());
        assertEquals(Path.of("sources", "example.cl").toString(), compile.input());
        assertEquals(TEST_WORKDIR.resolve("example.spv").toString(), upgradeMemoryModel.input());
        assertEquals(Path.of("sources", "example.cl").toString(), compile.args().get(0)); // {cmd_input}
        assertEquals(TEST_WORKDIR.resolve("example.spv").toString(), compile.args().get(3)); // {cmd_output}
        assertEquals(TEST_WORKDIR.resolve("example.spv").toString(), upgradeMemoryModel.args().get(1)); // {cmd_input}
        assertEquals(TEST_WORKDIR.resolve("example-vulkan.spv").toString(), upgradeMemoryModel.args().get(3)); // {cmd_output}
        assertEquals(TEST_WORKDIR.resolve("example-vulkan.spv").toString(), disassemble.args().get(0)); // {cmd_input}
        assertEquals(TEST_WORKDIR.resolve("example.spvasm").toString(), disassemble.args().get(2)); // {cmd_output}
    }

    @Test
    public void rejectsDuplicateExtensions() throws Exception {
        final Path yaml = writeConfiguration("""
                workdir: build
                pipelines:
                  - pipeline: ".foo"
                    output: output
                    commands: []
                  - pipeline: ".foo"
                    output: output
                    commands: []
        """);

        final IOException exception = assertThrows(IOException.class, () -> Pipelines.load(yaml));
        assertConfigurationError(yaml, exception, "Duplicate compilation pipeline for file extension: .foo");
    }

    @Test
    public void rejectsDuplicateAliases() throws Exception {
        final Path yaml = writeConfiguration("""
                workdir: build
                pipelines:
                  - pipeline: ".foo"
                    aliases: [".bar"]
                    output: output
                    commands: []
                  - pipeline: ".baz"
                    aliases: [".bar"]
                    output: output
                    commands: []
        """);

        final IOException exception = assertThrows(IOException.class, () -> Pipelines.load(yaml));
        assertConfigurationError(yaml, exception, "Duplicate compilation pipeline for file extension: .bar");
    }

    @Test
    public void rejectsPipelineOutputWithoutNativeParser() throws Exception {
        final Path yaml = writeConfiguration("""
                workdir: build
                pipelines:
                  - pipeline: ".foo"
                    output: "{basename}.foo"
                    commands:
                      - name: "Compile"
                        tool: "compiler"
                        input: "{pipeline_input}"
                        output: "{basename}.foo"
                        args: []
                """);

        final IOException exception = assertThrows(IOException.class, () -> Pipelines.load(yaml));
        assertConfigurationError(yaml, exception,
                "Compilation pipeline for '.foo' generates '{basename}.foo', which is not a natively supported format");
    }

    @Test
    public void rejectsPipelineWithoutCommands() throws Exception {
        final Path yaml = writeConfiguration("""
                workdir: build
                pipelines:
                  - pipeline: ".foo"
                    output: "{basename}.ll"
                    commands: []
        """);

        final IOException exception = assertThrows(IOException.class, () -> Pipelines.load(yaml));
        assertConfigurationError(yaml, exception, "Compilation pipeline for '.foo' has no commands");
    }

    @Test
    public void rejectsPipelineWhoseFinalCommandDoesNotGenerateItsDeclaredOutput() throws Exception {
        final Path yaml = writeConfiguration("""
                workdir: build
                pipelines:
                  - pipeline: ".foo"
                    output: "{basename}.ll"
                    commands:
                      - name: "Compile"
                        tool: "compiler"
                        input: "{pipeline_input}"
                        output: "{basename}.ll"
                        args: []
                      - name: "Postprocess"
                        tool: "postprocessor"
                        input: "{basename}.ll"
                        output: "{basename}.spvasm"
                        args: []
        """);

        final IOException exception = assertThrows(IOException.class, () -> Pipelines.load(yaml));
        assertConfigurationError(yaml, exception,
                "Final command of compilation pipeline for '.foo' does not generate its declared output '{basename}.ll'");
    }

    @Test
    public void cleansUpIntermediatesButPreservesOutput() throws IOException {
        final Path source = Files.createTempFile("source", ".cl");
        final Path intermediate = Files.createTempFile("intermediate", ".spv");
        final Path output = Files.createTempFile("output", ".spvasm");
        final Pipelines.Pipeline pipeline = new Pipelines.Pipeline(
                ".cl", List.of(), output.toString(), List.of(
                        new Pipelines.Pipeline.Command("compile", "tool", source.toString(), intermediate.toString(), List.of()),
                        new Pipelines.Pipeline.Command("disassemble", "tool", intermediate.toString(), output.toString(), List.of())
                ));

        pipeline.removeIntermediateFiles();

        assertTrue(Files.exists(source));
        assertFalse(Files.exists(intermediate));
        assertTrue(Files.exists(output));
        pipeline.removeOutputFile();
        assertFalse(Files.exists(output));
        Files.deleteIfExists(source);
    }

    @Test
    public void createsDirectoriesForIntermediateOutputs() throws Exception {
        final Path temporaryDirectory = Files.createTempDirectory("pipeline");
        final Path intermediate = temporaryDirectory.resolve("intermediate").resolve("generated").resolve("input.spv");
        final Path output = temporaryDirectory.resolve("output").resolve("generated").resolve("input.spvasm");
        final String java = ProcessHandle.current().info().command().orElseThrow();
        final Pipelines.Pipeline pipeline = new Pipelines.Pipeline(
                ".cl", List.of(), output.toString(), List.of(
                        new Pipelines.Pipeline.Command("compile", java, "input.cl", intermediate.toString(), List.of("--version")),
                        new Pipelines.Pipeline.Command("disassemble", java, intermediate.toString(), output.toString(), List.of("--version"))
                ));

        try {
            assertThrows(IOException.class, pipeline::execute);

            assertTrue(Files.isDirectory(intermediate.getParent()));
            assertTrue(Files.isDirectory(output.getParent()));
        } finally {
            Files.deleteIfExists(intermediate.getParent());
            Files.deleteIfExists(intermediate.getParent().getParent());
            Files.deleteIfExists(output.getParent());
            Files.deleteIfExists(output.getParent().getParent());
            Files.deleteIfExists(temporaryDirectory);
        }
    }

    @Test
    public void rejectsMissingFinalOutput() throws Exception {
        final Path directory = Files.createTempDirectory("pipeline");
        final Path output = directory.resolve("missing.spvasm");
        final String java = ProcessHandle.current().info().command().orElseThrow();
        final Pipelines.Pipeline pipeline = new Pipelines.Pipeline(
                ".cl", List.of(), output.toString(), List.of(
                        new Pipelines.Pipeline.Command("compile", java, "input.cl", output.toString(), List.of("--version"))
                ));

        try {
            final IOException exception = assertThrows(IOException.class, pipeline::execute);
            assertEquals("Compilation pipeline for '.cl' did not generate declared output '%s'".formatted(output), exception.getMessage());
        } finally {
            Files.deleteIfExists(directory);
        }
    }

    @Test
    public void rejectsMissingRequiredEntries() throws IOException {
        record InvalidConfiguration(String yaml, String expectedMessage) { }

        final List<InvalidConfiguration> configurations = List.of(
                new InvalidConfiguration("""
                        pipelines: []
                        """, "Missing workdir in the compilation pipeline configuration file"),
                new InvalidConfiguration("""
                        workdir: build
                        """, "Missing compilation pipelines in the configuration file"),
                new InvalidConfiguration("""
                        workdir: ""
                        pipelines: []
                        """, "Compilation pipeline workdir must not be blank"),
                new InvalidConfiguration(pipelineConfigurationWithout("pipeline"), "Missing compilation pipeline extension in the configuration file"),
                new InvalidConfiguration(pipelineConfigurationWithout("output"), "Missing compilation pipeline output for extension '.cl'"),
                new InvalidConfiguration(pipelineConfigurationWithout("commands"), "Missing compilation pipeline commands for extension '.cl'"),
                new InvalidConfiguration(commandConfigurationWithout("name"), "Missing name for step in the compilation pipeline configuration file"),
                new InvalidConfiguration(commandConfigurationWithout("tool"), "Entry tool for step 'compile' is mandatory in the compilation pipeline configuration file"),
                new InvalidConfiguration(commandConfigurationWithout("input"), "Entry input for step 'compile' is mandatory in the compilation pipeline configuration file"),
                new InvalidConfiguration(commandConfigurationWithout("output"), "Entry output for step 'compile' is mandatory in the compilation pipeline configuration file"),
                new InvalidConfiguration(commandConfigurationWithout("args"), "Entry args for step 'compile' is mandatory in the compilation pipeline configuration file")
        );

        for (InvalidConfiguration configuration : configurations) {
            final Path yaml = writeConfiguration(configuration.yaml());
            final IOException exception = assertThrows(
                    IOException.class,
                    () -> Pipelines.load(yaml)
            );
            assertConfigurationError(yaml, exception, configuration.expectedMessage());
        }
    }

    @Test
    public void rejectsRemovedOrUnknownEntries() throws Exception {
        final Path yaml = writeConfiguration("""
                workdir: build
                pipelines:
                  - pipeline: ".cl"
                    output: "{basename}.ll"
                    commands:
                      - name: Compile
                        tool: compiler
                        input: "{pipeline_input}"
                        output: "{basename}.ll"
                        read_from_workdir: false
                        args: []
                """);

        final IOException exception = assertThrows(IOException.class, () -> Pipelines.load(yaml));
        assertTrue(exception.getMessage().startsWith("Invalid compilation pipeline configuration '%s': ".formatted(yaml)));
        assertTrue(exception.getMessage().contains("Unrecognized field \"read_from_workdir\""));
    }

    private static String pipelineConfigurationWithout(String entryName) {
        final String yaml = """
                workdir: build
                pipelines:
                  - pipeline: ".cl"
                    output: pipeline-output
                    commands: []
                """;
        final String defaultEntry = switch (entryName) {
            case "pipeline" -> "pipeline: \".cl\"";
            case "output" -> "output: pipeline-output";
            case "commands" -> "commands: []";
            default -> throw new IllegalArgumentException("Unknown pipeline entry: " + entryName);
        };
        return yaml.replace(defaultEntry, "");
    }

    private static String commandConfigurationWithout(String entryName) {
        final String yaml = """
                workdir: build
                pipelines:
                  - pipeline: ".cl"
                    output: pipeline-output
                    commands:
                      - name: compile
                        tool: clspv
                        input: command-input
                        output: command-output
                        args: []
                """;
        final String defaultEntry = switch (entryName) {
            case "name" -> "name: compile";
            case "tool" -> "tool: clspv";
            case "input" -> "input: command-input";
            case "output" -> "output: command-output";
            case "args" -> "args: []";
            default -> throw new IllegalArgumentException("Unknown command entry: " + entryName);
        };
        return yaml.replace(defaultEntry, "");
    }

    private static Path writeConfiguration(String configuration) throws IOException {
        final Path yaml = Files.createTempFile("compilation", ".yml");
        Files.writeString(yaml, configuration);
        return yaml;
    }

    private static void assertConfigurationError(Path yaml, IOException exception, String message) {
        assertEquals("Invalid compilation pipeline configuration '%s': %s".formatted(yaml, message), exception.getMessage());
    }
}
