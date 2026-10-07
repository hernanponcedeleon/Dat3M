package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.processing.ExprSimplifier;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.core.Alloc;
import com.dat3m.dartagnan.program.event.core.Local;
import org.antlr.v4.runtime.CharStreams;
import org.junit.Test;

import java.math.BigInteger;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertThrows;
import static org.junit.Assert.assertTrue;

public class ParserLlvmTest {

    @Test
    public void pointerCastsZeroExtend() {
        for (String pointer : new String[]{"ptr", "i8*"}) {
            assertCastValue(32, "ptrtoint " + pointer + " inttoptr (i64 2147483648 to " + pointer + ") to i64");
            assertCastValue(64, "inttoptr i32 2147483648 to " + pointer);
            assertCastValue(32, "add i64 ptrtoint (" + pointer
                    + " inttoptr (i64 2147483648 to " + pointer + ") to i64), 0");
            assertCastValue(64, "ptrtoint " + pointer + " inttoptr (i32 2147483648 to " + pointer + ") to i64");
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
    public void acceptsLargeExplicitAllocationAlignments() {
        for (long alignment : new long[]{1L << 31, 1L << 32}) {
            final Program program = parse("e-p:64:64", "@g = global i8 0, align " + alignment,
                    "%p = alloca i8, align " + alignment + "\nret i32 0");
            final Alloc alloc = program.getFunctions().stream().flatMap(function -> function.getEvents().stream())
                    .filter(Alloc.class::isInstance).map(Alloc.class::cast).findFirst().orElseThrow();
            assertEquals(BigInteger.valueOf(alignment), ((IntLiteral) alloc.getAlignment()).getValue());
            assertEquals(BigInteger.valueOf(alignment),
                    ((IntLiteral) program.getMemory().getObjects().iterator().next().alignment()).getValue());
        }
    }

    @Test
    public void rejectsInvalidOrUnrepresentableAllocationAlignments() {
        for (long alignment : new long[]{3, 1L << 33}) {
            assertThrows(ParsingException.class, () -> parse("e-p:64:64", "",
                    "%p = alloca i8, align " + alignment + "\nret i32 0"));
        }
        assertThrows(ParsingException.class, () -> parse("e-p:32:32", "",
                "%p = alloca i8, align 4294967296\nret i32 0"));
    }

    private static void assertCastValue(int pointerWidth, String instruction) {
        final Program program = parse("e-p:" + pointerWidth + ":" + pointerWidth, "",
                "%r = " + instruction + "\nret i32 0");
        final Local assignment = program.getFunctions().stream().flatMap(function -> function.getEvents().stream())
                .filter(Local.class::isInstance).map(Local.class::cast)
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
