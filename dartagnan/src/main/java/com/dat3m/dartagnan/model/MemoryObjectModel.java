package com.dat3m.dartagnan.model;

import com.dat3m.dartagnan.encoding.TypedValue;
import com.dat3m.dartagnan.model.events.AllocModel;

import java.util.Objects;

public final class MemoryObjectModel {

    private final String name;
    private final TypedValue<?, ?> address;
    private final TypedValue<?, ?> size;

    private transient AllocModel allocationSite;

    public MemoryObjectModel(String name, TypedValue<?, ?> address, TypedValue<?, ?> size) {
        this.name = name;
        this.address = address;
        this.size = size;
    }

    public void setAllocationSite(AllocModel allocationSite) {
        this.allocationSite = allocationSite;
    }

    public boolean isStaticallyAllocated() {
        return allocationSite == null;
    }

    public boolean isDynamicallyAllocated() {
        return !isStaticallyAllocated();
    }

    public String name() {
        return name;
    }

    public TypedValue<?, ?> address() {
        return address;
    }

    public TypedValue<?, ?> size() {
        return size;
    }

    public AllocModel allocationSite() {
        return allocationSite;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) return true;
        if (obj == null || obj.getClass() != this.getClass()) return false;
        var that = (MemoryObjectModel) obj;
        return Objects.equals(this.name, that.name) &&
                Objects.equals(this.address, that.address) &&
                Objects.equals(this.size, that.size) &&
                Objects.equals(this.allocationSite, that.allocationSite);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name, address, size, allocationSite);
    }

    @Override
    public String toString() {
        return String.format("%s {address=%s, size=%s}", name, address, size);
    }


}
