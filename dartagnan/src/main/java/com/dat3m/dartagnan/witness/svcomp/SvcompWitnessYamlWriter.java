package com.dat3m.dartagnan.witness.svcomp;

import java.io.IOException;
import java.math.BigInteger;
import java.nio.file.Path;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.witness.svcomp.SvcompWitness.*;
import static java.nio.charset.StandardCharsets.UTF_8;
import static java.nio.file.Files.createDirectories;
import static java.nio.file.Files.writeString;

/** Serializes {@link SvcompWitness} instances to SV-COMP's YAML representation. */
public final class SvcompWitnessYamlWriter {

    private SvcompWitnessYamlWriter() { }

    public static void write(SvcompWitness witness, Path file) throws IOException {
        final Path parent = file.getParent();
        if (parent != null) {
            createDirectories(parent);
        }
        writeString(file, render(witness), UTF_8);
    }

    static String render(SvcompWitness witness) {
        return switch (witness) {
            case SvcompViolationWitness violation -> header("violation_sequence", violation.metadata())
                    + "  content:\n" + violation.segments().stream()
                    .map(SvcompWitnessYamlWriter::formatSegment)
                    .collect(Collectors.joining());
            // For now, we build correctness witnesses with an empty set of invariants.
            case SvcompCorrectnessWitness correctness -> header("invariant_set", correctness.metadata())
                    + "  content: []\n";
        };
    }

    private static String header(String entryType, Metadata metadata) {
        final Producer producer = metadata.producer();
        final Task task = metadata.task();
        return """
                - entry_type: %s
                  metadata:
                    format_version: \"%s\"
                    uuid: \"%s\"
                    creation_time: \"%s\"
                    producer:
                      name: %s
                      version: %s
                    task:
                      input_files:
                        - %s
                      input_file_hashes:
                        %s: \"%s\"
                      specification: %s
                      data_model: %s
                      language: %s
                """.formatted(entryType, metadata.formatVersion(), metadata.uuid(), metadata.creationTime(), yaml(producer.name()),
                yaml(producer.version()), yaml(task.inputFile()), yaml(task.inputFile()), task.inputFileHash(),
                yaml(task.specification()), task.dataModel(), task.language());
    }

    private static String formatSegment(Segment segment) {
        return "    - segment:\n" + segment.waypoints().stream()
                .map(SvcompWitnessYamlWriter::formatWaypoint)
                .collect(Collectors.joining());
    }

    private static String formatWaypoint(Waypoint waypoint) {
        final String type;
        switch (waypoint) {
            case Assumption assumption -> {
                return """
                                - waypoint:
                                    type: assumption
                                    action: follow
                                    thread_id: %d
                                    constraint:
                                      value: %s
                                      format: c_expression
                                    location:
                                      file_name: %s
                                      line: %d
                        """.formatted(assumption.threadId(), yaml(formatAssumption(assumption.expression())),
                        yaml(assumption.location().fileName()), assumption.location().line());
            }
            case FunctionEnter _ -> type = "function_enter";
            case Target _ -> type = "target";
        }
        return """
                        - waypoint:
                            type: %s
                            action: follow
                            thread_id: %d
                            location:
                              file_name: %s
                              line: %d
                """.formatted(type, waypoint.threadId(), yaml(waypoint.location().fileName()),
                waypoint.location().line());
    }

    private static String formatAssumption(AssumptionExpression expression) {
        return switch (expression) {
            case BooleanConstant(boolean value) -> value ? "1" : "0";
            case VariableEquality(String variable, BigInteger value) -> "(%s == %s)".formatted(variable, value);
            case Conjunction(AssumptionExpression left, AssumptionExpression right) ->
                    "(%s && %s)".formatted(formatAssumption(left), formatAssumption(right));
        };
    }

    private static String yaml(Path value) {
        return yaml(value.toString());
    }

    private static String yaml(String value) {
        return "\"" + value.replace("\\", "\\\\").replace("\"", "\\\"") + "\"";
    }
}
