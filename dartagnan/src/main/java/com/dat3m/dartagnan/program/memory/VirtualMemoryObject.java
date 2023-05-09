package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.program.event.core.Event;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.FormulaManager;

public class VirtualMemoryObject extends MemoryObject{
    VirtualMemoryObject(int index, int size, boolean isStaticallyAllocated) {
        super(index, size, isStaticallyAllocated);
    }
}
