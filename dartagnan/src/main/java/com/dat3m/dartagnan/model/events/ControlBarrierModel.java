package com.dat3m.dartagnan.model.events;

import com.dat3m.dartagnan.model.AbstractEventModel;

public final class ControlBarrierModel extends AbstractEventModel implements BlockingEventModel {

    private final String name;
    private final String instanceId;
    private final String execScope;
    private final boolean isBlocked;

    public ControlBarrierModel(String name, String instanceId, String execScope, boolean isBlocked) {
        this.name = name;
        this.instanceId = instanceId;
        this.execScope = execScope;
        this.isBlocked = isBlocked;
    }


    public String getName() { return name; }
    public String getInstanceId() { return instanceId; }
    public String getExecScope() { return execScope; }
    @Override
    public boolean isBlocked() { return isBlocked; }
}
