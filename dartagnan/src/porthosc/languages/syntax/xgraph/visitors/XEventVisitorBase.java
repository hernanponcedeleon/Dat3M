package porthosc.languages.syntax.xgraph.visitors;

import porthosc.languages.syntax.xgraph.events.computation.XBinaryComputationEvent;
import porthosc.languages.syntax.xgraph.events.computation.XUnaryComputationEvent;
import porthosc.languages.syntax.xgraph.events.controlflow.XJumpEvent;
import porthosc.languages.syntax.xgraph.events.fake.XEntryEvent;
import porthosc.languages.syntax.xgraph.events.fake.XExitEvent;
import porthosc.languages.syntax.xgraph.events.fake.XNopEvent;
import porthosc.languages.syntax.xgraph.events.memory.XInitialWriteEvent;
import porthosc.languages.syntax.xgraph.events.memory.XLoadMemoryEvent;
import porthosc.languages.syntax.xgraph.events.memory.XRegisterMemoryEvent;
import porthosc.languages.syntax.xgraph.events.memory.XStoreMemoryEvent;


public abstract class XEventVisitorBase<T> implements XEventVisitor<T> {

    @Override
    public T visit(XEntryEvent event) {
        throw new XVisitorIllegalStateException();
    }

    @Override
    public T visit(XExitEvent event) {
        throw new XVisitorIllegalStateException();
    }

    @Override
    public T visit(XUnaryComputationEvent event) {
        throw new XVisitorIllegalStateException();
    }

    @Override
    public T visit(XBinaryComputationEvent event) {
        throw new XVisitorIllegalStateException();
    }

    @Override
    public T visit(XInitialWriteEvent event) {
        throw new XVisitorIllegalStateException();
    }

    @Override
    public T visit(XRegisterMemoryEvent event) {
        throw new XVisitorIllegalStateException();
    }

    @Override
    public T visit(XStoreMemoryEvent event) {
        throw new XVisitorIllegalStateException();
    }

    @Override
    public T visit(XLoadMemoryEvent event) {
        throw new XVisitorIllegalStateException();
    }

    @Override
    public T visit(XJumpEvent event) {
        throw new XVisitorIllegalStateException();
    }

    @Override
    public T visit(XNopEvent event) {
        throw new XVisitorIllegalStateException();
    }

    //@Override
    //public T visit(XMethodCallEvent event) {
    //    throw new XVisitorIllegalStateException();
    //}
}
