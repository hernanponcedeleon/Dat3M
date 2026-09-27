package com.dat3m.dartagnan.witness.svcomp;

import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;

import java.io.IOException;
import java.math.BigInteger;
import java.nio.file.Files;
import java.nio.file.Path;

import static com.dat3m.dartagnan.witness.svcomp.SvcompWitness.*;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertThrows;
import static org.junit.Assert.assertTrue;

public class SvcompWitnessYamlParserTest {

    @Rule
    public TemporaryFolder temporaryFolder = new TemporaryFolder();

    @Test
    public void parsesConstants() throws Exception {
        for (String source : new String[]{"true", "TRUE", "1", "((true))"}) {
            assertEquals(new BooleanConstant(true), parse(source, "c_expression"));
        }
        for (String source : new String[]{"false", "FALSE", "0", "(0)"}) {
            assertEquals(new BooleanConstant(false), parse(source, "c_expression"));
        }
    }

    @Test
    public void parsesNestedConjunctionsAndLargeSignedIntegers() throws Exception {
        assertEquals(new Conjunction(new VariableEquality("x", new BigInteger("-123456789012345678901234567890")),
                        new Conjunction(new BooleanConstant(true), new VariableEquality("y", BigInteger.ZERO))),
                parse(" (x == -123456789012345678901234567890) && (true && y == 0) ", "c_expression"));
    }

    @Test
    public void rejectsUnsupportedSyntaxDuringYamlParsing() throws Exception {
        for (String source : new String[]{"x == 1.5", "v[0] == 1", "x = 1", "x == 1 || y == 2",
                "x == 1 trailing", "(x == 1", "x ==", "true &&", "2", ""}) {
            final IOException exception = assertThrows(IOException.class, () -> parse(source, "c_expression"));
            assertTrue(exception.getMessage().contains("Unsupported witness assumption"));
        }
    }

    @Test
    public void rejectsUnsupportedConstraintFormats() {
        final IOException exception = assertThrows(IOException.class, () -> parse("true", "other_format"));
        assertTrue(exception.getMessage().contains("Unsupported witness constraint format"));
    }

    @Test
    public void prefersExactHashKeyOverBasenameMatches() throws Exception {
        final SvcompWitness witness = parseWitness("true", "c_expression",
                "{example.c: exact, dir/example.c: other}");
        assertEquals("exact", witness.metadata().task().inputFileHash());
    }

    @Test
    public void acceptsUniqueBasenameHashKey() throws Exception {
        final SvcompWitness witness = parseWitness("true", "c_expression",
                "{../dir/example.c: matching, other.c: unrelated}");
        assertEquals(Path.of("example.c"), witness.metadata().task().inputFile());
        assertEquals("matching", witness.metadata().task().inputFileHash());
    }

    @Test
    public void rejectsMissingHashMatches() {
        for (String hashes : new String[]{"{}", "{other.c: unrelated}"}) {
            final IOException exception = assertThrows(IOException.class,
                    () -> parseWitness("true", "c_expression", hashes));
            assertTrue(exception.getMessage().contains("No input file hash matches"));
        }
    }

    @Test
    public void rejectsAmbiguousBasenameHashKeys() {
        final IOException exception = assertThrows(IOException.class,
                () -> parseWitness("true", "c_expression", "{dir1/example.c: first, dir2/example.c: second}"));
        assertTrue(exception.getMessage().contains("Multiple input file hashes match"));
    }

    private AssumptionExpression parse(String source, String format) throws IOException {
        final SvcompWitness witness = parseWitness(source, format, "{example.c: deadbeef}");
        return ((Assumption) witness.segments().get(0).waypoints().get(0)).expression();
    }

    private SvcompWitness parseWitness(String source, String format, String hashes) throws IOException {
        final Path file = temporaryFolder.newFile().toPath();
        Files.writeString(file, """
                - entry_type: violation_sequence
                  metadata:
                    format_version: '2.2'
                    uuid: test-uuid
                    creation_time: '2026-01-01T00:00:00Z'
                    producer:
                      name: test
                      version: test
                    task:
                      input_files: [example.c]
                      input_file_hashes: %s
                      specification: 'CHECK( init(main()), LTL(G ! data-race) )'
                      data_model: LP64
                      language: C
                  content:
                    - segment:
                        - waypoint:
                            type: assumption
                            action: follow
                            thread_id: 0
                            constraint:
                              value: '%s'
                              format: '%s'
                            location:
                              file_name: example.c
                              line: 7
                """.formatted(hashes, source, format));
        return SvcompWitnessYamlParser.parse(file);
    }
}
