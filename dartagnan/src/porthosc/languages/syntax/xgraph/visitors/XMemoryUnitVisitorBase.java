package porthosc.languages.syntax.xgraph.visitors;

import porthosc.languages.syntax.xgraph.events.computation.XAssertionEvent;
import porthosc.languages.syntax.xgraph.events.computation.XBinaryComputationEvent;
import porthosc.languages.syntax.xgraph.events.computation.XUnaryComputationEvent;
import porthosc.languages.syntax.xgraph.memories.XConstant;
import porthosc.languages.syntax.xgraph.memories.XLocation;
import porthosc.languages.syntax.xgraph.memories.XRegister;


public class XMemoryUnitVisitorBase<T> implements XMemoryUnitVisitor<T> {

    @Override
    public T visit(XRegister entity) {
        throw new XVisitorIllegalStateException();
    }

    @Override
    public T visit(XLocation entity) {
        throw new XVisitorIllegalStateException();
    }

    @Override
    public T visit(XConstant entity) {
        throw new XVisitorIllegalStateException();
    }

    @Override
    public T visit(XUnaryComputationEvent entity) {
        throw new XVisitorIllegalStateException();
    }

    @Override
    public T visit(XBinaryComputationEvent entity) {
        throw new XVisitorIllegalStateException();
    }

    @Override
    public T visit(XAssertionEvent entity) {
        throw new XVisitorIllegalStateException();
    }
}
