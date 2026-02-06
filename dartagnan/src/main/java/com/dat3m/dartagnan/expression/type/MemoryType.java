package com.dat3m.dartagnan.expression.type;

import com.dat3m.dartagnan.expression.Type;
import com.google.common.base.Preconditions;

/*
    This type represents an abstract value in memory, typically understood as a sequence of bits/bytes with
    additional metadata. Value instances of this type are referred to as "memory values".
    Properties:
        - Any other type that can be stored to/loaded from memory should be convertible to a memory type of
          appropriate size, i.e., the memory type that has size matching the memory size of the type.
        - Conversely, memory values must be convertible back to (at least) the type they originated from without loss of
          information: if o is of type T, then "o == toT(toMemory(o))" should hold.
        - To guarantee the above lossless round-trip property, for every metadata that some type may track
          (e.g., pointer provenance, address space, ...), the memory type must also be able to track it.
        - Storing any object "T o" in memory conceptually stores "toMemory(o)" in memory.
          Conversely, any load of type T from memory conceptually loads "toT(o)".
          Due the lossless round-trip property "o = toT(toMemory(o))", loads froms stores of the same type
          guarantee that the load sees exactly the stored value.
        - To support mixed-size accesses, MemoryType supports extraction and concatenation operations,
          which also have a lossless round-trip property:
          extracting single bits/bytes and then sticking them together again in the correct order must produce the original value
          including all metadata like pointer provenance.
          Concatenating bits from different memory values may or may not produce valid values:
          Generally, metadata like provenance will not be retained, however, for metadata-less types like
          integers, the concatenation may be reasonable.
 */
public class MemoryType implements Type {

    private final int bitWidth;

    MemoryType(int bitWidth) {
        Preconditions.checkArgument(bitWidth > 0, "Size for memory type must be positive: %s", bitWidth);
        Preconditions.checkArgument((bitWidth & 7) == 0, "Size must be a multiple of 8: %s", bitWidth);
        this.bitWidth = bitWidth;
    }

    public int getBitWidth() {
        return bitWidth;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }
        return obj instanceof MemoryType other && other.bitWidth == this.bitWidth;
    }

    @Override
    public int hashCode() {
        return 31 * bitWidth + getClass().hashCode();
    }

    @Override
    public String toString() {
        return "membits" + bitWidth;
    }
}
