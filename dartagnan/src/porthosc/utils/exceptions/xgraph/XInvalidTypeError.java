package porthosc.utils.exceptions.xgraph;

import porthosc.utils.StringUtils;


public class XInvalidTypeError extends XInterpretationError {

    public XInvalidTypeError(Object node, Class<?> castToClass) {
        super(getCastErrorMessage(node, castToClass));
    }

    private static String getCastErrorMessage(Object node, Class<?> castToClass) {
        return "Invalid xgraph node type: " + StringUtils.wrap(node.toString()) +
                ", its type " + StringUtils.wrap(node.getClass().getSimpleName()) +
                " is not coercive to " + StringUtils.wrap(castToClass.getSimpleName());
    }
}
