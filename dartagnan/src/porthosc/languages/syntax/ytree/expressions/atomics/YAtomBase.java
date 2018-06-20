package porthosc.languages.syntax.ytree.expressions.atomics;

import porthosc.languages.common.citation.Origin;


public abstract class YAtomBase implements YAtom {

    private final Origin origin;
    private final Kind kind;
    private final int pointerLevel;

    YAtomBase(Origin origin, Kind kind) {
        this(origin, kind, 0);
    }

    YAtomBase(Origin origin, Kind kind, int pointerLevel) {
        this.origin = origin;
        this.kind = kind;
        this.pointerLevel = pointerLevel;
    }

    @Override
    public Kind getKind() {
        return kind;
    }

    @Override
    public Origin origin() {
        return origin;
    }

    public boolean isGlobal() {
        return getKind() == Kind.Global;
    }

    public int getPointerLevel() {
        return pointerLevel;
    }
}
