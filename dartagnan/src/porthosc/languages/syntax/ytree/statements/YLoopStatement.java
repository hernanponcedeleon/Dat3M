package porthosc.languages.syntax.ytree.statements;

import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.ytree.expressions.YExpression;
import porthosc.languages.syntax.ytree.visitors.YtreeVisitor;

import java.util.Objects;


// while + for loops
public class YLoopStatement extends YStatement {

    private final YExpression condition;
    private final YStatement body;

    public YLoopStatement(Origin origin, YExpression condition, YStatement body) {
        super(origin);
        this.condition = condition;
        this.body = body;
    }

    public YExpression getCondition() {
        return condition;
    }

    public YStatement getBody() {
        return body;
    }

    @Override
    public <T> T accept(YtreeVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public String toString() {
        return String.format("while (%s) %s", getCondition(), getBody());
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof YLoopStatement)) return false;
        YLoopStatement that = (YLoopStatement) o;
        return Objects.equals(getCondition(), that.getCondition()) &&
                Objects.equals(getBody(), that.getBody());
    }

    @Override
    public int hashCode() {
        return Objects.hash(getCondition(), getBody());
    }
}
