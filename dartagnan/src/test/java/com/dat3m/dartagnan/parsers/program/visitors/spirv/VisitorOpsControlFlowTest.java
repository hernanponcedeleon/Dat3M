package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.booleans.BoolLiteral;
import com.dat3m.dartagnan.expression.booleans.BoolUnaryExpr;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockProgramBuilderSpv;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.IfAsJump;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Skip;
import com.dat3m.dartagnan.program.event.functions.Return;
import org.junit.Test;

import java.util.List;
import java.util.Map;

import static org.junit.Assert.*;

public class VisitorOpsControlFlowTest {

    private final MockProgramBuilderSpv builder = new MockProgramBuilderSpv();

    @Test
    public void testOpPhi() {
        // given
        String input = "%phi = OpPhi %int %value1 %label1 %value2 %label2";
        builder.mockFunctionStart();
        builder.mockIntType("%int", 64);

        // when
        visit(input);

        // then
        Register register = builder.getRegister("%phi");
        assertEquals(builder.getType("%int"), register.getType());

        Label label1 = builder.getOrCreateLabel("%label1");
        Map<Register, String> phi1 = builder.getPhiDefinitions(label1);
        assertEquals(1, phi1.size());
        assertEquals("%value1", phi1.get(register));

        Label label2 = builder.getOrCreateLabel("%label2");
        Map<Register, String> phi2 = builder.getPhiDefinitions(label2);
        assertEquals(1, phi2.size());
        assertEquals("%value2", phi2.get(register));
    }

    @Test
    public void testOpLabel() {
        // given
        String input = """
                %label1 = OpLabel
                %label2 = OpLabel
                """;
        builder.mockFunctionStart();

        // when
        visit(input);

        // then
        Label label1 = builder.getOrCreateLabel("%label1");
        Label label2 = builder.getOrCreateLabel("%label2");
        assertEquals(List.of(label2, label1), builder.getBlocks());

        // when
        builder.endBlock(new Skip());

        // then
        assertEquals(List.of(label1), builder.getBlocks());

        // when
        builder.endBlock(new Skip());

        // then
        assertEquals(List.of(), builder.getBlocks());
    }

    @Test
    public void testOpBranch() {
        // given
        String input = """
                %label = OpLabel
                OpBranch %label
                """;
        builder.mockFunctionStart();

        // when
        visit(input);

        // then
        Function function = builder.getCurrentFunction();
        CondJump event = (CondJump) function.getEvents().get(1);
        assertTrue(((BoolLiteral) (event.getGuard())).getValue());
        assertEquals(builder.getOrCreateLabel("%label"), event.getLabel());
        assertTrue(builder.getBlocks().isEmpty());
    }

    @Test
    public void testOpBranchNested() {
        // given
        String input = """
                %label1 = OpLabel
                %label2 = OpLabel
                OpBranch %label3
                %label3 = OpLabel
                OpBranch %label2
                """;
        builder.mockFunctionStart();

        // when
        visit(input);

        // then
        Function function = builder.getCurrentFunction();

        CondJump event1 = (CondJump) function.getEvents().get(2);
        assertTrue(((BoolLiteral) (event1.getGuard())).getValue());
        assertEquals(builder.getOrCreateLabel("%label3"), event1.getLabel());

        CondJump event2 = (CondJump) function.getEvents().get(4);
        assertTrue(((BoolLiteral) (event2.getGuard())).getValue());
        assertEquals(builder.getOrCreateLabel("%label2"), event2.getLabel());

        assertEquals(List.of(builder.getOrCreateLabel("%label1")), builder.getBlocks());
    }

