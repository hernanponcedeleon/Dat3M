package porthosc.utils.structures;

import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;


public class ListWrapperBase<T> implements List<T> {

    final List<T> value;

    public ListWrapperBase(List<T> value) {
        this.value = value;
    }

    @Override
    public int size() {
        return value.size();
    }

    @Override
    public boolean isEmpty() {
        return value.isEmpty();
    }

    @Override
    public boolean contains(Object o) {
        return value.contains(o);
    }

    @Override
    public Iterator<T> iterator() {
        return value.iterator();
    }

    @Override
    public Object[] toArray() {
        return value.toArray();
    }

    @Override
    public <T1> T1[] toArray(T1[] a) {
        return value.toArray(a);
    }

    @Override
    public boolean add(T t) {
        return value.add(t);
    }

    @Override
    public boolean remove(Object o) {
        return value.remove(o);
    }

    @Override
    public boolean containsAll(Collection<?> c) {
        return value.containsAll(c);
    }

    @Override
    public boolean addAll(Collection<? extends T> c) {
        return value.addAll(c);
    }

    @Override
    public boolean addAll(int index, Collection<? extends T> c) {
        return value.addAll(index, c);
    }

    @Override
    public boolean removeAll(Collection<?> c) {
        return value.removeAll(c);
    }

    @Override
    public boolean retainAll(Collection<?> c) {
        return value.retainAll(c);
    }

    @Override
    public void clear() {
        value.clear();
    }

    @Override
    public T get(int index) {
        return value.get(index);
    }

    @Override
    public T set(int index, T element) {
        return value.set(index, element);
    }

    @Override
    public void add(int index, T element) {
        value.add(index, element);
    }

    @Override
    public T remove(int index) {
        return value.remove(index);
    }

    @Override
    public int indexOf(Object o) {
        return value.indexOf(o);
    }

    @Override
    public int lastIndexOf(Object o) {
        return value.lastIndexOf(o);
    }

    @Override
    public ListIterator<T> listIterator() {
        return value.listIterator();
    }

    @Override
    public ListIterator<T> listIterator(int index) {
        return value.listIterator(index);
    }

    @Override
    public List<T> subList(int fromIndex, int toIndex) {
        return value.subList(fromIndex, toIndex);
    }
}