package com.dat3m.dartagnan.witness.svcomp;

import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;

import java.math.BigInteger;
import java.nio.file.Path;
import java.time.Instant;
import java.util.List;

import static com.dat3m.dartagnan.witness.svcomp.SvcompWitness.*;
import static com.dat3m.dartagnan.witness.svcomp.SvcompWitnessYamlWriter.render;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

public class SvcompWitnessYamlWriterTest {

    @Rule
    public TemporaryFolder temporaryFolder = new TemporaryFolder();

    @Test
    public void serializesSemanticWitness() {
        final Path inputFile = Path.of("example.c");
        final Location location = new Location(inputFile, 7);
        final SvcompWitness witness = new SvcompWitness(
                new Metadata("2.2", "test-uuid", Instant.parse("2026-01-01T00:00:00Z"),
                        new Producer("Dartagnan", "test-version"),
                        new Task(inputFile, "deadbeef", "CHECK( init(main()), LTL(G ! data-race) )",
                                "LP64", "C")),
                List.of(new Segment(List.of(new FunctionEnter(0, location))),
                        new Segment(List.of(new Assumption(1, new BooleanConstant(true), location))),
                        new Segment(List.of(new Target(1, location)))));

        final String yaml = render(witness);

        assertTrue(yaml.contains("entry_type: violation_sequence"));
        assertTrue(yaml.contains("version: \"test-version\""));
        assertTrue(yaml.contains("type: function_enter"));
        assertTrue(yaml.contains("type: assumption"));
        assertTrue(yaml.contains("type: target"));
        assertTrue(yaml.contains("file_name: \"example.c\""));
        assertTrue(yaml.contains("""
                    - segment:
                        - waypoint:
                            type: function_enter
                """));
    }

    @Test
    public void roundTripsStructuredAssumptions() throws Exception {
        final Path inputFile = Path.of("example.c");
        final Location location = new Location(inputFile, 7);
        final AssumptionExpression expression = new Conjunction(new BooleanConstant(true),
                new Conjunction(new VariableEquality("x", new BigInteger("-123456789012345678901234567890")),
                        new BooleanConstant(false)));
        final SvcompWitness witness = new SvcompWitness(
                new Metadata("2.2", "test-uuid", Instant.parse("2026-01-01T00:00:00Z"),
                        new Producer("Dartagnan", "test-version"),
                        new Task(inputFile, "deadbeef", "CHECK( init(main()), LTL(G ! data-race) )",
                                "LP64", "C")),
                List.of(new Segment(List.of(new Assumption(0, expression, location))),
                        new Segment(List.of(new Target(0, location)))));
        final Path file = temporaryFolder.newFile("witness.yml").toPath();

        SvcompWitnessYamlWriter.write(witness, file);

        assertEquals(witness, SvcompWitnessYamlParser.parse(file));
    }
}
