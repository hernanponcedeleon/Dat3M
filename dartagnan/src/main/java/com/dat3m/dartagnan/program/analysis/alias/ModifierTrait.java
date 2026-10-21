package com.dat3m.dartagnan.program.analysis.alias;

import com.google.common.math.IntMath;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.PriorityQueue;

/// Describes the abstract domain used in an Andersen-style Pointer Analysis.
/// The expressiveness of the domain usually impacts both precision and computation time.
/// Instances `m` of `Modifier` describe binary relations `[m]` over (pointer-sized) integers.
/// When an *inclusion edge* between pointer sets `X` and `Y` is labelled with `m`,
/// the analysis models that `Y` includes `{ y | x in X, (x, y) in [m] }`.
public interface ModifierTrait <Modifier> {

    /// Checks if `x[modifier]y` and `x[modifier]z` implies `y == z` for all `x`, `y` and `z`.
    boolean isFunctional(Modifier modifier);

    /// Checks if `compose(m, modifier) == m` for all `m`.
    boolean isIdentity(Modifier modifier);

    /// Checks if there may be integers `x` and `y` with `x[left]y` and `x[right]y`.
    /// This method must not have false negatives, but is allowed to have false positives.
    boolean mayOverlap(Modifier left, Modifier right);

    /// Checks if for all integers `x` and `y`, `x[smaller]y` must imply `x[larger]y`.
    /// This method must not have false positives, but is allowed to have false negatives.
    boolean mustInclude(Modifier larger, Modifier smaller);

    /// Describes a relation including `{ (x,y) | x + offset == y }`.
    Modifier constantModifier(BigInteger offset);

    /// Describes a relation including `{ (x,y) | exists z. x + alignment * z == y }`.
    Modifier relaxedModifier(BigInteger alignment);

    /// Describes a relation including `{ (x,z) | exists y. x[first]y && y[second]z }`.
    Modifier compose(Modifier first, Modifier second);

    /// Describes the transitive closure of `modifier`,
    /// i.e. `{ (x,y_n) | exists n,y_1...y_n. x[modifier]y_1 ... [modifier]y_n }`.
    Modifier accelerate(Modifier modifier);

    /// Intersects `[modifier]` with `{ (x,y) | x <= y < x + objectSize }`.
    /// If this intersection is empty, the associated access must be out-of-bounds.
    /// <p>
    /// This is an unsound strengthening that assumes no out-of-bounds accesses, given a memory object of known size.
    Modifier shrinkToBounds(Modifier modifier, int objectSize);

    /// Used to perform field-insensitive alias analysis.
    final class VoidTrait implements ModifierTrait<Void> {
        @Override public boolean isFunctional(Void modifier) { return false; }
        @Override public boolean isIdentity(Void modifier) { return true; }
        @Override public boolean mayOverlap(Void left, Void right) { return true; }
        @Override public boolean mustInclude(Void larger, Void smaller) { return true; }
        @Override public Void constantModifier(BigInteger offset) { return null; }
        @Override public Void relaxedModifier(BigInteger alignment) { return null; }
        @Override public Void compose(Void l, Void r) { return null; }
        @Override public Void accelerate(Void m) { return null; }
        @Override public Void shrinkToBounds(Void m, int s) { return null; }
    }

    /// Enables field-sensitive alias analysis based on finite sets.
    /// Each non-null integer `i` describes the relation `[i]` as `{ (x,y) | x + i == y }`.
    final class Offsets implements ModifierTrait<BigInteger> {
        @Override public boolean isFunctional(BigInteger v) { return v != null; }
        @Override public boolean isIdentity(BigInteger v) { return BigInteger.ZERO.equals(v); }
        @Override public boolean mayOverlap(BigInteger l, BigInteger r) { return l == null || r == null || l.equals(r); }
        @Override public boolean mustInclude(BigInteger larger, BigInteger smaller) { return larger == null || larger.equals(smaller); }
        @Override public BigInteger constantModifier(BigInteger offset) { return offset; }
        @Override public BigInteger relaxedModifier(BigInteger alignment) { return null; }
        @Override public BigInteger compose(BigInteger l, BigInteger r) { return l == null || r == null ? null : r.add(l); }
        @Override public BigInteger accelerate(BigInteger v) { return isIdentity(v) ? v : null; }
        @Override public BigInteger shrinkToBounds(BigInteger v, int s) { return v; }
    }

    /// Describes `{ (x,y) | exists z: y = x + offset + z * alignment }`.
    record Sd(int offset, int alignment) {}

