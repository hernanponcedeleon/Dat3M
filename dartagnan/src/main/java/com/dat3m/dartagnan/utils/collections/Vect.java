package com.dat3m.dartagnan.utils.collections;

import java.util.*;
import java.util.function.Predicate;
import java.util.function.UnaryOperator;
import java.util.stream.Stream;


// This is essentially an array with more functionality.
// It is similar to an ArrayList but without automatic resizing and
// it allows more fine-grained control over all operations.
// Most operations come in 2 variants, standard and unsafe
// Unsafe operations generally do not perform index out of range or capacity checks

public final class Vect<T> extends AbstractList<T> {
    
	private T[] array;
    private int numElements;

    private Vect(T[] array, int numElements) {
        this.array = array;
        this.numElements = numElements;
    }

    public Vect(Collection<T> c) {
        this((T[])c.toArray(), c.size());
    }

    public Vect(int capacity) {
        this((T[])new Object[capacity], 0);
    }

    public int getTotalCapacity() {
        return array.length;
    }

    public int getRemainingCapacity() {
        return array.length - numElements;
    }

    @Override
    public int size() {
        return numElements;
    }

    public boolean isEmpty() {
        return numElements == 0;
    }

    public boolean isFull() {
        return numElements == array.length;
    }

    public T getFirstUnsafe() {
        return array[0];
    }

    public T getFirst() {
        checkGetRange(0);
        return getFirstUnsafe();
    }

    public T getLast() {
        return array[numElements - 1];
    }

    public T getUnsafe(int index) {
        return array[index];
    }

    public T get(int index) {
        checkGetRange(index);
        return array[index];
    }

    public T setUnsafe(int index, T value) {
        T old = array[index];
        array[index] = value;
        return old;
    }

    public T set(int index, T value) {
        checkSetRange(index);
        return setUnsafe(index, value);
    }

    @Override
    public void sort(Comparator<? super T> cmp) {
        sort(0, numElements, cmp);
    }

    public void sort(int from, int to, Comparator<? super T> cmp) {
        if (from < 0)
            from = 0;
        if (to > numElements)
            to = numElements;
        Arrays.sort(array, from, to, cmp);
    }

    public int sortUnique(Comparator<? super T> cmp) {
        return sortUnique(0, numElements, cmp);
    }

    public int sortUnique(int from, int to, Comparator<? super T> cmp) {
        if (from < 0)
            from = 0;
        if (to > numElements)
            to = numElements;
        sort(from, to, cmp);
        return removeDuplicatesSorted(from, to, cmp);
    }

    public int removeDuplicatesSorted(Comparator<? super T> cmp) {
        return removeDuplicatesSorted(0, numElements, cmp);
    }

    public int removeDuplicatesSorted(int from, int to, Comparator<? super T> cmp) {
        if (from < 0)
            from = 0;
        if (to > numElements)
            to = numElements;

        int j = from + 1;
        int numRemoved = 0;
        while (j + numRemoved < to) {
            swapUnsafe(j, j + numRemoved);
            int cmpRes = cmp.compare(array[from], array[j]);
            if (cmpRes == 0) {
                numRemoved++;
                array[j] = null;
            }
            else if (cmpRes < 0) {
                from = j++;
            } else {
                throw new IllegalStateException("The vector was not correctly sorted.");
            }
        }
        numElements -= numRemoved;
        shiftToFront(to, numRemoved);
        return numRemoved;
    }

    public void insertUnsafe(T value, int index) {
        shiftToBack(index, 1);
        array[index] = value;
        numElements++;
    }

    public void insert(T value, int index) {
        checkInsertRange(index);
        insertUnsafe(value, index);
    }

    public void swapInsertUnsafe(T value, int index) {
        array[numElements++] = array[index];
        array[index] = value;
    }

    public void swapInsert(T value, int index) {
        checkInsertRange(index);
        swapInsertUnsafe(value, index);
    }

    public int insertSortedUnsafe(T value) {
        int index = binarySearch(value);
        if (index < 0)
            index = ~index;
        insertUnsafe(value, index);
        return index;
    }

