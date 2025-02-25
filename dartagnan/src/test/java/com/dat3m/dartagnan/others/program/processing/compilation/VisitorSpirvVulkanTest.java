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

public class VisitorSpirvVulkanTest {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private static final IntegerType archType = types.getArchType();

    private final VisitorSpirvVulkan visitor = new VisitorSpirvVulkan();

    @Test
    public void testLoad() {
        doTestLoad(
                Set.of(Tag.Spirv.SC_PRIVATE),
                Set.of()
        );
        doTestLoad(
                Set.of(Tag.Spirv.SC_WORKGROUP),
                Set.of(Tag.Vulkan.SC1)
        );
        doTestLoad(
                Set.of(Tag.Spirv.MEM_NON_PRIVATE, Tag.Spirv.DEVICE),
                Set.of(Tag.Vulkan.NON_PRIVATE, Tag.Vulkan.DEVICE)
        );
        doTestLoad(
                Set.of(Tag.Spirv.MEM_NON_PRIVATE, Tag.Spirv.MEM_VISIBLE, Tag.Spirv.DEVICE, Tag.Spirv.SC_UNIFORM),
                Set.of(Tag.Vulkan.NON_PRIVATE, Tag.Vulkan.VISIBLE, Tag.Vulkan.DEVICE, Tag.Vulkan.SC0)
        );
    }

