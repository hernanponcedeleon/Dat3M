package com.dat3m.dartagnan.program.memory;

import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;

import java.util.*;

public class Memory {

    private final ArrayList<Address> arrays = new ArrayList<>();

    private int nextIndex = 1;

    /**
     * Creates a new static location.
     * @return
     * Points to the created location.
     */
    public Address newLocation(int size) {
        Preconditions.checkArgument(size > 0, "Illegal malloc. Size must be positive");
        Address address = new Address(nextIndex,size);
        nextIndex += size;
        arrays.add(address);
        return address;
    }

    public ImmutableSet<Address> getAllAddresses() {
        return ImmutableSet.copyOf(arrays);
    }
}