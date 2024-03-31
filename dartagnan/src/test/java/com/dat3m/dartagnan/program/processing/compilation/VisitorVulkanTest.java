package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.lang.spirv.*;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.google.common.collect.Sets;
import org.junit.Test;

import java.util.List;
import java.util.Set;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;
import static org.mockito.Mockito.mock;

public class VisitorVulkanTest {

    private final VisitorVulkan visitor = new VisitorVulkan();

    @Test
    public void testLoad() {
        doTestLoad(
                Set.of(),
                Set.of()
        );
        doTestLoad(
                Set.of(Tag.Spirv.MEM_VISIBLE),
                Set.of(Tag.Vulkan.VISIBLE)
        );
        doTestLoad(
                Set.of(Tag.Spirv.MEM_VISIBLE, Tag.Spirv.MEM_NON_PRIVATE),
                Set.of(Tag.Vulkan.VISIBLE, Tag.Vulkan.NON_PRIVATE)
        );
        doTestLoad(
                Set.of(Tag.Spirv.MEM_VISIBLE, Tag.Vulkan.NON_PRIVATE, Tag.Spirv.DEVICE),
                Set.of(Tag.Vulkan.VISIBLE, Tag.Vulkan.NON_PRIVATE, Tag.Vulkan.DEVICE, Tag.Vulkan.VISDEVICE)
        );
    }

    private void doTestLoad(Set<String> spvTags, Set<String> vulTags) {
        // given
        Register register = mock(Register.class);
        MemoryObject address = mock(MemoryObject.class);
        Load e = EventFactory.newLoad(register, address);
        e.addTags(spvTags);

        // when
        List<Event> seq = visitor.visitLoad(e);

        // then
        assertEquals(1, seq.size());
        Load load = (Load) seq.get(0);
        Set<String> baseTags = Set.of(Tag.VISIBLE, Tag.MEMORY, Tag.READ);
        assertEquals(Sets.union(baseTags, vulTags), load.getTags());
    }

    @Test
    public void testStore() {
        doTestStore(
                Set.of(),
                Set.of()
        );
        doTestStore(
                Set.of(Tag.Spirv.MEM_AVAILABLE),
                Set.of(Tag.Vulkan.AVAILABLE)
        );
        doTestStore(
                Set.of(Tag.Spirv.MEM_AVAILABLE, Tag.Spirv.MEM_NON_PRIVATE),
                Set.of(Tag.Vulkan.AVAILABLE, Tag.Vulkan.NON_PRIVATE)
        );
        doTestStore(
                Set.of(Tag.Spirv.MEM_AVAILABLE, Tag.Vulkan.NON_PRIVATE, Tag.Spirv.DEVICE),
                Set.of(Tag.Vulkan.AVAILABLE, Tag.Vulkan.NON_PRIVATE, Tag.Vulkan.DEVICE, Tag.Vulkan.AVDEVICE)
        );
    }

    private void doTestStore(Set<String> spvTags, Set<String> vulTags) {
        // given
        Expression value = mock(Expression.class);
        MemoryObject address = mock(MemoryObject.class);
        Store e = EventFactory.newStore(address, value);
        e.addTags(spvTags);

        // when
        List<Event> seq = visitor.visitStore(e);

        // then
        assertEquals(1, seq.size());
        Store load = (Store) seq.get(0);
        Set<String> baseTags = Set.of(Tag.VISIBLE, Tag.MEMORY, Tag.WRITE);
        assertEquals(Sets.union(baseTags, vulTags), load.getTags());
    }

