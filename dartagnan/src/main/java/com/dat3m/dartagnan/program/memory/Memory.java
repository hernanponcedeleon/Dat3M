package com.dat3m.dartagnan.program.memory;

import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;

import java.util.*;

public class Memory {

    private final Set<Address> map;
    private final Collection<Address> arrays;

    private int nextIndex = 1;

    public Memory() {
        map = new HashSet<>();
        arrays = new ArrayList<>();
    }

    /**
     * @param a
     * Address associated with this instance.
     * @return
     * The address points to a static location.
     */
    public boolean isStatic(Address a) {
        return map.contains(a);
    }

    public Address malloc(int size) {
    	Preconditions.checkArgument(size > 0, "Illegal malloc. Size must be positive");

        Address address = new Address(nextIndex,size);
        nextIndex += size;
        arrays.add(address);
        return address;
    }

    /**
     * Creates a new static location.
     * @return
     * Points to the created location.
     */
    public Address newLocation() {
        Address address = new Address(nextIndex++,1);
        map.add(address);
        return address;
    }

    public ImmutableSet<Address> getAllAddresses() {
        Set<Address> result = new HashSet<>(map);
        result.addAll(arrays);
        return ImmutableSet.copyOf(result);
    }
}