package porthosc.languages.conversion.tozformula;

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
import porthosc.languages.syntax.xgraph.memories.XLocalMemoryUnit;
import porthosc.languages.syntax.xgraph.visitors.XEventVisitor;
import porthosc.utils.exceptions.NotImplementedException;

import java.util.Arrays;
import java.util.Collections;


// TODO: remove this class, use XMemoryUnitCollector and cast to local memory unit
public class XLocalMemoryUnitCollector implements XEventVisitor<Iterable<XLocalMemoryUnit>> {

    @Override
    public Iterable<XLocalMemoryUnit> visit(XUnaryComputationEvent event) {
        return Collections.singletonList(event.getOperand());
    }

    @Override
    public Iterable<XLocalMemoryUnit> visit(XBinaryComputationEvent event) {
        return Arrays.asList(event.getFirstOperand(), event.getSecondOperand());
    }

    @Override
    public Iterable<XLocalMemoryUnit> visit(XAssertionEvent event) {
        return event.getAssertion().accept(this);
    }

    @Override
    public Iterable<XLocalMemoryUnit> visit(XFunctionCallEvent event) {
        throw new NotImplementedException();
    }

    @Override
    public Iterable<XLocalMemoryUnit> visit(XInitialWriteEvent event) {
        throw new NotImplementedException(); //TODO
    }

    @Override
    public Iterable<XLocalMemoryUnit> visit(XRegisterMemoryEvent event) {
        return Arrays.asList(event.getSource(), event.getDestination());
    }

    @Override
    public Iterable<XLocalMemoryUnit> visit(XStoreMemoryEvent event) {
        return Collections.singletonList(event.getSource());
    }

    @Override
    public Iterable<XLocalMemoryUnit> visit(XLoadMemoryEvent event) {
        return Collections.singletonList(event.getDestination());
    }

    @Override
    public Iterable<XLocalMemoryUnit> visit(XEntryEvent event) {
        return Collections.emptyList();
    }

    @Override
    public Iterable<XLocalMemoryUnit> visit(XExitEvent event) {
        return Collections.emptyList();
    }

    @Override
    public Iterable<XLocalMemoryUnit> visit(XJumpEvent event) {
        return Collections.emptyList();
    }

    @Override
    public Iterable<XLocalMemoryUnit> visit(XNopEvent event) {
        return Collections.emptyList();
    }

    public Iterable<XLocalMemoryUnit> visit(XBarrierEvent event) {
        return Collections.emptyList();
    }
}
