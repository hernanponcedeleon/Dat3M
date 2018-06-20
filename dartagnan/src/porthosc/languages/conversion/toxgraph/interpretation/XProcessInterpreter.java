package porthosc.languages.conversion.toxgraph.interpretation;

import porthosc.languages.conversion.toxgraph.hooks.XHookManager;
import porthosc.languages.conversion.toxgraph.hooks.XInvocationHookAction;
import porthosc.languages.syntax.xgraph.XEntity;
import porthosc.languages.syntax.xgraph.events.XEvent;
import porthosc.languages.syntax.xgraph.events.barrier.XBarrierEvent;
import porthosc.languages.syntax.xgraph.events.computation.XAssertionEvent;
import porthosc.languages.syntax.xgraph.events.computation.XBinaryComputationEvent;
import porthosc.languages.syntax.xgraph.events.computation.XComputationEvent;
import porthosc.languages.syntax.xgraph.events.controlflow.XJumpEvent;
import porthosc.languages.syntax.xgraph.memories.XMemoryUnit;
import porthosc.languages.syntax.xgraph.process.XProcessId;
import porthosc.utils.exceptions.NotImplementedException;
import porthosc.utils.exceptions.xgraph.XInterpretationError;
import porthosc.utils.exceptions.xgraph.XInterpreterUsageError;

import javax.annotation.Nullable;
import java.util.*;

import static porthosc.utils.StringUtils.wrap;


class XProcessInterpreter extends XInterpreterBase {

    private final XHookManager hookManager;

    // todo: add add/put methods with non-null checks
    private final Stack<XBlockContext> contextStack;
    private final Deque<XBlockContext> almostReadyContexts;
    private final Deque<XBlockContext> readyContexts;

    private String nextEventLabel;
    private final Map<String, XEvent> jumpMap = new HashMap<>();
    private final Map<String, XJumpEvent> pendingJumpEvents = new HashMap<>();

    XProcessInterpreter(XProcessId processId, XMemoryManager memoryManager, XHookManager hookManager) {
        super(processId, memoryManager); //todo: non-uniqueness case
        contextStack = new Stack<>();
        readyContexts = new LinkedList<>();
        almostReadyContexts = new LinkedList<>();

        XBlockContext linearContext = new XBlockContext(BlockKind.Sequential);
        linearContext.state = XBlockContext.State.WaitingNextLinearEvent;
        this.contextStack.push(linearContext);

        this.hookManager = hookManager;
    }

    // --

    @Override
    public void finishInterpretation() {
        //todo: verify
        super.finishInterpretation();
        assert contextStack.size() == 1 : contextStack.size(); //linear entry context only
        assert readyContexts.isEmpty() : readyContexts.size();
        assert almostReadyContexts.isEmpty() : almostReadyContexts.size();
        assert pendingJumpEvents.size() == 0 : pendingJumpEvents;
    }

    @Override
    public XBarrierEvent emitBarrierEvent(XBarrierEvent.Kind kind) {
        //flushPostfixOperationsCache();
        XBarrierEvent event = kind.create(createEventInfo());
        processNextEvent(event);
        return event;
    }

    @Override
    public XJumpEvent emitJumpEvent() {
        //flushPostfixOperationsCache();
        XJumpEvent event = new XJumpEvent(createEventInfo());
        processNextEvent(event);
        return event;
    }

    @Override
    public XJumpEvent emitJumpEvent(String gotoLabel) {
        XJumpEvent jumpEvent = emitJumpEvent();
        if (jumpMap.containsKey(gotoLabel)) {
            XEvent gotoEvent = jumpMap.get(gotoLabel);
            graphBuilder.addEdge(true, jumpEvent, gotoEvent);
        }
        else {
            pendingJumpEvents.put(gotoLabel, jumpEvent);
        }
        return jumpEvent;
    }

    @Override
    public void markNextEventLabel(String label) {
        nextEventLabel = label;
    }

