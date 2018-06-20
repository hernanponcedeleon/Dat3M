package porthosc.utils.structures;


import java.util.Collections;
import java.util.List;


public abstract class ReversableList<T> extends ListWrapperBase<T> {

    ReversableList(List<T> value) {
        super(value);
    }

    private boolean reversed = false;

    public boolean reverseIfNotYet() {
        if (!reversed) {
            Collections.reverse(value);
            reversed = true;
            return true;
        }
        return false;
    }

    public boolean isReversed() {
        return reversed;
    }
}
