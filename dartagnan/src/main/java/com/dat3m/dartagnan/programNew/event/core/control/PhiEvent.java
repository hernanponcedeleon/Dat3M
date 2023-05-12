package com.dat3m.dartagnan.programNew.event.core.control;

import com.dat3m.dartagnan.expr.Expression;
import com.dat3m.dartagnan.programNew.Register;
import com.dat3m.dartagnan.programNew.event.AbstractEvent;
import com.dat3m.dartagnan.programNew.event.BranchingEvent;
import com.dat3m.dartagnan.programNew.event.Event;
import com.dat3m.dartagnan.programNew.event.EventUser;
import com.google.common.base.Preconditions;
import com.google.common.collect.Sets;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/*
    A PhiEvent is associated to a label L, and chooses a value from all incoming control-flow branches into L.
    PhiEvents should always be placed immediately after a label.
 */
// TODO: "abstract" is only here to avoid providing a complete implementation for now
public abstract class PhiEvent extends AbstractEvent implements Register.Writer, Register.Reader, EventUser {

    public record IncomingValue(BranchingEvent incomingBranch, Expression value) { }

    private Label associatedLabel;
    private List<IncomingValue> incomingValues;
    private Register resultRegister;

    private PhiEvent(Register resultRegister, Label associatedLabel) {
        this.resultRegister = resultRegister;
        this.associatedLabel = associatedLabel;
        this.incomingValues = new ArrayList<>();
    }

    public void addIncomingValue(BranchingEvent incomingBranch, Expression value) {
        Preconditions.checkArgument(incomingBranch.getBranchingTargets().contains(associatedLabel),
                "Provided branching instruction does not branch to this PHI nodes label.");
        Preconditions.checkState(incomingValues.stream().noneMatch(iv -> iv.incomingBranch == incomingBranch));

        incomingValues.add(new IncomingValue(incomingBranch, value));
        incomingBranch.registerUser(this);
    }

    @Override
    public Register getResultRegister() { return resultRegister; }

    @Override
    public Set<Register.Read> getRegisterReads() {
        final Set<Register.Read> regReads = new HashSet<>();
        incomingValues.forEach(iv -> Register.collectRegisterReads(iv.value, Register.UsageType.DATA, regReads));
        return regReads;
    }

    @Override
    public Set<Event> getReferencedEvents() {
        final Set<Event> referencedEvents = Sets.newHashSetWithExpectedSize(1 + incomingValues.size());
        referencedEvents.add(associatedLabel);
        incomingValues.forEach(iv -> referencedEvents.add(iv.incomingBranch));
        return referencedEvents;
    }
}
