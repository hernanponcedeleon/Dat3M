package com.dat3m.dartagnan.analysis.graphRefinement.logic;

import java.util.*;
import java.util.function.Predicate;
import java.util.stream.Collectors;

// A formal minimal conjunction of ground literals of type T
// The class is immutable
// The ordering is based on set inclusion. TRUE is least element, FALSE is largest element
public class Conjunction<T extends Literal<T>> implements PartialOrder<Conjunction<T>>
{
    public static final Conjunction TRUE;
    public static final Conjunction FALSE;

    static {
        TRUE = new Conjunction(new HashSet());
        FALSE = new Conjunction(new HashSet());
        FALSE.unsat = true;
    }

    // Using an ordered list for the literals is better!
    private final Set<T> literals;
    private Boolean unsat = false;
    private int hashCode;

    // The returned Set should not be modified!
    public Set<T> getLiterals() {
        return Collections.unmodifiableSet(literals);
    }

    public boolean isTrue() {
        return !unsat && literals.isEmpty();
    }

    public boolean isFalse() {
        return unsat;
    }

    public int getSize() {
        return literals.size();
    }

    public Conjunction(T literal) {
        literals = Collections.singleton(literal);
        computeHash();
    }

    public Conjunction(T ...literals) {
        this(Arrays.asList(literals));
    }

    public Conjunction(Collection<T> literals) {
        this.literals = new HashSet<>(literals.size());
        this.literals.addAll(literals);
        reduce();
        computeHash();
    }

    protected Conjunction(HashSet<T> literals, boolean reduce) {
        this.literals = literals;
        if (reduce)
            reduce();
        computeHash();
    }

    protected void reduce() {
        for (T literal : literals)
            if (literal.hasOpposite() && literals.contains(literal.getOpposite())) {
                unsat = true;
                literals.clear();
                break;
            }
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null || !(obj.getClass() == this.getClass()))
            return false;

        Conjunction<T> other = (Conjunction<T>)obj;
        if (this.hashCode != other.hashCode)
            return false;

        if (this.literals.size() != other.literals.size())
            return false;
        if (literals.isEmpty())
            return unsat == other.unsat;
        return literals.containsAll(other.literals);
    }

    @Override
    public int hashCode() {
        return hashCode;
    }

    // This is performed once on construction
    private void computeHash() {
        hashCode = literals.hashCode(); // the default implementation amounts to the below code
        /*
        for (T literal : literals)
            hashCode += literal.hashCode();
         */
    }

    @Override
    public String toString() {
        StringBuilder builder = new StringBuilder().append('(');
        String separator = "";
        for (T literal : literals) {
            builder.append(separator);
            builder.append(literal.toString());
            separator = " & ";
        }
        return builder.append(')').toString();
    }

    public boolean isProperSubclauseOf(Conjunction<T> other) {
        if (this.literals.size() >= other.literals.size())
            return false;
        return other.literals.containsAll(this.literals);
    }

    @Override
    public OrderResult compareToPartial(Conjunction<T> other) {
        if (equals(other))
            return OrderResult.EQ;
        if (this.isFalse())
            return OrderResult.GT;
        if (other.isFalse())
            return OrderResult.LT;
        if (this.getSize() == other.getSize())
            return OrderResult.INCOMP;
        if (this.getSize() < other.getSize())
            return other.getLiterals().containsAll(this.getLiterals()) ? OrderResult.LT : OrderResult.INCOMP;

        return this.getLiterals().containsAll(other.getLiterals()) ? OrderResult.GT : OrderResult.INCOMP;
    }

    public Conjunction<T> and(Conjunction<T> other) {
        if (this.isFalse() || other.isFalse())
            return FALSE;
        if (this.isTrue())
            return other.isTrue() ? TRUE : other;
        if (other.isTrue())
            return this;
        if (this.canResolve(other))
            return FALSE;

        OrderResult cmp = this.compareToPartial(other);
        if (cmp == OrderResult.EQ || cmp == OrderResult.GT)
            return this;
        if (cmp == OrderResult.LT)
            return other;

        HashSet<T> result = new HashSet<>(this.getSize() + other.getSize());
        result.addAll(this.getLiterals());
        result.addAll(other.getLiterals());

        return new Conjunction<>(result, false);
    }

    // Note: returns null, if there is no resolvent
    public Conjunction<T> resolveOn(Conjunction<T> other, T literal) {
        if (!literal.hasOpposite())
            return FALSE; // Maybe throw argument exception?
        if (this.isFalse() || other.isFalse())
            return FALSE;

        T opposite = literal.getOpposite();
        if (literals.contains(literal) && other.literals.contains(opposite)
                || literals.contains(opposite) && other.literals.contains(literal)) {
            HashSet<T> result = new HashSet<>(literals);
            result.addAll(other.literals);
            result.remove(literal);
            result.remove(opposite);
            return new Conjunction<T>(result, true);
        }
        return FALSE;
    }

    public Conjunction<T> removeIf(Predicate<T> pred) {
        HashSet<T> result = new HashSet<>(this.getSize());
        for (T literal : literals) {
            if (!pred.test(literal))
                result.add(literal);
        }
        return new Conjunction<>(result, false);
    }

    public Conjunction<T> resolve(Conjunction<T> other) {
        if (this.isFalse() || other.isFalse())
            return FALSE;
        if (this.isTrue() || other.isTrue())
            return TRUE;
        if (this.equals(other))
            return this;

        Conjunction<T> a = this;
        Conjunction<T> b = other;
        if (a.getSize() > b.getSize()) {
            a = other;
            b = this;
        }

        for (T literal : a.getLiterals()) {
            if (literal.hasOpposite() && b.getLiterals().contains(literal.getOpposite()))
                return resolveOn(other, literal);
        }
        return FALSE;
    }

    public boolean canResolve(Conjunction<T> other) {
        Conjunction<T> a = this;
        Conjunction<T> b = other;
        if (a.getSize() > b.getSize()) {
            a = other;
            b = this;
        }

        for (T literal : a.getLiterals()) {
            if (literal.hasOpposite() && b.getLiterals().contains(literal.getOpposite()))
                return true;
        }
        return false;
    }

    public List<T> toList() {
       // return Arrays.asList((T[])literals.toArray());
        return new ArrayList<>(literals);
    }

    public int getResolutionComplexity() {
        return (int)literals.stream().filter(Literal::hasOpposite).count();
    }

    public Set<T> getResolvableLiterals() {
        return literals.stream().filter(Literal::hasOpposite).collect(Collectors.toSet());
    }

}
