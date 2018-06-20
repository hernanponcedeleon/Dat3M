package porthosc.utils.exceptions.xgraph;

public class InvalidComparableExpressionError extends XInterpretationError {

    public InvalidComparableExpressionError(String originalExpr) {
        super("Cannot compare expression '" + originalExpr + "'");
    }
}
