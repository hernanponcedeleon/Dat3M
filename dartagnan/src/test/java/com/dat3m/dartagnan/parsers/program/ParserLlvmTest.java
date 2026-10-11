package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.processing.ExprSimplifier;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.MemoryAccess;
import com.dat3m.dartagnan.program.event.MemoryEvent;
import com.dat3m.dartagnan.program.event.core.Alloc;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.processing.ProcessingManager;
import org.antlr.v4.runtime.CharStreams;
import org.junit.Test;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.math.BigInteger;
import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertThrows;
import static org.junit.Assert.assertTrue;

public class ParserLlvmTest {

    @Test
    public void processesProgramsWithDifferentPointerWidths() throws InvalidConfigurationException {
        for (int pointerWidth : new int[]{32, 64}) {
            final Program program = parse("e-p:" + pointerWidth + ":" + pointerWidth,
                    "@g = global [2 x i8] zeroinitializer\n@slot = global ptr null", """
                    %p = alloca i8
                    store ptr %p, ptr @slot
                    store i8 1, ptr %p
                    %v = load i8, ptr %p
                    %q = getelementptr i8, ptr @g, i16 1
                    store i8 %v, ptr %q
                    ret i32 0
                    """);

            ProcessingManager.fromConfig(Configuration.defaultConfiguration()).run(program);

            final TypeFactory types = TypeFactory.getInstance();
            final List<Alloc> allocations = program.getThreadEvents(Alloc.class);
            for (Alloc allocation : allocations) {
                assertEquals(pointerWidth, types.getMemorySizeInBits(allocation.getResultRegister().getType()));
                assertEquals(pointerWidth, types.getMemorySizeInBits(allocation.getAllocatedObject().getType()));
            }
            final List<MemoryAccess> accesses = program.getThreadEvents(MemoryEvent.class).stream()
                    .flatMap(event -> event.getMemoryAccesses().stream()).toList();
            for (MemoryAccess access : accesses) {
                assertEquals(pointerWidth, types.getMemorySizeInBits(access.address().getType()));
            }
        }
    }

    @Test
    public void pointerCastsZeroExtend() {
        for (String pointer : new String[]{"ptr", "i8*"}) {
            assertCastPreservesHighBitValue(32, "ptrtoint " + pointer + " inttoptr (i64 2147483648 to " + pointer + ") to i64");
            assertCastPreservesHighBitValue(64, "inttoptr i32 2147483648 to " + pointer);
            assertCastPreservesHighBitValue(32, "add i64 ptrtoint (" + pointer
                    + " inttoptr (i64 2147483648 to " + pointer + ") to i64), 0");
            assertCastPreservesHighBitValue(64, "ptrtoint " + pointer + " inttoptr (i32 2147483648 to " + pointer + ") to i64");
        }
    }

    @Test
    public void rejectsDifferentPointerWidthsAcrossAddressSpaces() {
        for (String layout : new String[]{"e-p:32:32-p1:64:64", "e-p1:64:64-p:32:32", "e-p1:32:32"}) {
            final ParsingException exception = assertThrows(ParsingException.class,
                    () -> parse(layout, "@g = global ptr addrspace(1) null", "ret i32 0"));
            assertTrue(exception.getMessage().contains("Different pointer sizes across address spaces"));
        }
    }

    @Test
    public void acceptsEqualPointerWidthsAcrossAddressSpaces() {
        final Program program = parse("e-p1:32:64-p:32:32", "@g = global ptr addrspace(1) null", "ret i32 0");
        assertEquals(32, program.getArchType().getBitWidth());
        assertEquals(BigInteger.valueOf(8),
                ((IntLiteral) program.getMemory().getObjects().iterator().next().alignment()).getValue());
    }

    @Test
    public void acceptsUnusedAddressSpacesWithDifferentPointerWidths() {
        final Program program = parse("e-p270:32:32-p271:32:32-p272:64:64", "", "ret i32 0");
        assertEquals(64, program.getArchType().getBitWidth());
    }

