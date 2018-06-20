package porthosc.languages.syntax.ytree.statements;

import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.ytree.YEntity;


public abstract class YStatement implements YEntity {  // TODO: implement all as YJumpStatement

    private final Origin origin;

    protected YStatement(Origin origin) {
        this.origin = origin;
    }

    @Override
    public Origin origin() {
        return origin;
    }


    //private static int id = 1;
    //protected static String null {
    //    return "__stmt" + id++;
    //}
}
