package porthosc.languages.conversion.toxgraph.interpretation;


//import com.sun.istack.internal.NotNull;
import porthosc.languages.syntax.xgraph.XEntity;
import porthosc.languages.syntax.xgraph.events.XEvent;
import porthosc.languages.syntax.xgraph.events.XEventInfo;
import porthosc.languages.syntax.xgraph.events.computation.*;
import porthosc.languages.syntax.xgraph.events.fake.XEntryEvent;
import porthosc.languages.syntax.xgraph.events.fake.XExitEvent;
import porthosc.languages.syntax.xgraph.events.fake.XNopEvent;
import porthosc.languages.syntax.xgraph.events.memory.*;
import porthosc.languages.syntax.xgraph.memories.*;
import porthosc.languages.syntax.xgraph.process.XCyclicProcess;
import porthosc.languages.syntax.xgraph.process.XCyclicProcessBuilder;
import porthosc.languages.syntax.xgraph.process.XProcessId;

import static porthosc.utils.StringUtils.wrap;


abstract class XInterpreterBase implements XInterpreter {

    private final XProcessId processId;
    private final XMemoryManager memoryManager;
    protected final XCyclicProcessBuilder graphBuilder;
    private XCyclicProcess result;

    protected XEvent previousEvent;

    XInterpreterBase(XProcessId processId, XMemoryManager memoryManager) {
        this.processId = processId;
        this.memoryManager = memoryManager;
        this.graphBuilder = new XCyclicProcessBuilder(processId);
    }

    protected void preProcessEvent(XEvent nextEvent) {
        assert nextEvent != null;
        // want more? overload!
    }

    protected void postProcessEvent(XEvent nextEvent) {
        previousEvent = nextEvent;
    }

    protected abstract void processNextEvent(XEvent nextEvent);

    // --

    @Override
    public XProcessId getProcessId() {
        return processId;
    }

    @Override
    //@NotNull
    public XMemoryManager getMemoryManager() {
        return memoryManager;
    }

    @Override
    public XEntryEvent emitEntryEvent() {
        XEntryEvent entryEvent = new XEntryEvent(createEventInfo());
        graphBuilder.setSource(entryEvent);
        processNextEvent(entryEvent);
        return entryEvent;
    }

    @Override
    public XExitEvent emitExitEvent() {
        XExitEvent exitEvent = new XExitEvent(createEventInfo());
        processNextEvent(exitEvent);
        graphBuilder.setSink(exitEvent);
        return exitEvent;
    }

    //public XDeclarationEvent emitDeclarationEvent(XMemoryUnit memoryUnit) {
    //    XDeclarationEvent event = new XDeclarationEvent(createEventInfo(), memoryUnit);
    //    processNextEvent(event);
    //    return event;
    //}

    // --

    /**
     * For modelling empty statement
     */
    @Override
    public XNopEvent emitNopEvent() {
        XNopEvent event = new XNopEvent(createEventInfo());
        processNextEvent(event);
        return event;
    }

    @Override
    public XLocalMemoryEvent emitMemoryEvent(XLocalLvalueMemoryUnit destination, XLocalMemoryUnit source) {
        //emit local memory event here
        XRegisterMemoryEvent event = new XRegisterMemoryEvent(createEventInfo(), destination, source);
        processNextEvent(event);
        return event;
    }

    @Override
    public XSharedMemoryEvent emitMemoryEvent(XLocalLvalueMemoryUnit destination, XSharedMemoryUnit source) {
        XLoadMemoryEvent event = new XLoadMemoryEvent(createEventInfo(), destination, source);
        processNextEvent(event);
        return event;
    }

    @Override
    public XSharedMemoryEvent emitMemoryEvent(XSharedLvalueMemoryUnit destination, XLocalMemoryUnit source) {
        XStoreMemoryEvent event = new XStoreMemoryEvent(createEventInfo(), destination, source);
        processNextEvent(event);
        return event;
    }

    // --

    //@Override
    //public XComputationEvent emitSimpleComputationEvent(XUnaryOperator operator, XLocalMemoryUnit operand) {
    //    XUnaryComputationEvent event = new XUnaryComputationEvent(createEventInfo(), operator, operand);
    //    processNextEvent(event);
    //    return event;
    //}
    //
    //@Override
    //public XComputationEvent emitSimpleComputationEvent(XBinaryOperator operator, XLocalMemoryUnit firstOperand, XLocalMemoryUnit secondOperand) {
    //    XBinaryComputationEvent event = new XBinaryComputationEvent(createEventInfo(), operator, firstOperand, secondOperand);
    //    processNextEvent(event);
    //    return event;
    //}

    @Override
    public XComputationEvent createComputationEvent(XUnaryOperator operator, XLocalMemoryUnit operand) {
        return new XUnaryComputationEvent(createEventInfo(), operator, operand);
    }

    @Override
    public XComputationEvent createComputationEvent(XBinaryOperator operator, XLocalMemoryUnit firstOperand, XLocalMemoryUnit secondOperand) {
        return new XBinaryComputationEvent(createEventInfo(), operator, firstOperand, secondOperand);
    }

    // --

    @Override
    public void finishInterpretation() {
        emitExitEvent();
        result = graphBuilder.build();
    }

    @Override
    public final XCyclicProcess getResult() {
        if (result == null) {
            finishInterpretation();
            assert result != null;
        }
        return result;
    }

    @Override
    public XLocalMemoryUnit tryConvertToLocalOrNull(XEntity expression) {
        if (expression instanceof XLocalMemoryUnit) {
            // computation events, constants here
            return (XLocalMemoryUnit) expression;
        }
        if (expression instanceof XSharedMemoryUnit) {
            return copyToLocalMemory((XSharedMemoryUnit) expression);
        }
        return null;
    }

    //public XLocalMemoryUnit copyToLocalMemoryIfNecessary(XMemoryUnit memoryUnit) {
    //    if (memoryUnit instanceof XLocation) {
    //        return copyToLocalMemory((XLocation) memoryUnit);
    //    }
    //    else if (memoryUnit instanceof XLocalMemoryUnit) { // also here: XComputationEvent
    //        return (XLocalMemoryUnit) memoryUnit;
    //    }
    //    throw new XInterpretationError("Illegal attempt to write to the local memory a memory unit of type "
    //            + memoryUnit.getClass().getSimpleName());
    //}

    @Override
    public XRegister copyToLocalMemory(XSharedMemoryUnit shared) {
        XRegister tempLocal = memoryManager.declareTempRegister(shared.getType());
        emitMemoryEvent(tempLocal, shared);
        return tempLocal;
    }

    // --

    // TODO: should be in visitor
    @Override
    public XComputationEvent tryEvaluateComputation(XEntity entity) {
        XLocalMemoryUnit localUnit = null;
        if (entity instanceof XLocalMemoryUnit) {
            if (entity instanceof XComputationEvent) {
                return (XComputationEvent) entity;
            }
            localUnit = (XLocalMemoryUnit) entity;
        }
        else if (entity instanceof XSharedMemoryUnit) {
            localUnit = tryConvertToLocalOrNull(entity);
        }

        if (localUnit == null) {
            throw new IllegalStateException("Could not convert x-entity to local memory unit: " + wrap(entity));
        }
        return createComputationEvent(XUnaryOperator.NoOperation, localUnit);
    }

    protected XEventInfo createEventInfo() {
        return new XEventInfo(getProcessId());
    }

    protected String getIllegalOperationMessage() {
        return "Illegal operation for " + getClass().getSimpleName() + " interpreter";
    }
}