    @Test
    public void testSpirvLoad() {
        doTestSpirvLoad(
                Set.of(Tag.Spirv.RELAXED, Tag.Spirv.SUBGROUP),
                Set.of(Tag.Vulkan.SUB_GROUP)
        );
        doTestSpirvLoad(
                Set.of(Tag.Spirv.ACQUIRE, Tag.Spirv.WORKGROUP),
                Set.of(Tag.Vulkan.ACQUIRE, Tag.Vulkan.WORK_GROUP)
        );
        doTestSpirvLoad(
                Set.of(Tag.Spirv.ACQUIRE, Tag.Spirv.WORKGROUP, Tag.Spirv.SEM_VISIBLE),
                Set.of(Tag.Vulkan.ACQUIRE, Tag.Vulkan.WORK_GROUP, Tag.Vulkan.SEM_VISIBLE)
        );
        doTestSpirvLoad(
                Set.of(Tag.Spirv.ACQUIRE, Tag.Spirv.WORKGROUP, Tag.Spirv.SEM_UNIFORM, Tag.Spirv.SEM_VISIBLE),
                Set.of(Tag.Vulkan.ACQUIRE, Tag.Vulkan.WORK_GROUP, Tag.Vulkan.SEMSC0, Tag.Vulkan.SEM_VISIBLE)
        );
        doTestSpirvLoad(
                Set.of(Tag.Spirv.ACQUIRE, Tag.Spirv.WORKGROUP, Tag.Spirv.SEM_WORKGROUP, Tag.Spirv.SEM_VISIBLE),
                Set.of(Tag.Vulkan.ACQUIRE, Tag.Vulkan.WORK_GROUP, Tag.Vulkan.SEMSC1, Tag.Vulkan.SEM_VISIBLE)
        );
        doTestSpirvLoad(
                Set.of(Tag.Spirv.RELAXED, Tag.Spirv.DEVICE),
                Set.of(Tag.Vulkan.DEVICE, Tag.Vulkan.VISDEVICE)
        );
    }

    private void doTestSpirvLoad(Set<String> spvTags, Set<String> vulTags) {
        // given
        Register register = mock(Register.class);
        MemoryObject address = mock(MemoryObject.class);
        String scope = Tag.Spirv.getScopeTag(spvTags);
        SpirvLoad e = EventFactory.Spirv.newSpirvLoad(register, address, scope, spvTags);
        e.setFunction(mock(Function.class));

        // when
        List<Event> seq = visitor.visitSpirvLoad(e);

        // then
        assertEquals(1, seq.size());
        Load load = (Load) seq.get(0);
        Set<String> baseTags = Set.of(Tag.VISIBLE, Tag.MEMORY, Tag.READ, Tag.Vulkan.ATOM,
                Tag.Vulkan.VISIBLE, Tag.Vulkan.NON_PRIVATE);
        assertEquals(Sets.union(baseTags, vulTags), load.getTags());
    }

    @Test
    public void testSpirvLoadIllegal() {
        doTestSpirvLoadIllegal(
                Set.of(Tag.Spirv.SEQ_CST, Tag.Spirv.WORKGROUP),
                String.format("Non-Vulkan memory order '%s'", Tag.Spirv.SEQ_CST)
        );
    }

    private void doTestSpirvLoadIllegal(Set<String> spvTags, String error) {
        // given
        Register register = mock(Register.class);
        MemoryObject address = mock(MemoryObject.class);
        String scope = Tag.Spirv.getScopeTag(spvTags);
        SpirvLoad e = EventFactory.Spirv.newSpirvLoad(register, address, scope, spvTags);
        e.setFunction(mock(Function.class));

        try {
            // when
            visitor.visitSpirvLoad(e);
            fail("Should throw exception");
        } catch (Exception ex) {
            // then
            assertEquals(error, ex.getMessage());
        }
    }

