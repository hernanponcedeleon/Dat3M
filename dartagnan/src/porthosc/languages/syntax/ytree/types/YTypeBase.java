package porthosc.languages.syntax.ytree.types;/*

package porthosc.languages.syntax.ytree.types;

public abstract class YTypeBase implements YType {

private final YTypeBase.Qualifier qualifier;
private final int pointerLevel;

YTypeBase() {
    this(Qualifier.Default, 0);
}

//YTypeBase(int pointerLevel) {
//    this(Qualifier.Default, pointerLevel);
//}

YTypeBase(Qualifier qualifier, int pointerLevel) {
    this.qualifier = qualifier;
    this.pointerLevel = pointerLevel;
}

@Override
public YTypeBase.Qualifier getQualifier() {
    return qualifier;
}

@Override
public int getPointerLevel() {
    return pointerLevel;
}

@Override
public Iterator<? extends YEntity> getChildrenIterator() {
    return YtreeUtils.createIteratorFrom();
}

public enum Qualifier implements YType.Qualifier, Enumeration {
    Default, //no qualifier
    Const,
    Restrict,
    Volatile,
    Atomic,
    ;

    @Override
    public String getText() {
        switch (this) {
            case Default:  return "";
            case Const:    return "const";
            case Restrict: return "restrict";
            case Volatile: return "volatile";
            case Atomic:   return "_Atomic";
            default:
                throw new IllegalArgumentException(this.name());
        }
    }

    @Override
    public String toString() {
        return getText();
    }

    public static YTypeBase.Qualifier tryParse(String value) {
        for (Qualifier qualifier : values()) {
            if (value.equals(qualifier.getText())) {
                return qualifier;
            }
        }
        return null;
    }
}
}
*/