    private void doTestLoad(Set<String> spvTags, Set<String> vulTags) {
        // given
        Register register = mock(Register.class);
        MemoryObject address = mock(MemoryObject.class);
        Load e = EventFactory.newLoad(register, address);
        e.setFunction(mock(Function.class));
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
                Set.of(Tag.Spirv.SC_PRIVATE),
                Set.of()
        );
        doTestStore(
                Set.of(Tag.Spirv.SC_WORKGROUP),
                Set.of(Tag.Vulkan.SC1)
        );
        doTestStore(
                Set.of(Tag.Spirv.MEM_NON_PRIVATE, Tag.Spirv.DEVICE),
                Set.of(Tag.Vulkan.NON_PRIVATE, Tag.Vulkan.DEVICE)
        );
        doTestStore(
                Set.of(Tag.Spirv.MEM_NON_PRIVATE, Tag.Spirv.MEM_AVAILABLE, Tag.Spirv.DEVICE, Tag.Spirv.SC_UNIFORM),
                Set.of(Tag.Vulkan.NON_PRIVATE, Tag.Vulkan.AVAILABLE, Tag.Vulkan.DEVICE, Tag.Vulkan.SC0)
        );
    }

    private void doTestStore(Set<String> spvTags, Set<String> vulTags) {
        // given
        Expression value = mock(Expression.class);
        MemoryObject address = mock(MemoryObject.class);
        Store e = EventFactory.newStore(address, value);
        e.setFunction(mock(Function.class));
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
                Set.of(Tag.Spirv.SC_WORKGROUP, Tag.Spirv.SUBGROUP, Tag.Spirv.RELAXED),
                Set.of(Tag.Vulkan.SC1, Tag.Vulkan.SUB_GROUP)
        );
        doTestSpirvLoad(
                Set.of(Tag.Spirv.SC_WORKGROUP, Tag.Spirv.WORKGROUP, Tag.Spirv.ACQUIRE, Tag.Spirv.SEM_WORKGROUP),
                Set.of(Tag.Vulkan.SC1, Tag.Vulkan.WORK_GROUP, Tag.Vulkan.ACQUIRE, Tag.Vulkan.SEMSC1)
        );
        doTestSpirvLoad(
                Set.of(Tag.Spirv.SC_UNIFORM, Tag.Spirv.WORKGROUP, Tag.Spirv.ACQUIRE, Tag.Spirv.SEM_UNIFORM, Tag.Spirv.SEM_VISIBLE),
                Set.of(Tag.Vulkan.SC0, Tag.Vulkan.WORK_GROUP, Tag.Vulkan.ACQUIRE, Tag.Vulkan.SEMSC0, Tag.Vulkan.SEM_VISIBLE)
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
    public void testSpirvStore() {
        doTestSpirvStore(
                Set.of(Tag.Spirv.SC_WORKGROUP, Tag.Spirv.SUBGROUP, Tag.Spirv.RELAXED),
                Set.of(Tag.Vulkan.SC1, Tag.Vulkan.SUB_GROUP)
        );
        doTestSpirvStore(
                Set.of(Tag.Spirv.SC_WORKGROUP, Tag.Spirv.WORKGROUP, Tag.Spirv.RELEASE, Tag.Spirv.SEM_WORKGROUP),
                Set.of(Tag.Vulkan.SC1, Tag.Vulkan.WORK_GROUP, Tag.Vulkan.RELEASE, Tag.Vulkan.SEMSC1)
        );
        doTestSpirvStore(
                Set.of(Tag.Spirv.SC_UNIFORM, Tag.Spirv.WORKGROUP, Tag.Spirv.RELEASE, Tag.Spirv.SEM_UNIFORM, Tag.Spirv.SEM_AVAILABLE),
                Set.of(Tag.Vulkan.SC0, Tag.Vulkan.WORK_GROUP, Tag.Vulkan.RELEASE, Tag.Vulkan.SEMSC0, Tag.Vulkan.SEM_AVAILABLE)
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
    public void testSpirvXchg() {
        doTestSpirvXchg(
                Set.of(Tag.Spirv.SC_WORKGROUP, Tag.Spirv.SUBGROUP, Tag.Spirv.RELAXED),
                Set.of(Tag.Vulkan.SC1, Tag.Vulkan.SUB_GROUP),
                Set.of(Tag.Vulkan.SC1, Tag.Vulkan.SUB_GROUP)
        );
        doTestSpirvXchg(
                Set.of(Tag.Spirv.SC_WORKGROUP, Tag.Spirv.WORKGROUP, Tag.Spirv.ACQUIRE, Tag.Spirv.SEM_WORKGROUP),
                Set.of(Tag.Vulkan.SC1, Tag.Vulkan.WORK_GROUP, Tag.Vulkan.ACQUIRE, Tag.Vulkan.SEMSC1),
                Set.of(Tag.Vulkan.SC1, Tag.Vulkan.WORK_GROUP)
        );
        doTestSpirvXchg(
                Set.of(Tag.Spirv.SC_WORKGROUP, Tag.Spirv.WORKGROUP, Tag.Spirv.RELEASE, Tag.Spirv.SEM_WORKGROUP),
                Set.of(Tag.Vulkan.SC1, Tag.Vulkan.WORK_GROUP),
                Set.of(Tag.Vulkan.SC1, Tag.Vulkan.WORK_GROUP, Tag.Vulkan.RELEASE, Tag.Vulkan.SEMSC1)
        );
        doTestSpirvXchg(
                Set.of(Tag.Spirv.SC_WORKGROUP, Tag.Spirv.WORKGROUP, Tag.Spirv.ACQ_REL, Tag.Spirv.SEM_WORKGROUP),
                Set.of(Tag.Vulkan.SC1, Tag.Vulkan.WORK_GROUP, Tag.Vulkan.ACQUIRE, Tag.Vulkan.SEMSC1),
                Set.of(Tag.Vulkan.SC1, Tag.Vulkan.WORK_GROUP, Tag.Vulkan.RELEASE, Tag.Vulkan.SEMSC1)
        );
    }

    private void doTestSpirvXchg(Set<String> spvTags, Set<String> loadTags, Set<String> storeTags) {
        // given
        Function function = new Function("mock", mock(FunctionType.class), List.of(), 0, null);
        Register register = function.newRegister(types.getBooleanType());
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
                Set.of(Tag.Spirv.SC_WORKGROUP, Tag.Spirv.SUBGROUP, Tag.Spirv.RELAXED),
                Set.of(Tag.Vulkan.SC1, Tag.Vulkan.SUB_GROUP),
                Set.of(Tag.Vulkan.SC1, Tag.Vulkan.SUB_GROUP)
        );
        doTestSpirvRmw(
                Set.of(Tag.Spirv.SC_WORKGROUP, Tag.Spirv.WORKGROUP, Tag.Spirv.ACQUIRE, Tag.Spirv.SEM_WORKGROUP),
                Set.of(Tag.Vulkan.SC1, Tag.Vulkan.WORK_GROUP, Tag.Vulkan.ACQUIRE, Tag.Vulkan.SEMSC1),
                Set.of(Tag.Vulkan.SC1, Tag.Vulkan.WORK_GROUP)
        );
        doTestSpirvRmw(
                Set.of(Tag.Spirv.SC_WORKGROUP, Tag.Spirv.WORKGROUP, Tag.Spirv.RELEASE, Tag.Spirv.SEM_WORKGROUP),
                Set.of(Tag.Vulkan.SC1, Tag.Vulkan.WORK_GROUP),
                Set.of(Tag.Vulkan.SC1, Tag.Vulkan.WORK_GROUP, Tag.Vulkan.RELEASE, Tag.Vulkan.SEMSC1)
        );
        doTestSpirvRmw(
                Set.of(Tag.Spirv.SC_WORKGROUP, Tag.Spirv.WORKGROUP, Tag.Spirv.ACQ_REL, Tag.Spirv.SEM_WORKGROUP),
                Set.of(Tag.Vulkan.SC1, Tag.Vulkan.WORK_GROUP, Tag.Vulkan.ACQUIRE, Tag.Vulkan.SEMSC1),
                Set.of(Tag.Vulkan.SC1, Tag.Vulkan.WORK_GROUP, Tag.Vulkan.RELEASE, Tag.Vulkan.SEMSC1)
        );
    }

    private void doTestSpirvRmw(Set<String> spvTags, Set<String> loadTags, Set<String> storeTags) {
        // given
        Function function = new Function("mock", mock(FunctionType.class), List.of(), 0, null);
        Register register = function.newRegister(archType);
        Expression value = expressions.makeValue(1, archType);
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
                Set.of(Tag.Spirv.ACQUIRE, Tag.Spirv.SEM_WORKGROUP),
                Set.of(Tag.Spirv.ACQUIRE, Tag.Spirv.SEM_WORKGROUP),
                Set.of(Tag.Vulkan.WORK_GROUP, Tag.Vulkan.ACQUIRE, Tag.Vulkan.SEMSC1),
                Set.of(Tag.Vulkan.WORK_GROUP));
        doTestSpirvCmpXchg(
                Tag.Spirv.WORKGROUP,
                Set.of(Tag.Spirv.RELEASE, Tag.Spirv.SEM_WORKGROUP),
                Set.of(Tag.Spirv.RELAXED, Tag.Spirv.SEM_WORKGROUP),
                Set.of(Tag.Vulkan.WORK_GROUP),
                Set.of(Tag.Vulkan.WORK_GROUP, Tag.Vulkan.RELEASE, Tag.Vulkan.SEMSC1));
        doTestSpirvCmpXchg(
                Tag.Spirv.WORKGROUP,
                Set.of(Tag.Spirv.ACQ_REL, Tag.Spirv.SEM_WORKGROUP),
                Set.of(Tag.Spirv.ACQUIRE, Tag.Spirv.SEM_WORKGROUP),
                Set.of(Tag.Vulkan.WORK_GROUP, Tag.Vulkan.ACQUIRE, Tag.Vulkan.SEMSC1),
                Set.of(Tag.Vulkan.WORK_GROUP, Tag.Vulkan.RELEASE, Tag.Vulkan.SEMSC1));
    }

    private void doTestSpirvCmpXchg(String scope, Set<String> eqTags, Set<String> neqTags, Set<String> loadTags, Set<String> storeTags) {
        // given
        Function function = new Function("mock", mock(FunctionType.class), List.of(), 0, null);
        Register register = function.newRegister(archType);
        Expression cmp = expressions.makeValue(0, archType);
        Expression value = expressions.makeValue(1, archType);
        MemoryObject address = mock(MemoryObject.class);
        SpirvCmpXchg e = EventFactory.Spirv.newSpirvCmpXchg(register, address, cmp, value, scope, eqTags, neqTags);
        e.setFunction(function);

        // when
        List<Event> seq = visitor.visitSpirvCmpXchg(e);

        // then
        assertEquals(5, seq.size());
        Load load = (Load) seq.get(0);
        Set<String> baseLoadTags = Set.of(Tag.VISIBLE, Tag.MEMORY, Tag.READ, Tag.RMW,
                Tag.Vulkan.ATOM, Tag.Vulkan.VISIBLE, Tag.Vulkan.NON_PRIVATE);
        assertEquals(Sets.union(baseLoadTags, loadTags), load.getTags());
        Store store = (Store) seq.get(3);
        Set<String> baseStoreTags = Set.of(Tag.VISIBLE, Tag.MEMORY, Tag.WRITE, Tag.RMW,
                Tag.Vulkan.ATOM, Tag.Vulkan.AVAILABLE, Tag.Vulkan.NON_PRIVATE);
        assertEquals(Sets.union(baseStoreTags, storeTags), store.getTags());
    }

    @Test
    public void testCmpXchgIllegal() {
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
        Function function = new Function("mock", mock(FunctionType.class), List.of(), 0, null);
        Register register = function.newRegister(archType);
        Expression cmp = expressions.makeValue(0, archType);
        Expression value = expressions.makeValue(1, archType);
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
                Set.of(Tag.Spirv.SUBGROUP, Tag.Spirv.RELAXED),
                Set.of(Tag.Vulkan.SUB_GROUP)
        );
        doTestSpirvMemoryBarrier(
                Set.of(Tag.Spirv.SUBGROUP, Tag.Spirv.ACQUIRE, Tag.Spirv.SEM_WORKGROUP),
                Set.of(Tag.Vulkan.SUB_GROUP, Tag.Vulkan.ACQUIRE, Tag.Vulkan.SEMSC1)
        );
        doTestSpirvMemoryBarrier(
                Set.of(Tag.Spirv.SUBGROUP, Tag.Spirv.RELEASE, Tag.Spirv.SEM_WORKGROUP),
                Set.of(Tag.Vulkan.SUB_GROUP, Tag.Vulkan.RELEASE, Tag.Vulkan.SEMSC1)
        );
        doTestSpirvMemoryBarrier(
                Set.of(Tag.Spirv.SUBGROUP, Tag.Spirv.ACQ_REL, Tag.Spirv.SEM_WORKGROUP),
                Set.of(Tag.Vulkan.SUB_GROUP, Tag.Vulkan.ACQUIRE, Tag.Vulkan.RELEASE, Tag.Vulkan.SEMSC1)
        );
    }

    private void doTestSpirvMemoryBarrier(Set<String> spvTags, Set<String> expected) {
        // given
        GenericVisibleEvent e = new GenericVisibleEvent("membar", Tag.FENCE);
        e.setFunction(mock(Function.class));
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
                Set.of(Tag.Spirv.SUBGROUP, Tag.Spirv.RELAXED),
                Set.of(Tag.FENCE, Tag.Vulkan.SUB_GROUP)
        );
        doTestSpirvControlBarrier(
                Set.of(Tag.Spirv.SUBGROUP, Tag.Spirv.ACQUIRE, Tag.Spirv.SEM_WORKGROUP),
                Set.of(Tag.FENCE, Tag.Vulkan.SUB_GROUP, Tag.Vulkan.ACQUIRE, Tag.Vulkan.SEMSC1)
        );
        doTestSpirvControlBarrier(
                Set.of(Tag.Spirv.SUBGROUP, Tag.Spirv.RELEASE, Tag.Spirv.SEM_WORKGROUP),
                Set.of(Tag.FENCE, Tag.Vulkan.SUB_GROUP, Tag.Vulkan.RELEASE, Tag.Vulkan.SEMSC1)
        );
        doTestSpirvControlBarrier(
                Set.of(Tag.Spirv.SUBGROUP, Tag.Spirv.ACQ_REL, Tag.Spirv.SEM_WORKGROUP),
                Set.of(Tag.FENCE, Tag.Vulkan.SUB_GROUP, Tag.Vulkan.ACQUIRE, Tag.Vulkan.RELEASE, Tag.Vulkan.SEMSC1)
        );
    }

    private void doTestSpirvControlBarrier(Set<String> spvTags, Set<String> expected) {
        // given
        ControlBarrier e = EventFactory.newControlBarrier("test", "test");
        e.setFunction(mock(Function.class));
        e.addTags(Tag.Spirv.CONTROL);
        if (!spvTags.isEmpty()) {
            e.addTags(spvTags);
        } else {
            e.removeTags(Tag.FENCE);
        }

        // when
        List<Event> seq = visitor.visitControlBarrier(e);

        // then
        assertEquals(1, seq.size());
        ControlBarrier barrier = (ControlBarrier) seq.get(0);
        Set<String> baseTags = Set.of(Tag.VISIBLE, Tag.Vulkan.CBAR);
        assertEquals(Sets.union(baseTags, expected), barrier.getTags());
    }
}
