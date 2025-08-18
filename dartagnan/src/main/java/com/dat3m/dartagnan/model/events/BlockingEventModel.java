package com.dat3m.dartagnan.model.events;

import com.dat3m.dartagnan.model.EventModel;

public interface BlockingEventModel extends EventModel {
    boolean isBlocked();
}