    @Test
    public void testStructuredBranch() {
        // given
        String input = """
                %label0 = OpLabel
                OpSelectionMerge %label2 None
                OpBranchConditional %value %label1 %label2
                %label1 = OpLabel
                OpBranch %label2
                %label2 = OpLabel
                OpReturn
                """;

        builder.mockFunctionStart();
        builder.mockBoolType("%bool");
        builder.mockRegister("%value", "%bool");

        // when
        visit(input);

        // then
        List<Event> events = builder.getCurrentFunction().getEvents();

        Label label0 = (Label) events.get(0);
        IfAsJump ifJump = (IfAsJump) events.get(1);
        Label label1 = (Label) events.get(2);
        CondJump jump = (CondJump) events.get(3);
        Label label2 = (Label) events.get(4);
        Return ret = (Return) events.get(5);

        Label label2End = builder.getCfDefinition().get(label2);

        assertEquals(label2, ifJump.getLabel());
        assertEquals(label2End, ifJump.getEndIf());
        assertTrue(jump.isGoto());
        assertEquals(label2, jump.getLabel());

        assertEquals(ifJump, builder.getBlockEndEvents().get(label0));
        assertEquals(jump, builder.getBlockEndEvents().get(label1));
        assertEquals(ret, builder.getBlockEndEvents().get(label2));
    }

    @Test
    public void testStructuredBranchNestedTrue() {
        // given
        String input = """
                %label0 = OpLabel
                OpSelectionMerge %label2 None
                OpBranchConditional %value %label1 %label2
                %label1 = OpLabel
                OpSelectionMerge %label2_inner None
                OpBranchConditional %value %label1_inner %label2_inner
                %label1_inner = OpLabel
                OpBranch %label2_inner
                %label2_inner = OpLabel
                OpBranch %label2
                %label2 = OpLabel
                OpReturn
                """;

        builder.mockFunctionStart();
        builder.mockBoolType("%bool");
        builder.mockRegister("%value", "%bool");

        // when
        visit(input);

        // then
        List<Event> events = builder.getCurrentFunction().getEvents();

        Label label0 = (Label) events.get(0);
        IfAsJump ifJump = (IfAsJump) events.get(1);
        Label label1 = (Label) events.get(2);
        IfAsJump ifJumpInner = (IfAsJump) events.get(3);
        Label label1Inner = (Label) events.get(4);
        CondJump jumpInner = (CondJump) events.get(5);
        Label label2Inner = (Label) events.get(6);
        CondJump jump = (CondJump) events.get(7);
        Label label2 = (Label) events.get(8);
        Return ret = (Return) events.get(9);

        Label label2End = builder.getCfDefinition().get(label2);
        Label label2EndInner = builder.getCfDefinition().get(label2Inner);

        assertEquals(label2, ifJump.getLabel());
        assertEquals(label2End, ifJump.getEndIf());
        assertEquals(label2Inner, ifJumpInner.getLabel());
        assertEquals(label2EndInner, ifJumpInner.getEndIf());

        assertTrue(jump.isGoto());
        assertEquals(label2, jump.getLabel());
        assertTrue(jumpInner.isGoto());
        assertEquals(label2Inner, jumpInner.getLabel());

        assertEquals(ifJump, builder.getBlockEndEvents().get(label0));
        assertEquals(ifJumpInner, builder.getBlockEndEvents().get(label1));
        assertEquals(jumpInner, builder.getBlockEndEvents().get(label1Inner));
        assertEquals(jump, builder.getBlockEndEvents().get(label2Inner));
        assertEquals(ret, builder.getBlockEndEvents().get(label2));
    }

