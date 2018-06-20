package porthosc.languages.syntax.ytree.temporaries;

import porthosc.languages.syntax.ytree.YEntity;
import porthosc.languages.syntax.ytree.visitors.YtreeVisitor;

import java.util.ArrayList;
import java.util.List;


public class YQueueFILOTemp<T extends YEntity>
        extends YQueueTemp<T> {

    private final ArrayList<T> filo;

    public YQueueFILOTemp() {
        this.filo = new ArrayList<>();
    }

    @Override
    public List<T> getValues() {
        return filo;
    }

    @Override
    public void add(T entity) {
        filo.add(entity);
    }

    @Override
    public String toString() {
        return "FILO: " + filo;
    }

    @Override
    public <S> S accept(YtreeVisitor<S> visitor) {
        throw new UnsupportedOperationException();
    }
}
