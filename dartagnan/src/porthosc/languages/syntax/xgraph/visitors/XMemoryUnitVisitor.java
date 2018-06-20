package porthosc.languages.syntax.xgraph.visitors;

import porthosc.languages.syntax.xgraph.events.computation.XAssertionEvent;
import porthosc.languages.syntax.xgraph.events.computation.XBinaryComputationEvent;
import porthosc.languages.syntax.xgraph.events.computation.XUnaryComputationEvent;
import porthosc.languages.syntax.xgraph.memories.XConstant;
import porthosc.languages.syntax.xgraph.memories.XLocation;
import porthosc.languages.syntax.xgraph.memories.XRegister;


public interface XMemoryUnitVisitor<T> {

    T visit(XRegister entity);

    T visit(XLocation entity);

    T visit(XConstant entity);

    // --

    T visit(XUnaryComputationEvent entity);

    T visit(XBinaryComputationEvent entity);

    // --

    T visit(XAssertionEvent entity);
}
