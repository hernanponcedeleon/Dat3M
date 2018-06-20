package porthosc.utils.structures;

import java.util.ArrayList;


public abstract class YReversableList<T> extends ReversableList<T> {

    protected YReversableList() {
        super(new ArrayList<>());
    }
}
