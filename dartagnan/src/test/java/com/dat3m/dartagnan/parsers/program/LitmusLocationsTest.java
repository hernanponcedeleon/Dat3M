package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.booleans.BoolLiteral;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.exception.ParsingException;
import org.antlr.v4.runtime.CharStreams;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.List;

import static org.junit.Assert.*;

@RunWith(Parameterized.class)
public class LitmusLocationsTest {

    @Parameterized.Parameters(name = "{0}")
    public static Object[][] architectures() {
        return new Object[][]{
                {"AArch64", "X0"}, {"PPC", "r0"}, {"RISCV", "x1"}, {"X86", "EAX"},
                {"PTX", "r0"}, {"VULKAN", "r0"}, {"C", "r0"}, {"OPENCL", "r0"}
        };
    }

    private final String language;
    private final String register;

    public LitmusLocationsTest(String language, String register) {
        this.language = language;
        this.register = register;
    }

    private Program parse(String annotation) {
        final String body = switch (language) {
            case "C", "OPENCL" -> "P0() {}";
            case "PTX" -> "P0@cta 0,gpu 0;\n;";
            case "VULKAN" -> "P0@sg 0,wg 0,qf 0;\n;";
            default -> "P0;\n;";
        };
        return new ParserLitmus().parse(CharStreams.fromString("""
                %s locations-test
                { x=0; y=1; 0:%s=0; }
                %s
                %s
                """.formatted(language, register, body, annotation)));
    }

    @Test
    public void retainsLocationsInSourceOrderWithoutAnAssertion() {
        final Program program = parse("locations [y; 0:" + register + "; x;]");
        final List<Expression> locations = program.getLocations();

        assertEquals(3, locations.size());
        assertEquals("y", ((MemoryObject) locations.get(0)).getName());
        assertEquals(register, ((Register) locations.get(1)).getName());
        assertSame(program.getThreads().get(0), ((Register) locations.get(1)).getThread());
        assertEquals("x", ((MemoryObject) locations.get(2)).getName());
    }

    @Test
    public void parsesLocationsAlongsideFilterAndSpecification() {
        final Program program = parse("locations [x; 0:" + register + "]\n"
                + "filter (x=0)\nexists (0:" + register + "=0)");

        assertEquals(2, program.getLocations().size());
        assertNotNull(program.getSpecification());
        assertFalse(program.getFilterSpecification() instanceof BoolLiteral);
    }

    @Test
    public void absentAnnotationHasNoLocations() {
        assertTrue(parse("").getLocations().isEmpty());
    }

    @Test
    public void rejectsConstantsInLocations() {
        assertThrows(ParsingException.class, () -> parse("locations [1]"));
    }

    @Test
    public void rejectsDuplicateMemoryLocations() {
        final ParsingException exception = assertThrows(ParsingException.class,
                () -> parse("locations [x; x]"));
        assertTrue(exception.getMessage().contains("Duplicate location x"));
    }

    @Test
    public void rejectsDuplicateRegistersWithEquivalentThreadIdentifiers() {
        final ParsingException exception = assertThrows(ParsingException.class,
                () -> parse("locations [0:" + register + "; P0:" + register + "]"));
        assertTrue(exception.getMessage().contains("Duplicate location P0:" + register));
    }
}
