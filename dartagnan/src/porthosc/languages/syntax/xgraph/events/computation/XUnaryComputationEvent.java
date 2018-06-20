package porthosc.languages.syntax.xgraph.events.computation;

import porthosc.languages.syntax.xgraph.events.XEventInfo;
import porthosc.languages.syntax.xgraph.memories.XLocalMemoryUnit;
import porthosc.languages.syntax.xgraph.visitors.XEventVisitor;
import porthosc.languages.syntax.xgraph.visitors.XMemoryUnitVisitor;

import java.util.Objects;


public final class XUnaryComputationEvent extends XComputationEventBase {

    private final XLocalMemoryUnit operand;

    public XUnaryComputationEvent(XEventInfo info, XUnaryOperator operator, XLocalMemoryUnit operand) {
        this(NOT_UNROLLED_REF_ID, info, operator, operand);
    }

    private XUnaryComputationEvent(int refId, XEventInfo info, XUnaryOperator operator, XLocalMemoryUnit operand) {
        super(refId, info, XTypeDeterminer.determineType(operator, operand), operator);
        this.operand = operand;
    }

    public XUnaryOperator getOperator() {
        return (XUnaryOperator) super.getOperator();
    }

    public XLocalMemoryUnit getOperand() {
        return operand;
    }

    @Override
    public XUnaryComputationEvent asNodeRef(int refId) {
        return new XUnaryComputationEvent(refId, getInfo(), getOperator(), getOperand());
    }

    @Override
    public <T> T accept(XEventVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public <T> T accept(XMemoryUnitVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public String toString() {
        return wrapWithBracketsAndDepth("eval(" + getOperator() + getOperand() + ")");
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) { return true; }
        if (!(o instanceof XUnaryComputationEvent)) { return false; }
        if (!super.equals(o)) { return false; }
        XUnaryComputationEvent that = (XUnaryComputationEvent) o;
        return Objects.equals(getOperand(), that.getOperand());
    }

    @Override
    public int hashCode() {

        return Objects.hash(super.hashCode(), getOperand());
    }
}
