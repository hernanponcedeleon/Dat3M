package porthosc.utils.patterns;

import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import porthosc.utils.exceptions.BuilderException;

import java.util.List;


public abstract class BuilderBase<T> implements Builder<T> {

    private boolean isBuilt = false;

    public abstract T build();

    protected void markFinished() {
        isBuilt = true;
    }

    // TODO : check this method and re-implement other builders
    protected <S> void add(S element, List<S> collection) {
        throwIfAlreadyBuilt();
        collection.add(element);
    }

    // TODO : check this method and re-implement other builders
    protected <S> void add(S element, ImmutableList.Builder<S> collection) {
        throwIfAlreadyBuilt();
        collection.add(element);
    }

    protected <S, K> void put(S element1, K element2, ImmutableMap.Builder<S, K> collection) {
        throwIfAlreadyBuilt();
        collection.put(element1, element2);
    }

    protected <S> void addAll(Iterable<S> from, ImmutableList.Builder<S> to) {
        throwIfAlreadyBuilt();
        to.addAll(from);
    }

    protected void throwIfAlreadyBuilt() {
        if (isBuilt) {
            throw new BuilderException(getAlreadyFinishedMessage());
        }
    }

    private final String getAlreadyFinishedMessage() {
        return getClass().getName() + " has already finished.";
    }

    private final String getNotYetFinishedMessage() {
        return getClass().getName() + " is not yet finished.";
    }
}
