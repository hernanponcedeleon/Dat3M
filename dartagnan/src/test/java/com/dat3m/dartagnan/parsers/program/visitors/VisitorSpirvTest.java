package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import org.junit.Test;

import static org.junit.Assert.*;

public class VisitorSpirvTest {

    @Test
    public void testParseOpName() {
        doTestParseInstruction("OpStore %ptr %value", "OpStore");
    }

    @Test
    public void testParseOpNameRet() {
        doTestParseInstruction("%res = OpLoad %int %ptr", "OpLoad");
    }

    @Test
    public void testParseOpNameOpSpecConstantOp() {
        doTestParseInstruction("%res = Op SpecConstantOp %int IMul %value_1 %value_2", "OpIMul");
    }

    private void doTestParseInstruction(String input, String expected) {
        // given
        SpirvParser.OpContext ctx = new MockSpirvParser(input).op();

        // when
        String result = new VisitorSpirv().parseOpName(ctx);

        // then
        assertEquals(expected, result);
    }

    @Test
    public void testIsSpecConstantOp() {
        // given
        String input = "OpStore %ptr %value";
        SpirvParser.OpContext ctx = new MockSpirvParser(input).op();

        // when
        boolean result = new VisitorSpirv().isSpecConstantOp(ctx);

        // then
        assertFalse(result);
    }

    @Test
    public void testIsSpecConstantOpRet() {
        // given
        String input = "%res = OpLoad %int %ptr";
        SpirvParser.OpContext ctx = new MockSpirvParser(input).op();

        // when
        boolean result = new VisitorSpirv().isSpecConstantOp(ctx);

        // then
        assertFalse(result);
    }

    @Test
    public void testIsSpecConstantOpOpSpecConstantOp() {
        // given
        String input = "%res = Op SpecConstantOp %int IMul %value_1 %value_2";
        SpirvParser.OpContext ctx = new MockSpirvParser(input).op();

        // when
        boolean result = new VisitorSpirv().isSpecConstantOp(ctx);

        // then
        assertTrue(result);
    }
}
