package porthosc.languages.syntax.ytree.expressions.operations;

import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.ytree.expressions.YExpression;
import porthosc.languages.syntax.ytree.expressions.YOperator;
import porthosc.languages.syntax.ytree.visitors.YtreeVisitor;


/**
 * 6.5.3.3 Unary arithmetic operators
 * Constraints
 * The operand of the unary + or - operator shall have arithmetic type; of the ~ operator,
 * integer type; of the ! operator, scalar type.
 */
public enum YUnaryOperator implements YOperator {
    PrefixIncrement,    // ++x
    PrefixDecrement,    // --x
    PostfixIncrement,   // x++
    PostfixDecrement,   // x--
    IntegerNegation,    // -x
    /**
     * 6.5.3.3 Unary arithmetic operators
     * Semantics
     * The result of the ~ operator is the bitwise complement of its (promoted) operand (that is,
     * each bit in the result is set if and only if the corresponding bit in the converted operand is
     * not set). The integer promotions are performed on the operand, and the result has the
     * promoted type. If the promoted type is an unsigned type, the expression ~E is equivalent
     * to the maximum value representable in that type minus E.
     */
    BitwiseComplement,  // ~x
    //logical:
    Negation,
    ;

    @Override
    public <T> T accept(YtreeVisitor<T> visitor) {
        return visitor.visit(this);
    }

    public YUnaryExpression createExpression(Origin origin, YExpression baseExpression) {
        return new YUnaryExpression(origin, this, baseExpression);
    }

    @Override
    public String toString() {
        switch (this) {
            case PostfixIncrement:
            case PrefixIncrement:
                return "++";
            case PostfixDecrement:
            case PrefixDecrement:
                return "--";
            case IntegerNegation:
                return "-";
            case BitwiseComplement:
                return "~";
            case Negation:
                return "!";
            default:
                throw new IllegalArgumentException(this.name());
        }
    }
}
