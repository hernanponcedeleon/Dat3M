package porthosc.languages.syntax.xgraph.visitors;

import porthosc.languages.syntax.xgraph.events.barrier.XBarrierEvent;
import porthosc.languages.syntax.xgraph.events.computation.XAssertionEvent;
import porthosc.languages.syntax.xgraph.events.computation.XBinaryComputationEvent;
import porthosc.languages.syntax.xgraph.events.computation.XUnaryComputationEvent;
import porthosc.languages.syntax.xgraph.events.controlflow.XFunctionCallEvent;
import porthosc.languages.syntax.xgraph.events.controlflow.XJumpEvent;
import porthosc.languages.syntax.xgraph.events.fake.XEntryEvent;
import porthosc.languages.syntax.xgraph.events.fake.XExitEvent;
import porthosc.languages.syntax.xgraph.events.fake.XNopEvent;
import porthosc.languages.syntax.xgraph.events.memory.XInitialWriteEvent;
import porthosc.languages.syntax.xgraph.events.memory.XLoadMemoryEvent;
import porthosc.languages.syntax.xgraph.events.memory.XRegisterMemoryEvent;
import porthosc.languages.syntax.xgraph.events.memory.XStoreMemoryEvent;


public interface XEventVisitor<T> {

    T visit(XEntryEvent event);

    T visit(XExitEvent event);

    T visit(XUnaryComputationEvent event);

    T visit(XBinaryComputationEvent event);

    T visit(XAssertionEvent event);

    T visit(XInitialWriteEvent event);

    T visit(XRegisterMemoryEvent event);

    T visit(XStoreMemoryEvent event);

    T visit(XLoadMemoryEvent event);

    T visit(XFunctionCallEvent event);

    T visit(XJumpEvent event);

    T visit(XNopEvent event);

    T visit(XBarrierEvent event);
}
