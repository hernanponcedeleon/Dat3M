package porthosc.languages.syntax.xgraph.datamodels;

// used in HAL Computer Systems port of Solaris to SPARC64
public class DataModelILP64 extends DataModel {
    @Override
    protected int getIntSize() {
        return 64;
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
