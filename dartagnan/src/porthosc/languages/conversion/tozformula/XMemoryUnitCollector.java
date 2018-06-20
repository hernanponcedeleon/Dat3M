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
import porthosc.languages.syntax.xgraph.memories.XMemoryUnit;
import porthosc.languages.syntax.xgraph.visitors.XEventVisitor;
import porthosc.utils.exceptions.NotImplementedException;

import java.util.Arrays;
import java.util.Collections;


class XMemoryUnitCollector implements XEventVisitor<Iterable<XMemoryUnit>> {

    // TODO!!!! computation events are recursive structures => need to call this recursively! (Although, I think, by construction they are not recursive. Need additional constraints!)

    @Override
    public Iterable<XMemoryUnit> visit(XUnaryComputationEvent event) {
        return Collections.singletonList(event.getOperand());
    }

    @Override
    public Iterable<XMemoryUnit> visit(XBinaryComputationEvent event) {
        return Arrays.asList(event.getFirstOperand(), event.getSecondOperand());
    }

    @Override
    public Iterable<XMemoryUnit> visit(XAssertionEvent event) {
        return event.getAssertion().accept(this);
    }

    @Override
    public Iterable<XMemoryUnit> visit(XFunctionCallEvent event) {
        throw new NotImplementedException(); //todo: after method call is completed, return arguments + return register
    }

    @Override
    public Iterable<XMemoryUnit> visit(XInitialWriteEvent event) {
        throw new NotImplementedException(); //TODO
    }

    @Override
    public Iterable<XMemoryUnit> visit(XRegisterMemoryEvent event) {
        return Arrays.asList(event.getSource(), event.getDestination());
    }

    @Override
    public Iterable<XMemoryUnit> visit(XStoreMemoryEvent event) {
        return Arrays.asList(event.getSource(), event.getDestination());
    }

    @Override
    public Iterable<XMemoryUnit> visit(XLoadMemoryEvent event) {
        return Arrays.asList(event.getSource(), event.getDestination());
    }

    @Override
    public Iterable<XMemoryUnit> visit(XEntryEvent event) {
        return Collections.emptyList();
    }

    @Override
    public Iterable<XMemoryUnit> visit(XExitEvent event) {
        return Collections.emptyList();
    }

    @Override
    public Iterable<XMemoryUnit> visit(XJumpEvent event) {
        return Collections.emptyList();
    }

    @Override
    public Iterable<XMemoryUnit> visit(XNopEvent event) {
        return Collections.emptyList();
    }

    @Override
    public Iterable<XMemoryUnit> visit(XBarrierEvent event) {
        return Collections.emptyList();
    }
}