    @Test
    public void testSpirvStore() {
        doTestSpirvStore(
                Set.of(Tag.Spirv.RELAXED, Tag.Spirv.SUBGROUP),
                Set.of(Tag.Vulkan.SUB_GROUP)
        );
        doTestSpirvStore(
                Set.of(Tag.Spirv.RELEASE, Tag.Spirv.WORKGROUP),
                Set.of(Tag.Vulkan.RELEASE, Tag.Vulkan.WORK_GROUP)
        );
        doTestSpirvStore(
                Set.of(Tag.Spirv.RELEASE, Tag.Spirv.WORKGROUP, Tag.Spirv.SEM_AVAILABLE),
                Set.of(Tag.Vulkan.RELEASE, Tag.Vulkan.WORK_GROUP, Tag.Vulkan.SEM_AVAILABLE)
        );
        doTestSpirvStore(
                Set.of(Tag.Spirv.RELEASE, Tag.Spirv.WORKGROUP, Tag.Spirv.SEM_UNIFORM, Tag.Spirv.SEM_AVAILABLE),
                Set.of(Tag.Vulkan.RELEASE, Tag.Vulkan.WORK_GROUP, Tag.Vulkan.SEMSC0, Tag.Vulkan.SEM_AVAILABLE)
        );
        doTestSpirvStore(
                Set.of(Tag.Spirv.RELEASE, Tag.Spirv.WORKGROUP, Tag.Spirv.SEM_WORKGROUP, Tag.Spirv.SEM_AVAILABLE),
                Set.of(Tag.Vulkan.RELEASE, Tag.Vulkan.WORK_GROUP, Tag.Vulkan.SEMSC1, Tag.Vulkan.SEM_AVAILABLE, Tag.Vulkan.AVAILABLE, Tag.Vulkan.NON_PRIVATE)
        );
        doTestSpirvStore(
                Set.of(Tag.Spirv.RELAXED, Tag.Spirv.DEVICE),
                Set.of(Tag.Vulkan.DEVICE, Tag.Vulkan.AVDEVICE)
        );
    }

    private void doTestSpirvStore(Set<String> spvTags, Set<String> vulTags) {
        // given
        Expression value = mock(Expression.class);
        MemoryObject address = mock(MemoryObject.class);
        String scope = Tag.Spirv.getScopeTag(spvTags);
        SpirvStore e = EventFactory.Spirv.newSpirvStore(address, value, scope, spvTags);
        e.setFunction(mock(Function.class));

        // when
        List<Event> seq = visitor.visitSpirvStore(e);

        // then
        assertEquals(1, seq.size());
        Store store = (Store) seq.get(0);
        Set<String> baseTags = Set.of(Tag.VISIBLE, Tag.MEMORY, Tag.WRITE, Tag.Vulkan.ATOM,
                Tag.Vulkan.AVAILABLE, Tag.Vulkan.NON_PRIVATE);
        assertEquals(Sets.union(baseTags, vulTags), store.getTags());
    }

    @Test
    public void testSpirvStoreIllegal() {
        doTestSpirvStoreIllegal(
                Set.of(Tag.Spirv.SEQ_CST, Tag.Spirv.WORKGROUP),
                String.format("Non-Vulkan memory order '%s'", Tag.Spirv.SEQ_CST)
        );
    }

    private void doTestSpirvStoreIllegal(Set<String> spvTags, String error) {
        // given
        Expression value = mock(Expression.class);
        MemoryObject address = mock(MemoryObject.class);
        String scope = Tag.Spirv.getScopeTag(spvTags);
        SpirvStore e = EventFactory.Spirv.newSpirvStore(address, value, scope, spvTags);
        e.setFunction(mock(Function.class));

        try {
            // when
            visitor.visitSpirvStore(e);
            fail("Should throw exception");
        } catch (Exception ex) {
            // then
            assertEquals(error, ex.getMessage());
        }
    }

