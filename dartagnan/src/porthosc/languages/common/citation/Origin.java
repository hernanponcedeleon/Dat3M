package porthosc.languages.common.citation;

public class Origin {

    private final String file;
    private final int startIndex;
    private final int endIndex;

    public Origin(String file, int startIndex, int endIndex) {
        this.file = file;
        this.startIndex = startIndex;
        this.endIndex = endIndex;
    }

    public int start() {
        return startIndex;
    }

    public int end() {
        return endIndex;
    }

    public static final Origin empty = new Origin("", -1, -1);
}
