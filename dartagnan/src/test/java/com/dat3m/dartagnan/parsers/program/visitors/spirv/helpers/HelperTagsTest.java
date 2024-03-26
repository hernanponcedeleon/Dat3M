package com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import org.junit.Test;

import java.util.Set;

import static com.dat3m.dartagnan.program.event.Tag.Spirv.*;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

public class HelperTagsTest {

    private static final ExpressionFactory EXPR_FACTORY = ExpressionFactory.getInstance();
    private static final IntegerType TYPE = TypeFactory.getInstance().getArchType();
    private final HelperTags helper = new HelperTags();

    @Test
    public void testValidScope() {
        doTestValidScope(0, CROSS_DEVICE);
        doTestValidScope(1, DEVICE);
        doTestValidScope(2, WORKGROUP);
        doTestValidScope(3, SUBGROUP);
        doTestValidScope(4, INVOCATION);
        doTestValidScope(5, QUEUE_FAMILY);
        doTestValidScope(6, SHADER_CALL);
    }

    private void doTestValidScope(int input, String expected) {
        // given
        Expression expr = EXPR_FACTORY.makeValue(input, TYPE);

        // when
        String scope = helper.visitScope("test", expr);

        // then
        assertEquals(expected, scope);
    }

    @Test
    public void testInvalidScope() {
        doTestInvalidScope(7, "Illegal scope value 7");
        doTestInvalidScope(-1, "Illegal scope value -1");
    }

    private void doTestInvalidScope(int input, String error) {
        // given
        Expression expr = EXPR_FACTORY.makeValue(input, TYPE);

        try {
            // when
            helper.visitScope("test", expr);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals(error, e.getMessage());
        }
    }

    @Test
    public void testValidMemorySemantics() {
        doTestValidSemantics(0x0, Set.of(RELAXED));
        doTestValidSemantics(0x10, Set.of(SEQ_CST));
        doTestValidSemantics(0x40, Set.of(RELAXED, SEM_UNIFORM));
        doTestValidSemantics(0x42, Set.of(ACQUIRE, SEM_UNIFORM));
        doTestValidSemantics(0x44, Set.of(RELEASE, SEM_UNIFORM));
        doTestValidSemantics(0x48, Set.of(ACQ_REL, SEM_UNIFORM));
        doTestValidSemantics(0x50, Set.of(SEQ_CST, SEM_UNIFORM));
        doTestValidSemantics(0x90, Set.of(SEQ_CST, SEM_SUBGROUP));
        doTestValidSemantics(0x110, Set.of(SEQ_CST, SEM_WORKGROUP));
        doTestValidSemantics(0x210, Set.of(SEQ_CST, SEM_CROSS_WORKGROUP));
        doTestValidSemantics(0x410, Set.of(SEQ_CST, SEM_ATOMIC_COUNTER));
        doTestValidSemantics(0x810, Set.of(SEQ_CST, SEM_IMAGE));
        doTestValidSemantics(0x1010, Set.of(SEQ_CST, SEM_OUTPUT));
        doTestValidSemantics(0xd0, Set.of(SEQ_CST, SEM_UNIFORM, SEM_SUBGROUP));
        doTestValidSemantics(0xf10, Set.of(SEQ_CST, SEM_WORKGROUP, SEM_CROSS_WORKGROUP,
                SEM_ATOMIC_COUNTER, SEM_IMAGE));
        doTestValidSemantics(0xfd0, Set.of(SEQ_CST, SEM_UNIFORM, SEM_SUBGROUP, SEM_WORKGROUP,
                SEM_CROSS_WORKGROUP, SEM_ATOMIC_COUNTER, SEM_IMAGE));
        doTestValidSemantics(0x2010, Set.of(SEQ_CST, SEM_AVAILABLE));
        doTestValidSemantics(0x4010, Set.of(SEQ_CST, SEM_VISIBLE));
        doTestValidSemantics(0x6108, Set.of(ACQ_REL, SEM_WORKGROUP, SEM_AVAILABLE, SEM_VISIBLE));
        doTestValidSemantics(0x8010, Set.of(SEQ_CST, SEM_VOLATILE));
        doTestValidSemantics(0xe010, Set.of(SEQ_CST, SEM_AVAILABLE, SEM_VISIBLE, SEM_VOLATILE));
        doTestValidSemantics(0xefd0, Set.of(SEQ_CST, SEM_AVAILABLE, SEM_VISIBLE, SEM_VOLATILE,
                SEM_UNIFORM, SEM_SUBGROUP, SEM_WORKGROUP, SEM_CROSS_WORKGROUP, SEM_ATOMIC_COUNTER, SEM_IMAGE));
    }

    public void doTestValidSemantics(int input, Set<String> expected) {
        // given
        Expression expr = EXPR_FACTORY.makeValue(input, TYPE);

        // when
        Set<String> tags = helper.visitIdMemorySemantics("test", expr);

        // then
        assertEquals(expected, tags);
    }

    @Test
    public void testInvalidSemantics() {
        doTestInvalidSemantics(0x1, "Unexpected memory semantics bits");
        doTestInvalidSemantics(0x3, "Unexpected memory semantics bits");
        doTestInvalidSemantics(0xffff, "Unexpected memory semantics bits");
        doTestInvalidSemantics(0x6, "Selected multiple non-relaxed memory order bits");
        doTestInvalidSemantics(0x18, "Selected multiple non-relaxed memory order bits");
    }

    private void doTestInvalidSemantics(int input, String error) {
        // given
        Expression expr = EXPR_FACTORY.makeValue(input, TYPE);

        try {
            // when
            helper.visitIdMemorySemantics("test", expr);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals(error, e.getMessage());
        }
    }
}
