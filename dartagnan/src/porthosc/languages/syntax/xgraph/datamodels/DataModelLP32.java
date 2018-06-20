package porthosc.languages.syntax.xgraph.datamodels;

// used in Win-16, Apple Macintosh
public class DataModelLP32 extends DataModel {

    @Override
    protected int getIntSize() {
        return 16;
    }

    @Override
    protected int getPointerSize() {
        return 32;
    }

    @Override
    protected int getLongSize() {
        return 32;
    }
}
