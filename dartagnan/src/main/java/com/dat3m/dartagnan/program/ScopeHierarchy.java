package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.program.event.Tag;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class ScopeHierarchy{

    // There is a hierarchy of scopes, the order of keys
    // is important, thus we use a LinkedHashMap
    protected final Map<String, Integer> scopeIds = new LinkedHashMap<>();

    private ScopeHierarchy() {}

    public static ScopeHierarchy ScopeHierarchyForVulkan(int queueFamily, int workGroup, int subGroup) {
        ScopeHierarchy scopeHierarchy = new ScopeHierarchy();
        scopeHierarchy.scopeIds.put(Tag.Vulkan.DEVICE, 0);
        scopeHierarchy.scopeIds.put(Tag.Vulkan.QUEUE_FAMILY, queueFamily);
        scopeHierarchy.scopeIds.put(Tag.Vulkan.WORK_GROUP, workGroup);
        scopeHierarchy.scopeIds.put(Tag.Vulkan.SUB_GROUP, subGroup);
        return scopeHierarchy;
    }

    public static ScopeHierarchy ScopeHierarchyForPTX(int gpu, int cta) {
        ScopeHierarchy scopeHierarchy = new ScopeHierarchy();
        scopeHierarchy.scopeIds.put(Tag.PTX.SYS, 0);
        scopeHierarchy.scopeIds.put(Tag.PTX.GPU, gpu);
        scopeHierarchy.scopeIds.put(Tag.PTX.CTA, cta);
        return scopeHierarchy;
    }

    public static ScopeHierarchy ScopeHierarchyForOpenCL(int dev, int wg) {
        ScopeHierarchy scopeHierarchy = new ScopeHierarchy();
        scopeHierarchy.scopeIds.put(Tag.OpenCL.ALL, 0);
        scopeHierarchy.scopeIds.put(Tag.OpenCL.DEVICE, dev);
        scopeHierarchy.scopeIds.put(Tag.OpenCL.WORK_GROUP, wg);
        return scopeHierarchy;
    }

    public List<String> getScopes() {
        return new ArrayList<>(scopeIds.keySet());
    }

    public int getScopeId(String scope) {
        return scopeIds.getOrDefault(scope, -1);
    }

    // For any scope higher than the given one, we check both threads have the same scope id.
    public boolean canSyncAtScope(ScopeHierarchy other, String scope) {
        if (!this.getScopes().contains(scope)) {
            return false;
        }

        List<String> scopes = this.getScopes();
        int validIndex = scopes.indexOf(scope);
        // scopes(0) is highest in hierarchy
        // i = 0 is global, every thread will always have the same id, so start from i = 1
        for (int i = 1; i <= validIndex; i++) {
            if (!atSameScopeId(other, scopes.get(i))) {
                return false;
            }
        }
        return true;
    }

    private boolean atSameScopeId(ScopeHierarchy other, String scope) {
        int thisId = this.getScopeId(scope);
        int otherId = other.getScopeId(scope);
        return (thisId == otherId && thisId != -1);
    }
}
