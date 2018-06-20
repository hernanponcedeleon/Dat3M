package porthosc.languages.syntax.ytree.statements;

import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.ytree.expressions.YExpression;
import porthosc.languages.syntax.ytree.visitors.YtreeVisitor;

import java.util.Objects;


public class YLinearStatement extends YStatement {

    private final YExpression expression;

    public YLinearStatement(YExpression expression) {
        this(expression.origin(), expression);
    }

    private YLinearStatement(Origin origin, YExpression expression) {
        super(origin);
        assert expression != null;//TODO: add non-null asserts everywhere
        this.expression = expression;
    }

    public YExpression getExpression() {
        return expression;
    }

    @Override
    public <T> T accept(YtreeVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public String toString() {
        return getExpression() + ";";
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof YLinearStatement)) return false;
        YLinearStatement that = (YLinearStatement) o;
        return Objects.equals(getExpression(), that.getExpression());
    }

    @Override
    public int hashCode() {
        return Objects.hash(getExpression());
    }
}
