package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.booleans.BoolLiteral;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockControlFlowBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockProgramBuilder;
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

    private final MockProgramBuilder builder = new MockProgramBuilder();
    private final MockControlFlowBuilder cfBuilder = (MockControlFlowBuilder) builder.getControlFlowBuilder();

    @Test
    public void testOpPhi() {
        // given
        String input = "%phi = OpPhi %int %value1 %label1 %value2 %label2";
        builder.mockIntType("%int", 64);
        builder.mockFunctionStart(false);

        // when
        visit(input);

        // then
        Register register = builder.getCurrentFunction().getRegister("%phi");
        assertEquals(builder.getType("%int"), register.getType());

        Map<Register, String> phi1 = cfBuilder.getPhiDefinitions("%label1");
        assertEquals(1, phi1.size());
        assertEquals("%value1", phi1.get(register));

        Map<Register, String> phi2 = cfBuilder.getPhiDefinitions("%label2");
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

        builder.mockFunctionStart(false);

        // when
        visit(input);

        // then
        assertEquals(List.of("%label2", "%label1"), cfBuilder.getBlockStack());

        // when
        cfBuilder.endBlock(new Skip());

        // then
        assertEquals(List.of("%label1"), cfBuilder.getBlockStack());

        // when
        cfBuilder.endBlock(new Skip());

        // then
        assertEquals(List.of(), cfBuilder.getBlockStack());
    }

    @Test
    public void testOpBranch() {
        // given
        String input = """
                %label = OpLabel
                OpBranch %label
                """;

        builder.mockFunctionStart(false);

        // when
        visit(input);

        // then
        Function function = builder.getCurrentFunction();
        CondJump condJump = (CondJump) function.getEvents().get(1);
        assertTrue(((BoolLiteral) (condJump.getGuard())).getValue());
        assertEquals("%label", condJump.getLabel().getName());
        assertTrue(cfBuilder.getBlockStack().isEmpty());
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

        builder.mockFunctionStart(false);

        // when
        visit(input);

        // then
        Function function = builder.getCurrentFunction();

        CondJump condJump1 = (CondJump) function.getEvents().get(2);
        assertTrue(((BoolLiteral) (condJump1.getGuard())).getValue());
        assertEquals("%label3", condJump1.getLabel().getName());

        CondJump condJump2 = (CondJump) function.getEvents().get(4);
        assertTrue(((BoolLiteral) (condJump2.getGuard())).getValue());
        assertEquals("%label2", condJump2.getLabel().getName());

        assertEquals(List.of("%label1"), cfBuilder.getBlockStack());
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

        builder.mockBoolType("%bool");
        builder.mockUndefinedValue("%value", "%bool");
        builder.mockFunctionStart(false);

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

        assertEquals("%label0", label0.getName());
        assertEquals("%label2", ifJump.getLabel().getName());
        assertEquals("%label2_end", ifJump.getEndIf().getName());
        assertEquals("%label1", label1.getName());
        assertEquals("%label2", jump.getLabel().getName());
        assertEquals("%label2", label2.getName());

        assertTrue(jump.isGoto());
        assertEquals(Map.of("%label2", "%label2_end"), cfBuilder.getMergeLabelIds());
        assertEquals(Map.of("%label0", ifJump, "%label1", jump, "%label2", ret),
                cfBuilder.getLastBlockEvents());
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

        builder.mockFunctionStart(false);
        builder.mockBoolType("%bool");
        builder.mockUndefinedValue("%value", "%bool");

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

        assertEquals("%label0", label0.getName());
        assertEquals("%label2", ifJump.getLabel().getName());
        assertEquals("%label2_end", ifJump.getEndIf().getName());
        assertEquals("%label1", label1.getName());
        assertEquals("%label2_inner", ifJumpInner.getLabel().getName());
        assertEquals("%label2_inner_end", ifJumpInner.getEndIf().getName());
        assertEquals("%label1_inner", label1Inner.getName());
        assertEquals("%label2_inner", jumpInner.getLabel().getName());
        assertEquals("%label2_inner", label2Inner.getName());
        assertEquals("%label2", jump.getLabel().getName());
        assertEquals("%label2", jump.getLabel().getName());
        assertEquals("%label2", label2.getName());

        assertTrue(jump.isGoto());
        assertTrue(jumpInner.isGoto());

        assertEquals(Map.of(
                "%label0", ifJump,
                "%label1", ifJumpInner,
                "%label1_inner", jumpInner,
                "%label2_inner", jump,
                "%label2", ret
        ), cfBuilder.getLastBlockEvents());
    }

    @Test
    public void testStructuredBranchNestedFalse() {
        // given
        String input = """
                %label0 = OpLabel
                OpSelectionMerge %label2 None
                OpBranchConditional %value %label1 %label3
                %label1 = OpLabel
                OpBranch %label2
                %label2 = OpLabel
                OpSelectionMerge %label2_inner None
                OpBranchConditional %value %label1_inner %label2_inner
                %label1_inner = OpLabel
                OpBranch %label2_inner
                %label2_inner = OpLabel
                OpBranch %label3
                %label3 = OpLabel
                OpReturn
                """;

        builder.mockFunctionStart(false);
        builder.mockBoolType("%bool");
        builder.mockUndefinedValue("%value", "%bool");

        // when
        visit(input);

        // then
        List<Event> events = builder.getCurrentFunction().getEvents();

        Label label0 = (Label) events.get(0);
        IfAsJump ifJump = (IfAsJump) events.get(1);
        Label label1 = (Label) events.get(2);
        CondJump jump1 = (CondJump) events.get(3);
        Label label2 = (Label) events.get(4);
        IfAsJump ifJumpInner = (IfAsJump) events.get(5);
        Label label1Inner = (Label) events.get(6);
        CondJump jumpInner = (CondJump) events.get(7);
        Label label2Inner = (Label) events.get(8);
        CondJump jump2 = (CondJump) events.get(9);
        Label label3 = (Label) events.get(10);
        Return ret = (Return) events.get(11);

        assertEquals("%label0", label0.getName());
        assertEquals("%label3", ifJump.getLabel().getName());
        assertEquals("%label3_end", ifJump.getEndIf().getName());
        assertEquals("%label2", jump1.getLabel().getName());
        assertEquals("%label1", label1.getName());
        assertEquals("%label2", label2.getName());
        assertEquals("%label2_inner", ifJumpInner.getLabel().getName());
        assertEquals("%label2_inner_end", ifJumpInner.getEndIf().getName());
        assertEquals("%label1_inner", label1Inner.getName());
        assertEquals("%label2_inner", jumpInner.getLabel().getName());
        assertEquals("%label2_inner", label2Inner.getName());
        assertEquals("%label3", jump2.getLabel().getName());
        assertEquals("%label3", label3.getName());

        assertTrue(jump1.isGoto());
        assertTrue(jump2.isGoto());
        assertTrue(jumpInner.isGoto());

        assertEquals(Map.of(
                "%label0", ifJump,
                "%label1", jump1,
                "%label2", ifJumpInner,
                "%label1_inner", jumpInner,
                "%label2_inner", jump2,
                "%label3", ret
        ), cfBuilder.getLastBlockEvents());
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

        builder.mockFunctionStart(false);
        builder.mockBoolType("%bool");
        builder.mockUndefinedValue("%value", "%bool");

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Attempt to redefine label '%label2_end'", e.getMessage());
        }
    }

    @Test
    public void testLoopWithForwardLabels() {
        // given
        String input = """
                        %label0 = OpLabel
                        OpLoopMerge %label1 %label2 None
                        OpBranchConditional %value %label1 %label2
                        %label1 = OpLabel
                        OpBranch %label2
                        %label2 = OpLabel
                        OpReturn
                        """;

        builder.mockFunctionStart(false);
        builder.mockBoolType("%bool");
        builder.mockUndefinedValue("%value", "%bool");

        // when
        visit(input);

        // then
        List<Event> events = builder.getCurrentFunction().getEvents();

        Label label0 = (Label) events.get(0);
        CondJump jump1 = (CondJump) events.get(1);
        CondJump jump2 = (CondJump) events.get(2);
        Label label1 = (Label) events.get(3);
        CondJump jump3 = (CondJump) events.get(4);
        Label label2 = (Label) events.get(5);
        Return ret = (Return) events.get(6);

        assertEquals("%label0", label0.getName());
        assertEquals("%label1", jump1.getLabel().getName());
        assertEquals("%label2", jump2.getLabel().getName());
        assertEquals("%label1", label1.getName());
        assertEquals("%label2", jump2.getLabel().getName());
        assertEquals("%label2", label2.getName());

        assertFalse(jump1.isGoto());
        assertTrue(jump2.isGoto());
        assertTrue(jump3.isGoto());

        assertTrue(cfBuilder.getMergeLabelIds().isEmpty());

        assertEquals(Map.of("%label0", jump1, "%label1", jump3, "%label2", ret),
                cfBuilder.getLastBlockEvents());
    }

    @Test
    public void testLoopWithBackwardLabel() {
        // given
        String input = """
                %label0 = OpLabel
                OpLoopMerge %label1 %label0 None
                OpBranchConditional %value %label1 %label0
                %label1 = OpLabel
                OpReturn
                """;

        builder.mockFunctionStart(false);
        builder.mockBoolType("%bool");
        builder.mockUndefinedValue("%value", "%bool");

        // when
        visit(input);

        // then
        List<Event> events = builder.getCurrentFunction().getEvents();

        Label label0 = (Label) events.get(0);
        CondJump jump1 = (CondJump) events.get(1);
        CondJump jump2 = (CondJump) events.get(2);
        Label label1 = (Label) events.get(3);
        Return ret = (Return) events.get(4);

        assertEquals("%label0", label0.getName());
        assertEquals("%label1", jump1.getLabel().getName());
        assertEquals("%label0", jump2.getLabel().getName());
        assertEquals("%label1", label1.getName());

        assertFalse(jump1.isGoto());
        assertTrue(jump2.isGoto());

        assertTrue(cfBuilder.getMergeLabelIds().isEmpty());

        assertEquals(Map.of("%label0", jump1, "%label1", ret),
                cfBuilder.getLastBlockEvents());
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
                "Illegal backward jump to '%label0' " +
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
                "Illegal backward jump to '%label0' " +
                        "from a structured branch");
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
    public void testLoopMergeWithTwoBackwardLabels() {
        doTestIllegalStructuredBranch("""
                        %label2 = OpLabel
                        OpBranch %label0
                        %label0 = OpLabel
                        OpLoopMerge %label2 %label0 None
                        OpBranchConditional %value1 %label2 %label0
                        %label1 = OpLabel
                        OpReturn
                        """,
                "Unsupported conditional branch " +
                        "with two backward jumps to '%label2' and '%label0'");
    }

    @Test
    public void testOpLoopIllegalTrueLabel() {
        doTestIllegalStructuredBranch("""
                        %label0 = OpLabel
                        OpLoopMerge %label1 %label0 None
                        OpBranchConditional %value1 %label0 %label1
                        %label1 = OpLabel
                        OpReturn
                        """,
                "Illegal label, expected '%label0' but received '%label1'");
    }

    private void doTestIllegalStructuredBranch(String input, String error) {
        // given
        builder.mockFunctionStart(false);
        builder.mockBoolType("%bool");
        builder.mockUndefinedValue("%value1", "%bool");

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
                OpBranchConditional %value1 %label1 %label2
                %label1 = OpLabel
                OpBranchConditional %value2 %label2 %label1
                %label2 = OpLabel
                OpReturn
                """;

        builder.mockFunctionStart(false);
        builder.mockBoolType("%bool");
        builder.mockUndefinedValue("%value1", "%bool");
        builder.mockUndefinedValue("%value2", "%bool");

        // when
        visit(input);

        // then
        List<Event> events = builder.getCurrentFunction().getEvents();

        Label label0 = (Label) events.get(0);
        CondJump jump1 = (CondJump) events.get(1);
        CondJump jump2 = (CondJump) events.get(2);
        Label label1 = (Label) events.get(3);
        CondJump jump3 = (CondJump) events.get(4);
        CondJump jump4 = (CondJump) events.get(5);
        Label label2 = (Label) events.get(6);
        Return ret = (Return) events.get(7);

        assertEquals("%label0", label0.getName());
        assertEquals("%label1", jump1.getLabel().getName());
        assertEquals("%label2", jump2.getLabel().getName());
        assertEquals("%label1", label1.getName());
        assertEquals("%label2", jump3.getLabel().getName());
        assertEquals("%label1", jump4.getLabel().getName());
        assertEquals("%label2", label2.getName());

        assertFalse(jump1.isGoto());
        assertTrue(jump2.isGoto());
        assertFalse(jump3.isGoto());
        assertTrue(jump4.isGoto());

        assertTrue(cfBuilder.getBlockStack().isEmpty());
        assertEquals(Map.of("%label0", jump1, "%label1", jump3, "%label2", ret),
                cfBuilder.getLastBlockEvents());
    }

    @Test
    public void testOpBranchConditionalSameLabels() {
        // given
        String input = """
                %label0 = OpLabel
                OpBranchConditional %value %label1 %label1
                """;

        builder.mockFunctionStart(false);
        builder.mockBoolType("%bool");
        builder.mockUndefinedValue("%value", "%bool");

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Labels of conditional branch cannot be the same", e.getMessage());
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

        builder.mockFunctionStart(false);

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
        Function function = new Function("%func", fType, List.of(), 0, null);
        builder.startCurrentFunction(function);
        builder.addEvent(mockStartLabel());

        // when
        visit("OpReturn");

        // then
        Return event = (Return) function.getEvents().get(1);
        assertNotNull(event);
        assertTrue(event.getValue().isEmpty());
        assertTrue(cfBuilder.getBlockStack().isEmpty());
    }

    @Test
    public void testReturnValue() {
        // given
        builder.mockIntType("%int", 64);
        builder.mockConstant("%value", "%int", 5);
        FunctionType fType = builder.mockFunctionType("%int_func", "%int");
        Function function = new Function("%func", fType, List.of(), 0, null);
        builder.startCurrentFunction(function);
        builder.addEvent(mockStartLabel());

        // when
        visit("OpReturnValue %value");

        // then
        Return event = (Return) function.getEvents().get(1);
        assertEquals(builder.getExpression("%value"), event.getValue().orElseThrow());
        assertTrue(cfBuilder.getBlockStack().isEmpty());
    }

    @Test
    public void testReturnForValueFunction() {
        // given
        builder.mockVoidType("%void");
        builder.mockIntType("%int", 64);
        builder.mockConstant("%value", "%int", 5);
        FunctionType fType = builder.mockFunctionType("%int_func", "%int");
        Function function = new Function("%func", fType, List.of(), 0, null);
        builder.startCurrentFunction(function);
        builder.addEvent(mockStartLabel());

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
        Function function = new Function("%func", fType, List.of(), 0, null);
        builder.startCurrentFunction(function);
        builder.addEvent(mockStartLabel());

        try {
            // when
            visit("OpReturnValue %value");
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal value return for a void function '%func'", e.getMessage());
        }
    }

    private Label mockStartLabel() {
        Label label = cfBuilder.getOrCreateLabel("%mock_label");
        cfBuilder.startBlock("%mock_label");
        return label;
    }

    private void visit(String text) {
        new MockSpirvParser(text).spv().accept(new VisitorOpsControlFlow(builder));
    }
}