    @Test
    public void testSpirvXchg() {
        doTestSpirvXchg(
                Set.of(Tag.Spirv.RELAXED, Tag.Spirv.SUBGROUP),
                Set.of(Tag.Vulkan.SUB_GROUP),
                Set.of(Tag.Vulkan.SUB_GROUP)
        );
        doTestSpirvXchg(
                Set.of(Tag.Spirv.ACQUIRE, Tag.Spirv.WORKGROUP),
                Set.of(Tag.Vulkan.ACQUIRE, Tag.Vulkan.WORK_GROUP),
                Set.of(Tag.Vulkan.WORK_GROUP)
        );
        doTestSpirvXchg(
                Set.of(Tag.Spirv.RELEASE, Tag.Spirv.WORKGROUP),
                Set.of(Tag.Vulkan.WORK_GROUP),
                Set.of(Tag.Vulkan.RELEASE, Tag.Vulkan.WORK_GROUP)
        );
        doTestSpirvXchg(
                Set.of(Tag.Spirv.ACQ_REL, Tag.Spirv.WORKGROUP),
                Set.of(Tag.Vulkan.ACQUIRE, Tag.Vulkan.WORK_GROUP),
                Set.of(Tag.Vulkan.RELEASE, Tag.Vulkan.WORK_GROUP)
        );
        doTestSpirvXchg(
                Set.of(Tag.Spirv.RELAXED, Tag.Spirv.DEVICE),
                Set.of(Tag.Vulkan.DEVICE, Tag.Vulkan.VISDEVICE),
                Set.of(Tag.Vulkan.DEVICE, Tag.Vulkan.AVDEVICE)
        );
    }

    private void doTestSpirvXchg(Set<String> spvTags, Set<String> loadTags, Set<String> storeTags) {
        // given
        Function function = new Function("mock", mock(FunctionType.class), List.of(), 0, null);
        Register register = function.newRegister(TypeFactory.getInstance().getBooleanType());
        Expression value = mock(Expression.class);
        MemoryObject address = mock(MemoryObject.class);
        String scope = Tag.Spirv.getScopeTag(spvTags);
        SpirvXchg e = EventFactory.Spirv.newSpirvXchg(register, address, value, scope, spvTags);
        e.setFunction(function);

        // when
        List<Event> seq = visitor.visitSpirvXchg(e);

        // then
        assertEquals(3, seq.size());
        Load load = (Load) seq.get(0);
        Set<String> baseLoadTags = Set.of(Tag.VISIBLE, Tag.MEMORY, Tag.READ, Tag.RMW, Tag.Vulkan.ATOM,
                Tag.Vulkan.VISIBLE, Tag.Vulkan.NON_PRIVATE);
        assertEquals(Sets.union(baseLoadTags, loadTags), load.getTags());
        Store store = (Store) seq.get(1);
        Set<String> baseStoreTags = Set.of(Tag.VISIBLE, Tag.MEMORY, Tag.WRITE, Tag.RMW, Tag.Vulkan.ATOM,
                Tag.Vulkan.AVAILABLE, Tag.Vulkan.NON_PRIVATE);
        assertEquals(Sets.union(baseStoreTags, storeTags), store.getTags());
        Local local = (Local) seq.get(2);
        assertEquals(register, local.getResultRegister());
    }

    @Test
    public void testSpirvRmw() {
        doTestSpirvRmw(
                Set.of(Tag.Spirv.RELAXED, Tag.Spirv.SUBGROUP),
                Set.of(Tag.Vulkan.SUB_GROUP),
                Set.of(Tag.Vulkan.SUB_GROUP)
        );
        doTestSpirvRmw(
                Set.of(Tag.Spirv.ACQUIRE, Tag.Spirv.WORKGROUP),
                Set.of(Tag.Vulkan.ACQUIRE, Tag.Vulkan.WORK_GROUP),
                Set.of(Tag.Vulkan.WORK_GROUP)
        );
        doTestSpirvRmw(
                Set.of(Tag.Spirv.RELEASE, Tag.Spirv.WORKGROUP),
                Set.of(Tag.Vulkan.WORK_GROUP),
                Set.of(Tag.Vulkan.RELEASE, Tag.Vulkan.WORK_GROUP)
        );
        doTestSpirvRmw(
                Set.of(Tag.Spirv.ACQ_REL, Tag.Spirv.WORKGROUP),
                Set.of(Tag.Vulkan.ACQUIRE, Tag.Vulkan.WORK_GROUP),
                Set.of(Tag.Vulkan.RELEASE, Tag.Vulkan.WORK_GROUP)
        );
        doTestSpirvRmw(
                Set.of(Tag.Spirv.RELAXED, Tag.Spirv.DEVICE),
                Set.of(Tag.Vulkan.DEVICE, Tag.Vulkan.VISDEVICE),
                Set.of(Tag.Vulkan.DEVICE, Tag.Vulkan.AVDEVICE)
        );
    }

