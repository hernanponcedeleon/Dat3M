package com.dat3m.dartagnan.verification.model.event;

import com.dat3m.dartagnan.program.Register.Read;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.IfAsJump;

import java.util.Set;
import java.util.List;


public class CondJumpModel extends DefaultEventModel implements RegReaderModel {
    public CondJumpModel(CondJump event) {
        super(event);
    }

    public boolean isGoto() {
        return ((CondJump) event).isGoto();
    }

    public boolean isDead() {
        return ((CondJump) event).isDead();
    }

    public List<Event> getDependentEvents() {
        if (event instanceof IfAsJump jump) {
            return jump.getBranchesEvents();
        }
        return ((CondJump) event).getSuccessor().getSuccessors();
    }

    @Override
    public Set<Read> getRegisterReads() {
        return ((RegReader) event).getRegisterReads();
    }
}