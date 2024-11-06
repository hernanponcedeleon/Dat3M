package com.dat3m.dartagnan.program.analysis.alias;

import com.dat3m.dartagnan.expression.Expression;
import com.google.common.math.IntMath;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

public sealed interface ModifierType <T> {

    boolean isConstant(T modifier);

    boolean isTrivial(T modifier);

    boolean overlaps(T left, T right);

    boolean includes(T larger, T smaller);

    int offset(T modifier);

    T top();

    T constant(int value);

    T compose(T left, T right);

    T accelerate(T modifier);

    T fromExpression(int offset, Map<Expression, Integer> expression, Expression key);

    default T trivial() {
        return constant(0);
    }

    final class FieldInsensitive implements ModifierType<Void> {
        @Override
        public boolean isConstant(Void modifier) { return false; }
        @Override
        public boolean isTrivial(Void modifier) { return false; }
        @Override
        public boolean overlaps(Void larger, Void smaller) { return true; }
        @Override
        public boolean includes(Void larger, Void smaller) { return true; }
        @Override
        public int offset(Void modifier) { return 0; }
        @Override
        public Void top() { return null; }
        @Override
        public Void constant(int value) { return null; }
        @Override
        public Void compose(Void left, Void right) { return null; }
        @Override
        public Void accelerate(Void modifier) { return null; }
        @Override
        public Void fromExpression(int offset, Map<Expression, Integer> expression, Expression key) { return null; }
    }

    /**
     * Supports one-dimensional indexing.
     */
    record Modifier1(int offset, int alignment) {}

    final class FieldSensitive1 implements ModifierType<Modifier1> {
        private static final Modifier1 TOP = new Modifier1(0, 1);
        @Override
        public boolean isConstant(Modifier1 modifier) { return modifier.alignment == 0; }
        @Override
        public boolean isTrivial(Modifier1 modifier) { return modifier.offset == 0 && modifier.alignment == 0; }
        @Override
        public boolean overlaps(Modifier1 left, Modifier1 right) {
            // do x,y exist such that l.o + x * l.a = s.o + y * s.a
            if (left.alignment == 0 && right.alignment == 0) {
                return left.offset == right.offset;
            }
            int divisor = left.alignment == 0 ? right.alignment : right.alignment == 0 ? left.alignment :
                    IntMath.gcd(left.alignment, right.alignment);
            return (left.offset - right.offset) % divisor == 0;
        }
        @Override
        public boolean includes(Modifier1 larger, Modifier1 smaller) {
            if (larger.alignment == 0) {
                return smaller.equals(larger);
            }
            return (smaller.offset - larger.offset) % larger.alignment == 0 && smaller.alignment % larger.alignment == 0;
        }
        @Override
        public int offset(Modifier1 modifier) { return modifier.offset; }
        @Override
        public Modifier1 top() { return TOP; }
        @Override
        public Modifier1 constant(int value) { return new Modifier1(value, 0); }
        @Override
        public Modifier1 compose(Modifier1 left, Modifier1 right) {
            return modifier(left.offset + right.offset, IntMath.gcd(left.alignment, right.alignment));
        }
        @Override
        public Modifier1 accelerate(Modifier1 modifier) {
            if (modifier.offset == 0) {
                return modifier;
            }
            return new Modifier1(0, IntMath.gcd(Math.abs(modifier.offset), modifier.alignment));
        }
        @Override
        public Modifier1 fromExpression(int offset, Map<Expression, Integer> expression, Expression key) {
            int alignment = 0;
            for (Map.Entry<Expression, Integer> entry : expression.entrySet()) {
                if (entry.getKey() != key) {
                    alignment = IntMath.gcd(entry.getValue(), alignment);
                }
            }
            return new Modifier1(offset, alignment);
        }
        private Modifier1 modifier(int offset, int alignment) {
            return new Modifier1(alignment == 0 ? offset : offset % alignment, alignment);
        }
    }

    /**
     * Supports multi-dimensional indexing.
     * Also
     */
    record ModifierN(int offset, List<Integer> alignment) {}

    final class FieldSensitiveN implements ModifierType<ModifierN> {
        private static final ModifierN TOP = new ModifierN(0, List.of(-1));
        private static final ModifierN TRIVIAL = new ModifierN(0, List.of());
        @Override
        public boolean isConstant(ModifierN modifier) { return modifier.alignment.isEmpty(); }
        @Override
        public boolean isTrivial(ModifierN modifier) { return modifier.offset == 0 && modifier.alignment.isEmpty(); }
        @Override
        public boolean overlaps(ModifierN l, ModifierN r) {
            // exists non-negative integers x, y with l.offset + x * l.alignment == r.offset + y * r.alignment
            final int offset = r.offset - l.offset;
            final int leftAlignment = singleAlignment(l.alignment);
            final int rightAlignment = singleAlignment(r.alignment);
            final int left = leftAlignment < 0 ? -leftAlignment : reduceGCD(l.alignment);
            final int right = rightAlignment < 0 ? -rightAlignment : reduceGCD(r.alignment);
            if (left == 0 && right == 0) {
                return offset == 0;
            }
            final int divisor = left == 0 ? right : right == 0 ? left : IntMath.gcd(left, right);
            final boolean leftDirectedTowardsRight = right != 0 || leftAlignment < 0 || offset >= 0;
            final boolean rightDirectedTowardsLeft = left != 0 || rightAlignment < 0 || offset <= 0;
            return leftDirectedTowardsRight && rightDirectedTowardsLeft && offset % divisor == 0;
        }
        @Override
        public boolean includes(ModifierN left, ModifierN right) {
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
        public int offset(ModifierN modifier) { return modifier.offset; }
        @Override
        public ModifierN top() { return TOP; }
        @Override
        public ModifierN constant(int value) { return value == 0 ? TRIVIAL : new ModifierN(value, List.of()); }
        @Override
        public ModifierN compose(ModifierN left, ModifierN right) {
            return modifier(left.offset + right.offset, compose(left.alignment, right.alignment));
        }
        @Override
        public ModifierN accelerate(ModifierN modifier) {
            if (modifier.offset == 0) {
                return modifier;
            }
            return new ModifierN(0, compose(modifier.alignment, List.of(modifier.offset)));
        }
        @Override
        public ModifierN fromExpression(int offset, Map<Expression, Integer> expression, Expression key) {
            final List<Integer> alignment = new ArrayList<>();
            for (Map.Entry<Expression, Integer> e : expression.entrySet()) {
                final int v = Math.absExact(e.getValue());
                if (e.getKey() != key && hasNoDivisorsInList(v, alignment, true)) {
                    alignment.removeIf(w -> w % v == 0);
                    alignment.add(-v);
                }
            }
            sort(alignment);
            return modifier(offset, alignment);
        }

        private ModifierN modifier(int offset, List<Integer> alignment) {
            int a = singleAlignment(alignment);
            return new ModifierN(a >= 0 ? offset : offset % -a, alignment);
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
        // Merges two sets of pairwise-indivisible dynamic offsets.
        private static List<Integer> compose(List<Integer> left, List<Integer> right) {
            if (left.isEmpty() || right.isEmpty()) {
                return right.isEmpty() ? left : right;
            }
            // Handle TOP
            if (left.equals(List.of(-1)) || right.equals(List.of(-1))) {
                return List.of(-1);
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
            // assert left and right each consist of pairwise indivisible positives
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
    }
}