    private void doTestSpirvRmw(Set<String> spvTags, Set<String> loadTags, Set<String> storeTags) {
        // given
        IntegerType type = TypeFactory.getInstance().getArchType();
        Function function = new Function("mock", mock(FunctionType.class), List.of(), 0, null);
        Register register = function.newRegister(type);
        Expression value = ExpressionFactory.getInstance().makeValue(1, type);
        MemoryObject address = mock(MemoryObject.class);
        String scope = Tag.Spirv.getScopeTag(spvTags);
        SpirvRmw e = EventFactory.Spirv.newSpirvRmw(register, address, IntBinaryOp.ADD, value, scope, spvTags);
        e.setFunction(function);

        // when
        List<Event> seq = visitor.visitSpirvRMW(e);

        // then
        assertEquals(3, seq.size());
        Load load = (Load) seq.get(0);
        Set<String> baseLoadTags = Set.of(Tag.VISIBLE, Tag.MEMORY, Tag.READ, Tag.RMW, Tag.Vulkan.ATOM,
                Tag.Vulkan.VISIBLE, Tag.Vulkan.NON_PRIVATE);
        assertEquals(Sets.union(baseLoadTags, loadTags), load.getTags());
        Store store = (Store) seq.get(1);
        Set<String> baseStoreTags = Set.of(Tag.VISIBLE, Tag.MEMORY, Tag.WRITE, Tag.RMW, Tag.Vulkan.ATOM,
                Tag.Vulkan.AVAILABLE, Tag.Vulkan.NON_PRIVATE);
        assertEquals(Sets.union(baseStoreTags, storeTags), store.getTags());
        Local local = (Local) seq.get(2);
        assertEquals(register, local.getResultRegister());
    }

    @Test
    public void testSpirvCmpXchg() {
        doTestSpirvCmpXchg(
                Tag.Spirv.WORKGROUP,
                Set.of(Tag.Spirv.RELAXED),
                Set.of(Tag.Spirv.RELAXED),
                Set.of(Tag.Vulkan.WORK_GROUP),
                Set.of(Tag.Vulkan.WORK_GROUP));
        doTestSpirvCmpXchg(
                Tag.Spirv.WORKGROUP,
                Set.of(Tag.Spirv.ACQUIRE),
                Set.of(Tag.Spirv.ACQUIRE),
                Set.of(Tag.Vulkan.ACQUIRE, Tag.Vulkan.WORK_GROUP),
                Set.of(Tag.Vulkan.WORK_GROUP));
        doTestSpirvCmpXchg(
                Tag.Spirv.WORKGROUP,
                Set.of(Tag.Spirv.RELEASE),
                Set.of(Tag.Spirv.RELAXED),
                Set.of(Tag.Vulkan.WORK_GROUP),
                Set.of(Tag.Vulkan.RELEASE, Tag.Vulkan.WORK_GROUP));
        doTestSpirvCmpXchg(
                Tag.Spirv.WORKGROUP,
                Set.of(Tag.Spirv.ACQ_REL),
                Set.of(Tag.Spirv.ACQUIRE),
                Set.of(Tag.Vulkan.ACQUIRE, Tag.Vulkan.WORK_GROUP),
                Set.of(Tag.Vulkan.RELEASE, Tag.Vulkan.WORK_GROUP));
        doTestSpirvCmpXchg(
                Tag.Spirv.DEVICE,
                Set.of(Tag.Spirv.RELAXED),
                Set.of(Tag.Spirv.RELAXED),
                Set.of(Tag.Vulkan.DEVICE, Tag.Vulkan.VISDEVICE),
                Set.of(Tag.Vulkan.DEVICE, Tag.Vulkan.AVDEVICE));
    }

