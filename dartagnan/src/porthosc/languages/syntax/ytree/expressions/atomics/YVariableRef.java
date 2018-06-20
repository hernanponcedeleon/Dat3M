package porthosc.languages.syntax.ytree.expressions.atomics;

import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.ytree.visitors.YtreeVisitor;

import java.util.Objects;


// TODO: NOTE!!! IN FUNCTION INVOCATION FUNC. NAME IS YVariable!
public class YVariableRef extends YAtomBase {

    private final String name;

    public YVariableRef(Origin origin, String name) {
        this(origin, Kind.Local, name, 0);
    }

    protected YVariableRef(Origin origin, String name, int pointerLevel) {
        this(origin, Kind.Local, name, pointerLevel);
    }

    private YVariableRef(Origin origin, Kind kind, String name, int pointerLevel) {
        super(origin, kind, pointerLevel);
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public YVariableRef asGlobal() {
        return new YVariableRef(origin(), Kind.Global, getName(), getPointerLevel());
    }

    @Override
    public YVariableRef withPointerLevel(int level) {
        return new YVariableRef(origin(), getKind(), getName(), level);
    }

    @Override
    public <T> T accept(YtreeVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public String toString() {
        String prefix = getKind() == Kind.Local ? "%" : "@";
        return prefix + getName();
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) { return true; }
        if (!(o instanceof YVariableRef)) { return false; }
        if (!super.equals(o)) { return false; }
        YVariableRef that = (YVariableRef) o;
        return getPointerLevel() == that.getPointerLevel() &&
                Objects.equals(getName(), that.getName());
    }

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), getName(), getPointerLevel());
    }
}
