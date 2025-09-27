package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;

import java.util.Objects;

import static com.google.common.base.Preconditions.checkArgument;

/**
 * Memory locations that can hold virtual addresses.
 */
public class VirtualMemoryObject extends MemoryObject {
    // the physical address of this virtual address
    private final VirtualMemoryObject physicalAddress;
    // the generic address of this virtual address
    private final VirtualMemoryObject genericAddress;

    VirtualMemoryObject(int index, Expression size, Expression alignment, boolean generic, VirtualMemoryObject alias, Type ptrType) {
        super(index, size, alignment, null, ptrType);
        checkArgument(generic || alias != null,
                "Non-generic VirtualMemoryObject must have alias target.");
        if (alias == null) {
            // not alias another virtual address, so the physical address is itself
            this.physicalAddress = this;
            this.genericAddress = this;
        } else {
            this.physicalAddress = alias.getPhysicalAddress();
            // If generic, the generic address is itself, otherwise it is the alias target.
            this.genericAddress = generic ? this : alias;
        }
    }

    public VirtualMemoryObject getGenericAddress() {
        return genericAddress;
    }

    public VirtualMemoryObject getPhysicalAddress() {
        return physicalAddress;
    }

    @Override
    public int hashCode() {
        int parentHash = super.hashCode();
        return Objects.hash(parentHash,
                this == physicalAddress ? parentHash : physicalAddress,
                this == genericAddress ? parentHash : genericAddress);
    }
}
