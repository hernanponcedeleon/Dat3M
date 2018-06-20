package porthosc.languages.syntax.xgraph.datamodels;

// used in Microsoft Windows (X64/IA-64)
public class DataModelLLP64 extends DataModel {
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
        return 32;
    }
}