    private void doTestSpirvCmpXchg(String scope, Set<String> eqTags, Set<String> neqTags, Set<String> loadTags, Set<String> storeTags) {
        // given
        IntegerType type = TypeFactory.getInstance().getArchType();
        Function function = new Function("mock", mock(FunctionType.class), List.of(), 0, null);
        Register register = function.newRegister(type);
        Expression cmp = ExpressionFactory.getInstance().makeValue(0, type);
        Expression value = ExpressionFactory.getInstance().makeValue(1, type);
        MemoryObject address = mock(MemoryObject.class);
        SpirvCmpXchg e = EventFactory.Spirv.newSpirvCmpXchg(register, address, cmp, value, scope, eqTags, neqTags);
        e.setFunction(function);

        // when
        List<Event> seq = visitor.visitSpirvCmpXchg(e);

        // then
        assertEquals(2, seq.size());
        Load load = (Load) seq.get(0);
        Set<String> baseLoadTags = Set.of(Tag.VISIBLE, Tag.MEMORY, Tag.READ, Tag.RMW,
                Tag.Vulkan.ATOM, Tag.Vulkan.VISIBLE, Tag.Vulkan.NON_PRIVATE);
        assertEquals(Sets.union(baseLoadTags, loadTags), load.getTags());
        Store store = (Store) seq.get(1);
        Set<String> baseStoreTags = Set.of(Tag.VISIBLE, Tag.MEMORY, Tag.WRITE, Tag.RMW,
                Tag.Vulkan.ATOM, Tag.Vulkan.AVAILABLE, Tag.Vulkan.NON_PRIVATE);
        assertEquals(Sets.union(baseStoreTags, storeTags), store.getTags());
    }

    @Test
    public void testCmpXchgIllegal() {
        doTestSpirvCmpXchgIllegal(
                Set.of(Tag.Spirv.SEQ_CST),
                Set.of(Tag.Spirv.RELAXED),
                "Non-Vulkan memory order 'SPV_SEQ_CST'");
        doTestSpirvCmpXchgIllegal(
                Set.of(Tag.Spirv.SEQ_CST),
                Set.of(Tag.Spirv.SEQ_CST),
                "Non-Vulkan memory order 'SPV_SEQ_CST'");
        doTestSpirvCmpXchgIllegal(
                Set.of(Tag.Spirv.ACQUIRE),
                Set.of(Tag.Spirv.RELAXED),
                "Spir-V CmpXchg with unequal tag sets is not supported");
        doTestSpirvCmpXchgIllegal(
                Set.of(Tag.Spirv.ACQ_REL),
                Set.of(Tag.Spirv.RELAXED),
                "Spir-V CmpXchg with unequal tag sets is not supported");
        doTestSpirvCmpXchgIllegal(
                Set.of(Tag.Spirv.RELAXED, Tag.Spirv.SEM_UNIFORM),
                Set.of(Tag.Spirv.RELAXED),
                "Spir-V CmpXchg with unequal tag sets is not supported");
        doTestSpirvCmpXchgIllegal(
                Set.of(Tag.Spirv.RELAXED),
                Set.of(Tag.Spirv.RELAXED, Tag.Spirv.SEM_UNIFORM),
                "Spir-V CmpXchg with unequal tag sets is not supported");
    }

    private void doTestSpirvCmpXchgIllegal(Set<String> eqTags, Set<String> neqTags, String error) {
        // given
        IntegerType type = TypeFactory.getInstance().getArchType();
        Function function = new Function("mock", mock(FunctionType.class), List.of(), 0, null);
        Register register = function.newRegister(type);
        Expression cmp = ExpressionFactory.getInstance().makeValue(0, type);
        Expression value = ExpressionFactory.getInstance().makeValue(1, type);
        MemoryObject address = mock(MemoryObject.class);
        SpirvCmpXchg e = EventFactory.Spirv.newSpirvCmpXchg(register,
                address, cmp, value, Tag.Spirv.WORKGROUP, eqTags, neqTags);
        e.setFunction(function);

        try {
            // when
            visitor.visitSpirvCmpXchg(e);
            fail("Should throw exception");
        } catch (Exception ex) {
            // then
            assertEquals(error, ex.getMessage());
        }
    }