    public int insertSortedUnsafe(T value, Comparator<? super T> cmp) {
        int index = binarySearch(value, cmp);
        if (index < 0)
            index = ~index;
        insertUnsafe(value, index);
        return index;
    }

    public int insertSorted(T value) {
        checkCapacity(1);
        return insertSortedUnsafe(value);
    }

    public int insertSorted(T value, Comparator<? super T> cmp) {
        checkCapacity(1);
        return insertSortedUnsafe(value, cmp);
    }

    public T removeUnsafe(int index) {
        T old = array[index];
        if (index == numElements - 1)
            array[--numElements] = null;
        else {
            shiftToFront(index + 1, 1);
            numElements--;
        }
        return old;
    }

    public T remove(int index) {
        checkGetRange(index);
        return removeUnsafe(index);
    }

    public T swapRemoveUnsafe(int index) {
        T old = array[index];
        array[index] = array[--numElements];
        return old;
    }

    public T removeAndSwap(int index) {
        checkGetRange(index);
        return swapRemoveUnsafe(index);
    }

    public void removeBulkUnsafe(int index, int len) {
        if (len <= 0)
            return;
        else if (index + len >= numElements)
            deleteFromUnsafe(index);
        else {
            shiftToFront(index + len, len);
            numElements -= len;
        }
    }

    public int insertSortedUniqueUnsafe(T value, Comparator<? super T> cmp) {
        int index = binarySearch(value,0, numElements, cmp);
        boolean unique = index < 0;
        if (unique) {
            insertUnsafe(value, ~index);
        }
        return index;
    }

    public int insertSortedUnique(T value, Comparator<? super T> cmp) {
        checkCapacity(1);
        return insertSortedUniqueUnsafe(value, cmp);
    }

    public void insertBulkUnsafe(Collection<? extends T> c, int index) {
        int size = c.size();
        shiftToBack(index, size);
        for (T e : c)
            array[index++] = e;
        numElements += size;
    }

    public void insertBulk(Collection<? extends T> c, int index) {
        checkGetRange(index);
        checkCapacity(c.size());
        insertBulkUnsafe(c, index);
    }

    public void appendUnsafe(T value) {
        array[numElements++] = value;
    }

    public void append(T value) {
        checkCapacity(1);
        appendUnsafe(value);
    }

    public void mergeUnsafe(Vect<T> other, Comparator<? super T> cmp) {
        if (other.isEmpty())
            return;
        // temporary implementation
        this.addAll(other);
        sort(cmp);

        //TODO(TH): can we remove this?
        /*
        int i,j = 0;
        int start = binarySearch(other.getFirstUnsafe());
        int end = binarySearch(other.getLast());
        if (start < 0)
            start = ~start;
        if (end < 0)
            end = ~end;
        shiftToBack(start);
        */

    }

    /*public boolean appendAndCheckSortedUnsafe(T value, Comparator<? super T> cmp) {
        array[numElements++] = value;
        return numElements <= 1 || cmp.compare(array[numElements - 2], value) <= 0;
    }*/

    /*public boolean appendAndCheckSorted(T value, Comparator<? super T> cmp) {
        checkInsertRange(numElements);
        return appendAndCheckSortedUnsafe(value, cmp);
    }*/

    public int binarySearch(T value) {
        return binarySearch(value, 0, numElements);
    }

    public int binarySearch(T value, Comparator<? super T> cmp) {
        return binarySearch(value, 0, numElements, cmp);
    }

    public int binarySearch(T value, int from, int to) {
        if (to > numElements)
            to = numElements;
        if (from < 0)
            from = 0;
        return Arrays.binarySearch(array, from, to, value);
    }

    public int binarySearch(T value, int from, int to, Comparator<? super T> cmp) {
        if (to > numElements)
            to = numElements;
        if (from < 0)
            from = 0;
        return Arrays.binarySearch(array, from, to, value, cmp);
    }

    public int linearSearch(T value) {
        return linearSearch(value, 0, numElements);
    }

    public int linearSearch(T value, int start, int end) {
        if (end > numElements)
            end = numElements;
        for (int i = start; i < end; i++) {
            if (value.equals(array[i]))
                return i;
        }
        return -1;
    }

