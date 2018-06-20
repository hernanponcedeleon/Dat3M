package porthosc.languages.conversion.toxgraph.interpretation;

import porthosc.languages.syntax.xgraph.XEntity;
import porthosc.languages.syntax.xgraph.events.XEvent;
import porthosc.languages.syntax.xgraph.events.barrier.XBarrierEvent;
import porthosc.languages.syntax.xgraph.events.computation.XAssertionEvent;
import porthosc.languages.syntax.xgraph.events.computation.XBinaryComputationEvent;
import porthosc.languages.syntax.xgraph.events.computation.XComputationEvent;
import porthosc.languages.syntax.xgraph.events.controlflow.XJumpEvent;
import porthosc.languages.syntax.xgraph.memories.XMemoryUnit;
import porthosc.languages.syntax.xgraph.process.XProcessId;
import porthosc.utils.exceptions.xgraph.XInterpretationError;

import javax.annotation.Nullable;
import java.util.HashSet;
import java.util.Set;


public abstract class XLudeInterpreterBase extends XInterpreterBase {

    private final Set<String> accessedLocalUnits;
    private final Set<String> accessedSharedUnits;

    public XLudeInterpreterBase(XProcessId processId, XMemoryManager memoryManager) {
        super(processId, memoryManager);
        this.accessedLocalUnits = new HashSet<>();
        this.accessedSharedUnits = new HashSet<>();
    }

    @Override
    protected void processNextEvent(XEvent nextEvent) {
        preProcessEvent(nextEvent);
        if (previousEvent != null) {
            graphBuilder.addEdge(true, previousEvent, nextEvent);
        }
        postProcessEvent(nextEvent);
    }

    // --

    @Override
    public XBarrierEvent emitBarrierEvent(XBarrierEvent.Kind kind) {
        throw new XInterpretationError(getIllegalOperationMessage());
    }

    @Override
    public XJumpEvent emitJumpEvent() {
        throw new XInterpretationError(getIllegalOperationMessage());
    }

    @Override
    public XJumpEvent emitJumpEvent(String label) {
        throw new XInterpretationError(getIllegalOperationMessage());
    }

    @Override
    public void markNextEventLabel(String label) {
        throw new XInterpretationError(getIllegalOperationMessage());
    }

    @Override
    public XAssertionEvent emitAssertionEvent(XBinaryComputationEvent assertion) {
        return null;
    }

    @Override
    public void startBlockDefinition(BlockKind blockKind) {
        throw new XInterpretationError(getIllegalOperationMessage());
    }

    @Override
    public void startBlockConditionDefinition() {
        throw new XInterpretationError(getIllegalOperationMessage());
    }

    @Override
    public void finishBlockConditionDefinition(XComputationEvent conditionEvent) {
        throw new XInterpretationError(getIllegalOperationMessage());
    }

    @Override
    public void startBlockBranchDefinition(BranchKind branchKind) {
        throw new XInterpretationError(getIllegalOperationMessage());
    }

    @Override
    public void finishBlockBranchDefinition() {
        throw new XInterpretationError(getIllegalOperationMessage());
    }

    @Override
    public void finishNonlinearBlockDefinition() {
        throw new XInterpretationError(getIllegalOperationMessage());
    }

    @Override
    public void processJumpStatement(JumpKind kind) {
        throw new XInterpretationError(getIllegalOperationMessage());
    }

    @Override
    public XEntity processMethodCall(String methodName, @Nullable XMemoryUnit receiver, XMemoryUnit... arguments) {
        throw new XInterpretationError(getIllegalOperationMessage());
    }
}
