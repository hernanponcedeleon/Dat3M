package com.dat3m.dartagnan.prototype.program.memory;

import com.dat3m.dartagnan.prototype.program.GlobalVariable;
import com.dat3m.dartagnan.prototype.program.event.core.memory.Alloc;

import java.util.ArrayList;
import java.util.List;

/*
    Both the Memory and the MemoryObjects are created after program transformation.
 */
public final class Memory {

    private List<StaticMemoryObject> staticMemoryObjects = new ArrayList<>();
    private List<DynamicMemoryObject> dynamicMemoryObjects = new ArrayList<>();

    public StaticMemoryObject staticallyAllocate(GlobalVariable var) {
        final StaticMemoryObject memoryObject = new StaticMemoryObject(var);
        staticMemoryObjects.add(memoryObject);
        return memoryObject;
    }

    public DynamicMemoryObject dynamicallyAllocate(Alloc allocationSite) {
        final DynamicMemoryObject memoryObject = new DynamicMemoryObject(allocationSite);
        dynamicMemoryObjects.add(memoryObject);
        return memoryObject;
    }

    public List<StaticMemoryObject> getStaticMemoryObjects() { return staticMemoryObjects; }
    public List<DynamicMemoryObject> getDynamicMemoryObjects() { return dynamicMemoryObjects; }
    public List<MemoryObject> getMemoryObjects() {
        final List<MemoryObject> memoryObjects =
                new ArrayList<>(staticMemoryObjects.size() + dynamicMemoryObjects.size());
        memoryObjects.addAll(staticMemoryObjects);
        memoryObjects.addAll(dynamicMemoryObjects);
        return memoryObjects;
    }


}
