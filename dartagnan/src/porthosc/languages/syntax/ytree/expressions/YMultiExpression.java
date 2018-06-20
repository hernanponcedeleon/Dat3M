package porthosc.languages.syntax.ytree.expressions;

import com.google.common.collect.ImmutableList;
import porthosc.languages.common.citation.Origin;

import java.util.Objects;


public abstract class YMultiExpression implements YExpression {

    private final Origin origin;
    private final int pointerLevel;
    private final ImmutableList<YExpression> elements;

    protected YMultiExpression(Origin origin, YExpression... elements) {
        this(origin, 0, elements);
    }

    protected YMultiExpression(Origin origin, int pointerLevel, YExpression... elements) {
        this(origin, pointerLevel, ImmutableList.copyOf(elements));
    }

    protected YMultiExpression(Origin origin, int pointerLevel, ImmutableList<YExpression> elements) {
        this.pointerLevel = pointerLevel;
        this.elements = elements;
        this.origin = origin;
    }

    protected ImmutableList<YExpression> getElements() {
        return elements;
    }

    @Override
    public int getPointerLevel() {
        return pointerLevel;
    }

    @Override
    public Origin origin() {
        return origin;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof YMultiExpression)) return false;
        YMultiExpression that = (YMultiExpression) o;
        return Objects.equals(getElements(), that.getElements());
    }

    @Override
    public int hashCode() {
        return Objects.hash(getElements());
    }
}