    @Override
    protected void preProcessEvent(XEvent nextEvent) {
        super.preProcessEvent(nextEvent);
        if (nextEventLabel != null) {
            jumpMap.put(nextEventLabel, nextEvent);

            for (Map.Entry<String, XJumpEvent> entry : pendingJumpEvents.entrySet()) {
                String pendingLabel = entry.getKey();
                if (pendingLabel.equals(nextEventLabel)) {
                    XJumpEvent jumpEvent = entry.getValue();
                    graphBuilder.addEdge(true, jumpEvent, nextEvent);
                    pendingJumpEvents.remove(pendingLabel);
                    break;
                }
            }
            nextEventLabel = null;
        }
    }

    @Override
    protected void processNextEvent(XEvent nextEvent) {
        preProcessEvent(nextEvent);

        boolean alreadySetEdgeToNextEvent = processReadyContexts(nextEvent);

        assert !contextStack.empty();
        for (int i = contextStack.size() - 1; i >= 0; i--) { //NonlinearBlock context : contextStack) {
            XBlockContext context = contextStack.get(i);

            switch (context.state) {
                case WaitingNextLinearEvent: {
                    if (!alreadySetEdgeToNextEvent) {
                        if (previousEvent != null) {
                            graphBuilder.addEdge(true, previousEvent, nextEvent);
                        }
                        alreadySetEdgeToNextEvent = true;
                    }
                }
                break;

                //case Idle: {
                //    // do nothing
                //}
                //break;

                case WaitingAdditionalCommand: {
                    throw new IllegalStateException("waiting for an additional command before processing next event: " + nextEvent);
                }
                //break;

                case WaitingFirstConditionEvent: {
                    context.setEntryEvent(nextEvent);
                    context.setState(XBlockContext.State.WaitingNextLinearEvent);
                }
                break;

                case WaitingLastConditionEvent: {
                    assert nextEvent instanceof XComputationEvent : nextEvent;
                    context.setConditionEvent((XComputationEvent) nextEvent);
                    context.setState(XBlockContext.State.WaitingAdditionalCommand);
                }
                break;

                case WaitingFirstSubBlockEvent: { //this case of stateStack should be on stack
                    assert nextEvent != context.conditionEvent;
                    switch (context.currentBranchKind) {
                        case Then:
                            // todo: do all nonlinear edge settings from ready hashset
                            context.firstThenBranchEvent = nextEvent;
                            break;
                        case Else:
                            context.firstElseBranchEvent = nextEvent;
                            break;
                    }
                    context.setState(XBlockContext.State.WaitingNextLinearEvent);
                    alreadySetEdgeToNextEvent = true; //delayed edge set (in traversing ready-contexts)
                }
                break;

                //case Idle: {
                //    // do nothing
                //}
                //break;

                default:
                    throw new XInterpreterUsageError("Received new event while in invalid stateStack: " + context.state.name());
            }
        }

        postProcessEvent(nextEvent);
    }

