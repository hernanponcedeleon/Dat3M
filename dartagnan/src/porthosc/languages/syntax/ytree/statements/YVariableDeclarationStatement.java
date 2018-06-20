package porthosc.languages.syntax.ytree.statements;

import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.ytree.expressions.atomics.YVariableRef;
import porthosc.languages.syntax.ytree.types.YType;
import porthosc.languages.syntax.ytree.visitors.YtreeVisitor;

import java.util.Objects;


public class YVariableDeclarationStatement extends YStatement {

    private final YType type;
    private final YVariableRef variable;

    public YVariableDeclarationStatement(Origin origin, YType type, YVariableRef variable) {
        super(origin);
        this.type = type;
        this.variable = variable;
    }

    public YType getType() {
        return type;
    }

    public YVariableRef getVariable() {
        return variable;
    }

    @Override
    public <T> T accept(YtreeVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public String toString() {
        return String.format("declare(%s: %s);", getVariable(), getType());
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof YVariableDeclarationStatement)) return false;
        YVariableDeclarationStatement that = (YVariableDeclarationStatement) o;
        return Objects.equals(getType(), that.getType()) &&
                Objects.equals(getVariable(), that.getVariable());
    }

    @Override
    public int hashCode() {
        return Objects.hash(getType(), getVariable());
    }
}
