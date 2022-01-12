package com.dat3m.dartagnan.program.memory;

import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;

import java.util.*;

public class Memory {

    private final Set<Address> map;
    private final Collection<List<Address>> arrays;

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

    public List<Address> malloc(int size) {
    	Preconditions.checkArgument(size > 0, "Illegal malloc. Size must be positive");

    	List<Address> addresses = new ArrayList<>();
    	for(int i = 0; i < size; i++) {
    		addresses.add(new Address(nextIndex++));
    	}
    	arrays.add(addresses);
    	return addresses;
    }

    /**
     * Creates a new static location.
     * @return
     * Points to the created location.
     */
    public Address newLocation() {
        Address address = new Address(nextIndex++);
        map.add(address);
        return address;
    }

    public ImmutableSet<Address> getAllAddresses() {
        Set<Address> result = new HashSet<>(map);
        for(List<Address> array : arrays){
            result.addAll(array);
        }
        return ImmutableSet.copyOf(result);
    }

    public boolean isArrayPointer(Address address) {
        return arrays.stream().anyMatch(array -> array.contains(address));
    }

    public Collection<List<Address>> getArrays() {
        return arrays;
    }

    public List<Address> getArrayFromPointer(Address address) {
        return arrays.stream()
                .filter(array -> array.contains(address))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("Provided address does not belong to any array."));
    }
}