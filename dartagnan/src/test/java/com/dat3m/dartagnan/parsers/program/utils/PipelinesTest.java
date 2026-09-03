package com.dat3m.dartagnan.parsers.program.utils;

import com.dat3m.dartagnan.parsers.program.ProgramParser;
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
                    read_from_workdir: true
                    args: ["--upgrade-memory-model", "{cmd_input}", "-o", "{cmd_output}"]
                  disassemble_cmd: &disassemble_cmd
                    name: "Disassemble"
                    tool: "spirv-dis"
                    input: "{basename}-vulkan.spv"
                    output: "{basename}.spvasm"
                    read_from_workdir: true
                    args: ["{cmd_input}", "-o", "{cmd_output}"]
                pipelines:
                  - pipeline: ".cl"
                    aliases: [".i"]
                    input: "{pipeline_input}"
                    output: "{basename}.spvasm"
                    commands:
                      - name: "Compile"
                        tool: "clspv"
                        input: "{pipeline_input}"
                        output: "{basename}.spv"
                        read_from_workdir: false
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
        assertEquals(Path.of("build", "example.spvasm").toString(), pipeline.output());
        assertEquals(pipeline.output(), aliasPipeline.output());
        assertEquals(Path.of("sources", "example.cl").toString(), compile.args().get(0)); // {cmd_input}
        assertEquals(Path.of("build", "example.spv").toString(), compile.args().get(3)); // {cmd_output}
        assertEquals(Path.of("build", "example.spv").toString(), upgradeMemoryModel.args().get(1)); // {cmd_input}
        assertEquals(Path.of("build", "example-vulkan.spv").toString(), upgradeMemoryModel.args().get(3)); // {cmd_output}
        assertEquals(Path.of("build", "example-vulkan.spv").toString(), disassemble.args().get(0)); // {cmd_input}
        assertEquals(Path.of("build", "example.spvasm").toString(), disassemble.args().get(2)); // {cmd_output}
    }

    @Test
    public void rejectsDuplicateExtensions() throws Exception {
        final Path yaml = writeConfiguration("""
                workdir: build
                pipelines:
                  - pipeline: ".foo"
                    input: input
                    output: output
                    commands: []
                  - pipeline: ".foo"
                    input: input
                    output: output
                    commands: []
                """);

        final IOException exception = assertThrows(IOException.class, () -> Pipelines.load(yaml));
        assertTrue(exception.getMessage().contains("Duplicate pipeline"));
    }

    @Test
    public void rejectsDuplicateAliases() throws Exception {
        final Path yaml = writeConfiguration("""
                workdir: build
                pipelines:
                  - pipeline: ".foo"
                    aliases: [".bar"]
                    input: input
                    output: output
                    commands: []
                  - pipeline: ".baz"
                    aliases: [".bar"]
                    input: input
                    output: output
                    commands: []
                """);

        final IOException exception = assertThrows(IOException.class, () -> Pipelines.load(yaml));
        assertTrue(exception.getMessage().contains("Duplicate pipeline"));
    }

    @Test
    public void rejectsPipelineOutputWithoutNativeParser() throws Exception {
        final Path yaml = writeConfiguration("""
                workdir: build
                pipelines:
                  - pipeline: ".foo"
                    input: "{pipeline_input}"
                    output: "{basename}.foo"
                    commands: []
                """);

        final Pipelines pipelines = Pipelines.load(yaml);
        final IOException exception = assertThrows(IOException.class, () -> new ProgramParser(pipelines));
        assertTrue(exception.getMessage().contains("not a natively supported format"));
    }

    @Test
    public void cleansUpIntermediatesButPreservesOutput() throws IOException {
        final Path source = Files.createTempFile("source", ".cl");
        final Path intermediate = Files.createTempFile("intermediate", ".spv");
        final Path output = Files.createTempFile("output", ".spvasm");
        final Pipelines.Pipeline pipeline = new Pipelines.Pipeline(
                ".cl", List.of(), source.toString(), output.toString(), List.of(
                        new Pipelines.Pipeline.Command("compile", "tool", source.toString(), intermediate.toString(), false, List.of()),
                        new Pipelines.Pipeline.Command("disassemble", "tool", intermediate.toString(), output.toString(), true, List.of())
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
    public void rejectsMissingRequiredEntries() {
        final List<InvalidConfiguration> configurations = List.of(
                new InvalidConfiguration("""
                        pipelines: []
                        """, "Missing workdir"),
                new InvalidConfiguration("""
                        workdir: build
                        """, "Missing pipelines"),
                new InvalidConfiguration(pipelineConfigurationWithout("pipeline"), "Missing pipeline extension"),
                new InvalidConfiguration(pipelineConfigurationWithout("input"), "Missing pipeline input"),
                new InvalidConfiguration(pipelineConfigurationWithout("output"), "Missing pipeline output"),
                new InvalidConfiguration(pipelineConfigurationWithout("commands"), "Missing pipeline commands"),
                new InvalidConfiguration(commandConfigurationWithout("name"), "Missing name"),
                new InvalidConfiguration(commandConfigurationWithout("tool"), "Entry tool"),
                new InvalidConfiguration(commandConfigurationWithout("input"), "Entry input"),
                new InvalidConfiguration(commandConfigurationWithout("output"), "Entry output"),
                new InvalidConfiguration(commandConfigurationWithout("read_from_workdir"), "Entry read_from_workdir"),
                new InvalidConfiguration(commandConfigurationWithout("args"), "Entry args")
        );

        for (InvalidConfiguration configuration : configurations) {
            final IOException exception = assertThrows(
                    IOException.class,
                    () -> Pipelines.load(writeConfiguration(configuration.yaml()))
            );
            assertTrue(exception.getMessage().contains(configuration.expectedMessage()));
        }
    }

    private static String pipelineConfigurationWithout(String entryName) {
        final String yaml = """
                workdir: build
                pipelines:
                  - pipeline: ".cl"
                    input: pipeline-input
                    output: pipeline-output
                    commands: []
                """;
        final String defaultEntry = switch (entryName) {
            case "pipeline" -> "pipeline: \".cl\"";
            case "input" -> "input: pipeline-input";
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
                    input: pipeline-input
                    output: pipeline-output
                    commands:
                      - name: compile
                        tool: clspv
                        input: command-input
                        output: command-output
                        read_from_workdir: false
                        args: []
                """;
        final String defaultEntry = switch (entryName) {
            case "name" -> "name: compile";
            case "tool" -> "tool: clspv";
            case "input" -> "input: command-input";
            case "output" -> "output: command-output";
            case "read_from_workdir" -> "read_from_workdir: false";
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

    private record InvalidConfiguration(String yaml, String expectedMessage) {
    }
}
