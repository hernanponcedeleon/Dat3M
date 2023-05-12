package com.dat3m.dartagnan.program.ScopedThread;

import java.util.ArrayList;

public interface ScopedThread {

    ArrayList<String> getScopes();

    int getScopeIds(String scope);
}
