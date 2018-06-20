package porthosc.languages.syntax.xgraph.events.computation;

import porthosc.languages.common.XType;
import porthosc.languages.syntax.xgraph.events.XEventBase;
import porthosc.languages.syntax.xgraph.visitors.XEventVisitor;
import porthosc.languages.syntax.xgraph.visitors.XMemoryUnitVisitor;

// TODO: implement the Fake event

public final class XAssertionEvent extends XEventBase implements XComputationEvent {

    private final XBinaryComputationEvent assertion;
    //private final Map<XLocalMemoryUnit, XRvalueMemoryUnit> values;

    public XAssertionEvent(XBinaryComputationEvent assertion) {
        this(assertion.getRefId(), assertion);
    }

    private XAssertionEvent(int refId, XBinaryComputationEvent assertion) {
        super(refId, assertion.getInfo());
        this.assertion = assertion;
    }

    public XBinaryComputationEvent getAssertion() {
        return assertion;
    }

    @Override
    public XType getType() {
        return assertion.getType();
    }

    @Override
    public XAssertionEvent asNodeRef(int refId) {
        return new XAssertionEvent(refId, getAssertion());
    }

    @Override
    public String toString() {
        return "exists (" + getAssertion() + ")";
    }

    @Override
    public <T> T accept(XEventVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public <T> T accept(XMemoryUnitVisitor<T> visitor) {
        return visitor.visit(this);
    }
}