    public int linearSearchBackwards(T value) {
        return linearSearchBackwards(value, 0, numElements);
    }

    public int linearSearchBackwards(T value, int start, int end) {
        if (end > numElements)
            end = numElements;
        for (int i = end - 1; i >= start; i--) {
            if (value.equals(array[i]))
                return i;
        }
        return -1;
    }

    public int linearSearch(T value, Comparator<? super T> equalityComparator) {
        return linearSearch(value, 0, numElements, equalityComparator);
    }

    public int linearSearch(T value, int from, int to, Comparator<? super T> equalityComparator) {
        if (to > numElements)
            to = numElements;
        for (int i = from; i < to; i++) {
            if (equalityComparator.compare(array[i], value) == 0)
                return i;
        }
        return -1;
    }

    public void enlargeBy(int extraSize) {
        resize(numElements + extraSize);
    }

    public void ensureCapacity(int capacity) {
        ensureCapacity(capacity, 3); // Resizes to allow 3 more elements by default
    }

    public void ensureCapacity(int capacity, int extraBufferSize) {
        int neededSpace = capacity - (array.length - numElements);
        if (neededSpace > 0) {
            resize(array.length + neededSpace + extraBufferSize);
        }
    }

    public void ensureTotalCapacity(int maxCapacity) {
        if (maxCapacity > array.length)
            resize(maxCapacity);
    }

    public void trimToCapacity() {
        resize(numElements);
    }

    public boolean removeIf(int from, Predicate<? super T> filter) {
        return removeIf(from, numElements, filter);
    }

    public boolean removeIf(int from, int to, Predicate<? super T> filter) {
        if (to > numElements)
            to = numElements;

        int j = from;
        int numRemoved = 0;
        while (j + numRemoved < to) {
            swapUnsafe(j, j + numRemoved);
            if (filter.test(array[j])) {
                numRemoved++;
                array[j] = null;
            }
            else
                j++;
        }
        numElements -= numRemoved;
        shiftToFront(to, numRemoved);
        return numRemoved > 0;

    }

    public void deleteFromUnsafe(int indexInclusive) {
        numElements = indexInclusive;
    }

    public void deleteFrom(int indexInclusive) {
        checkGetRange(indexInclusive);
        deleteFromUnsafe(indexInclusive);
    }

    public void deleteFromAndClearUnsafe(int indexInclusive) {
        deleteFromUnsafe(indexInclusive);
        while(indexInclusive < array.length)
            array[indexInclusive++] = null;
    }

    public void deleteFromAndClear(int indexInclusive) {
        checkGetRange(indexInclusive);
        deleteFromAndClearUnsafe(indexInclusive);
    }

    public void swapUnsafe(int i, int j) {
        T temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }

    public void swap(int i, int j) {
        checkGetRange(i);
        checkGetRange(j);
        swapUnsafe(i, j);
    }

    // =========== Internal operations ===========

    // For small arrays (< 20 elements), a manual for loop could be better
    protected final void shiftToBack(int from, int steps) {
        if (numElements > from)
            System.arraycopy(array, from, array, from + steps, numElements - from);
    }

    protected final void shiftToFront(int from, int steps) {
        if (numElements > from)
            System.arraycopy(array, from, array, from - steps, numElements - from);
    }

    protected final void resize(int newSize) {
        array = Arrays.copyOf(array, newSize);
    }

    protected final void checkGetRange(int i) {
        if (i < 0 || i >= numElements)
            throw new ArrayIndexOutOfBoundsException(i);
    }

    protected final void checkSetRange(int i) {
        if (i < 0 || i >= numElements)
            throw new ArrayIndexOutOfBoundsException(i);
    }

    protected final void checkInsertRange(int i) {
        checkCapacity(1);
        checkSetRange(i);
    }

    protected final void checkCapacity(int needed) {
        if (array.length - numElements < needed)
            throw new IllegalStateException("Not enough capacity");
    }

    protected final boolean containsAllSortedWithDuplicates(Vect<? extends T> other, Comparator<? super T> cmp) {
        if (other.numElements > this.numElements)
            return false;
        int i = 0;
        int j = 0;
        while (i < other.numElements && j < numElements) {
                int cmpRes = cmp.compare(other.array[i], array[j++]);
                if (cmpRes > 0)
                    return false;
                else if (cmpRes == 0)
                    i++;
        }
        return true;
    }

