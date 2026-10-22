package com.dat3m.dartagnan.witness.svcomp;

import com.dat3m.dartagnan.metadata.SourceLocation;
import com.dat3m.dartagnan.program.event.Event;

import java.math.BigInteger;
import java.nio.file.Path;
import java.time.Instant;
import java.util.List;
import java.util.Objects;

import static com.google.common.base.Preconditions.checkArgument;

/** Data model for SV-COMP 2.2 witnesses, independent of their YAML serialization. */
public sealed interface SvcompWitness permits SvcompViolationWitness, SvcompCorrectnessWitness {

    Metadata metadata();

    public record Metadata(String formatVersion, String uuid, Instant creationTime, Producer producer, Task task) {
        public Metadata {
            Objects.requireNonNull(formatVersion);
            Objects.requireNonNull(uuid);
            Objects.requireNonNull(creationTime);
            Objects.requireNonNull(producer);
            Objects.requireNonNull(task);
        }
    }

    public record Producer(String name, String version) {
        public Producer {
            Objects.requireNonNull(name);
            Objects.requireNonNull(version);
        }
    }

    public record Task(Path inputFile, String inputFileHash, String specification, String dataModel, String language) {
        public Task {
            Objects.requireNonNull(inputFile);
            Objects.requireNonNull(inputFileHash);
            Objects.requireNonNull(specification);
            Objects.requireNonNull(dataModel);
            Objects.requireNonNull(language);
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
            Objects.requireNonNull(location);
        }
    }

    public record Assumption(int threadId, AssumptionExpression expression, Location location) implements Waypoint {
        public Assumption {
            checkArgument(threadId >= 0, "Witness thread identifier must be non-negative");
            Objects.requireNonNull(expression);
            Objects.requireNonNull(location);
        }
    }

    public sealed interface AssumptionExpression permits BooleanConstant, VariableEquality, Conjunction { }

    public record BooleanConstant(boolean value) implements AssumptionExpression { }

    public record VariableEquality(String variable, BigInteger value) implements AssumptionExpression {
        public VariableEquality {
            Objects.requireNonNull(variable);
            checkArgument(variable.matches("[A-Za-z_][A-Za-z0-9_$]*"), "Invalid assumption variable: %s", variable);
            Objects.requireNonNull(value);
        }
    }

    public record Conjunction(AssumptionExpression left, AssumptionExpression right) implements AssumptionExpression {
        public Conjunction {
            Objects.requireNonNull(left);
            Objects.requireNonNull(right);
        }
    }

    public record Target(int threadId, Location location) implements Waypoint {
        public Target {
            checkArgument(threadId >= 0, "Witness thread identifier must be non-negative");
            Objects.requireNonNull(location);
        }
    }

    public record Location(Path fileName, int line) {
        public Location {
            Objects.requireNonNull(fileName);
            checkArgument(line > 0, "Source location line must be positive");
        }

        /** Events are matched by source line and file name, ignoring directories. */
        public boolean matches(Event event) {
            return event.getMetadata(SourceLocation.class) instanceof SourceLocation.Generic generic
                    && generic.lineNumber() == line
                    && generic.sourcePath().getFileName().equals(fileName.getFileName());
        }
    }
}
