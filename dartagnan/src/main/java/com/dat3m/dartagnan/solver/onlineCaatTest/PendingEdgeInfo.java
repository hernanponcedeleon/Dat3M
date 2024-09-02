package com.dat3m.dartagnan.solver.onlineCaatTest;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.Relation;

public record PendingEdgeInfo(Relation relation, Event source, Event target, int deleteTime, int addTime) {
}
