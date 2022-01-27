package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.processing.ProgramProcessor;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;

import java.math.BigInteger;
import java.util.*;

public class Memory {

    private final ArrayList<Address> arrays = new ArrayList<>();

    private int nextIndex = 1;

    /**
     * Creates a new static location.
     * @return
     * Points to the created location.
     */
    public Address allocate(int size) {
        Preconditions.checkArgument(size > 0, "Illegal malloc. Size must be positive");
        Address address = new Address(nextIndex++,size);
        arrays.add(address);
        return address;
    }

    public ImmutableSet<Address> getAllAddresses() {
        return ImmutableSet.copyOf(arrays);
    }

    /**
     * Creates a new processing primitive that recalculates addresses.
     * @return
     * When provided a program, repositions its allocated addresses.
     */
    public static FixateMemoryValues fixateMemoryValues() {
        return new FixateMemoryValues();
    }

    /**
     * Recomputes the values for all addresses,
     * so that their arrays do not overlap.
     */
    public static final class FixateMemoryValues implements ProgramProcessor {

        @Override
        public void run(Program program) {
            BigInteger i = BigInteger.ONE;
            for(Address a : program.getMemory().arrays) {
                a.value = i;
                i = i.add(BigInteger.valueOf(a.size()));
            }
        }
    }
}