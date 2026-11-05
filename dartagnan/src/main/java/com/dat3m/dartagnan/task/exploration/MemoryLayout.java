package com.dat3m.dartagnan.task.exploration;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Alloc;
import com.dat3m.dartagnan.program.event.core.Init;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;

import java.math.BigInteger;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

/*
    Assigns concrete addresses to memory objects.
    Statically allocated objects get a fixed address.
    Each dynamic execution of an allocation site (Alloc event) gets its own fresh region, identified by the
    allocation site, the executing thread instance (threads spawned from the same template share allocation sites),
    and the number of previous executions of the site by that thread.
    The same execution of an allocation site always gets the same address, in every explored graph.

    The layout also provides the (unique) init node of each location.
 */
final class MemoryLayout {

    record Region(MemoryObject object, int instance, BigInteger base, int size) {}
    private record AllocationKey(Alloc alloc, int thread, int count) {}

    private static final int DEFAULT_ALIGNMENT = 8;

    private final Program program;
    private final TreeMap<BigInteger, Region> regions = new TreeMap<>();
    private final Map<MemoryObject, Region> firstInstance = new ConcurrentHashMap<>();
    private final Map<AllocationKey, Region> dynamicInstances = new HashMap<>();
    private final Map<Alloc, Integer> numInstances = new HashMap<>();
    private final Map<MemoryObject, Map<Integer, Init>> initEvents = new HashMap<>();
    private final Map<BigInteger, Node> initNodes = new ConcurrentHashMap<>();
    private final Set<String> syntheticInitTags;
    private BigInteger next = BigInteger.valueOf(0x1000);

    // Needed to evaluate initial values (which may contain addresses).
    private ConcreteEvaluator constantEvaluator;

    MemoryLayout(Program program) {
        this.program = program;
        final boolean isC11 = program.getArch() == Arch.C11 || program.getArch() == Arch.OPENCL;
        syntheticInitTags = isC11
                ? ImmutableSet.<String>builder().addAll(Node.SYNTHETIC_INIT_TAGS).add(Tag.C11.NONATOMIC).build()
                : Node.SYNTHETIC_INIT_TAGS;
        for (Thread t : program.getThreads()) {
            for (Event e : t.getEvents()) {
                if (e instanceof Init init) {
                    initEvents.computeIfAbsent(init.getBase(), k -> new HashMap<>()).put(init.getOffset(), init);
                }
            }
        }
        // Allocate static objects in a deterministic order.
        program.getMemory().getObjects().stream()
                .filter(MemoryObject::isStaticallyAllocated)
                .sorted(Comparator.comparing(MemoryObject::toString))
                .forEach(o -> firstInstance.put(o, allocateRegion(o, 0, sizeOf(o), alignmentOf(o))));
        constantEvaluator = new ConcreteEvaluator(new ConcreteEvaluator.Environment() {
            @Override
            public Object getRegisterValue(com.dat3m.dartagnan.program.Register register) {
                throw new UnsupportedOperationException("Initial values cannot depend on registers: " + register);
            }

            @Override
            public BigInteger getAddress(MemoryObject memoryObject) {
                return MemoryLayout.this.getAddress(memoryObject);
            }
        });
    }

    private static int sizeOf(MemoryObject o) {
        return o.hasKnownSize() ? Math.max(o.getKnownSize(), 1) : 1;
    }

    private static int alignmentOf(MemoryObject o) {
        return o.hasKnownAlignment() ? Math.max(o.getKnownAlignment(), 1) : DEFAULT_ALIGNMENT;
    }

    private Region allocateRegion(MemoryObject object, int instance, int size, int alignment) {
        final BigInteger align = BigInteger.valueOf(Math.max(alignment, DEFAULT_ALIGNMENT));
        final BigInteger rem = next.mod(align);
        if (rem.signum() != 0) {
            next = next.add(align.subtract(rem));
        }
        final Region region = new Region(object, instance, next, size);
        regions.put(next, region);
        // Leave a gap between objects to make out-of-bounds accesses distinguishable.
        next = next.add(BigInteger.valueOf(size + DEFAULT_ALIGNMENT));
        return region;
    }

