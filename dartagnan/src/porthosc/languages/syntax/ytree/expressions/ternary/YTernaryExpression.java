package porthosc.languages.syntax.ytree.expressions.ternary;

import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.ytree.expressions.YExpression;
import porthosc.languages.syntax.ytree.expressions.YMultiExpression;
import porthosc.languages.syntax.ytree.visitors.YtreeVisitor;
import porthosc.utils.exceptions.NotSupportedException;

public class YTernaryExpression extends YMultiExpression {

    public YTernaryExpression(Origin origin,
                              YExpression condition,
                              YExpression trueExpression,
                              YExpression falseExpression) {
        super(origin, condition, trueExpression, falseExpression);
    }

    public YExpression getCondition() {
        return getElements().get(0);
    }

    public YExpression getTrueExpression() {
        return getElements().get(1);
    }

    public YExpression getFalseExpression() {
        return getElements().get(2);
    }

    @Override
    public int getPointerLevel() {
        return 0;//NOTE: this is because pointers for ternary expressions are not implemented yet
    }

    @Override
    public YExpression withPointerLevel(int level) {
        throw new NotSupportedException("ternary expression cannot be a pointer"); //todo: this is not true
    }

    @Override
    public <T> T accept(YtreeVisitor<T> visitor) {
        return visitor.visit(this);
    }
}
