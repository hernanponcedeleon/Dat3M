package com.dat3m.dartagnan.program.analysis.alias;

import com.dat3m.dartagnan.program.event.core.MemEvent;
// TODO: implement for ptx alias proxy
public class ProxyAliasAnalysis implements AliasAnalysis{
    @Override
    public boolean mustAlias(MemEvent a, MemEvent b) {
        return false;
    }

    @Override
    public boolean mayAlias(MemEvent a, MemEvent b) {
        return false;
    }
}
