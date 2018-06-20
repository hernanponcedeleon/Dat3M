package porthosc.languages.syntax.ytree.expressions.accesses;

import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.ytree.expressions.YMultiExpression;
import porthosc.languages.syntax.ytree.expressions.atomics.YAtom;
import porthosc.languages.syntax.ytree.visitors.YtreeVisitor;


public class YMemberAccessExpression extends YMultiExpression implements YAtom {

    private final String memberName;

    public YMemberAccessExpression(Origin origin, YAtom baseExpression, String memberName) {
        this(origin, baseExpression, memberName, baseExpression.getPointerLevel());
    }

    private YMemberAccessExpression(Origin origin, YAtom baseExpression, String memberName, int pointerLevel) {
        super(origin, pointerLevel, baseExpression);
        this.memberName = memberName;
    }

    public YAtom getBaseExpression() {
        return (YAtom) getElements().get(0);
    }

    public String getMemberName() {
        return memberName;
    }

    @Override
    public Kind getKind() {
        return getBaseExpression().getKind();
    }

    @Override
    public YMemberAccessExpression withPointerLevel(int level) {
        return new YMemberAccessExpression(origin(), getBaseExpression(), getMemberName(), level);
    }

    @Override
    public <T> T accept(YtreeVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public String toString() {
        return getBaseExpression() + "." + getMemberName(); // "." or "->"
    }
}
