package porthosc.languages.syntax.ytree.litmus;

import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.ytree.expressions.YExpression;
import porthosc.languages.syntax.ytree.statements.YStatement;
import porthosc.languages.syntax.ytree.visitors.YtreeVisitor;


public final class YPostludeDefinition extends YStatement {

    private final YExpression expression; //a recursive boolean expression-tree

    public YPostludeDefinition(Origin origin, YExpression expression) {
        super(origin);
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
        return "exists( " + getExpression() + " )";
    }
}
