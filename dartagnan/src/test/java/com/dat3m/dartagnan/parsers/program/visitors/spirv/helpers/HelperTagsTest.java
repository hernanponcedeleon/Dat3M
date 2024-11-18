package com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import org.junit.Test;

import java.util.List;
import java.util.Set;
import java.util.stream.IntStream;

import static com.dat3m.dartagnan.program.event.Tag.Spirv.*;
import static org.junit.Assert.*;

public class HelperTagsTest {

    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private static final IntegerType archType = TypeFactory.getInstance().getArchType();

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
        Expression expr = expressions.makeValue(input, archType);

        // when
        String scope = HelperTags.parseScope("test", expr);

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
        Expression expr = expressions.makeValue(input, archType);

        try {
            // when
            HelperTags.parseScope("test", expr);
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
        Expression expr = expressions.makeValue(input, archType);

        // when
        Set<String> tags = HelperTags.parseMemorySemanticsTags("test", expr);

        // then
        assertEquals(expected, tags);
    }

    @Test
    public void testInvalidSemantics() {
        doTestInvalidSemantics(0x1, "Illegal memory semantics '1': unexpected bits");
        doTestInvalidSemantics(0x3, "Illegal memory semantics '3': unexpected bits");
        doTestInvalidSemantics(0xffff, "Illegal memory semantics '65535': unexpected bits");
        doTestInvalidSemantics(0x6, "Illegal memory semantics '6': multiple non-relaxed memory order bits");
        doTestInvalidSemantics(0x18, "Illegal memory semantics '24': multiple non-relaxed memory order bits");
    }

    private void doTestInvalidSemantics(int input, String error) {
        // given
        Expression expr = expressions.makeValue(input, archType);

        try {
            // when
            HelperTags.parseMemorySemanticsTags("test", expr);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals(error, e.getMessage());
        }
    }

    @Test
    public void testValidMemoryOperands() {
        // Empty
        doTestValidMemoryOperands(Set.of(), "", null, List.of());
        doTestValidMemoryOperands(Set.of(), "None", null, List.of());

        // Non-parametrized
        doTestValidMemoryOperands(Set.of(MEM_VOLATILE), "Volatile", null, List.of());
        doTestValidMemoryOperands(Set.of(MEM_NONTEMPORAL), "Nontemporal", null, List.of());
        doTestValidMemoryOperands(Set.of(MEM_NON_PRIVATE), "NonPrivatePointer", null, List.of());
        doTestValidMemoryOperands(Set.of(MEM_VOLATILE, MEM_NONTEMPORAL, MEM_NON_PRIVATE),
                "Volatile|Nontemporal|NonPrivatePointer", null, List.of());
        doTestValidMemoryOperands(Set.of(MEM_VOLATILE, MEM_NONTEMPORAL, MEM_NON_PRIVATE),
                "NonPrivatePointer|Nontemporal|Volatile", null, List.of());

        // Aligned
        doTestValidMemoryOperands(Set.of(), "Aligned", 4, List.of());
        doTestValidMemoryOperands(Set.of(), "Aligned", 8, List.of());
        doTestValidMemoryOperands(Set.of(MEM_NON_PRIVATE), "NonPrivatePointer|Aligned", 4, List.of());
        doTestValidMemoryOperands(Set.of(MEM_NONTEMPORAL, MEM_NON_PRIVATE, MEM_VISIBLE, DEVICE),
                "Nontemporal|Aligned|NonPrivatePointer|MakePointerVisible", 4, List.of(1));

        // Availability-Visibility
        doTestValidMemoryOperands(Set.of(MEM_NON_PRIVATE, MEM_VISIBLE, DEVICE),
                "NonPrivatePointer|MakePointerVisible", null, List.of(1));
        doTestValidMemoryOperands(Set.of(MEM_NON_PRIVATE, MEM_VISIBLE, DEVICE),
                "NonPrivatePointer|Aligned|MakePointerVisible", 4, List.of(1));
        doTestValidMemoryOperands(Set.of(MEM_VOLATILE, MEM_NONTEMPORAL, MEM_NON_PRIVATE, MEM_VISIBLE, DEVICE),
                "Volatile|Aligned|Nontemporal|NonPrivatePointer|MakePointerVisible", 4, List.of(1));
        // TODO: Uncomment after implementing combined av-vis operands
        //doTestValidMemoryOperands(Set.of(MEM_AVAILABLE, MEM_VISIBLE, DEVICE),
        //        "MakePointerAvailable|MakePointerVisible", null, List.of(1, 2));
    }

