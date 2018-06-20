package porthosc.languages.syntax.ytree.expressions.accesses;

import com.google.common.collect.ImmutableList;
import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.ytree.expressions.YExpression;
import porthosc.languages.syntax.ytree.expressions.YMultiExpression;
import porthosc.languages.syntax.ytree.visitors.YtreeVisitor;
import porthosc.utils.ImmutableUtils;


public class YInvocationExpression extends YMultiExpression  {

    private final int elementsCount;
    // TODO: process signatures! firstly only function name. -- not here, on YIndexerExpression level

    //public YInvocationExpression(YExpression baseExpression, YExpression... arguments) {
    //    this(baseExpression, ImmutableList.copyOf(arguments));
    //}
    public YInvocationExpression(Origin origin, YExpression baseExpression, ImmutableList<YExpression> arguments) {
        this(origin, baseExpression, arguments, 0);
    }

    private YInvocationExpression(Origin origin, YExpression baseExpression, ImmutableList<YExpression> arguments, int pointerLevel) {
        super(origin, pointerLevel, ImmutableUtils.append(baseExpression, arguments));
        this.elementsCount = arguments.size() + 1;
    }

    public YExpression getBaseExpression() {
        return getElements().get(0);
    }

    public ImmutableList<YExpression> getArguments() {
        return getElements().subList(1, elementsCount);
    }

    @Override
    public YInvocationExpression withPointerLevel(int level) {
        return new YInvocationExpression(origin(), getBaseExpression(), getArguments(), level);
    }

    @Override
    public <T> T accept(YtreeVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public String toString() {
        final StringBuilder sb = new StringBuilder();
        sb.append(getBaseExpression()).append("(");
        for (YExpression arg : getArguments()) {
            sb.append(arg).append(", ");
        }
        sb.append(")");
        return sb.toString();
    }
}
