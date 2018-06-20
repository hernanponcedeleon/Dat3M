package porthosc.languages.syntax.xgraph.datamodels;

// used in Most 64 bit Unix and Unix-like systems, e.g. Solaris, Linux, and Mac OS YIndexerExpression; z/OS
public class DataModelLP64 extends DataModel {
    @Override
    protected int getIntSize() {
        return 32;
    }

    @Override
    protected int getPointerSize() {
        return 64;
    }

    @Override
    protected int getLongSize() {
        return 64;
    }
}
