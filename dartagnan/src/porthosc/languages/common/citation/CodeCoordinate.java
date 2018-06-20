package porthosc.languages.common.citation;

public class CodeCoordinate {

    private final int lineNumber;
    private final int charNumber;

    public CodeCoordinate(int lineNumber, int charNumber) {
        this.lineNumber = lineNumber;
        this.charNumber = charNumber;
    }
}
