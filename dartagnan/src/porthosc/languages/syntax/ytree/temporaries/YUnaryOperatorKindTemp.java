package porthosc.languages.syntax.ytree.temporaries;

/**
 * unaryOperator
 * :   '&' | '*' | '+' | '-' | '~' | '!'
 * ;
 */
public enum YUnaryOperatorKindTemp implements YTempEntity {
    Ampersand,
    Asterisk,
    Plus,
    Minus,
    Tilde,
    Exclamation,
    ;

    public static YUnaryOperatorKindTemp tryParse(String value) {
        switch (value) {
            case "&": return Ampersand;
            case "*": return Asterisk;
            case "+": return Plus;
            case "-": return Minus;
            case "~": return Tilde;
            case "!": return Exclamation;
            default:
                return null;
        }
    }
}
