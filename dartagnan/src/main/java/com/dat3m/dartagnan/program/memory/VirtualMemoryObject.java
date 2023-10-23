package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.expression.type.IntegerType;

import static com.google.common.base.Preconditions.checkArgument;

/**
 * Memory locations that can hold virtual addresses.
 */
public class VirtualMemoryObject extends MemoryObject {
    // the physical address of this virtual address
    private final VirtualMemoryObject physicalAddress;
    // the generic address of this virtual address
    private final VirtualMemoryObject genericAddress;

    VirtualMemoryObject(
            int index,
            IntegerType addressType,
            int size,
            boolean isStaticallyAllocated,
            boolean generic,
            VirtualMemoryObject alias) {
        super(index, addressType, size, isStaticallyAllocated);
        checkArgument(generic || alias != null,
                "Non-generic virtualMemoryObject must have generic address it alias target");
        if (alias == null) {
            // not alias to other virtual address, so physical address is itself
            this.physicalAddress = this;
            this.genericAddress = this;
        } else {
            this.physicalAddress = alias.getPhysicalAddress();
            if (generic) {
                // this is a generic virtual address, so generic address is itself
                this.genericAddress = this;
            } else {
                // this is a non-generic virtual address, so generic address is alias target
                this.genericAddress = alias;
            }
        }
    }

    public VirtualMemoryObject getGenericAddress() {
        return genericAddress;
    }

    public VirtualMemoryObject getPhysicalAddress() {
        return physicalAddress;
    }
}
