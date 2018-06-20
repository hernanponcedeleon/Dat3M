package porthosc.languages.syntax.ytree.expressions.atomics;

import porthosc.languages.syntax.ytree.expressions.YExpression;


public interface YAtom extends YExpression {

    Kind getKind();

    enum Kind {
        Local,
        Global,
        ;
    }
}
