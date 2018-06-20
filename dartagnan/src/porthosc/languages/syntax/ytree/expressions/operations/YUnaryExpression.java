package porthosc.languages.syntax.ytree.expressions.operations;

import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.ytree.expressions.YExpression;
import porthosc.languages.syntax.ytree.expressions.YMultiExpression;
import porthosc.languages.syntax.ytree.visitors.YtreeVisitor;
import porthosc.utils.exceptions.NotSupportedException;

import java.util.Objects;


public class YUnaryExpression extends YMultiExpression {

    private final YUnaryOperator operator;

    YUnaryExpression(Origin origin, YUnaryOperator operator, YExpression baseExpression) {
        super(origin, baseExpression);
        this.operator = operator;
    }

    public YUnaryOperator getOperator() {
        return operator;
    }

    public YExpression getExpression() {
        return getElements().get(0);
    }

    public String toString() {
        return "" + getOperator() + getExpression();
    }

    @Override
    public YExpression withPointerLevel(int level) {
        throw new NotSupportedException("unary expression cannot be a pointer"); //todo: is that true?
    }

    @Override
    public <T> T accept(YtreeVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) { return true; }
        if (!(o instanceof YUnaryExpression)) { return false; }
        if (!super.equals(o)) { return false; }
        YUnaryExpression that = (YUnaryExpression) o;
        return getOperator() == that.getOperator();
    }

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), getOperator());
    }
}
