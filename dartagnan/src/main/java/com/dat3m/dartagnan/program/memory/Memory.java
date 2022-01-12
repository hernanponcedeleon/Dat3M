package com.dat3m.dartagnan.program.memory;

import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;

import java.util.*;

public class Memory {

    private final Set<Address> map;
    private final Map<String, List<Address>> arrays;

    private int nextIndex = 1;

    public Memory() {
        map = new HashSet<>();
        arrays = new HashMap<>();
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

    public List<Address> malloc(String name, int size) {
    	Preconditions.checkArgument(!arrays.containsKey(name), "Illegal malloc. Array " + name + " is already defined");
    	Preconditions.checkArgument(size > 0, "Illegal malloc. Size must be positive");

    	List<Address> addresses = new ArrayList<>();
    	for(int i = 0; i < size; i++) {
    		addresses.add(new Address(nextIndex++));
    	}
    	arrays.put(name, addresses);
    	return addresses;
    }

    public Location newLocation(String name){
        Location location = new Location(name, new Address(nextIndex++));
        map.add(location.getAddress());
        return location;
    }

    public ImmutableSet<Address> getAllAddresses() {
        Set<Address> result = new HashSet<>(map);
        for(List<Address> array : arrays.values()){
            result.addAll(array);
        }
        return ImmutableSet.copyOf(result);
    }

    public boolean isArrayPointer(Address address) {
        return arrays.values().stream().anyMatch(array -> array.contains(address));
    }

    public Collection<List<Address>> getArrays() {
        return arrays.values();
    }

    public List<Address> getArrayFromPointer(Address address) {
        return arrays.values().stream()
                .filter(array -> array.contains(address))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("Provided address does not belong to any array."));
    }
}