package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import org.junit.Test;

import static org.junit.Assert.*;

public class VisitorOpsDebugTest {

    private final MockProgramBuilder builder = new MockProgramBuilder();

    @Test
    public void testLegalSourceString() {
        doTestLegalLiteralString("""
                OpSource Unknown 0
        """);
        doTestLegalLiteralString("""
                OpSource Unknown 0 ""
        """);
        doTestLegalLiteralString("""
                OpSource Unknown 0 "source string"
        """);
        doTestLegalLiteralString("""
                OpSource Unknown 0 "multi-
                    multi-
                            multi-
                line source string"
        """);
        doTestLegalLiteralString("""
                OpSource Unknown 0 "multi-line source string

                with empty lines
                "
        """);
        doTestLegalLiteralString("""
                OpSource Unknown 0 "\\"source \\"string\\"
                with escaped quotes\\""
        """);
        doTestLegalLiteralString("""
                OpSource Unknown 0 "\\\\\\"source \\\\\\"string\\\\\\"
                with escaped \\\\\\\\\\"backslashes and quotes\\\\\\""
        """);
        doTestLegalLiteralString("""
                OpSource Unknown 0 "\\"\\\\\\" a _l{o}ng_ [and] \\\\\\"
                multi--line? \\r\\n SOURCE string;
                /with/ !d@i#f$f%e^r&e*n(t) characters \\d \\w ÖÄÅ
                \\"\\\\\\""
        """);
    }

    @Test
    public void testSimpleIllegalSourceString() {
        doTestIllegalLiteralString("""
                OpSource Unknown 0 "illegal" source string
                with unescaped quote"
                """
        );
        doTestIllegalLiteralString("""
                OpSource Unknown 0 "illegal source string
                with "multiple" unescaped quotes"
                """
        );
        doTestIllegalLiteralString("""
                OpSource Unknown 0 ""illegal source string
                with leading duplicated quote"
                """
        );
        doTestIllegalLiteralString("""
                OpSource Unknown 0 "illegal source string
                with trailing duplicated quote""
                """
        );
        doTestIllegalLiteralString("""
                OpSource Unknown 0 "\\\\"illegal source string
                with incorrectly escaped leading quote"
                """
        );
        doTestIllegalLiteralString("""
                OpSource Unknown 0 "illegal source string
                with incorrectly escaped trailing quote\\\\""
                """
        );
        doTestIllegalLiteralString("""
                OpSource Unknown 0 "illegal source string
                with incorrectly escaped \\\\"inner quote"
                """
        );
        doTestIllegalLiteralString("""
                OpSource Unknown 0 "\\\\"illegal source string
                with \\\\"multiple incorrectly escaped quotes\\\\""
                """
        );
    }

    private void doTestLegalLiteralString(String input) {
        Void result = new MockSpirvParser(input).spv().accept(new VisitorOpsDebug(builder));
        assertNull(result);
    }

    private void doTestIllegalLiteralString(String input) {
        try {
            new MockSpirvParser(input).spv().accept(new VisitorOpsDebug(builder));
            fail("Should throw exception");
        } catch (Exception e) {
            assertNotNull(e.getMessage());
        }
    }
}
