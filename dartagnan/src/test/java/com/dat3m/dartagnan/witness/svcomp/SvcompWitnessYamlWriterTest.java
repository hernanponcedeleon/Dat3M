package com.dat3m.dartagnan.witness.svcomp;

import org.junit.Test;

import java.nio.file.Path;
import java.time.Instant;
import java.util.List;

import static com.dat3m.dartagnan.witness.svcomp.SvcompWitness.*;
import static org.junit.Assert.assertTrue;

public class SvcompWitnessYamlWriterTest {

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
                        new Segment(List.of(new Assumption(1, "1", "c_expression", location))),
                        new Segment(List.of(new Target(1, location)))));

        final String yaml = SvcompWitnessYamlWriter.render(witness);

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
}