    /// Enables field-sensitive alias analysis based on unions of single-period linear sets.
    /// This is more precise than {@link Offsets} in presence of dynamic indexing into arrays.
    final class SdLinear implements ModifierTrait<Sd> {
        @Override public boolean isFunctional(Sd m) { return m.alignment == 0; }
        @Override public boolean isIdentity(Sd m) { return m.offset == 0 && m.alignment == 0; }
        @Override
        public boolean mayOverlap(Sd left, Sd right) {
            // Exists non-negative integers x, y with l.offset + x * l.alignment == r.offset + y * r.alignment
            final int offset = right.offset - left.offset;
            final int l = left.alignment;
            final int r = right.alignment;
            final int divisor = l == 0 ? r : r == 0 ? l : IntMath.gcd(l, r);
            return divisor == 0 ? offset == 0 : offset % divisor == 0;
        }
        @Override
        public boolean mustInclude(Sd left, Sd right) {
            int offset = right.offset - left.offset;
            if (left.alignment == 0) {
                return right.alignment == 0 && offset == 0;
            }
            // Case of unbounded dynamic indexes.
            int l = left.alignment;
            int r = right.alignment;
            return offset % l == 0 && r % l == 0;
        }
        @Override
        public Sd constantModifier(BigInteger offset) {
            try {
                return new Sd(offset.intValueExact(), 0);
            } catch (ArithmeticException x) {
                return new Sd(0, 1);
            }
        }
        @Override
        public Sd relaxedModifier(BigInteger alignment) {
            try {
                return new Sd(0, Math.abs(alignment.intValueExact()));
            } catch (ArithmeticException x) {
                return new Sd(0, 1);
            }
        }
        @Override
        public Sd compose(Sd left, Sd right) {
            return new Sd(left.offset + right.offset, IntMath.gcd(left.alignment, right.alignment));
        }
        @Override
        public Sd accelerate(Sd m) {
            return m.offset == 0 ? m : new Sd(0, IntMath.gcd(Math.abs(m.offset), m.alignment));
        }
        @Override
        public Sd shrinkToBounds(Sd m, int objectSize) {
            return m.alignment < objectSize || objectSize <= m.offset || m.offset < 0 ? m
                    : constantModifier(BigInteger.valueOf(m.offset));
        }
    }

    /// Instances describe linear sets. `offset` is the *base*, `alignment` are the *periods*.
    // If there is a lower bound, `alignment` contains only positive values.
    // If there is no lower bound, `alignment` contains exactly one negative value.
    record Md(int offset, List<Integer> alignment) {}

