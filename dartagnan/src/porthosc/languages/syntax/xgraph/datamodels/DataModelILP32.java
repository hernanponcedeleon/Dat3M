package porthosc.languages.syntax.xgraph.datamodels;

// used in 32-bit UNIX
public class DataModelILP32 extends DataModel {

    @Override
    protected int getIntSize() {
        return 32;
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
