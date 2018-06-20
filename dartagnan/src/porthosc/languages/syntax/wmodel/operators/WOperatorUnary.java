package porthosc.languages.syntax.wmodel.operators;

import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.wmodel.WEntity;
import porthosc.languages.syntax.wmodel.WOperator;
import porthosc.languages.syntax.wmodel.visitors.WmodelVisitor;


public class WOperatorUnary extends WOperatorBase {

    private final WEntity operand;

    private WOperatorUnary(Origin origin,
                           WOperatorUnary.Kind kind,
                           WEntity operand) {
        super(origin, operand.containsRecursion(), kind);
        this.operand = operand;
    }

    public WEntity getOperand() {
        return operand;
    }

    @Override
    public WOperatorUnary.Kind getKind() {
        return (WOperatorUnary.Kind) super.getKind();
    }

    @Override
    public <T> T accept(WmodelVisitor<T> visitor) {
        return visitor.visit(this);
    }

    // --

    public enum Kind implements WOperator.Kind {
        IdentityClosure,
        ReflexiveTransitiveClosure,
        TransitiveClosure,
        Complement,
        Inverse,
        ;


        @Override
        public String toString() {
            switch (this) {
                case IdentityClosure:            return "?";
                case ReflexiveTransitiveClosure: return "*";
                case TransitiveClosure:          return "+";
                case Complement:                 return "~";
                case Inverse:                    return "^-1";
                default:
                    throw new IllegalStateException(this.name());
            }
        }

        public WOperator create(Origin origin, WEntity operand) {
            return new WOperatorUnary(origin, this, operand);
        }
    }
}
