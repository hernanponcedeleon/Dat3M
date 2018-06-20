package porthosc.languages.syntax.ytree.temporaries;

import porthosc.languages.syntax.ytree.YEntity;
import porthosc.languages.syntax.ytree.visitors.YtreeVisitor;

import java.util.LinkedList;
import java.util.List;


public class YQueueFIFOTemp<T extends YEntity>
        extends YQueueTemp<T> {

    private final LinkedList<T> fifo;

    public YQueueFIFOTemp() {
        this.fifo = new LinkedList<>();
    }

    @Override
    public List<T> getValues() {
        return fifo;
    }

    @Override
    public void add(T entity) {
        fifo.addFirst(entity);
    }

    @Override
    public String toString() {
        return "FIFO: " + fifo;
    }

    @Override
    public <S> S accept(YtreeVisitor<S> visitor) {
        throw new UnsupportedOperationException();
    }
}
