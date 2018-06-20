package porthosc.languages.syntax.ytree.expressions;

import porthosc.languages.syntax.ytree.YEntity;


// TODO: add 'Origin origin()' method where Origin contains text citation, line number(s), etc...
public interface YExpression extends YEntity {

    /**
     * Returns the C-pointer level of current expression.
     * For example:
     * -1: Address reference (ampersand &)
     *  0: Value itself (no asterisks and ampersands)
     *  1,2,3...: pointer dereference n times (number of asterisks *)
     *  I.e., the reference operator decreases the pointer level,
     *  and the dereference operator increases it.
     */
    int getPointerLevel();

    /**
     * Return a copy of {@link this} with pointer-level {@param level}.
     */
    YExpression withPointerLevel(int level);
}