    @Test
    public void testInvalidMemoryOperands() {
        // Non-parameterized
        doTestInvalidMemoryOperandsParameters("None", 4, List.of());
        doTestInvalidMemoryOperandsParameters("Volatile", null, List.of(1));
        doTestInvalidMemoryOperandsParameters("Nontemporal", null, List.of(1, 2));
        doTestInvalidMemoryOperandsParameters("NonPrivatePointer", 4, List.of(1));
        doTestInvalidMemoryOperandsParameters("NonPrivatePointerKHR", 4, List.of(1, 2));

        doTestInvalidMemoryOperandsParameters("Volatile|Nontemporal", 4, List.of());
        doTestInvalidMemoryOperandsParameters("Volatile|Nontemporal|NonPrivatePointer", null, List.of(1));
        doTestInvalidMemoryOperandsParameters("Volatile|Nontemporal|NonPrivatePointerKHR", null, List.of(1, 2));
        doTestInvalidMemoryOperandsParameters("NonPrivatePointer|Nontemporal", 4, List.of(1));
        doTestInvalidMemoryOperandsParameters("NonPrivatePointerKHR|Nontemporal|Volatile", 4, List.of(1, 2));

        // Aligned
        doTestInvalidMemoryOperandsParameters("Aligned", null, List.of());
        doTestInvalidMemoryOperandsParameters("Aligned", null, List.of(1));
        doTestInvalidMemoryOperandsParameters("Aligned", null, List.of(1, 2));
        doTestInvalidMemoryOperandsParameters("Aligned", 4, List.of(1));
        doTestInvalidMemoryOperandsParameters("Aligned", 4, List.of(1, 2));

        doTestInvalidMemoryOperandsParameters("Aligned|Volatile", null, List.of());
        doTestInvalidMemoryOperandsParameters("Volatile|Aligned", null, List.of(1));
        doTestInvalidMemoryOperandsParameters("Aligned|MakePointerVisible", null, List.of(1));
        doTestInvalidMemoryOperandsParameters("Aligned|NonPrivatePointer|MakePointerVisible", null, List.of(1));

        // Availability-Visibility
        doTestInvalidMemoryOperandsParameters("MakePointerVisible", null, List.of());
        doTestInvalidMemoryOperandsParameters("MakePointerVisible", 4, List.of());
        doTestInvalidMemoryOperandsParameters("MakePointerVisible", null, List.of(1, 2));
        doTestInvalidMemoryOperandsParameters("MakePointerAvailable", null, List.of());
        doTestInvalidMemoryOperandsParameters("MakePointerAvailable", 4, List.of());
        doTestInvalidMemoryOperandsParameters("MakePointerAvailable", null, List.of(1, 2));

        doTestInvalidMemoryOperandsParameters("NonPrivatePointer|MakePointerAvailable", null, List.of());
        doTestInvalidMemoryOperandsParameters("Aligned|NonPrivatePointer|MakePointerAvailable", 4, List.of(1, 2));
        doTestInvalidMemoryOperandsParameters("MakePointerAvailable|MakePointerVisible", null, List.of(1));
        doTestInvalidMemoryOperandsParameters("MakePointerAvailable|MakePointerVisible", null, List.of(1, 1, 1));
    }

    @Test
    public void testInvalidMemoryOperandsCombinedNone() {
        doTestInvalidMemoryOperandsCombinedWithNone("None|Volatile", null, List.of());
        doTestInvalidMemoryOperandsCombinedWithNone("Volatile|None", null, List.of());
        doTestInvalidMemoryOperandsCombinedWithNone("None|Aligned", 4, List.of());
        doTestInvalidMemoryOperandsCombinedWithNone("Aligned|None", 4, List.of());
        doTestInvalidMemoryOperandsCombinedWithNone("None|MakePointerVisible", null, List.of(1));
        doTestInvalidMemoryOperandsCombinedWithNone("MakePointerVisible|None", null, List.of(1));
        doTestInvalidMemoryOperandsCombinedWithNone("None|Aligned|MakePointerVisible", 4, List.of(1));
        doTestInvalidMemoryOperandsCombinedWithNone("Aligned|None|MakePointerVisible", 4, List.of(1));
        doTestInvalidMemoryOperandsCombinedWithNone("Aligned|MakePointerVisible|None", 4, List.of(1));
    }

