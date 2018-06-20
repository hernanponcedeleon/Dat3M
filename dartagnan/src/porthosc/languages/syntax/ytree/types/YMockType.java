package porthosc.languages.syntax.ytree.types;

import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.ytree.visitors.YtreeVisitor;
import porthosc.utils.exceptions.NotImplementedException;


public class YMockType implements YType {

    @Override
    public Qualifier getQualifier() {
        return null;
    }

    @Override
    public Specifier getSpecifier() {
        return null;
    }

    @Override
    public <T> T accept(YtreeVisitor<T> visitor) {
        throw new NotImplementedException();
    }

    @Override
    public Origin origin() {
        return Origin.empty;
    }

    @Override
    public String toString() {
        return "mock_type";
    }

    @Override
    public boolean equals(Object obj) {
        return obj instanceof YMockType;
    }
}
