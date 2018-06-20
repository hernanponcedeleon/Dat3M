package porthosc.languages.syntax.ytree.types;/*

package porthosc.languages.syntax.ytree.types;

public class YPrimitiveType extends YTypeBase {

private final YPrimitiveType.Kind kind;
private final YPrimitiveType.Specifier specifier;

private YPrimitiveType(YPrimitiveType.Kind kind) {
    super();
    this.kind = kind;
    this.specifier = Specifier.Default;
}

YPrimitiveType(YPrimitiveType.Kind kind,
               YPrimitiveType.Specifier specifier,
               YTypeBase.Qualifier qualifier,
               int pointerLevel) {
    super(qualifier, pointerLevel);
    this.kind = kind;
    this.specifier = specifier;
}

public Kind getOperator() {
    return kind;
}

@Override
public YPrimitiveType.Specifier getSpecifier() {
    return specifier;
}

@Override
public YType withPointerLevel(int newPointerLevel) {
    return new YPrimitiveType(getOperator(), getSpecifier(), getQualifier(), newPointerLevel);
}

public YPrimitiveType asUnsigned() {
    return new YPrimitiveType(getOperator(), Specifier.Unsigned, getQualifier(), getPointerLevel());
}

@Override
public Iterator<? extends YEntity> getChildrenIterator() {
    return YtreeUtils.createIteratorFrom();
}

@Override
public <T> T accept(YtreeVisitor<T> visitor) {
    return visitor.visit(this);
}

@Override
public YPrimitiveType copy() {
    return new YPrimitiveType(getOperator(), getSpecifier(), getQualifier(), getPointerLevel());
}

@Override
public String toString() {
    StringBuilder builder = new StringBuilder();
    String qualifierText = getQualifier().toString();
    if (qualifierText.length() > 0) {
        builder.append(qualifierText).append(' ');
    }
    String specifierText = getSpecifier().toString();
    if (specifierText.length() > 0) {
        builder.append(specifierText).append(' ');
    }
    builder.append(getOperator().getText());
    return builder.toString();
}


// see https://os.mbed.com/handbook/C-Data-Types
// or http://en.cppreference.com/w/cpp/language/types

public enum Kind {
    Void,
    Char,
    Short,
    Int,
    Long,
    LongLong,
    Float,
    Double,
    LongDouble,
    Bool,
    ;

    public static Kind tryParse(String value) {
        for (Kind kind : values()) {
            if (value.equals(kind.getText())) {
                return kind;
            }
        }
        return null;
    }

    public String getText() {
        final StringBuilder builder = new StringBuilder();
        String space = "";
        for (char c : this.name().toCharArray()) {
            if (c >= 'a' && c <= 'z') {
                builder.append(c);
            } else {
                builder.append(space).append(Character.toLowerCase(c));
                space = " ";
            }
        }
        return builder.toString();
    }

    public YPrimitiveType create() {
        return new YPrimitiveType(this);
    }

    @Override
    public String toString() {
        return getText();
    }
}

public enum Specifier implements YType.Specifier {
    Default,
    Signed,
    Unsigned,
    ;

    public String getText() {
        switch (this) {
            case Signed:   return "signed";
            case Unsigned: return "unsigned";
            default:
                throw new IllegalArgumentException(this.name());
        }
    }

    @Override
    public String toString() {
        return getText();
    }

    public static Specifier tryParse(String value) {
        for (Specifier specifier : values()) {
            if (value.equals(specifier.getText())) {
                return specifier;
            }
        }
        return null;
    }
}
}
*/
