package porthosc.languages.conversion.toxgraph.interpretation;

import porthosc.languages.syntax.xgraph.events.XEvent;
import porthosc.languages.syntax.xgraph.events.computation.XComputationEvent;
import porthosc.languages.syntax.xgraph.events.controlflow.XJumpEvent;

import java.util.ArrayList;
import java.util.List;


class XBlockContext {

    public enum State {
        //Idle,
        WaitingAdditionalCommand,

        WaitingFirstConditionEvent,
        WaitingLastConditionEvent, //branching event itself (computation)

        WaitingFirstSubBlockEvent,
        WaitingNextLinearEvent,

        //JustFinishedBranch,
        //JustJumped,
        //JustFinished,
    }

    /*private*/public XEvent entryEvent;

    /*private*/public final XInterpreter.BlockKind kind;
    /*private*/public State state;
    /*private*/public XProcessInterpreter.BranchKind currentBranchKind;

    /*private*/public XComputationEvent conditionEvent;

    /*private*/public XEvent firstThenBranchEvent;
    /*private*/public XEvent firstElseBranchEvent;

    /*private*/public XEvent lastThenBranchEvent;
    /*private*/public XEvent lastElseBranchEvent;

    /*private*/public List<XJumpEvent> continueingEvents;
    /*private*/public List<XJumpEvent> breakingEvents;

    public XBlockContext(XInterpreter.BlockKind kind) {
        this.kind = kind;
        this.state = State.WaitingAdditionalCommand;
    }

    public void setEntryEvent(XEvent entryEvent) {
        assert entryEvent != null;
        assert this.entryEvent == null : entryEvent;
        this.entryEvent = entryEvent;
    }

    public void setConditionEvent(XComputationEvent conditionEvent) {
        assert conditionEvent != null;
        if (entryEvent == null) {
            //System.err.println("Warning: setting stack-entry event same as conditional event: " + conditionEvent);
            setEntryEvent(conditionEvent);
        }
        assert this.conditionEvent == null;
        this.conditionEvent = conditionEvent;
    }

    public void setState(State state) {
        this.state = state;
    }

    //public void setFirstTrueBranchEvent(XEvent event) {
    //    assert event != conditionEvent;
    //    this.firstTrueBranchEvent = event;
    //}
    //
    //public void setFirstFalseBranchEvent(XEvent event) {
    //    assert event != conditionEvent;
    //    this.firstFalseBranchEvent = event;
    //}

    public void addJumpEvent(XInterpreter.JumpKind jumpKind, XJumpEvent jumpEvent) {
        switch (jumpKind) {
            case Break:
                if (breakingEvents == null) {
                    breakingEvents = new ArrayList<>();
                }
                breakingEvents.add(jumpEvent);
                break;
            case Continue:
                if (continueingEvents == null) {
                    continueingEvents = new ArrayList<>();
                }
                continueingEvents.add(jumpEvent);
                break;
            default:
                throw new IllegalArgumentException(jumpKind.name());
        }
    }

    public boolean hasContinueEvents() {
        return continueingEvents != null && continueingEvents.size() > 0;
    }

    public boolean hasBreakEvents() {
        return breakingEvents != null && breakingEvents.size() > 0;
    }

    @Override
    public String toString() {
        return  entryEvent + "..." + conditionEvent + " { " + firstThenBranchEvent + "..." + lastThenBranchEvent +
                " } else { " + firstElseBranchEvent + "..." + lastElseBranchEvent + " }";
    }
}