    @Test
    public void testInvalidMemoryOperandsDuplicate() {
        // Trivial duplicates
        doTestInvalidMemoryOperandsDuplicate("None|None", null, List.of());
        doTestInvalidMemoryOperandsDuplicate("Volatile|Volatile", null, List.of());
        doTestInvalidMemoryOperandsDuplicate("Volatile|Nontemporal|Volatile|Nontemporal", null, List.of());
        doTestInvalidMemoryOperandsDuplicate("Aligned|Aligned", 4, List.of());
        doTestInvalidMemoryOperandsDuplicate("MakePointerVisible|MakePointerVisible", null, List.of(1));
        doTestInvalidMemoryOperandsDuplicate("MakePointerVisible|MakePointerVisible",null, List.of(1, 2));

        // KHR duplicates
        doTestInvalidMemoryOperandsDuplicate("NonPrivatePointer|NonPrivatePointerKHR", null, List.of());
        doTestInvalidMemoryOperandsDuplicate("MakePointerVisible|MakePointerVisibleKHR", null, List.of(1));
        doTestInvalidMemoryOperandsDuplicate("MakePointerVisible|MakePointerVisibleKHR", null, List.of(1, 2));
        doTestInvalidMemoryOperandsDuplicate("MakePointerAvailable|MakePointerAvailableKHR",null, List.of(1));
        doTestInvalidMemoryOperandsDuplicate("MakePointerAvailable|MakePointerAvailableKHR", null, List.of(1, 2));
    }

    private void doTestInvalidMemoryOperandsParameters(String operand, Integer alignment, List<Integer> params) {
        String error = String.format("Illegal parameter(s) in memory operands definition '%s'", operand);
        doTestInvalidMemoryOperands(error, operand, alignment, params);
    }

    private void doTestInvalidMemoryOperandsDuplicate(String operand, Integer alignment, List<Integer> params) {
        String error = String.format("Duplicated memory operands definition(s) in '%s'", operand);
        doTestInvalidMemoryOperands(error, operand, alignment, params);
    }

    private void doTestInvalidMemoryOperandsCombinedWithNone(String operand, Integer alignment, List<Integer> params) {
        String error = "Memory operand 'None' cannot be combined with other operands";
        doTestInvalidMemoryOperands(error, operand, alignment, params);
    }

    private void doTestInvalidMemoryOperands(String error, String operands, Integer alignment, List<Integer> params) {
        // given
        List<String> operandsList = operands.isEmpty() ? List.of() : List.of(operands.split("\\|"));
        List<String> paramIds = IntStream.range(0, params.size()).boxed().map(idx -> "param_" + idx).toList();
        List<Expression> paramValues = params.stream().map(p -> (Expression) expressions.makeValue(p, archType)).toList();

        try {
            // when
            HelperTags.parseMemoryOperandsTags(operandsList, alignment, paramIds, paramValues);
            fail("Should throw exception");
        } catch (Exception e) {
            // then
            assertEquals(error, e.getMessage());
        }
    }

    private void doTestValidMemoryOperands(Set<String> expected, String operands, Integer alignment, List<Integer> params) {
        // given
        List<String> operandsList = operands.isEmpty() ? List.of() : List.of(operands.split("\\|"));
        List<String> paramIds = IntStream.range(0, params.size()).boxed().map(idx -> "param_" + idx).toList();
        List<Expression> paramValues = params.stream().map(p -> (Expression) expressions.makeValue(p, archType)).toList();

        // when
        Set<String> actual = HelperTags.parseMemoryOperandsTags(operandsList, alignment, paramIds, paramValues);

        // then
        assertEquals(expected, actual);
    }
}
