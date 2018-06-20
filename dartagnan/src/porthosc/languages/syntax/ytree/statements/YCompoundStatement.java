package porthosc.languages.syntax.ytree.statements;

import com.google.common.collect.ImmutableList;
import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.ytree.visitors.YtreeVisitor;

import java.util.Objects;


public class YCompoundStatement extends YStatement {

    // TODO: perhaps, we don't need the Compound statement without braces.
    private final boolean hasBraces; // defines whether sequence of statements has surrounding braces '{' '}'
    private final ImmutableList<YStatement> statements; // <- recursive

    public YCompoundStatement(Origin origin, YStatement... statements) {
        this(origin, true, statements);
    }

    public YCompoundStatement(Origin origin, boolean hasBraces, YStatement... statements) {
        this(origin, hasBraces, ImmutableList.copyOf(statements));
    }

    public YCompoundStatement(Origin origin, boolean hasBraces, ImmutableList<YStatement> statements) {
        super(origin);
        this.statements = statements;
        this.hasBraces = hasBraces;
    }

    public ImmutableList<YStatement> getStatements() {
        return statements;
    }

    public boolean hasBraces() {
        return hasBraces;
    }

    @Override
    public <T> T accept(YtreeVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public String toString() {
        StringBuilder builder = new StringBuilder();
        if (hasBraces) {
            builder.append('{');
        }
        for (YStatement statement : getStatements()) {
            builder.append(statement.toString()).append(" ");
        }
        if (hasBraces) {
            builder.append('}');
        }
        return builder.toString();
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof YCompoundStatement)) return false;
        YCompoundStatement that = (YCompoundStatement) o;
        return hasBraces == that.hasBraces &&
                Objects.equals(getStatements(), that.getStatements());
    }

    @Override
    public int hashCode() {
        return Objects.hash(hasBraces, getStatements());
    }
}
