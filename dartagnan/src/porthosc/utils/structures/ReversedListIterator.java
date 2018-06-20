package porthosc.utils.structures;//package porthosc.utils.structures;
//
//import java.util.Iterator;
//import java.util.List;
//
//
//public class ReversedListIterator<T> implements Iterator<T> {
//
//    private int currentIndex;
//    private final List<T> values;
//
//    public ReversedListIterator(List<T> values) {
//        this.values = values;
//        this.currentIndex = this.values.size() - 1;
//    }
//
//    @Override
//    public boolean hasNext() {
//        return currentIndex >= 0;
//    }
//
//    @Override
//    public T next() {
//        return values.get(currentIndex--);
//    }
//}