    @Test
    public void testStructuredBranchNestedFalse() {
        // given
        String input = """
                %label0 = OpLabel
                OpSelectionMerge %label2 None
                OpBranchConditional %value %label1 %label2
                %label1 = OpLabel
                OpBranch %label2
                %label2 = OpLabel
                OpSelectionMerge %label2_inner None
                OpBranchConditional %value %label1_inner %label2_inner
                %label1_inner = OpLabel
                OpBranch %label2_inner
                %label2_inner = OpLabel
                OpReturn
                """;

        builder.mockFunctionStart();
        builder.mockBoolType("%bool");
        builder.mockRegister("%value", "%bool");

        // when
        visit(input);

        // then
        List<Event> events = builder.getCurrentFunction().getEvents();

        Label label0 = (Label) events.get(0);
        IfAsJump ifJump = (IfAsJump) events.get(1);
        Label label1 = (Label) events.get(2);
        CondJump jump = (CondJump) events.get(3);
        Label label2 = (Label) events.get(4);
        IfAsJump ifJumpInner = (IfAsJump) events.get(5);
        Label label1Inner = (Label) events.get(6);
        CondJump jumpInner = (CondJump) events.get(7);
        Label label2Inner = (Label) events.get(8);
        Return ret = (Return) events.get(9);

        Label label2End = builder.getCfDefinition().get(label2);
        Label label2EndInner = builder.getCfDefinition().get(label2Inner);

        assertEquals(label2, ifJump.getLabel());
        assertEquals(label2End, ifJump.getEndIf());
        assertEquals(label2Inner, ifJumpInner.getLabel());
        assertEquals(label2EndInner, ifJumpInner.getEndIf());

        assertTrue(jump.isGoto());
        assertEquals(label2, jump.getLabel());
        assertTrue(jumpInner.isGoto());
        assertEquals(label2Inner, jumpInner.getLabel());

        assertEquals(ifJump, builder.getBlockEndEvents().get(label0));
        assertEquals(jump, builder.getBlockEndEvents().get(label1));
        assertEquals(ifJumpInner, builder.getBlockEndEvents().get(label2));
        assertEquals(jumpInner, builder.getBlockEndEvents().get(label1Inner));
        assertEquals(ret, builder.getBlockEndEvents().get(label2Inner));
    }