    // TODO: should be in preProcessEvent()
    private boolean processReadyContexts(XEvent nextEvent) {
        boolean alreadySetEdgeToNextEvent = false;
        if (!readyContexts.isEmpty()) {

            XEvent nextLinearEvent = nextEvent;

            for (XBlockContext context : readyContexts) {

                Set<XEvent> alreadySetEdgeFromLinearEvent = new HashSet<>();

                if (context.firstThenBranchEvent != null) {
                    switch (context.kind) {
                        case Sequential:
                            assert false : "no then-events are allowed for linear statements";
                            break;
                        case Branching:
                            graphBuilder.addEdge(true, context.conditionEvent, context.firstThenBranchEvent);
                            break;
                        case Loop:
                            graphBuilder.addEdge(true, context.conditionEvent, context.firstThenBranchEvent);
                            alreadySetEdgeToNextEvent = true;
                            break;
                    }
                }
                else {
                    switch (context.kind) {
                        case Sequential:
                            assert false : "no then-events are allowed for linear statements";
                            break;
                        case Branching:
                        case Loop:
                            assert false : "every branching statement must have at least one then-event (NOP if none)";
                            break;
                    }
                }
                if (context.lastThenBranchEvent != null) {
                    switch (context.kind) {
                        case Sequential:
                            assert false : "no then-events are allowed for linear statements";
                            break;
                        case Branching:
                            if (alreadySetEdgeFromLinearEvent.add(context.lastThenBranchEvent)
                                    && !graphBuilder.hasEdgesFrom(context.lastThenBranchEvent)) {
                                graphBuilder.addEdge(true, context.lastThenBranchEvent, nextLinearEvent);
                            }
                            break;
                        case Loop:
                            if (alreadySetEdgeFromLinearEvent.add(context.lastThenBranchEvent)
                                    && !graphBuilder.hasEdgesFrom(context.lastThenBranchEvent)) {
                                graphBuilder.addEdge(true, context.lastThenBranchEvent, context.entryEvent);
                            }
                            break;
                    }
                }
                else {
                    switch (context.kind){
                        case Sequential:
                        case Branching:
                        case Loop:
                            break;
                    }
                }

                if (context.firstElseBranchEvent != null) {
                    switch (context.kind) {
                        case Sequential:
                            assert false : "no else-events are allowed for linear statements";
                            break;
                        case Branching:
                        case Loop: //loops also must have else-branch with single nop-event
                            graphBuilder.addEdge(false, context.conditionEvent, context.firstElseBranchEvent);
                            break;
                    }
                }
                else {
                    switch (context.kind) {
                        case Sequential:
                            break;
                        case Branching:
                        case Loop:
                            assert false : "every non-linear statement must have at least one then-event (NOP if none)";
                            break;
                    }
                }
                if (context.lastElseBranchEvent != null) {
                    switch (context.kind) {
                        case Sequential:
                            assert false : "no else-events are allowed for linear statements";
                            break;
                        case Branching:
                        case Loop:
                            if (alreadySetEdgeFromLinearEvent.add(context.lastElseBranchEvent)
                                    && !graphBuilder.hasEdgesFrom(context.lastElseBranchEvent)) {
                                graphBuilder.addEdge(true, context.lastElseBranchEvent, nextLinearEvent);
                            }
                            alreadySetEdgeToNextEvent = true;
                            break;
                    }
                }

                if (context.kind == BlockKind.Loop) {
                    if (context.hasBreakEvents()) {
                        for (XJumpEvent breakingEvent : context.breakingEvents) {
                            graphBuilder.addEdge(true, breakingEvent, nextLinearEvent);
                            alreadySetEdgeFromLinearEvent.add(breakingEvent);
                        }
                    }
                    if (context.hasContinueEvents()) {
                        for (XJumpEvent continueingEvent : context.continueingEvents) {
                            graphBuilder.addEdge(true, continueingEvent, context.entryEvent);
                            alreadySetEdgeFromLinearEvent.add(continueingEvent);
                        }
                    }
                }

                if (context.kind == BlockKind.Loop) {
                    nextLinearEvent = context.entryEvent; //for this and others
                }
            }
            readyContexts.clear();
        }
        return alreadySetEdgeToNextEvent;
    }

    // -- BRANCHING + LOOPS --------------------------------------------------------------------------------------------

    @Override
    public void startBlockDefinition(BlockKind blockKind) {
        contextStack.push(new XBlockContext(blockKind));
    }

    @Override
    public void startBlockConditionDefinition() {
        XBlockContext context = contextStack.peek();
        assert context.state == XBlockContext.State.WaitingAdditionalCommand : context.state.name();
        context.setState(XBlockContext.State.WaitingFirstConditionEvent);
    }

    @Override
    public void finishBlockConditionDefinition(XComputationEvent conditionEvent) {
        XBlockContext context = contextStack.peek();
        // TODO: send here Branching event! -- ? maybe we don't need them, as it's implemented now
        context.setState(XBlockContext.State.WaitingLastConditionEvent);
        processNextEvent(conditionEvent);
        context.setState(XBlockContext.State.WaitingAdditionalCommand);
        //previousEvent = null;
    }

