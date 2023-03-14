package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.program.memory.MemoryObject;

public interface Alias {
    void setAliasMemoryObject(MemoryObject memoryObject);
    MemoryObject getAliasMemoryObject(MemoryObject memoryObject);

    void setProxyType(String proxyType);
    String getProxyType(String proxyType);
}