    /// Enables field-sensitive alias analysis based on linear sets.
    /// This might be slightly more precise than {@link SdLinear} in presence of aggregates containing arrays.
    final class MdLinear implements ModifierTrait<Md> {
        @Override
        public boolean isFunctional(Md m) {
            return m.alignment.isEmpty();
        }
        @Override
        public boolean isIdentity(Md m) {
            return m.offset == 0 && m.alignment.isEmpty();
        }
        @Override
        public boolean mayOverlap(Md left, Md right) {
            // Exists non-negative integers x, y with l.offset + x * l.alignment == r.offset + y * r.alignment
            final int offset = right.offset - left.offset;
            final int leftAlignment = singleAlignment(left.alignment);
            final int rightAlignment = singleAlignment(right.alignment);
            final int l = leftAlignment < 0 ? -leftAlignment : reduceGCD(left.alignment);
            final int r = rightAlignment < 0 ? -rightAlignment : reduceGCD(right.alignment);
            if (l == 0 && r == 0) {
                return offset == 0;
            }
            final int divisor = l == 0 ? r : r == 0 ? l : IntMath.gcd(l, r);
            final boolean leftDirectedTowardsRight = r != 0 || leftAlignment < 0 || offset >= 0;
            final boolean rightDirectedTowardsLeft = l != 0 || rightAlignment < 0 || offset <= 0;
            return leftDirectedTowardsRight && rightDirectedTowardsLeft && offset % divisor == 0;
        }
        @Override
        public boolean mustInclude(Md larger, Md smaller) {
            final int offset = smaller.offset - larger.offset;
            // Case where `larger` is functional.
            if (larger.alignment.isEmpty()) {
                return smaller.alignment.isEmpty() && offset == 0;
            }
            final int alignmentLarger = singleAlignment(larger.alignment);
            final int alignmentSmaller = singleAlignment(smaller.alignment);
            // Case where `larger` has no lower bound.
            // Removing any lower bound on `smaller` should have no effect on the return value.
            if (alignmentLarger < 0) {
                final int l = -alignmentLarger;
                final int r = alignmentSmaller < 0 ? -alignmentSmaller : reduceGCD(smaller.alignment);
                return offset % l == 0 && r % l == 0;
            }
            // From here on, `larger` has a lower bound.
            // Cases where `smaller` has no lower bound or starts lower than `larger`.
            if (alignmentSmaller < 0 || offset < 0) {
                return false;
            }
            // Sufficient condition: `offset` and all of `smaller.alignment` are contained.
            // This also covers `larger.equals(smaller)`.
            boolean b = false;
            for (int d : larger.alignment) {
                b |= (offset % d) == 0;
            }
            for (int a : smaller.alignment) {
                boolean c = false;
                for (int d : larger.alignment) {
                    c |= (a % d) == 0;
                }
                b &= c;
            }
            if (b) {
                return true;
            }
            // At this point, both `smaller` and `larger` describe numerical semigroups.
            final int gcd = reduceGCD(larger.alignment);
            assert gcd > 0;
            if (IntMath.gcd(offset, reduceGCD(smaller.alignment)) % gcd != 0) {
                // Here, `smaller` is "denser" than `larger`.
                return false;
            }
            final int remainders = larger.alignment.stream().mapToInt(i -> i).min().orElseThrow() / gcd;
            final int[] largerAperySet = aperySet(larger.alignment, gcd, remainders);
            final int[] smallerAperySet = aperySet(smaller.alignment, gcd, remainders);
            for (int remainder = 0; remainder < remainders; remainder++) {
                if (smallerAperySet[remainder] == -1) {
                    continue;
                }
                final int smallerValueUnchecked = smallerAperySet[remainder] + offset / gcd;
                // This addition may overflow.
                if (smallerValueUnchecked < 0 || smallerValueUnchecked == Integer.MAX_VALUE
                        || largerAperySet[smallerValueUnchecked % remainders] == Integer.MAX_VALUE
                        || smallerValueUnchecked < largerAperySet[smallerValueUnchecked % remainders]) {
                    return false;
                }
            }
            return true;
        }
        // For each remainder modulo `remainders`, return the smallest generatable.
        // `-1` means no value has this remainder.
        // `Integer.MAX_VALUE` means the smallest value is at least as high as the maximal value.
        private int[] aperySet(List<Integer> alignment, int divisor, int remainders) {
            final int[] aperySet = new int[remainders];
            aperySet[0] = 0;
            for (int i = 1; i < remainders; i++) {
                aperySet[i] = -1;
            }
            final var queue = new PriorityQueue<Integer>();
            queue.add(0);
            while (!queue.isEmpty()) {
                final int current = queue.remove();
                for (int a : alignment) {
                    final int generatedUnchecked = aperySet[current] + a / divisor;
                    final int generated = generatedUnchecked < 0 ? Integer.MAX_VALUE : generatedUnchecked;
                    final int remainder = generated % remainders;
                    if (aperySet[remainder] == -1 || generated < aperySet[remainder]) {
                        aperySet[remainder] = generated;
                        queue.add(remainder);
                    }
                }
            }
            return aperySet;
        }
        @Override
        public Md constantModifier(BigInteger offset) {
            try {
                return new Md(offset.intValueExact(), List.of());
            } catch (ArithmeticException x) {
                return new Md(0, List.of(-1));
            }
        }
        @Override
        public Md relaxedModifier(BigInteger alignment) {
            try {
                final int a = Math.abs(alignment.intValueExact());
                return new Md(0, a == 0 ? List.of() : List.of(-a));
            } catch (ArithmeticException x) {
                return new Md(0, List.of(-1));
            }
        }
        @Override
        public Md compose(Md left, Md right) {
            return new Md(left.offset + right.offset, compose(left.alignment, right.alignment));
        }
        @Override
        public Md accelerate(Md m) {
            return m.offset == 0 ? m : new Md(0, compose(List.of(m.offset), m.alignment));
        }
        @Override
        public Md shrinkToBounds(Md modifier, int objectSize) {
            final int remainingSize = objectSize - modifier.offset;
            for (final int a : modifier.alignment) {
                if (a > 0 ? a < remainingSize : -a < remainingSize || -a <= modifier.offset) {
                    return modifier;
                }
            }
            return constantModifier(BigInteger.valueOf(modifier.offset));
        }
        // Computes the greatest common divisor of the operands.
        private static int reduceGCD(List<Integer> alignment) {
            if (alignment.isEmpty()) {
                return 0;
            }
            int result = alignment.get(0);
            for (final Integer a : alignment.subList(1, alignment.size())) {
                result = IntMath.gcd(result, a);
            }
            return result;
        }
        private List<Integer> compose(List<Integer> left, List<Integer> right) {
            if (left.isEmpty() || right.isEmpty() || (left.size() == 1 && left.equals(right))) {
                return right.isEmpty() ? left : right;
            }
            // Negative values are unrestricted and compose always.
            // Therefore, each list shall either contain a single negative value, or only positive values.
            final int leftAlignment = singleAlignment(left);
            final int rightAlignment = singleAlignment(right);
            if (leftAlignment < 0 || rightAlignment < 0) {
                int alignment = leftAlignment < 0 ? -leftAlignment : -rightAlignment;
                for (final Integer other : leftAlignment < 0 ? right : left) {
                    alignment = IntMath.gcd(alignment, Math.abs(other));
                }
                return List.of(-alignment);
            }
            // Assert left and right each consist of pairwise indivisible positives
            final List<Integer> result = new ArrayList<>();
            for (final Integer i : left) {
                if (hasNoDivisorsInList(i, right, true)) {
                    result.add(i);
                }
            }
            for (final Integer j : right) {
                if (hasNoDivisorsInList(j, left, false)) {
                    result.add(j);
                }
            }
            if (result.size() > 1) {
                Collections.sort(result);
            }
            return result;
        }
        private static int singleAlignment(List<Integer> alignment) {
            return alignment.size() != 1 ? 0 : alignment.get(0);
        }
        // Checks if value is no multiple of any element in the list.
        private static boolean hasNoDivisorsInList(int value, List<Integer> candidates, boolean strict) {
            for (final int candidate : candidates) {
                if ((strict || value < candidate) && value % candidate == 0) {
                    return false;
                }
            }
            return true;
        }
    }

}
