package porthosc.languages.syntax.ytree.temporaries;

public class YTokenTemp implements YTempEntity {

    private final String value;

    public YTokenTemp(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}
