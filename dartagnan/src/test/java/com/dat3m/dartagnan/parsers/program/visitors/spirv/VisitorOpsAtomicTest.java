package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockProgramBuilderSpv;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.lang.spirv.*;
import org.junit.Test;

import java.util.Set;

import static com.dat3m.dartagnan.program.event.Tag.*;
import static com.dat3m.dartagnan.program.event.Tag.Spirv.*;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

public class VisitorOpsAtomicTest {

    @Test
    public void testLoad() {
        // given
        MockProgramBuilderSpv builder = new MockProgramBuilderSpv();
        builder.mockIntType("%int", 64);
        builder.mockVariable("%ptr", "%int");
        builder.mockConstant("%scope", "%int", 1);
        builder.mockConstant("%tags", "%int", 66);
        String input = "%result = OpAtomicLoad %int %ptr %scope %tags";

        // when
        SpirvLoad event = (SpirvLoad) visit(builder, input);

        // then
        assertEquals("%result", event.getResultRegister().getName());
        assertEquals(builder.getType("%int"), event.getResultRegister().getType());
        assertEquals(builder.getExpression("%ptr"), event.getAddress());
        assertEquals(ACQUIRE, event.getMo());
        assertEquals(Set.of(ACQUIRE, SEM_UNIFORM, DEVICE, READ, MEMORY, VISIBLE), event.getTags());
    }

    @Test
    public void testStore() {
        // given
        MockProgramBuilderSpv builder = new MockProgramBuilderSpv();
        builder.mockIntType("%int", 64);
        builder.mockVariable("%ptr", "%int");
        builder.mockConstant("%scope", "%int", 1);
        builder.mockConstant("%tags", "%int", 68);
        builder.mockConstant("%value", "%int", 123);
        String input = "OpAtomicStore %ptr %scope %tags %value";

        // when
        SpirvStore event = (SpirvStore) visit(builder, input);

        // then
        assertEquals(builder.getExpression("%ptr"), event.getAddress());
        assertEquals(builder.getExpression("%value"), event.getMemValue());
        assertEquals(RELEASE, event.getMo());
        assertEquals(Set.of(RELEASE, SEM_UNIFORM, DEVICE, WRITE, MEMORY, VISIBLE), event.getTags());
    }

    @Test
    public void testXchg() {
        // given
        MockProgramBuilderSpv builder = new MockProgramBuilderSpv();
        builder.mockIntType("%int", 64);
        builder.mockVariable("%ptr", "%int");
        builder.mockConstant("%value", "%int", 123);
        builder.mockConstant("%scope", "%int", 1);
        builder.mockConstant("%tags", "%int", 72);
        String input = "%orig = OpAtomicExchange %int %ptr %scope %tags %value";

        // when
        SpirvXchg event = (SpirvXchg) visit(builder, input);

        // then
        assertEquals("%orig", event.getResultRegister().getName());
        assertEquals(builder.getType("%int"), event.getResultRegister().getType());
        assertEquals(builder.getExpression("%ptr"), event.getAddress());
        assertEquals(builder.getExpression("%value"), event.getValue());
        assertEquals(ACQ_REL, event.getMo());
        assertEquals(Set.of(ACQ_REL, SEM_UNIFORM, DEVICE, READ, WRITE, RMW, MEMORY, VISIBLE), event.getTags());
    }

    @Test
    public void testCmpXchg() {
        // given
        MockProgramBuilderSpv builder = new MockProgramBuilderSpv();
        builder.mockIntType("%int", 64);
        builder.mockVariable("%ptr", "%int");
        builder.mockConstant("%value", "%int", 123);
        builder.mockConstant("%cmp", "%int", 456);
        builder.mockConstant("%scope", "%int", 1);
        builder.mockConstant("%eq", "%int", 72);
        builder.mockConstant("%neq", "%int", 66);
        String input = "%result = OpAtomicCompareExchange %int %ptr %scope %eq %neq %value %cmp";

        // when
        SpirvCmpXchg event = (SpirvCmpXchg) visit(builder, input);

        // then
        assertEquals("%result", event.getResultRegister().getName());
        assertEquals(builder.getType("%int"), event.getResultRegister().getType());
        assertEquals(builder.getExpression("%ptr"), event.getAddress());
        assertEquals(builder.getExpression("%value"), event.getStoreValue());
        assertEquals(builder.getExpression("%cmp"), event.getExpectedValue());
        assertEquals(ACQUIRE, event.getMo());
        assertEquals(Set.of(ACQUIRE, SEM_UNIFORM, DEVICE, READ, WRITE, RMW, MEMORY, VISIBLE), event.getTags());
        assertEquals(Set.of(ACQ_REL, SEM_UNIFORM, DEVICE, READ, WRITE, RMW, MEMORY, VISIBLE), event.getEqTags());
    }

