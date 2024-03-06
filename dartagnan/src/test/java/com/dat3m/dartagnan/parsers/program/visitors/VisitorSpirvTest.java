package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import org.junit.Test;

import static org.junit.Assert.*;

public class VisitorSpirvTest {

    @Test
    public void testParseOpName() {
        // given
        String input = "OpStore %ptr %value";
        SpirvParser.OpContext ctx = new MockSpirvParser(input).op();

        // when
        String result = VisitorSpirv.parseOpName(ctx);

        // then
        assertEquals("OpStore", result);
    }

    @Test
    public void testParseOpNameRet() {
        // given
        String input = "%res = OpLoad %int %ptr";
        SpirvParser.OpContext ctx = new MockSpirvParser(input).op();

        // when
        String result = VisitorSpirv.parseOpName(ctx);

        // then
        assertEquals("OpLoad", result);
    }

    @Test
    public void testParseOpNameOpSpecConstantOp() {
        // given
        String input = "%res = Op SpecConstantOp %int IMul %value_1 %value_2";
        SpirvParser.OpContext ctx = new MockSpirvParser(input).op();

        // when
        String result = VisitorSpirv.parseOpName(ctx);

        // then
        assertEquals("OpIMul", result);
    }

    @Test
    public void testIsSpecConstantOp() {
        // given
        String input = "OpStore %ptr %value";
        SpirvParser.OpContext ctx = new MockSpirvParser(input).op();

        // when
        boolean result = VisitorSpirv.isSpecConstantOp(ctx);

        // then
        assertFalse(result);
    }

    @Test
    public void testIsSpecConstantOpRet() {
        // given
        String input = "%res = OpLoad %int %ptr";
        SpirvParser.OpContext ctx = new MockSpirvParser(input).op();

        // when
        boolean result = VisitorSpirv.isSpecConstantOp(ctx);

        // then
        assertFalse(result);
    }

    @Test
    public void testIsSpecConstantOpOpSpecConstantOp() {
        // given
        String input = "%res = Op SpecConstantOp %int IMul %value_1 %value_2";
        SpirvParser.OpContext ctx = new MockSpirvParser(input).op();

        // when
        boolean result = VisitorSpirv.isSpecConstantOp(ctx);

        // then
        assertTrue(result);
    }
}