    @Test
    public void testStructuredBranchNestedSameLabel() {
        // given
        String input = """
                %label0 = OpLabel
                OpSelectionMerge %label2 None
                OpBranchConditional %value %label1 %label2
                %label1 = OpLabel
                OpSelectionMerge %label2 None
                OpBranchConditional %value %label1_inner %label2
                %label1_inner = OpLabel
                OpBranch %label2
                %label2 = OpLabel
                OpReturn
                """;

        builder.mockFunctionStart();
        builder.mockBoolType("%bool");
        builder.mockRegister("%value", "%bool");

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Overlapping blocks with endpoint in label '%label2'",
                    e.getMessage());
        }
    }

    @Test
    public void testStructuredLoop() {
        // given
        String input = """
                %label0 = OpLabel
                OpLoopMerge %label1 %label0 None
                OpBranchConditional %value %label1 %label0
                %label1 = OpLabel
                OpReturn
                """;

        builder.mockFunctionStart();
        builder.mockBoolType("%bool");
        builder.mockRegister("%value", "%bool");

        // when
        visit(input);

        // then
        List<Event> events = builder.getCurrentFunction().getEvents();

        Label label0 = (Label) events.get(0);
        IfAsJump ifJump = (IfAsJump) events.get(1);
        CondJump jump = (CondJump) events.get(2);
        Label label1 = (Label) events.get(3);
        Return ret = (Return) events.get(4);

        assertTrue(builder.getCfDefinition().isEmpty());

        assertEquals(label1, ifJump.getLabel());
        assertEquals(label1, ifJump.getEndIf());
        assertTrue(jump.isGoto());
        assertEquals(label0, jump.getLabel());

        assertEquals(ifJump, builder.getBlockEndEvents().get(label0));
        assertEquals(ret, builder.getBlockEndEvents().get(label1));
    }

    @Test
    public void testStructuredBranchBackwardTrue() {
        doTestIllegalStructuredBranch("""
                        %label0 = OpLabel
                        OpSelectionMerge %label1 None
                        OpBranchConditional %value1 %label0 %label1
                        %label1 = OpLabel
                        OpReturn
                        """,
                "Illegal backward jump to label '%label0' " +
                        "from a structured branch");
    }

    @Test
    public void testStructuredBranchBackwardFalse() {
        doTestIllegalStructuredBranch("""
                        %label0 = OpLabel
                        OpSelectionMerge %label0 None
                        OpBranchConditional %value1 %label1 %label0
                        %label1 = OpLabel
                        OpReturn
                        """,
                "Illegal backward jump to label '%label0' " +
                        "from a structured branch");
    }

    @Test
    public void testLoopMergeBackward() {
        doTestIllegalStructuredBranch("""
                        %label2 = OpLabel
                        OpBranch %label0
                        %label0 = OpLabel
                        OpLoopMerge %label2 %label0 None
                        OpBranchConditional %value1 %label2 %label0
                        %label1 = OpLabel
                        OpReturn
                        """,
                "Illegal backward jump to label '%label2' " +
                        "from a structured branch");
    }

    @Test
    public void testLoopContinueForward() {
        doTestIllegalStructuredBranch("""
                        %label0 = OpLabel
                        OpLoopMerge %label1 %label2 None
                        OpBranchConditional %value1 %label1 %label2
                        %label1 = OpLabel
                        OpBranch %label2
                        %label2 = OpLabel
                        OpReturn
                        """,
                "Illegal forward jump to label '%label2' " +
                        "from a structured loop");
    }

    @Test
    public void testStructuredBranchIllegalMergeLabel() {
        doTestIllegalStructuredBranch("""
                        %label0 = OpLabel
                        OpSelectionMerge %label3 None
                        OpBranchConditional %value1 %label1 %label2
                        %label1 = OpLabel
                        OpBranch %label2
                        %label2 = OpLabel
                        OpBranch %label3
                        %label3 = OpLabel
                        OpReturn
                        """,
                "Illegal last label in conditional branch, " +
                        "expected '%label3' but received '%label2'");
    }

    @Test
    public void testStructuredBranchLabelsIllegalOrder() {
        doTestIllegalStructuredBranch("""
                        %label0 = OpLabel
                        OpSelectionMerge %label1 None
                        OpBranchConditional %value1 %label2 %label1
                        %label1 = OpLabel
                        OpBranch %label2
                        %label2 = OpLabel
                        OpReturn
                        """,
                "Illegal label, expected '%label2' but received '%label1'");
    }

    @Test
    public void testOpLoopLabelsIllegalContinueLabel() {
        doTestIllegalStructuredBranch("""
                        %label0 = OpLabel
                        OpLoopMerge %label1 %label2 None
                        OpBranchConditional %value1 %label1 %label0
                        %label1 = OpLabel
                        OpBranch %label2
                        %label2 = OpLabel
                        OpReturn
                        """,
                "Illegal labels, expected mergeLabel='%label1' " +
                        "and continueLabel='%label2' but received " +
                        "mergeLabel='%label1' and continueLabel='%label0'");
    }

    @Test
    public void testOpLoopLabelsIllegalMergeLabel() {
        doTestIllegalStructuredBranch("""
                        %label0 = OpLabel
                        OpLoopMerge %label2 %label0 None
                        OpBranchConditional %value1 %label1 %label0
                        %label1 = OpLabel
                        OpBranch %label2
                        %label2 = OpLabel
                        OpReturn
                        """,
                "Illegal labels, expected mergeLabel='%label2' " +
                        "and continueLabel='%label0' but received " +
                        "mergeLabel='%label1' and continueLabel='%label0'");
    }

    @Test
    public void testOpLoopLabelsIllegalOrder() {
        doTestIllegalStructuredBranch("""
                        %label0 = OpLabel
                        OpLoopMerge %label1 %label0 None
                        OpBranchConditional %value1 %label0 %label1
                        %label1 = OpLabel
                        OpReturn
                        """,
                "Illegal labels, expected mergeLabel='%label1' " +
                        "and continueLabel='%label0' but received " +
                        "mergeLabel='%label0' and continueLabel='%label1'");
    }

    private void doTestIllegalStructuredBranch(String input, String error) {
        // given
        builder.mockFunctionStart();
        builder.mockBoolType("%bool");
        builder.mockRegister("%value1", "%bool");

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals(error, e.getMessage());
        }
    }

    @Test
    public void testOpBranchConditionalUnstructured() {
        // given
        String input = """
                %label0 = OpLabel
                OpBranchConditional %value1 %label2 %label3
                %label2 = OpLabel
                OpBranchConditional %value2 %label3 %label1
                %label3 = OpLabel
                OpReturn
                """;
        builder.mockFunctionStart();
        builder.mockBoolType("%bool");
        builder.mockRegister("%value1", "%bool");
        builder.mockRegister("%value2", "%bool");

        // when
        visit(input);

        // then
        List<Event> events = builder.getCurrentFunction().getEvents();

        CondJump event1 = (CondJump) events.get(1);
        assertEquals("%value1", getGuardRegister(event1).getName());
        assertEquals(builder.getOrCreateLabel("%label2"), event1.getLabel());

        CondJump event2 = (CondJump) events.get(2);
        assertEquals("%value1", getGuardRegister(event2).getName());
        assertEquals(builder.getOrCreateLabel("%label3"), event2.getLabel());

        CondJump event4 = (CondJump) events.get(4);
        assertEquals("%value2", getGuardRegister(event4).getName());
        assertEquals(builder.getOrCreateLabel("%label3"), event4.getLabel());

        CondJump event5 = (CondJump) events.get(5);
        assertEquals("%value2", getGuardRegister(event5).getName());
        assertEquals(builder.getOrCreateLabel("%label1"), event5.getLabel());

        assertTrue(builder.getBlocks().isEmpty());
    }

    @Test
    public void testOpBranchConditionalSameLabels() {
        // given
        String input = """
                %label0 = OpLabel
                OpBranchConditional %value %label1 %label1
                """;
        builder.mockFunctionStart();
        builder.mockBoolType("%bool");
        builder.mockRegister("%value", "%bool");

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Labels of conditional branch cannot be the same",
                    e.getMessage());
        }
    }

    @Test
    public void testOpLabelRedefining() {
        // given
        String input = """
                %label = OpLabel
                OpBranch %label
                %label = OpLabel
                """;
        builder.mockFunctionStart();

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Attempt to redefine label '%label'", e.getMessage());
        }
    }

    @Test
    public void testReturn() {
        // given
        builder.mockVoidType("%void");
        FunctionType fType = builder.mockFunctionType("%void_func", "%void");
        builder.startFunctionDefinition("%func", fType, List.of());
        builder.mockLabel("%label");

        // when
        visit("OpReturn");

        // then
        Function function = builder.getCurrentFunction();
        Return event = (Return) function.getEvents().get(1);
        assertNotNull(event);
        assertTrue(event.getValue().isEmpty());
        assertTrue(builder.getBlocks().isEmpty());
    }

    @Test
    public void testReturnValue() {
        // given
        builder.mockIntType("%int", 64);
        builder.mockConstant("%value", "%int", 5);
        FunctionType fType = builder.mockFunctionType("%int_func", "%int");
        builder.startFunctionDefinition("%func", fType, List.of());
        builder.mockLabel("%label");

        // when
        visit("OpReturnValue %value");

        // then
        Function function = builder.getCurrentFunction();
        Return event = (Return) function.getEvents().get(1);
        assertEquals(builder.getExpression("%value"), event.getValue().orElseThrow());
        assertTrue(builder.getBlocks().isEmpty());
    }

    @Test
    public void testReturnForValueFunction() {
        // given
        builder.mockVoidType("%void");
        builder.mockIntType("%int", 64);
        builder.mockConstant("%value", "%int", 5);
        FunctionType fType = builder.mockFunctionType("%int_func", "%int");
        builder.startFunctionDefinition("%func", fType, List.of());
        builder.mockLabel("%label");

        try {
            // when
            visit("OpReturn");
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal non-value return for a non-void function '%func'",
                    e.getMessage());
        }
    }

    @Test
    public void testReturnValueForVoidFunction() {
        // given
        builder.mockVoidType("%void");
        builder.mockIntType("%int", 64);
        builder.mockConstant("%value", "%int", 5);
        FunctionType fType = builder.mockFunctionType("%void_func", "%void");
        builder.startFunctionDefinition("%func", fType, List.of());
        builder.mockLabel("%label");

        try {
            // when
            visit("OpReturnValue %value");
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal value return for a void function '%func'", e.getMessage());
        }
    }

    private Register getGuardRegister(CondJump event) {
        Expression guard = event.getGuard();
        if (guard instanceof Register register) {
            return register;
        }
        if (guard instanceof BoolUnaryExpr expr) {
            return (Register) expr.getOperand();
        }
        throw new RuntimeException("Unexpected expression type");
    }

    private void visit(String text) {
        new MockSpirvParser(text).spv().accept(new VisitorOpsControlFlow(builder));
    }
}
