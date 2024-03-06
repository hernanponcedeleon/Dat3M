package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.BConst;
import com.dat3m.dartagnan.expression.BExprUn;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockProgramBuilderSpv;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.*;
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
        assertTrue(((BConst) (event.getGuard())).getValue());
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
        assertTrue(((BConst) (event1.getGuard())).getValue());
        assertEquals(builder.getOrCreateLabel("%label3"), event1.getLabel());

        CondJump event2 = (CondJump) function.getEvents().get(4);
        assertTrue(((BConst) (event2.getGuard())).getValue());
        assertEquals(builder.getOrCreateLabel("%label2"), event2.getLabel());

        assertEquals(List.of(builder.getOrCreateLabel("%label1")), builder.getBlocks());
    }

    @Test
    public void testOpBranchConditionalStructured() {
        // given
        String input = """
                %label0 = OpLabel
                OpSelectionMerge %label1 None
                OpBranchConditional %value1 %label2 %label3
                %label2 = OpLabel
                OpSelectionMerge %label4 None
                OpBranchConditional %value2 %label5 %label6
                %label5 = OpLabel
                OpBranch %label6
                %label6 = OpLabel
                OpBranch %label4
                %label4 = OpLabel
                OpBranch %label3
                %label3 = OpLabel
                OpBranch %label1
                %label1 = OpLabel
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

        IfAsJump event1 = (IfAsJump) events.get(1);
        assertEquals("%value1", getGuardRegister(event1).getName());
        assertEquals(builder.getOrCreateLabel("%label3"), event1.getLabel());
        assertEquals(builder.getOrCreateLabel("%label1"), event1.getEndIf());

        IfAsJump event2 = (IfAsJump) events.get(3);
        assertEquals("%value2", getGuardRegister(event2).getName());
        assertEquals(builder.getOrCreateLabel("%label6"), event2.getLabel());
        assertEquals(builder.getOrCreateLabel("%label4"), event2.getEndIf());

        assertTrue(builder.getBlocks().isEmpty());
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
        assertEquals(builder.getOrCreateLabel("%label3"), event1.getLabel());

        CondJump event2 = (CondJump) events.get(3);
        assertEquals("%value2", getGuardRegister(event2).getName());
        assertEquals(builder.getOrCreateLabel("%label1"), event2.getLabel());

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
        BExprUn expression = ((BExprUn) event.getGuard());
        return (Register) expression.getInner();
    }

    private void visit(String text) {
        new MockSpirvParser(text).spv().accept(new VisitorOpsControlFlow(builder));
    }
}