    BigInteger getAddress(MemoryObject object) {
        final Region known = firstInstance.get(object);
        return known != null ? known.base() : getAddressSlow(object);
    }

    private synchronized BigInteger getAddressSlow(MemoryObject object) {
        Region region = firstInstance.get(object);
        if (region == null) {
            // Dynamically allocated object referenced directly: we use its first allocation by the first thread.
            Preconditions.checkState(object.isDynamicallyAllocated());
            region = getDynamicRegion(new AllocationKey(object.getAllocationSite(), 0, 0), sizeOf(object));
        }
        return region.base();
    }

    // Returns the address of the count-th execution of the allocation site by the given thread instance.
    synchronized BigInteger allocate(Alloc alloc, int thread, int count, int sizeInBytes) {
        final Region region = getDynamicRegion(new AllocationKey(alloc, thread, count), sizeInBytes);
        if (region.size() < sizeInBytes) {
            throw new UnsupportedOperationException(String.format(
                    "Allocation site %s allocates objects of varying size (%d > %d).", alloc, sizeInBytes, region.size()));
        }
        return region.base();
    }

    private Region getDynamicRegion(AllocationKey key, int sizeInBytes) {
        final Region known = dynamicInstances.get(key);
        if (known != null) {
            return known;
        }
        final MemoryObject object = key.alloc().getAllocatedObject();
        final int instance = numInstances.merge(key.alloc(), 1, Integer::sum) - 1;
        final int size = Math.max(sizeInBytes, sizeOf(object));
        final Region region = allocateRegion(object, instance, Math.max(size, 1), alignmentOf(object));
        dynamicInstances.put(key, region);
        if (instance == 0) {
            firstInstance.put(object, region);
        }
        return region;
    }

    // Returns the unique init node of the location.
    Node getInitNode(BigInteger address, Type accessType) {
        final Node known = initNodes.get(address);
        return known != null ? known : createInitNode(address, accessType);
    }

    private synchronized Node createInitNode(BigInteger address, Type accessType) {
        Node init = initNodes.get(address);
        if (init != null) {
            return init;
        }
        final Map.Entry<BigInteger, Region> entry = regions.floorEntry(address);
        Init initEvent = null;
        Object value = ConcreteEvaluator.zeroOf(accessType);
        if (entry != null) {
            final Region region = entry.getValue();
            final int offset = address.subtract(region.base()).intValueExact();
            if (offset < region.size()) {
                final MemoryObject object = region.object();
                if (region.instance() == 0) {
                    initEvent = initEvents.getOrDefault(object, Map.of()).get(offset);
                }
                if (object.hasKnownSize() && object.getInitializedFields().contains(offset)) {
                    value = Values.convert(constantEvaluator.evaluate(object.getInitialValue(offset)), accessType);
                }
            }
        }
        init = Node.newInit(address, accessType, value, initEvent, syntheticInitTags);
        initNodes.put(address, init);
        return init;
    }

    synchronized String describe(BigInteger address) {
        final Map.Entry<BigInteger, Region> entry = regions.floorEntry(address);
        if (entry != null) {
            final Region region = entry.getValue();
            final int offset = address.subtract(region.base()).intValue();
            if (offset < region.size()) {
                final String name = region.object().hasName() ? region.object().getName() : region.object().toString();
                final String inst = region.instance() > 0 ? "#" + region.instance() : "";
                return offset == 0 ? name + inst : name + inst + "[" + offset + "]";
            }
        }
        return "0x" + address.toString(16);
    }

    BigInteger getAddress(MemoryObject object, int offset) {
        return getAddress(object).add(BigInteger.valueOf(offset));
    }

    Program getProgram() {
        return program;
    }
}
