package porthosc.languages.syntax.ytree.expressions.atomics;

import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.ytree.visitors.YtreeVisitor;
import porthosc.utils.exceptions.ArgumentNullException;
import porthosc.utils.exceptions.NotSupportedException;

import java.util.Objects;


public class YConstant extends YAtomBase {

    private final Object value;

    private YConstant(Origin origin, Object value) {
        super(origin, Kind.Global);
        this.value = value;
    }

    public Object getValue() {
        return value;
    }

    @Override
    public YAtom withPointerLevel(int level) {
        throw new NotSupportedException("constants cannot be pointers");
    }

    @Override
    public <T> T accept(YtreeVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public String toString() {
        return /*"(" + getType() + ")" +*/ ""+getValue();
    }

    // ... todo: other types...


    public static YConstant fromValue(int value) {
        return new YConstant(Origin.empty, value); //YTypeFactory.getPrimitiveType(YTypeName.Int));
    }

    public static YConstant fromValue(boolean value) {
        return new YConstant(Origin.empty, value); //YTypeFactory.getPrimitiveType(YTypeName.Bool));
    }

    public static YConstant fromValue(float value) {
        return new YConstant(Origin.empty, value); //YTypeFactory.getPrimitiveType(YTypeName.Float));
    }

    public static YConstant tryParse(String text) {
        if (text == null) {
            throw new ArgumentNullException();
        }

        // Integer:
        try {
            int value = Integer.parseInt(text);
            return fromValue(value);
        }
        catch (NumberFormatException e) { }
        // Float:
        try {
            float value = Float.parseFloat(text);
            return fromValue(value);
        }
        catch (NumberFormatException e) { }
        // Bool:
        {
            // TODO: set up good parsing of the keywords of C language as a separate module with 'C' in name
            if (text.equals("true")) {
                return fromValue(true);
            }
            else if (text.equals("false")) {
                return fromValue(false);
            }
        }

        // String (as char array) :
        // use StringBuilder

        // TODO: try other known types.
        return null;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) { return true; }
        if (!(o instanceof YConstant)) { return false; }
        if (!super.equals(o)) { return false; }
        YConstant yConstant = (YConstant) o;
        return Objects.equals(getValue(), yConstant.getValue());
    }

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), getValue());
    }
}
