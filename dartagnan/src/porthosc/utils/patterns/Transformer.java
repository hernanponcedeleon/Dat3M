package porthosc.utils.patterns;

public interface Transformer<T> {
    T transform(T entity);
}
