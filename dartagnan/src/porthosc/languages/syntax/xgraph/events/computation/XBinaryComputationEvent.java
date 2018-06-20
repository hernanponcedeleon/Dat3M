package porthosc.languages.syntax.xgraph.events.computation;

import porthosc.languages.syntax.xgraph.events.XEventInfo;
import porthosc.languages.syntax.xgraph.memories.XLocalMemoryUnit;
import porthosc.languages.syntax.xgraph.visitors.XEventVisitor;
import porthosc.languages.syntax.xgraph.visitors.XMemoryUnitVisitor;

import java.util.Objects;


public final class XBinaryComputationEvent extends XComputationEventBase {

    private final XLocalMemoryUnit firstOperand;
    private final XLocalMemoryUnit secondOperand;

    public XBinaryComputationEvent(XEventInfo info,
                                   XBinaryOperator operator,
                                   XLocalMemoryUnit firstOperand,
                                   XLocalMemoryUnit secondOperand) {
        this(NOT_UNROLLED_REF_ID, info, operator, firstOperand, secondOperand);
    }

    protected XBinaryComputationEvent(int refId,
                                   XEventInfo info,
                                   XBinaryOperator operator,
                                   XLocalMemoryUnit firstOperand,
                                   XLocalMemoryUnit secondOperand) {
        super(refId, info, XTypeDeterminer.determineType(operator, firstOperand, secondOperand), operator);
        this.firstOperand = firstOperand;
        this.secondOperand = secondOperand;
    }

    public XBinaryOperator getOperator() {
        return (XBinaryOperator) super.getOperator();
    }

    public XLocalMemoryUnit getFirstOperand() {
        return firstOperand;
    }

    public XLocalMemoryUnit getSecondOperand() {
        return secondOperand;
    }

    @Override
    public XBinaryComputationEvent asNodeRef(int refId) {
        return new XBinaryComputationEvent(refId, getInfo(), getOperator(), getFirstOperand(), getSecondOperand());
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
        return wrapWithBracketsAndDepth("eval(" + getFirstOperand() + " " + getOperator() + " " + getSecondOperand() + ")");
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) { return true; }
        if (!(o instanceof XBinaryComputationEvent)) { return false; }
        if (!super.equals(o)) { return false; }
        XBinaryComputationEvent that = (XBinaryComputationEvent) o;
        return Objects.equals(getFirstOperand(), that.getFirstOperand()) &&
                Objects.equals(getSecondOperand(), that.getSecondOperand());
    }

    @Override
    public int hashCode() {

        return Objects.hash(super.hashCode(), getFirstOperand(), getSecondOperand());
    }
}
