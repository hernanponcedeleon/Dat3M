package com.dat3m.dartagnan.verification.model.event;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.IfAsJump;
import com.dat3m.dartagnan.verification.model.ExecutionModelNext;
import com.dat3m.dartagnan.verification.model.ThreadModel;

import java.util.List;


public class CondJumpModel extends DefaultEventModel implements RegReaderModel {
    public CondJumpModel(CondJump event, ThreadModel thread, int id) {
        super(event, thread, id);
    }

    public List<EventModel> getDependentEvents(ExecutionModelNext executionModel) {
        List<Event> dependents;
        if (((CondJump) event).isGoto() || ((CondJump) event).isDead()) {
            return List.of();
        }

        if (event instanceof IfAsJump jump) {
            dependents = jump.getBranchesEvents();
        } else {
            dependents = ((CondJump) event).getSuccessor().getSuccessors();
        }

        return dependents.stream()
                         .map(e -> executionModel.getEventModelByEvent(e))
                         .filter(m -> m != null)
                         .toList();
    }
}