    @Test
    public void testSpirvMemoryBarrier() {
        doTestSpirvMemoryBarrier(
                Set.of(Tag.Spirv.RELAXED, Tag.Spirv.SUBGROUP),
                Set.of(Tag.Vulkan.SUB_GROUP)
        );
        doTestSpirvMemoryBarrier(
                Set.of(Tag.Spirv.ACQUIRE, Tag.Spirv.SUBGROUP),
                Set.of(Tag.Vulkan.ACQUIRE, Tag.Vulkan.SUB_GROUP)
        );
        doTestSpirvMemoryBarrier(
                Set.of(Tag.Spirv.RELEASE, Tag.Spirv.SUBGROUP),
                Set.of(Tag.Vulkan.RELEASE, Tag.Vulkan.SUB_GROUP)
        );
        doTestSpirvMemoryBarrier(
                Set.of(Tag.Spirv.ACQ_REL, Tag.Spirv.SUBGROUP),
                Set.of(Tag.Vulkan.ACQUIRE, Tag.Vulkan.RELEASE, Tag.Vulkan.SUB_GROUP)
        );
    }

    private void doTestSpirvMemoryBarrier(Set<String> spvTags, Set<String> expected) {
        // given
        GenericVisibleEvent e = new GenericVisibleEvent("membar", Tag.FENCE);
        e.addTags(spvTags);

        // when
        List<Event> seq = visitor.visitGenericVisibleEvent(e);

        // then
        assertEquals(1, seq.size());
        GenericVisibleEvent barrier = (GenericVisibleEvent) seq.get(0);
        Set<String> baseTags = Set.of(Tag.VISIBLE, Tag.FENCE);
        assertEquals(Sets.union(baseTags, expected), barrier.getTags());
    }

    @Test
    public void testSpirvControlBarrier() {
        doTestSpirvControlBarrier(
                Set.of(),
                Set.of()
        );
        doTestSpirvControlBarrier(
                Set.of(Tag.Spirv.RELAXED, Tag.Spirv.SUBGROUP),
                Set.of(Tag.FENCE, Tag.Vulkan.SUB_GROUP)
        );
        doTestSpirvControlBarrier(
                Set.of(Tag.Spirv.ACQUIRE, Tag.Spirv.SUBGROUP),
                Set.of(Tag.FENCE, Tag.Vulkan.ACQUIRE, Tag.Vulkan.SUB_GROUP)
        );
        doTestSpirvControlBarrier(
                Set.of(Tag.Spirv.RELEASE, Tag.Spirv.SUBGROUP),
                Set.of(Tag.FENCE, Tag.Vulkan.RELEASE, Tag.Vulkan.SUB_GROUP)
        );
        doTestSpirvControlBarrier(
                Set.of(Tag.Spirv.ACQ_REL, Tag.Spirv.SUBGROUP),
                Set.of(Tag.FENCE, Tag.Vulkan.ACQUIRE, Tag.Vulkan.RELEASE, Tag.Vulkan.SUB_GROUP)
        );
    }

    private void doTestSpirvControlBarrier(Set<String> spvTags, Set<String> expected) {
        // given
        FenceWithId e = EventFactory.newFenceWithId("cbar", mock(Expression.class));
        e.addTags(Tag.Spirv.CONTROL);
        if (!spvTags.isEmpty()) {
            e.addTags(spvTags);
        } else {
            e.removeTags(Tag.FENCE);
        }

        // when
        List<Event> seq = visitor.visitGenericVisibleEvent(e);

        // then
        assertEquals(1, seq.size());
        FenceWithId barrier = (FenceWithId) seq.get(0);
        Set<String> baseTags = Set.of(Tag.VISIBLE, Tag.Vulkan.CBAR);
        assertEquals(Sets.union(baseTags, expected), barrier.getTags());
    }
}
