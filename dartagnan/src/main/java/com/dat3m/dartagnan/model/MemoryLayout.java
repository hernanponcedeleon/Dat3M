package com.dat3m.dartagnan.model;

import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.google.common.base.Preconditions;

import java.math.BigInteger;
import java.util.*;

/*
    The concrete placement of all allocated memory objects of an execution.
    Addresses are normalized to unsigned values.
 */
public final class MemoryLayout {

    public record AllocatedObject(MemoryObject object, BigInteger address, BigInteger size) {
        public boolean contains(BigInteger addr) {
            return addr.compareTo(address) >= 0 && addr.compareTo(address.add(size)) < 0;
        }
    }

    public record Location(AllocatedObject base, BigInteger offset) {
        public BigInteger address() { return base.address().add(offset); }
    }

    private final Map<MemoryObject, AllocatedObject> objects;
    private final NavigableMap<BigInteger, AllocatedObject> objectsByAddress;

    MemoryLayout(Collection<AllocatedObject> allocatedObjects) {
        final Map<MemoryObject, AllocatedObject> objects = new LinkedHashMap<>();
        final NavigableMap<BigInteger, AllocatedObject> objectsByAddress = new TreeMap<>();
        for (AllocatedObject obj : allocatedObjects) {
            Preconditions.checkArgument(objects.put(obj.object(), obj) == null, "Duplicate object %s", obj.object());
            // Zero-sized objects can share their address with other objects, we do not use them for address lookups.
            if (obj.size().signum() > 0) {
                objectsByAddress.put(obj.address(), obj);
            }
        }
        this.objects = Collections.unmodifiableMap(objects);
        this.objectsByAddress = Collections.unmodifiableNavigableMap(objectsByAddress);
    }

    public Collection<AllocatedObject> getAllocatedObjects() {
        return objects.values();
    }

    public boolean isAllocated(MemoryObject object) {
        return objects.containsKey(object);
    }

    public Optional<AllocatedObject> get(MemoryObject object) {
        return Optional.ofNullable(objects.get(object));
    }

    public BigInteger getAddress(MemoryObject object) {
        final AllocatedObject obj = objects.get(object);
        Preconditions.checkArgument(obj != null, "Memory object %s is not allocated", object);
        return obj.address();
    }

    // Returns the allocated object (and offset) that contains the given address, if any.
    public Optional<Location> resolve(BigInteger address) {
        return floor(address)
                .filter(obj -> obj.contains(address))
                .map(obj -> new Location(obj, address.subtract(obj.address())));
    }

    // Returns the (non-empty) object with the greatest start address at or below the given address, if any.
    // Unlike resolve, the address may lie beyond the end of the object (e.g. for out-of-bounds accesses).
    public Optional<AllocatedObject> floor(BigInteger address) {
        return Optional.ofNullable(objectsByAddress.floorEntry(address)).map(Map.Entry::getValue);
    }
}