    @Test
    public void acceptsOmittedAndEqualPointerIndexWidths() {
        for (int width : new int[]{32, 64}) {
            for (String suffix : new String[]{"", ":" + width + ":" + width}) {
                final Program program = parse("e-p:" + width + ":" + width + suffix,
                        "@g = global ptr addrspace(1) null", "%p = alloca i8\nret i32 0");
                assertEquals(width, program.getArchType().getBitWidth());
            }
        }
    }

    @Test
    public void rejectsNarrowPointerIndexWidthInDefaultAddressSpace() {
        for (int width : new int[]{32, 64}) {
            final String layout = "e-p:" + width + ":" + width + ":" + width + ":" + width / 2;
            final ParsingException exception = assertThrows(ParsingException.class,
                    () -> parse(layout, "", "%p = alloca i8\nret i32 0"));
            assertTrue(exception.getMessage().contains("Pointer index widths different from pointer widths"));
            assertTrue(exception.getMessage().contains("address space 0"));
        }
    }

    @Test
    public void rejectsNarrowPointerIndexWidthInUsedAddressSpace() {
        for (String layout : new String[]{"e-p:64:64-p1:64:64:64:32", "e-p1:64:64:64:32-p:64:64"}) {
            for (String pointer : new String[]{"ptr addrspace(1)", "i8 addrspace(1)*"}) {
                final ParsingException exception = assertThrows(ParsingException.class,
                        () -> parse(layout, "@g = global " + pointer + " null", "ret i32 0"));
                assertTrue(exception.getMessage().contains("Pointer index widths different from pointer widths"));
                assertTrue(exception.getMessage().contains("address space 1"));
            }
        }
    }

    @Test
    public void rejectsInheritedNarrowPointerIndexWidth() {
        final ParsingException exception = assertThrows(ParsingException.class,
                () -> parse("e-p:64:64:64:32", "",
                        "%p = ptrtoint ptr addrspace(1) null to i64\nret i32 0"));
        assertTrue(exception.getMessage().contains("Pointer index widths different from pointer widths"));
        assertTrue(exception.getMessage().contains("address space 1"));
    }

    @Test
    public void acceptsUnusedAddressSpacesWithNarrowPointerIndexWidths() {
        for (String layout : new String[]{"e-p:64:64-p1:64:64:64:32", "e-p1:64:64:64:32-p:64:64"}) {
            final Program program = parse(layout, "@g = global i8 0", "%p = alloca i8\nret i32 0");
            assertEquals(64, program.getArchType().getBitWidth());
        }
    }

    @Test
    public void rejectsInvalidPointerIndexWidths() {
        for (int indexWidth : new int[]{0, 128}) {
            final ParsingException exception = assertThrows(ParsingException.class,
                    () -> parse("e-p1:64:64:64:" + indexWidth, "", "ret i32 0"));
            assertTrue(exception.getMessage().contains("Pointer index size must be positive and at most the pointer size"));
        }
    }

    @Test
    public void acceptsLargeExplicitAllocationAlignments() {
        for (long alignment : new long[]{1L << 31, 1L << 32}) {
            final Program program = parse("e-p:64:64", "@g = global i8 0, align " + alignment,
                    "%p = alloca i8, align " + alignment + "\nret i32 0");
            final Alloc alloc = program.getFunctions().stream().flatMap(function -> function.getEvents(Alloc.class).stream())
                    .findFirst().orElseThrow();
            assertEquals(BigInteger.valueOf(alignment), ((IntLiteral) alloc.getAlignment()).getValue());
            assertEquals(BigInteger.valueOf(alignment),
                    ((IntLiteral) program.getMemory().getObjects().iterator().next().alignment()).getValue());
        }
    }