    protected final boolean containsAllBinary(Collection<? extends T> c) {
        for(T e : c) {
            if(binarySearch(e) < 0)
                return false;
        }
        return true;
    }

    protected final boolean containsAllLinear(Collection<? extends T> c) {
        for(T e : c) {
            if(linearSearch(e) < 0)
                return false;
        }
        return true;
    }

    // =========== Interface implementations ===========


    @Override
    public Vect<T> clone() {
        return new Vect<>(array.clone(), numElements);
    }

    @Override
    public Iterator<T> iterator() {
        return listIterator();
    }

    @Override
    public Stream<T> stream() {
        return Arrays.stream(array, 0, size());
    }

    @Override
    public boolean contains(Object o) {
        return linearSearch((T)o) >= 0;
    }

    @Override
    public Object[] toArray() {
        return Arrays.copyOf(array, numElements);
    }

    @Override
    public <T1> T1[] toArray(T1[] a) {
        if (a.length < numElements)
            return (T1[])Arrays.copyOf(array, numElements, a.getClass());

        System.arraycopy(array, 0, a, 0, numElements);
        if (a.length > numElements)
            a[numElements] = null;
        return a;
    }

    @Override
    public void add(int index, T element) {
        insert(element, index);
    }

    @Override
    public int indexOf(Object o) {
        return linearSearch((T)o);
    }

    @Override
    public int lastIndexOf(Object o) {
        return linearSearchBackwards((T)o);
    }

    @Override
    public boolean add(T t) {
        append(t);
        return true;
    }

    @Override
    public boolean remove(Object o) {
        int index = indexOf(o);
        if(index < 0)
            return false;
        removeUnsafe(index);
        return true;
    }

    @Override
    public boolean removeIf(Predicate<? super T> filter) {
        return removeIf(0, numElements, filter);
    }

    @Override
    public boolean containsAll(Collection<?> c) {
        return containsAllLinear((Collection<T>) c);
    }

    // Todo

    @Override
    public boolean addAll(Collection<? extends T> c) {
        checkCapacity(c.size());
        for (T e : c)
            appendUnsafe(e);
        return true;
    }

    @Override
    public boolean addAll(int index, Collection<? extends T> c) {
        insertBulk(c, index);
        return true;
    }

    @Override
    public boolean removeAll(Collection<?> c) {
        boolean res = false;
        for (T e : (Collection<T>)c)
            res |= remove(e);
        return res;
    }

    @Override
    public boolean retainAll(Collection<?> c) {
        throw new UnsupportedOperationException();
    }

    @Override
    public void replaceAll(UnaryOperator<T> operator) {
        for (int i = 0; i < numElements; i++)
            array[i] = operator.apply(array[i]);
    }

    @Override
    public void clear() {
        deleteFromAndClearUnsafe(0);
    }

    public ListIterator<T> listIterator() {
        return new VectIterator();
    }

    @Override
    public ListIterator<T> listIterator(int index) {
        return new VectIterator(index);
    }

    @Override
    public List<T> subList(int fromIndex, int toIndex) {
        return super.subList(fromIndex, toIndex);
    }

    protected class VectIterator implements ListIterator<T> {
        private int index;

        public VectIterator(int index) {
            this.index = index;
        }

        public VectIterator() {
            this(0);
        }

        @Override
        public boolean hasNext() {
            return index < numElements;
        }

        @Override
        public T next() {
            return array[index++];
        }

        @Override
        public boolean hasPrevious() {
            return index > 0;
        }

        @Override
        public T previous() {
            return array[--index];
        }

        @Override
        public int nextIndex() {
            return index;
        }

        @Override
        public int previousIndex() {
            return index-1;
        }

        @Override
        public void remove() {
           Vect.this.remove(--index);
        }

        @Override
        public void set(T t) {
            Vect.this.set(index - 1, t);
        }

        @Override
        public void add(T t) {
            insert(t, index++);
        }
    }
}
