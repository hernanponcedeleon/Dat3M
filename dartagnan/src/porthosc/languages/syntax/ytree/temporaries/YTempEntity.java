package porthosc.languages.syntax.ytree.temporaries;

import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.ytree.YEntity;
import porthosc.languages.syntax.ytree.visitors.YtreeVisitor;


public interface YTempEntity extends YEntity {

    @Override
    default <T> T accept(YtreeVisitor<T> visitor) {
        throw new UnsupportedOperationException();
    }

    @Override
    default Origin origin() {
        throw new UnsupportedOperationException();
    }
}