    @Test
    public void rejectsInvalidOrUnrepresentableAllocationAlignments() {
        for (long alignment : new long[]{3, 1L << 33}) {
            assertThrows(ParsingException.class, () -> parse("e-p:64:64",
                    "@g = global i8 0, align " + alignment, "ret i32 0"));
            assertThrows(ParsingException.class, () -> parse("e-p:64:64", "",
                    "%p = alloca i8, align " + alignment + "\nret i32 0"));
        }
        assertThrows(ParsingException.class, () -> parse("e-p:32:32", "",
                "%p = alloca i8, align 4294967296\nret i32 0"));
    }

    @Test
    public void rejectsNonPowerOfTwoDataLayoutAlignments() {
        for (String layout : new String[]{"e-p:64:24", "e-p:64:64:96", "e-i32:24:32", "e-a:0:24"}) {
            assertThrows(ParsingException.class, () -> parse(layout, "", "ret i32 0"));
        }
    }

    @Test
    public void infersIntegerAllocationAlignments() {
        assertInferredAlignment("e", "i64", 8);
        assertInferredAlignment("e-i32:32:128", "i32", 16);
        // Unlisted widths use the next larger integer width, or the largest available width.
        assertInferredAlignment("e-i32:32:128", "i24", 16);
        assertInferredAlignment("e", "i128", 8);
    }

    @Test
    public void infersArrayAllocationAlignmentsFromElements() {
        assertInferredAlignment("e-i32:32:128", "[3 x i32]", 16);
        assertInferredAlignment("e-i32:32:128", "[2 x [3 x i32]]", 16);
    }

    @Test
    public void infersStructAllocationAlignments() {
        // Member ABI alignment contributes to struct alignment; member preferred alignment does not.
        assertInferredAlignment("e-i32:32:256-a:0:64", "{ i8, i32 }", 8);
        assertInferredAlignment("e-i32:128:256-a:0:64", "{ i8, i32 }", 16);
        assertInferredAlignment("e-i32:32:256-a:128:256", "{ i8, i32 }", 32);
        // Packed members do not raise the aggregate's preferred alignment.
        assertInferredAlignment("e-i32:128:256-a:0:64", "<{ i8, i32 }>", 8);
    }

    @Test
    public void infersNamedStructAllocationAlignments() {
        final Program program = parse("e-i32:128:256-a:0:64",
                "%S = type { i8, i32 }\n@g = global %S zeroinitializer",
                "%p = alloca %S\nret i32 0");
        assertAllocationAlignments(program, 16);
    }

    private static void assertInferredAlignment(String layout, String type, long expected) {
        final Program program = parse(layout, "@g = global " + type + " zeroinitializer",
                "%p = alloca " + type + "\nret i32 0");
        assertAllocationAlignments(program, expected);
    }

    private static void assertAllocationAlignments(Program program, long expected) {
        final Alloc alloc = program.getFunctions().stream().flatMap(function -> function.getEvents(Alloc.class).stream())
                .findFirst().orElseThrow();
        assertEquals(BigInteger.valueOf(expected), ((IntLiteral) alloc.getAlignment()).getValue());
        assertEquals(BigInteger.valueOf(expected),
                ((IntLiteral) program.getMemory().getObjects().iterator().next().alignment()).getValue());
    }

    private static void assertCastPreservesHighBitValue(int pointerWidth, String instruction) {
        final Program program = parse("e-p:" + pointerWidth + ":" + pointerWidth, "",
                "%r = " + instruction + "\nret i32 0");
        final Local assignment = program.getFunctions().stream().flatMap(function -> function.getEvents(Local.class).stream())
                .filter(local -> local.getResultRegister().getName().equals("rr"))
                .findFirst().orElseThrow();
        assertEquals(BigInteger.ONE.shiftLeft(31),
                ((IntLiteral) assignment.getExpr().accept(new ExprSimplifier(true))).getValue());
    }

    private static Program parse(String layout, String globals, String body) {
        return new ParserLlvm().parse(CharStreams.fromString("target datalayout = \"" + layout + "\"\n"
                + globals + "\ndefine i32 @main() {\nentry:\n" + body + "\n}\n"));
    }
}
