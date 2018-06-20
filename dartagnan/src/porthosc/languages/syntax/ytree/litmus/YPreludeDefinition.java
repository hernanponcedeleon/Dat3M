package porthosc.languages.syntax.ytree.litmus;

import com.google.common.collect.ImmutableList;
import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.ytree.definitions.YDefinition;
import porthosc.languages.syntax.ytree.statements.YStatement;
import porthosc.languages.syntax.ytree.visitors.YtreeVisitor;


public final class YPreludeDefinition extends YDefinition {

    private final ImmutableList<YStatement> initialWrites;

    public YPreludeDefinition(Origin origin, ImmutableList<YStatement> initialWrites) {
        super(origin);
        this.initialWrites = initialWrites;
    }

    public ImmutableList<YStatement> getInitialWrites() {
        return initialWrites;
    }

    @Override
    public String toString() {
        return "init { " + initialWrites + " }";
    }

    @Override
    public <T> T accept(YtreeVisitor<T> visitor) {
        return visitor.visit(this);
    }
}
