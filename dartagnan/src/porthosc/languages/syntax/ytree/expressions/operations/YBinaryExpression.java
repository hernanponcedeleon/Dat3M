package porthosc.languages.syntax.ytree.expressions.operations;

import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.ytree.expressions.YExpression;
import porthosc.languages.syntax.ytree.expressions.YMultiExpression;
import porthosc.languages.syntax.ytree.visitors.YtreeVisitor;
import porthosc.utils.exceptions.NotSupportedException;

import java.util.Objects;


public class YBinaryExpression extends YMultiExpression {

    private final YBinaryOperator operator;

    YBinaryExpression(Origin origin, YBinaryOperator operator, YExpression leftExpression, YExpression rightExpression) {
        super(origin, leftExpression, rightExpression);
        this.operator = operator;
    }

    public YBinaryOperator getOperator() {
        return operator;
    }

    public YExpression getLeftExpression() {
        return getElements().get(0);
    }

    public YExpression getRightExpression() {
        return getElements().get(1);
    }

    @Override
    public YExpression withPointerLevel(int level) {
        throw new NotSupportedException("binary expression cannot be a pointer");//todo: is that true?
    }

    @Override
    public String toString() {
        return "(" + getLeftExpression() + getOperator() + getRightExpression() + ")";
    }

    @Override
    public <T> T accept(YtreeVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof YBinaryExpression)) return false;
        if (!super.equals(o)) return false;
        YBinaryExpression that = (YBinaryExpression) o;
        return Objects.equals(getOperator(), that.getOperator());
    }

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), getOperator());
    }
}
