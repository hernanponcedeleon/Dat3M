package com.dat3m.dartagnan.verification.model.event;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.IfAsJump;
import com.dat3m.dartagnan.verification.model.ExecutionModelNext;
import com.dat3m.dartagnan.verification.model.ThreadModel;

import java.util.List;
import java.util.Objects;


public class CondJumpModel extends DefaultEventModel implements RegReaderModel {
    public CondJumpModel(CondJump event, ThreadModel thread, int id) {
        super(event, thread, id);
    }

    public List<EventModel> getDependentEvents(ExecutionModelNext executionModel) {
        final CondJump jump = (CondJump) this.getEvent();
        if (jump.isGoto() || jump.isDead()) {
            return List.of();
        }

        final List<Event> dependents = jump instanceof IfAsJump ifJump
                ? ifJump.getBranchesEvents()
                : jump.getSuccessor().getSuccessors();
        return dependents.stream()
                         .map(executionModel::getEventModelByEvent)
                         .filter(Objects::nonNull)
                         .toList();
    }
}