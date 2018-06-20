package porthosc.languages.syntax.ytree.expressions.atomics;

import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.ytree.types.YType;
import porthosc.languages.syntax.ytree.visitors.YtreeVisitor;


public class YParameter implements YAtom {

    private final Origin origin;
    private final YType type;
    private final YVariableRef variable;

    public YParameter(Origin origin, YType type, YVariableRef variable) {
        this.origin = origin;
        this.variable = variable.asGlobal();
        this.type = type;
    }

    public YType getType() {
        return type;
    }

    public YVariableRef getVariable() {
        return variable;
    }

    @Override
    public Kind getKind() {
        return getVariable().getKind();
    }

    @Override
    public int getPointerLevel() {
        return getVariable().getPointerLevel();
    }

    @Override
    public YParameter withPointerLevel(int level) {
        return new YParameter(origin(), getType(), getVariable().withPointerLevel(level));
    }

    @Override
    public Origin origin() {
        return origin;
    }

    @Override
    public String toString() {
        return "param(" + getType() + getVariable() + ")";
    }

    @Override
    public <T> T accept(YtreeVisitor<T> visitor) {
        return visitor.visit(this);
    }
}
