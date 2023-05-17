package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

public class Memory {

    private final ArrayList<MemoryObject> objects = new ArrayList<>();

    private final Map<String, MemoryObject> staticObjects = new HashMap<>();

    private int nextIndex = 1;

    /**
     * Creates a new object.
     * @return
     * Points to the created location.
     */
    public MemoryObject allocate(int size, boolean isStatic) {
        Preconditions.checkArgument(size > 0, "Illegal malloc. Size must be positive");
        MemoryObject address = new MemoryObject(nextIndex++, size, isStatic);
        objects.add(address);
        return address;
    }

    public Optional<MemoryObject> getObject(String name) {
        return Optional.ofNullable(staticObjects.get(name));
    }

    public MemoryObject newObject(String name, int size) {
        MemoryObject newObject = allocate(size, true);
        staticObjects.put(name, newObject);
        return newObject;
    }

    public MemoryObject getOrNewObject(String name) {
        MemoryObject fetched = staticObjects.get(name);
        if (fetched == null) {
            return newObject(name, 1);
        }
        return fetched;
    }

    public MemoryObject getOrNewObject(String name, int size) {
        MemoryObject fetched = staticObjects.get(name);
        if (fetched == null) {
            return newObject(name, size);
        }
        if (fetched.size() != size) {
            throw new MalformedProgramException("Inconsistent size of static variable \"" + name + "\": " + fetched.size() + " vs. " + size + ".");
        }
        return fetched;
    }

    /**
     * Accesses all shared variables.
     * @return
     * Copy of the complete collection of allocated objects.
     */
    public ImmutableSet<MemoryObject> getObjects() {
        return ImmutableSet.copyOf(objects);
    }

}