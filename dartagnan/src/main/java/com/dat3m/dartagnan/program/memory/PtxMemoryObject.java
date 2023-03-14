package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.expression.Alias;
import com.dat3m.dartagnan.program.Register;
import com.google.common.collect.ImmutableSet;

public class PtxMemoryObject extends MemoryObject implements Alias {
    MemoryObject aliasTarget;
    String proxyType;

    PtxMemoryObject(int index, int s, MemoryObject aliasTarget, String proxyType) {
        super(index, s);
        this.aliasTarget = aliasTarget;
        this.proxyType = proxyType;
    }

    @Override
    public void setAliasMemoryObject(MemoryObject memoryObject) {
        this.aliasTarget = memoryObject;
    }

    @Override
    public MemoryObject getAliasMemoryObject(MemoryObject memoryObject) {
        return this.aliasTarget;
    }

    @Override
    public void setProxyType(String proxyType) {
        this.proxyType = proxyType;
    }

    @Override
    public String getProxyType(String proxyType) {
        return this.proxyType;
    }

    @Override
    public ImmutableSet<Register> getRegs() {
        return super.getRegs();
    }
}
