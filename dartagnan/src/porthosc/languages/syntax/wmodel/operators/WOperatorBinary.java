package porthosc.languages.syntax.wmodel.operators;

import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.wmodel.WEntity;
import porthosc.languages.syntax.wmodel.WOperator;
import porthosc.languages.syntax.wmodel.visitors.WmodelVisitor;


public class WOperatorBinary extends WOperatorBase {

    private final WEntity operandLeft;

    private final WEntity operandRight;

    private WOperatorBinary(Origin origin,
                            WOperatorBinary.Kind kind,
                            WEntity operandLeft,
                            WEntity operandRight) {
        super(origin, (operandLeft.containsRecursion() || operandRight.containsRecursion()), kind);
        this.operandLeft = operandLeft;
        this.operandRight = operandRight;
    }

    public WEntity getOperandLeft() {
        return operandLeft;
    }

    public WEntity getOperandRight() {
        return operandRight;
    }

    @Override
    public WOperatorBinary.Kind getKind() {
        return (WOperatorBinary.Kind) super.getKind();
    }

    @Override
    public <T> T accept(WmodelVisitor<T> visitor) {
        return visitor.visit(this);
    }

    // --

    public enum Kind implements WOperator.Kind {
        Union,
        Intersection,
        Difference,
        Sequence,
        CartesianProduct,
        ;

        @Override
        public String toString() {
            switch (this) {
                case Union:             return "|";
                case Intersection:      return "&";
                case Difference:        return "\\";
                case Sequence:          return ";";
                case CartesianProduct:  return "*";
                default:
                    throw new IllegalArgumentException(this.name());
            }
        }

        public WOperator create(Origin origin, WEntity operandLeft, WEntity operandRight) {
            return new WOperatorBinary(origin, this, operandLeft, operandRight);
        }
    }

}
