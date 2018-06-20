package porthosc.languages.syntax.ytree.types;/*
package porthosc.languages.syntax.ytree.types;

import porthosc.languages.syntax.ytree.YEntity;
import porthosc.languages.syntax.ytree.temporaries.YTempEntity;
import porthosc.languages.syntax.ytree.visitors.YtreeVisitor;
import porthosc.utils.StringUtils;
import porthosc.utils.exceptions.BuilderException;
import porthosc.utils.exceptions.NotSupportedException;
import porthosc.utils.patterns.Builder;

import java.util.Iterator;


public class YPrimitiveTypeBuilder extends Builder<YPrimitiveType> implements YTempEntity {

    private YPrimitiveType.Kind kind;
    private YPrimitiveType.Specifier specifier;
    private YTypeBase.Qualifier qualifier;
    private int pointerLevel;

    public YPrimitiveTypeBuilder() {
        specifier = YPrimitiveType.Specifier.Default;
        qualifier = YTypeBase.Qualifier.Default;
        pointerLevel = 0;
    }

    @Override
    public YPrimitiveType build() {
        if (kind ==  null) {
            throw new IllegalStateException(getClass().getSimpleName() + ": 'kind' has not been set yet");
        }
        return new YPrimitiveType(kind, specifier, qualifier, pointerLevel);
    }

    public boolean tryAddToken(String token) {
        return tryAddKind(token) || tryAddSpecifier(token) || tryAddQualifier(token);
    }

    private boolean tryAddKind(String token) {
        YPrimitiveType.Kind testKind = YPrimitiveType.Kind.tryParse(token);
        if (testKind != null) {
            if (kind == null) {
                kind = testKind;
                return true;
            }
            else {
                switch (kind) {
                    case Short:
                        if (testKind == YPrimitiveType.Kind.Int) {
                            return true;
                        }
                        break;
                    case Int:
                        if (testKind == YPrimitiveType.Kind.Short ||
                                testKind == YPrimitiveType.Kind.Long ||
                                testKind == YPrimitiveType.Kind.LongLong) {
                            kind = testKind;
                            return true;
                        }
                        break;
                    case Long:
                        if (testKind == YPrimitiveType.Kind.Long) {
                            kind = YPrimitiveType.Kind.LongLong;
                            return true;
                        }
                        break;
                    case Double:
                        if (testKind == YPrimitiveType.Kind.Long) {
                            kind = YPrimitiveType.Kind.LongDouble;
                            return true;
                        }
                        break;
                }
                throw new BuilderException("Cannot set 'kind' value " + StringUtils.wrap(token) +
                        ", already having value: " + StringUtils.wrap(kind.getText()));
            }
        }
        return false;
    }

    private boolean tryAddSpecifier(String token) {
        YPrimitiveType.Specifier testSpecifier = YPrimitiveType.Specifier.tryParse(token);
        if (testSpecifier != null) {
            if (specifier == null || specifier == YPrimitiveType.Specifier.Default) {
                specifier = testSpecifier;
                return true;
            }
            throw new BuilderException("Cannot set 'specifier' value " + StringUtils.wrap(token) +
                    ", already having value: " + StringUtils.wrap(specifier.getText()));
        }
        return false;
    }

    public boolean tryAddQualifier(String token) {
        YTypeBase.Qualifier testQualifier = YTypeBase.Qualifier.tryParse(token);
        if (testQualifier != null) {
            if (qualifier == null || qualifier == YTypeBase.Qualifier.Default) {
                qualifier = testQualifier;
                return true;
            }
            throw new BuilderException("Cannot set 'qualifier' value " + StringUtils.wrap(token) +
                    ", already having value: " + StringUtils.wrap(qualifier.getText()));
        }
        return false;
    }

    public void incrementPointerLevel() {
        pointerLevel++;
    }

    @Override
    public Iterator<? extends YEntity> getChildrenIterator() {
        throw new UnsupportedOperationException();
    }

    @Override
    public <T> T accept(YtreeVisitor<T> visitor) {
        throw new UnsupportedOperationException();
    }

    @Override
    public YEntity copy() {
        throw new UnsupportedOperationException();
    }

}
*/