package porthosc.languages.syntax.ytree.statements.jumps;

import java.util.Objects;


public class YJumpLabel {

    private final String value;

    public YJumpLabel(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }

    @Override
    public String toString() {
        return value;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) { return true; }
        if (!(o instanceof YJumpLabel)) { return false; }
        YJumpLabel that = (YJumpLabel) o;
        return Objects.equals(getValue(), that.getValue());
    }

    @Override
    public int hashCode() {
        return Objects.hash(getValue());
    }
}
