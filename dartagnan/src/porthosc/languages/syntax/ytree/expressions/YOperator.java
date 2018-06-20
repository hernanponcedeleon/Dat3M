package porthosc.languages.syntax.ytree.expressions;

import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.ytree.YEntity;


public interface YOperator extends YEntity {

    @Override
    default Origin origin() {
        return Origin.empty;
    }
}
