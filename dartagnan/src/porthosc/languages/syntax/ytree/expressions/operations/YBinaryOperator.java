package porthosc.languages.syntax.ytree.expressions.operations;

import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.ytree.expressions.YExpression;
import porthosc.languages.syntax.ytree.expressions.YOperator;
import porthosc.languages.syntax.ytree.visitors.YtreeVisitor;


public enum YBinaryOperator implements YOperator {
    //integer:
    Plus,
    Minus,
    Multiply,
    Divide,
    Modulo,
    LeftShift,
    RightShift,
    BitAnd,
    BitOr,
    BitXor,
    //logical:
    Conjunction,
    Disjunction,
    //relative:
    Equals,
    NotEquals,
    Greater,
    GreaterOrEquals,
    Less,
    LessOrEquals,
    ;

    public YBinaryExpression createExpression(Origin origin, YExpression leftExpression, YExpression rightExpression) {
        return new YBinaryExpression(origin, this, leftExpression, rightExpression);
    }

    @Override
    public <T> T accept(YtreeVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public String toString() {
        switch (this) {
            case Plus:         return "+";
            case Minus:        return "-";
            case Multiply:     return "*";
            case Divide:       return "/";
            case Modulo:       return "%";
            case LeftShift:    return "<<";
            case RightShift:   return ">>";
            case BitAnd:       return "&";
            case BitOr:        return "|";
            case BitXor:       return "^";
            //
            case Conjunction:  return "&&";
            case Disjunction:  return "||";
            //
            case Equals:          return "==";
            case NotEquals:       return "!=";
            case Greater:         return ">";
            case GreaterOrEquals: return ">=";
            case Less:            return "<";
            case LessOrEquals:    return "<=";
            default:
                throw new IllegalArgumentException(this.name());
        }
    }
}
