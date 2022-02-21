package com.dat3m.dartagnan.utils.logic;

import com.google.common.collect.Iterables;

import java.util.*;

// A formal minimal(*) disjunction of conjunctions of type T
// The class is immutable
// The ordering is based on set inclusion. FALSE is the least element and TRUE is the largest element
// (*) the minimality is weak in the sense that only duplicates are avoided.
public class DNF<T extends Literal<T>> implements PartialOrder<DNF<T>> {

    private static final DNF FALSE;
    private static final DNF TRUE;

    static {
        FALSE = new DNF(Collections.EMPTY_SET);
        TRUE = new DNF(Conjunction.TRUE());
    }


    public static <V extends Literal<V>> DNF<V> TRUE() { return TRUE; }
    public static <V extends Literal<V>> DNF<V> FALSE() { return FALSE; }

    // Using a sorted list is better (e.g. sorted by size)
    private final Set<Conjunction<T>> reasons;
    private int hashCode;

    // This set should never be modified
    public Set<Conjunction<T>> getCubes() {
        return Collections.unmodifiableSet(reasons);
    }

    public int getNumberOfCubes() {
        return reasons.size();
    }

    public int getTotalSize() {
        return reasons.stream().mapToInt(Conjunction::getSize).sum();
    }

    public boolean isFalse() {
        return reasons.isEmpty();
    }

    // Note: This class does not reduce disjunctions of the form "p or not p" to true.
    public boolean isTriviallyTrue() {
        return this.equals(TRUE);
    }

    public DNF(T literal) {
        this(new Conjunction<>(literal));
    }

    public DNF(Conjunction<T> cube) {
        if (cube.isFalse() && FALSE != null) {
            this.reasons = FALSE.reasons;
            this.hashCode = FALSE.hashCode;
        } else if (cube.isTrue() && TRUE != null) {
            this.reasons = TRUE.reasons;
            this.hashCode = TRUE.hashCode;
        } else {
            reasons = Collections.singleton(cube);
            computeHash();
        }
    }

    public DNF(Collection<Conjunction<T>> reasons) {
        this(new HashSet<>(reasons), true);
    }

    public DNF(Conjunction<T>... reasons) {
        this(Arrays.asList(reasons));
    }

    protected DNF(Set<Conjunction<T>> reasons) {
        this(reasons, true);
    }

    protected DNF(Set<Conjunction<T>> reasons, boolean reduce) {
        this.reasons = reasons;
        if (reduce) {
            reduce();
        }
        computeHash();
    }

    // Keeps the DNF minimal (without self-subsumption or any other advanced techniques)
    private void reduce() {
        for (Iterator<Conjunction<T>> it = reasons.iterator(); it.hasNext(); ) {
            Conjunction<T> cube = it.next();
            if (cube.isFalse()) {
                it.remove();
                continue;
            } // We could also shortcut when finding a true cube

            boolean isDominated = false;
            for (Conjunction<T> cube2 : reasons) {
                if (cube.compareToPartial(cube2) == OrderResult.GT) {
                    isDominated = true;
                    break;
                }
            }
            if (isDominated) {
                it.remove();
            }
        }
    }

    @Override
    public int hashCode() {
        return hashCode;
    }

    private void computeHash() {
        hashCode = 1;
        for (Conjunction<T> cube : reasons) {
            int cubeHash = cube.hashCode();
            assert (!cube.isFalse());
            hashCode *= cubeHash; // Use * instead of + (important!)
        }
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        } else if (obj == null || obj.getClass() != DNF.class) {
            return false;
        }

        DNF<T> other = (DNF<T>) obj;

        if (this.hashCode != other.hashCode
                || this.getNumberOfCubes() != other.getNumberOfCubes()
                || this.getTotalSize() != other.getTotalSize()) {
            return false;
        }

        return this.reasons.containsAll(other.reasons);
    }

    @Override
    public OrderResult compareToPartial(DNF<T> other) {
        if (equals(other)) {
            return OrderResult.EQ;
        } else if (this.isFalse() || other.isTriviallyTrue()) {
            return OrderResult.LT;
        } else if (other.isFalse() || this.isTriviallyTrue()) {
            return OrderResult.GT;
        }

        boolean isLessThan = true;
        for (Conjunction<T> cube1 : this.reasons) {
            if (other.reasons.contains(cube1)) {
                continue;
            }
            boolean found = false;
            for (Conjunction<T> cube2 : other.reasons) {
                OrderResult cmp = cube1.compareToPartial(cube2);
                if (cmp == OrderResult.LT || cmp == OrderResult.EQ) {
                    found = true;
                    break;
                }
            }
            if (!found) {
                isLessThan = false;
                break;
            }
        }

        // We are returning here with the assumption that equality is not possible
        if (isLessThan) {
            return OrderResult.LT;
        }


        // Same code as above but with roles swapped
        boolean isGreaterThan = true;
        for (Conjunction<T> cube1 : other.reasons) {
            if (this.reasons.contains(cube1)) {
                continue;
            }
            boolean found = false;
            for (Conjunction<T> cube2 : this.reasons) {
                OrderResult cmp = cube1.compareToPartial(cube2);
                if (cmp == OrderResult.LT || cmp == OrderResult.EQ) {
                    found = true;
                    break;
                }
            }
            if (!found) {
                isGreaterThan = false;
                break;
            }
        }

        if (isGreaterThan) {
            return OrderResult.GT;
        }

        return OrderResult.INCOMP;
    }

    @Override
    public String toString() {
        return "{ " + String.join(" | ", Iterables.transform(reasons, Conjunction::toString)) + " }";
    }

    public DNF<T> remove(Collection<Conjunction<T>> reasons) {
        if (this.isTriviallyTrue() || this.isFalse()
                || this.reasons.stream().noneMatch(reasons::contains)) {
            return this;
        }

        Set<Conjunction<T>> result = new HashSet<>(this.reasons);
        result.removeAll(reasons);
        return new DNF<>(result, false);

    }


    public DNF<T> or(DNF<T> other) {
        if (this.isTriviallyTrue() || other.isTriviallyTrue()) {
            return TRUE();
        } else if (this.isFalse()) {
            return other.isFalse() ? FALSE() : other;
        } else if (other.isFalse()) {
            return this;
        }

        HashSet<Conjunction<T>> result = new HashSet<>(this.reasons);
        result.addAll(other.reasons);
        return new DNF<>(result);
    }

    public DNF<T> and(DNF<T> other) {
        if (this.isFalse() || other.isFalse()) {
            return FALSE();
        } else if (this.isTriviallyTrue()) {
            return other;
        } else if (other.isTriviallyTrue()) {
            return this;
        }

        HashSet<Conjunction<T>> result = new HashSet<>(this.getNumberOfCubes() * other.getNumberOfCubes());
        for (Conjunction<T> cube1 : this.reasons) {
            for (Conjunction<T> cube2 : other.reasons) {
                result.add(cube1.and(cube2));
            }
        }
        return new DNF<>(result);
    }
}
