package com.dat3m.dartagnan.program.analysis.alias;

import com.google.common.math.IntMath;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

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
    boolean overlaps(Modifier left, Modifier right);

    /// Checks if for all integers `x` and `y`, `x[smaller]y` must imply `x[larger]y`.
    /// This method must not have false positives, but is allowed to have false negatives.
    boolean includes(Modifier larger, Modifier smaller);

    /// Estimates the *complexity* of `modifier`.
    /// For each `l`, there should only exist finitely many `m` with `level(m) <= l`.
    /// Ideally, `includes(larger,smaller)` implies `level(larger) < level(smaller)`.
    /// <p>
    /// Undetected cycles in the dynamic inclusion graph produce address sets of increasing `level`.
    /// This may cause the analysis to never terminate.
    /// A dynamic cycle detection mechanism triggers when values propagate between temporarily-equal address sets.
    /// The analysis prioritises low-`level` values to guarantee that this happens eventually for each cycle.
    /// @return Non-negative value, zero for `relaxedModifier()`.
    int level(Modifier modifier);

    /// Describes a relation including `{ (x,y) | x + offset == y }`.
    Modifier constantModifier(int offset);

    /// Describes a relation including `{ (x,y) | exists z. x + alignment * z == y }`.
    Modifier relaxedModifier(int alignment);

    /// Describes a relation including `{ (x,z) | exists y. x[first]y && y[second]z }`.
    Modifier compose(Modifier first, Modifier second);

    /// Describes the transitive closure of `modifier`,
    /// i.e. `{ (x,y_n) | exists n,y_1...y_n. x[modifier]y_1 ... [modifier]y_n }`.
    Modifier accelerate(Modifier modifier);

    /// Intersects `[modifier]` with `{ (x,y) | x <= y < x + objectSize }`.
    /// If this intersection is empty, the associated access must be out-of-bounds.
    /// <p>
    /// This is an unsound strengthening that assumes no out-of-bounds accesses, given a memory object of known size.
    Modifier postProcess(Modifier modifier, int objectSize);

    /// Used to perform field-insensitive alias analysis.
    final class VoidTrait implements ModifierTrait<Void> {
        @Override public boolean isFunctional(Void modifier) { return false; }
        @Override public boolean isIdentity(Void modifier) { return false; }
        @Override public boolean overlaps(Void left, Void right) { return true; }
        @Override public boolean includes(Void larger, Void smaller) { return true; }
        @Override public int level(Void modifier) { return 0; }
        @Override public Void constantModifier(int offset) { return null; }
        @Override public Void relaxedModifier(int alignment) { return null; }
        @Override public Void compose(Void l, Void r) { return null; }
        @Override public Void accelerate(Void m) { return null; }
        @Override public Void postProcess(Void m, int s) { return null; }
    }

    /// Enables field-sensitive alias analysis based on finite sets.
    /// Each non-null integer `i` describes the relation `[i]` as `{ (x,y) | x + i == y }`.
    final class Offsets implements ModifierTrait<Integer> {
        @Override public boolean isFunctional(Integer v) { return v != null; }
        @Override public boolean isIdentity(Integer v) { return v != null && v == 0; }
        @Override public boolean overlaps(Integer l, Integer r) { return l == null || r == null || l.equals(r); }
        @Override public boolean includes(Integer larger, Integer smaller) { return larger == null || larger.equals(smaller); }
        @Override public int level(Integer v) { return v == null ? 0 : Math.abs(v); }
        @Override public Integer constantModifier(int offset) { return offset; }
        @Override public Integer relaxedModifier(int alignment) { return null; }
        @Override public Integer compose(Integer l, Integer r) { return l == null || r == null ? null : r + l; }
        @Override public Integer accelerate(Integer v) { return isIdentity(v) ? v : null; }
        @Override public Integer postProcess(Integer v, int s) { return v; }
    }

    /// Describes `{ (x,y) | exists z: y = x + offset + z * alignment }`.
    record Sd(int offset, int alignment) {}

    /// Enables field-sensitive alias analysis based on unions of one-dimensional linear sets.
    /// This is more precise than {@link Offsets} in presence of dynamic indexing into arrays.
    final class SdLinear implements ModifierTrait<Sd> {
        @Override public boolean isFunctional(Sd m) { return m.alignment == 0; }
        @Override public boolean isIdentity(Sd m) { return m.offset == 0 && m.alignment == 0; }
        @Override
        public boolean overlaps(Sd left, Sd right) {
            // Exists non-negative integers x, y with l.offset + x * l.alignment == r.offset + y * r.alignment
            final int offset = right.offset - left.offset;
            final int l = left.alignment;
            final int r = right.alignment;
            final int divisor = l == 0 ? r : r == 0 ? l : IntMath.gcd(l, r);
            return divisor == 0 ? offset == 0 : offset % divisor == 0;
        }
        @Override
        public boolean includes(Sd left, Sd right) {
            int offset = right.offset - left.offset;
            if (left.alignment == 0) {
                return right.alignment == 0 && offset == 0;
            }
            // Case of unbounded dynamic indexes.
            int l = left.alignment;
            int r = right.alignment;
            return offset % l == 0 && r % l == 0;
        }
        @Override public int level(Sd m) { return Math.abs(m.offset); }
        @Override public Sd constantModifier(int offset) { return new Sd(offset, 0); }
        @Override public Sd relaxedModifier(int alignment) { return new Sd(0, Math.abs(alignment)); }
        @Override
        public Sd compose(Sd left, Sd right) {
            return new Sd(left.offset + right.offset, IntMath.gcd(left.alignment, right.alignment));
        }
        @Override
        public Sd accelerate(Sd m) {
            return m.offset == 0 ? m : new Sd(0, IntMath.gcd(Math.abs(m.offset), m.alignment));
        }
        @Override
        public Sd postProcess(Sd m, int objectSize) {
            return m.alignment < objectSize ? m : constantModifier(m.offset);
        }
    }

    record Md(int offset, List<Integer> alignment) {}

    /// Enables field-sensitive alias analysis based on multidimensional linear sets.
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
        public boolean overlaps(Md left, Md right) {
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
        public boolean includes(Md left, Md right) {
            int offset = right.offset - left.offset;
            if (left.alignment.isEmpty()) {
                return right.alignment.isEmpty() && offset == 0;
            }
            // Case of unbounded dynamic indexes.
            int leftAlignment = singleAlignment(left.alignment);
            int rightAlignment = singleAlignment(right.alignment);
            if (leftAlignment < 0 || rightAlignment < 0) {
                int l = leftAlignment < 0 ? -leftAlignment : reduceGCD(left.alignment);
                int r = rightAlignment < 0 ? -rightAlignment : reduceGCD(right.alignment);
                return offset % l == 0 && r % l == 0;
            }
            // Case of a single non-negative dynamic index.
            if (left.alignment.size() == 1) {
                for (final Integer a : right.alignment) {
                    if (a % leftAlignment != 0) {
                        return false;
                    }
                }
                return offset % leftAlignment == 0 && offset >= 0;
            }
            // Case of multiple dynamic indexes with pairwise indivisible alignments.
            final int gcd = IntMath.gcd(reduceGCD(right.alignment), Math.abs(offset));
            if (gcd == 0) {
                return true;
            }
            int max = Math.abs(offset);
            for (final Integer i : right.alignment) {
                max = Math.max(max, i);
            }
            final var mem = new boolean[max / gcd + 1];
            mem[0] = true;
            for (int j = 1; j < mem.length; j++) {
                for (final Integer i : left.alignment) {
                    if (j - i/gcd >= 0 && mem[j - i/gcd]) {
                        mem[j] = true;
                        break;
                    }
                }
            }
            for (final Integer j : right.alignment) {
                if (!mem[j/gcd]) {
                    return false;
                }
            }
            return mem[Math.abs(offset)/gcd];
        }
        @Override
        public int level(Md m) {
            return Math.abs(m.offset);
        }
        @Override
        public Md constantModifier(int offset) {
            return new Md(offset, List.of());
        }
        @Override
        public Md relaxedModifier(int alignment) {
            return new Md(0, alignment == 0 ? List.of() : List.of(-Math.abs(alignment)));
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
        public Md postProcess(Md modifier, int objectSize) {
            final int remainingSize = objectSize - modifier.offset;
            for (final Integer a : modifier.alignment) {
                if (a < remainingSize) {
                    return modifier;
                }
            }
            return constantModifier(modifier.offset);
        }
        private static int singleAlignment(List<Integer> alignment) {
            return alignment.size() != 1 ? 0 : alignment.get(0);
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
        private static void sort(List<Integer> alignment) {
            if (alignment.size() > 1) {
                Collections.sort(alignment);
            }
        }
        // Checks if value is no multiple of any element in the list.
        private static boolean hasNoDivisorsInList(int value, List<Integer> candidates, boolean strict) {
            for (final Integer candidate : candidates) {
                if ((strict || value < candidate) && value % candidate == 0) {
                    return false;
                }
            }
            return true;
        }
        private List<Integer> compose(List<Integer> left, List<Integer> right) {
            if (left.isEmpty() || right.isEmpty() || (left.size() == 1 && left.equals(right))) {
                return right.isEmpty() ? left : right;
            }
            // Negative values are unrestricted and compose always.
            // Therefore, each list shall either contain a single negative value, or only positive values.
            int leftAlignment = singleAlignment(left);
            int rightAlignment = singleAlignment(right);
            if (leftAlignment < 0 || rightAlignment < 0) {
                int alignment = leftAlignment < 0 ? -leftAlignment : -rightAlignment;
                for (Integer other : leftAlignment < 0 ? right : left) {
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
            sort(result);
            return result;
        }
    }

}
