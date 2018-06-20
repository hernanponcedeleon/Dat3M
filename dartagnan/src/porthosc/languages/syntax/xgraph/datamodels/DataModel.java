package porthosc.languages.syntax.xgraph.datamodels;

// NOTE: NOT USED YET

/**
 * The data model, which specifies the sizes of primitive C data types.
 * See http://www.unix.org/whitepapers/64bit.html,
 * http://dewkumar.blogspot.fi/2012/03/cc-data-model-3264-bit.html
 */
public abstract class DataModel {

    ///** Returns the size of primitive returnType in bytes
    // */
    //public int getPrimitiveTypeSize(YType type) {
    //    switch (typeName) {
    //        case Void:
    //            return getPointerSize();
    //        case Char:
    //            return getCharSize();
    //        case Short:
    //            return getShortSize();
    //        case Int:
    //            return getIntSize();
    //        case Long:
    //            return getLongSize();
    //        case LongLong:
    //            return getLongLongSize();
    //        case Float:
    //        case Double:
    //        case LongDouble:
    //            throw new NotImplementedException();
    //        case Bool:
    //            return getBoolSize();
    //        default:
    //            throw new IllegalArgumentException(typeName.name());
    //    }
    //}

    protected abstract int getIntSize();
    protected abstract int getPointerSize();
    protected abstract int getLongSize();

    protected int getBoolSize() {
        return 1;
    }

    protected int getCharSize() {
        return 8;
    }

    protected int getShortSize() {
        return 16;
    }

    protected int getLongLongSize() {
        return 64;
    }
}
