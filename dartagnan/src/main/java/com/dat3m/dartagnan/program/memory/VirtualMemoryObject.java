package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.PointerType;

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

    VirtualMemoryObject(int index, Expression size, Expression alignment, boolean generic, VirtualMemoryObject alias, PointerType ptrType) {
        super(index, size, alignment, null, ptrType);
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

    @Override
    public int hashCode() {
        int parentHash = super.hashCode();
        return Objects.hash(parentHash,
                this == physicalAddress ? parentHash : physicalAddress,
                this == genericAddress ? parentHash : genericAddress);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof VirtualMemoryObject that)) return false;
        if (!super.equals(o)) return false;
        if (!equalsPhysical(that)) return false;
        return equalsGeneric(that);
    }

    private boolean equalsGeneric(VirtualMemoryObject that) {
        if (this == this.genericAddress) {
            return super.equals(that.genericAddress);
        }
        return this.genericAddress.equals(that.genericAddress);
    }

    private boolean equalsPhysical(VirtualMemoryObject that) {
        if (this == this.physicalAddress) {
            return super.equals(that.physicalAddress);
        }
        return this.physicalAddress.equals(that.physicalAddress);
    }
}
