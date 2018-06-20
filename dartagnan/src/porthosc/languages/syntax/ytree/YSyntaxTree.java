package porthosc.languages.syntax.ytree;

import com.google.common.collect.ImmutableList;
import porthosc.languages.common.citation.Origin;
import porthosc.languages.conversion.toytree.c11.JumpsResolver;
import porthosc.languages.syntax.ytree.visitors.YtreeVisitor;

import java.util.Collection;


public class YSyntaxTree implements YEntity {

    private final Origin origin;
    private final ImmutableList<YEntity> roots;
    
    private final JumpsResolver jumpsResolver;

    public YSyntaxTree(Origin origin, JumpsResolver jumpsResolver, ImmutableList<YEntity> roots) {
        this.roots = roots;
        this.origin = origin;
        this.jumpsResolver = jumpsResolver;
    }

    public YSyntaxTree(Origin origin, JumpsResolver jumpsResolver, YEntity... statements) {
        this(origin, jumpsResolver, ImmutableList.copyOf(statements));
    }

    public YSyntaxTree(Origin origin, JumpsResolver jumpsResolver, Collection<YEntity> statements) {
        this(origin, jumpsResolver, ImmutableList.copyOf(statements));
    }

    public JumpsResolver getJumpsResolver() {
        return jumpsResolver;
    }

    public ImmutableList<YEntity> getRoots() {
        return roots;
    }

    @Override
    public Origin origin() {
        return origin;
    }

    @Override
    public <T> T accept(YtreeVisitor<T> visitor) {
        return visitor.visit(this);
    }
}
