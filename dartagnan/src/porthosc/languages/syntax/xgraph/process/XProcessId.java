package porthosc.languages.syntax.xgraph.process;

import java.util.Objects;


public class XProcessId {

    public static final XProcessId PreludeProcessId  = new XProcessId("_Prelude_");
    public static final XProcessId PostludeProcessId = new XProcessId("_Postlude_");

    private final String value;

    public XProcessId(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }

    @Override
    public String toString() {
        return getValue();
    }

    @Override

    public boolean equals(Object o) {
        if (this == o) { return true; }
        if (!(o instanceof XProcessId)) { return false; }
        XProcessId that = (XProcessId) o;
        return Objects.equals(getValue(), that.getValue());
    }

    @Override
    public int hashCode() {

        return Objects.hash(getValue());
    }
}