    @Test
    public void testRmw() {
        // given
        MockProgramBuilderSpv builder = new MockProgramBuilderSpv();
        builder.mockIntType("%int", 64);
        builder.mockVariable("%ptr", "%int");
        builder.mockConstant("%value", "%int", 123);
        builder.mockConstant("%scope", "%int", 1);
        builder.mockConstant("%tags", "%int", 64);
        String input = "%orig = OpAtomicIAdd %int %ptr %scope %tags %value";

        // when
        SpirvRmw event = (SpirvRmw) visit(builder, input);

        // then
        assertEquals("%orig", event.getResultRegister().getName());
        assertEquals(builder.getType("%int"), event.getResultRegister().getType());
        assertEquals(builder.getExpression("%ptr"), event.getAddress());
        assertEquals(builder.getExpression("%value"), event.getOperand());
        assertEquals(IOpBin.ADD, event.getOperator());
        assertEquals(RELAXED, event.getMo());
        assertEquals(Set.of(RELAXED, SEM_UNIFORM, DEVICE, READ, WRITE, RMW, MEMORY, VISIBLE), event.getTags());
    }

    @Test
    public void testIllegalMemoryOrder() {
        doTestIllegalMemoryOrder(68, 0,
                "%result = OpAtomicLoad %int %ptr %scope %eq",
                "SpirvLoad cannot have memory order 'RELEASE'");
        doTestIllegalMemoryOrder(72, 0,
                "%result = OpAtomicLoad %int %ptr %scope %eq",
                "SpirvLoad cannot have memory order 'ACQ_REL'");
        doTestIllegalMemoryOrder(66, 0,
                "OpAtomicStore %ptr %scope %eq %value",
                "SpirvStore cannot have memory order 'ACQUIRE'");
        doTestIllegalMemoryOrder(72, 0,
                "OpAtomicStore %ptr %scope %eq %value",
                "SpirvStore cannot have memory order 'ACQ_REL'");
        doTestIllegalMemoryOrder(72, 68,
                "%result = OpAtomicCompareExchange %int %ptr %scope %eq %neq %value %cmp",
                "SpirvCmpXchg cannot have unequal memory order 'RELEASE'");
        doTestIllegalMemoryOrder(72, 72,
                "%result = OpAtomicCompareExchange %int %ptr %scope %eq %neq %value %cmp",
                "SpirvCmpXchg cannot have unequal memory order 'ACQ_REL'");
        doTestIllegalMemoryOrder(64, 66,
                "%result = OpAtomicCompareExchange %int %ptr %scope %eq %neq %value %cmp",
                "Unequal semantics 'ACQUIRE' is stronger than equal semantics 'RELAXED'");
        doTestIllegalMemoryOrder(72, 80,
                "%result = OpAtomicCompareExchange %int %ptr %scope %eq %neq %value %cmp",
                "Unequal semantics 'SEQ_CST' is stronger than equal semantics 'ACQ_REL'");
    }

    private void doTestIllegalMemoryOrder(int eq, int neq, String input, String error) {
        // given
        MockProgramBuilderSpv builder = new MockProgramBuilderSpv();
        builder = new MockProgramBuilderSpv();
        builder.mockIntType("%int", 64);
        builder.mockVariable("%ptr", "%int");
        builder.mockConstant("%value", "%int", 123);
        builder.mockConstant("%cmp", "%int", 456);
        builder.mockConstant("%scope", "%int", 1);
        builder.mockConstant("%eq", "%int", eq);
        builder.mockConstant("%neq", "%int", neq);

        try {
            // when
            visit(builder, input);
            fail("Should throw exception");
        } catch (IllegalArgumentException e) {
            // then
            assertEquals(error, e.getMessage());
        }
    }

    private Event visit(MockProgramBuilderSpv builder, String input) {
        builder.mockFunctionStart();
        builder.mockLabel();
        return new MockSpirvParser(input).op().accept(new VisitorOpsAtomic(builder));
    }
}
