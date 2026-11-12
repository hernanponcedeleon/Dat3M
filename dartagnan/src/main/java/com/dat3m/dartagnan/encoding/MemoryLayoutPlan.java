package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableList;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigInteger;
import java.util.*;

/*
    Determines the order in which memory objects are placed in memory and statically computes the placement of all
    objects whose size and alignment are known.

    Objects are placed in the following order:
      (1) objects of known size and alignment (static objects first, then stack objects, then heap objects),
      (2) stack objects of unknown size or alignment,
      (3) heap objects of unknown size or alignment.
    Objects of group (1) get fixed addresses computed here (even if their allocation is not executed).
    Objects of groups (2) and (3) are placed by the encoding right after the last object of group (1).

    A heap object of group (1) that does not fit into the address space reserves no memory.
    Static and stack objects are assumed to be small enough to never wrap around the address space.
 */
final class MemoryLayoutPlan {

    private static final Logger logger = LoggerFactory.getLogger(MemoryLayoutPlan.class);

    record Placement(BigInteger address, BigInteger size, boolean fits) { }

    private final List<MemoryObject> fixedObjects;
    private final List<MemoryObject> dynamicObjects;
    private final Map<MemoryObject, Placement> placements;
    private final BigInteger nextAvailableAddress;

    private MemoryLayoutPlan(List<MemoryObject> fixedObjects, List<MemoryObject> dynamicObjects,
                             Map<MemoryObject, Placement> placements, BigInteger nextAvailableAddress) {
        this.fixedObjects = fixedObjects;
        this.dynamicObjects = dynamicObjects;
        this.placements = placements;
        this.nextAvailableAddress = nextAvailableAddress;
    }

    // Objects with statically known placement, in placement order.
    List<MemoryObject> getFixedObjects() { return fixedObjects; }

    // Objects whose placement must be encoded, in placement order (placed after all fixed objects).
    List<MemoryObject> getDynamicObjects() { return dynamicObjects; }

    boolean isFixed(MemoryObject object) { return placements.containsKey(object); }

    Placement getPlacement(MemoryObject object) {
        Preconditions.checkArgument(isFixed(object), "Memory object %s has no fixed placement.", object);
        return placements.get(object);
    }

    // The first address after the last fixed object.
    BigInteger getNextAvailableAddress() { return nextAvailableAddress; }

    static MemoryLayoutPlan compute(Memory memory) {
        final int bitWidth = memory.getArchType().getBitWidth();
        final BigInteger addressSpaceSize = BigInteger.ONE.shiftLeft(bitWidth);

        final List<MemoryObject> fixed = new ArrayList<>();
        final List<MemoryObject> dynamicStack = new ArrayList<>();
        final List<MemoryObject> dynamicHeap = new ArrayList<>();
        for (MemoryObject obj : memory.getObjects()) {
            if (obj.hasKnownSize() && obj.hasKnownAlignment()) {
                fixed.add(obj);
            } else if (obj.isHeapAllocated()) {
                dynamicHeap.add(obj);
            } else {
                dynamicStack.add(obj);
            }
        }
        // Stable sort: keeps the original order within each group.
        fixed.sort(Comparator.comparingInt(MemoryLayoutPlan::fixedGroup));

        final Map<MemoryObject, Placement> placements = new HashMap<>();
        BigInteger next = BigInteger.ZERO;
        for (MemoryObject obj : fixed) {
            final BigInteger size = ((IntLiteral) obj.size()).getValue().mod(addressSpaceSize);
            final BigInteger alignment = ((IntLiteral) obj.alignment()).getValue().mod(addressSpaceSize).max(BigInteger.ONE);
            // Same placement as in the encoding: the next well-aligned address with a padding in [1, alignment].
            final BigInteger address = next.add(alignment).subtract(next.mod(alignment));
            final BigInteger end = address.add(size);
            // NOTE: The end must be strictly below 2^n, so that the next object does not start at address 0.
            final boolean fits = end.compareTo(addressSpaceSize) < 0;
            if (fits) {
                placements.put(obj, new Placement(address, size, true));
                next = end;
            } else if (obj.isHeapAllocated()) {
                logger.warn("Heap allocation of {} bytes for {} can never fit into the {}-bit address space.",
                        size, obj, bitWidth);
                // Failed allocations reserve no memory.
                placements.put(obj, new Placement(next, BigInteger.ZERO, false));
            } else {
                throw new IllegalStateException(String.format(
                        "Memory object %s of %s bytes does not fit into the %d-bit address space.", obj, size, bitWidth));
            }
        }

        final List<MemoryObject> dynamic = ImmutableList.<MemoryObject>builder()
                .addAll(dynamicStack).addAll(dynamicHeap).build();
        return new MemoryLayoutPlan(ImmutableList.copyOf(fixed), dynamic, placements, next);
    }

    private static int fixedGroup(MemoryObject obj) {
        return obj.isStaticallyAllocated() ? 0 : obj.isHeapAllocated() ? 2 : 1;
    }
}
