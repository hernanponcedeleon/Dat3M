package com.dat3m.dartagnan.witness.svcomp;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.witness.svcomp.SvcompWitness.*;

/** Serializes {@link SvcompWitness} instances to SV-COMP's YAML representation. */
public final class SvcompWitnessYamlWriter {

    private SvcompWitnessYamlWriter() { }

    public static void write(SvcompWitness witness, Path file) throws IOException {
        final Path parent = file.getParent();
        if (parent != null) {
            Files.createDirectories(parent);
        }
        Files.writeString(file, render(witness), StandardCharsets.UTF_8);
    }

    static String render(SvcompWitness witness) {
        final Metadata metadata = witness.metadata();
        final Producer producer = metadata.producer();
        final Task task = metadata.task();
        final String header = """
                - entry_type: violation_sequence
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
                  content:
                """.formatted(metadata.formatVersion(), metadata.uuid(), metadata.creationTime(), yaml(producer.name()),
                yaml(producer.version()), yaml(task.inputFile()), yaml(task.inputFile()), task.inputFileHash(),
                yaml(task.specification()), task.dataModel(), task.language());
        return header + witness.segments().stream()
                .map(SvcompWitnessYamlWriter::formatSegment)
                .collect(Collectors.joining());
    }

    private static String formatSegment(Segment segment) {
        return "    - segment:\n" + segment.waypoints().stream()
                .map(SvcompWitnessYamlWriter::formatWaypoint)
                .collect(Collectors.joining());
    }

    private static String formatWaypoint(Waypoint waypoint) {
        if (waypoint instanceof Assumption assumption) {
            return """
                    - waypoint:
                        type: assumption
                        action: follow
                        thread_id: %d
                        constraint:
                          value: %s
                          format: %s
                        location:
                          file_name: %s
                          line: %d
                    """.formatted(assumption.threadId(), yaml(assumption.value()), assumption.format(),
                    yaml(assumption.location().fileName()), assumption.location().line());
        }

        final String type;
        if (waypoint instanceof FunctionEnter) {
            type = "function_enter";
        } else if (waypoint instanceof Target) {
            type = "target";
        } else {
            throw new AssertionError("Unsupported waypoint: " + waypoint);
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

    private static String yaml(Path value) {
        return yaml(value.toString());
    }

    private static String yaml(String value) {
        return "\"" + value.replace("\\", "\\\\").replace("\"", "\\\"") + "\"";
    }
}
