package com.dat3m.dartagnan.witness.svcomp;

import java.nio.file.Path;
import java.time.Instant;
import java.util.List;
import java.util.Objects;

import static com.google.common.base.Preconditions.checkArgument;

/** Data model for an SV-COMP 2.2 violation witness, independent of its YAML serialization. */
public record SvcompWitness(Metadata metadata, List<Segment> segments) {

    public SvcompWitness {
        metadata = Objects.requireNonNull(metadata);
        segments = List.copyOf(segments);
    }

    public record Metadata(String formatVersion, String uuid, Instant creationTime, Producer producer, Task task) {
        public Metadata {
            formatVersion = Objects.requireNonNull(formatVersion);
            uuid = Objects.requireNonNull(uuid);
            creationTime = Objects.requireNonNull(creationTime);
            producer = Objects.requireNonNull(producer);
            task = Objects.requireNonNull(task);
        }
    }

    public record Producer(String name, String version) {
        public Producer {
            name = Objects.requireNonNull(name);
            version = Objects.requireNonNull(version);
        }
    }

    public record Task(Path inputFile, String inputFileHash, String specification, String dataModel, String language) {
        public Task {
            inputFile = Objects.requireNonNull(inputFile);
            inputFileHash = Objects.requireNonNull(inputFileHash);
            specification = Objects.requireNonNull(specification);
            dataModel = Objects.requireNonNull(dataModel);
            language = Objects.requireNonNull(language);
        }
    }

    public record Segment(List<Waypoint> waypoints) {
        public Segment {
            waypoints = List.copyOf(waypoints);
        }
    }

    public sealed interface Waypoint permits FunctionEnter, Assumption, Target {
        int threadId();

        Location location();
    }

    public record FunctionEnter(int threadId, Location location) implements Waypoint {
        public FunctionEnter {
            checkArgument(threadId >= 0, "Witness thread identifier must be non-negative");
            location = Objects.requireNonNull(location);
        }
    }

    public record Assumption(int threadId, String value, String format, Location location) implements Waypoint {
        public Assumption {
            checkArgument(threadId >= 0, "Witness thread identifier must be non-negative");
            value = Objects.requireNonNull(value);
            format = Objects.requireNonNull(format);
            location = Objects.requireNonNull(location);
        }
    }

    public record Target(int threadId, Location location) implements Waypoint {
        public Target {
            checkArgument(threadId >= 0, "Witness thread identifier must be non-negative");
            location = Objects.requireNonNull(location);
        }
    }

    public record Location(Path fileName, int line) {
        public Location {
            fileName = Objects.requireNonNull(fileName);
            checkArgument(line > 0, "Source location line must be positive");
        }
    }
}