    @Override
    public void startBlockBranchDefinition(BranchKind branchKind) {
        XBlockContext context = contextStack.peek();
        assert context.state == XBlockContext.State.WaitingAdditionalCommand : context.state.name();
        context.setState(XBlockContext.State.WaitingFirstSubBlockEvent);
        switch (branchKind) {
            case Then: {
                context.currentBranchKind = BranchKind.Then;
            }
            break;
            case Else: {
                context.currentBranchKind = BranchKind.Else;
                if (!readyContexts.isEmpty()) {
                    almostReadyContexts.addAll(readyContexts);
                    readyContexts.clear();
                }
            }
            break;
        }
    }

    @Override
    public void finishBlockBranchDefinition() {
        XBlockContext context = contextStack.peek();
        assert context.currentBranchKind != null;
        assert previousEvent != context.conditionEvent : previousEvent;
        if (previousEvent != null) {
            switch (context.currentBranchKind) {
                case Then:
                    assert context.lastThenBranchEvent == null;
                    context.lastThenBranchEvent = previousEvent;
                    //if (context.firstThenBranchEvent == null) {
                    //    context.firstThenBranchEvent = previousEvent;
                    //}
                    break;
                case Else:
                    assert context.lastElseBranchEvent == null;
                    context.lastElseBranchEvent = previousEvent;
                    //if (context.firstElseBranchEvent == null) {
                    //    context.firstElseBranchEvent = previousEvent;
                    //}
                    break;
            }
        }
        else {
            int a =2;
        }
        context.currentBranchKind = null;
        context.setState(XBlockContext.State.WaitingAdditionalCommand);
        //previousEvent = null;
    }


    @Override
    public void finishNonlinearBlockDefinition() {
        XBlockContext context = contextStack.pop();
        context.currentBranchKind = null;
        //context.setState(XBlockContext.State.Idle);
        context.setState(XBlockContext.State.WaitingNextLinearEvent);
        almostReadyContexts.addFirst(context);

        if (!almostReadyContexts.isEmpty()) {
            readyContexts.addAll(almostReadyContexts);
            almostReadyContexts.clear();
        }
        //previousEvent = null; //not to set too many linear jumps: e.g. `if (a) { while(b) do1(); } do2();`
    }

    @Override
    public void processJumpStatement(JumpKind jumpKind) {
        //flushPostfixOperationsCache();
        XJumpEvent jumpEvent = emitJumpEvent();
        XBlockContext context = currentNearestLoopContext(); //context should peeked after the jump event was emitted
        context.addJumpEvent(jumpKind, jumpEvent);
        //context.setState(XBlockContext.State.Idle);
        context.setState(XBlockContext.State.WaitingNextLinearEvent);
    }

    @Override
    public XAssertionEvent emitAssertionEvent(XBinaryComputationEvent assertion) {
        throw new XInterpretationError(getIllegalOperationMessage());
    }
// -- METHOD CALLS -------------------------------------------------------------------------------------------------

    // TODO: signature instead of just name
    // TODO: arguments: write all shared to registers and set up control-flow binding
    @Override
    public XEntity processMethodCall(String methodName, @Nullable XMemoryUnit receiver, XMemoryUnit... arguments) {
        //flushPostfixOperationsCache();
        XInvocationHookAction intercepted = hookManager.tryInterceptInvocation(methodName);
        if (intercepted != null) {
            XEntity res = intercepted.execute(receiver, arguments);
            // TODO: After we set up finding type processors by signature, not by name, we should make a restriction that their lambdas cannot return null!
            if (res != null) {
                return res;
            }
        }
        throw new NotImplementedException("Method call " + wrap(methodName) + " was not recognised" +
                                                      ", however, the method call binding is not implemented yet");
    }

    // =================================================================================================================

    private XBlockContext currentNearestLoopContext() {
        for (int i = contextStack.size() - 1; i >= 0; --i) {
            XBlockContext context = contextStack.get(i);
            if (context.kind == BlockKind.Loop) {
                return context;
            }
        }
        throw new XInterpreterUsageError("Not found any loop contexts");
    }
}
