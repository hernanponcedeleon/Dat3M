package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.processing.ProgramProcessor;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;

import java.math.BigInteger;
import java.util.*;

public class Memory {

    private final ArrayList<MemoryObject> objects = new ArrayList<>();

    private int nextIndex = 1;

    /**
     * Creates a new object.
     * @return
     * Points to the created location.
     */
    public MemoryObject allocate(int size) {
        Preconditions.checkArgument(size > 0, "Illegal malloc. Size must be positive");
        MemoryObject address = new MemoryObject(nextIndex++,size);
        objects.add(address);
        return address;
    }

    /**
     * Accesses all shared variables.
     * @return
     * Copy of the complete collection of allocated objects.
     */
    public ImmutableSet<MemoryObject> getObjects() {
        return ImmutableSet.copyOf(objects);
    }

    /**
     * Creates a new processing primitive that recalculates addresses.
     * @return
     * When provided a program, repositions its allocated objects.
     */
    public static FixateMemoryValues fixateMemoryValues() {
        return new FixateMemoryValues();
    }

    /**
     * Recomputes the values for all objects,
     * so that their arrays do not overlap.
     */
    public static final class FixateMemoryValues implements ProgramProcessor {

        @Override
        public void run(Program program) {
            BigInteger i = BigInteger.ONE;
            for(MemoryObject a : program.getMemory().objects) {
                a.address = i;
                i = i.add(BigInteger.valueOf(a.size()));
            }
        }
    }
}