package com.dat3m.dartagnan.program.analysis.alias;

import org.junit.Test;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import static org.junit.Assert.assertTrue;

public class ModifierTraitSoundnessTest {

    private static final int SAMPLE_BOUND = 40;

    @Test
    public void sdLinearDoesNotMissOverlapsOrClaimFalseInclusions() {
        ModifierTrait.SdLinear trait = new ModifierTrait.SdLinear();
        List<ModifierTrait.Sd> modifiers = new ArrayList<>();
        for (int offset = -4; offset <= 4; offset++) {
            for (int alignment = 0; alignment <= 5; alignment++) {
                modifiers.add(new ModifierTrait.Sd(offset, alignment));
            }
        }

        for (ModifierTrait.Sd left : modifiers) {
            for (ModifierTrait.Sd right : modifiers) {
                Set<Integer> leftValues = values(left);
                Set<Integer> rightValues = values(right);
                if (leftValues.stream().anyMatch(rightValues::contains)) {
                    assertTrue("Missed overlap between " + left + " and " + right,
                            trait.mayOverlap(left, right));
                }
                if (trait.mustInclude(left, right)) {
                    assertTrue("False inclusion of " + right + " in " + left,
                            rightValues.stream().allMatch(value -> contains(left, value)));
                }
            }
        }
    }

    @Test
    public void mdLinearDoesNotMissOverlapsOrClaimFalseInclusions() {
        ModifierTrait.MdLinear trait = new ModifierTrait.MdLinear();
        // Regression: mustInclude previously claimed that a positive-only set included a bidirectional set, and that
        // it included offsets below its starting point. Either false positive can discard a required inclusion edge.
        List<List<Integer>> alignments = List.of(
                List.of(),
                List.of(2), List.of(3), List.of(4), List.of(5),
                List.of(2, 3), List.of(2, 5), List.of(3, 4), List.of(4, 9),
                List.of(-1), List.of(-2), List.of(-3));
        List<ModifierTrait.Md> modifiers = new ArrayList<>();
        for (int offset = -4; offset <= 4; offset++) {
            for (List<Integer> alignment : alignments) {
                modifiers.add(new ModifierTrait.Md(offset, alignment));
            }
        }

        for (ModifierTrait.Md left : modifiers) {
            for (ModifierTrait.Md right : modifiers) {
                Set<Integer> leftValues = values(left);
                Set<Integer> rightValues = values(right);
                if (leftValues.stream().anyMatch(rightValues::contains)) {
                    assertTrue("Missed overlap between " + left + " and " + right,
                            trait.mayOverlap(left, right));
                }
                if (trait.mustInclude(left, right)) {
                    assertTrue("False inclusion of " + right + " in " + left,
                            rightValues.stream().allMatch(value -> contains(left, value)));
                }
            }
        }
    }

    private Set<Integer> values(ModifierTrait.Sd modifier) {
        Set<Integer> values = new HashSet<>();
        for (int factor = -SAMPLE_BOUND; factor <= SAMPLE_BOUND; factor++) {
            values.add(modifier.offset() + factor * modifier.alignment());
        }
        return values;
    }

    private boolean contains(ModifierTrait.Sd modifier, int value) {
        int delta = value - modifier.offset();
        return modifier.alignment() == 0 ? delta == 0
                : delta % modifier.alignment() == 0;
    }

    private Set<Integer> values(ModifierTrait.Md modifier) {
        Set<Integer> values = new HashSet<>();
        if (modifier.alignment().size() == 1 && modifier.alignment().get(0) < 0) {
            int alignment = -modifier.alignment().get(0);
            for (int factor = -SAMPLE_BOUND; factor <= SAMPLE_BOUND; factor++) {
                values.add(modifier.offset() + factor * alignment);
            }
            return values;
        }
        boolean[] reachable = positiveReachability(modifier.alignment(), SAMPLE_BOUND);
        for (int delta = 0; delta < reachable.length; delta++) {
            if (reachable[delta]) {
                values.add(modifier.offset() + delta);
            }
        }
        return values;
    }

    private boolean contains(ModifierTrait.Md modifier, int value) {
        int delta = value - modifier.offset();
        if (modifier.alignment().size() == 1 && modifier.alignment().get(0) < 0) {
            return delta % -modifier.alignment().get(0) == 0;
        }
        return delta >= 0 && positiveReachability(modifier.alignment(), delta)[delta];
    }

    private boolean[] positiveReachability(List<Integer> alignments, int bound) {
        boolean[] reachable = new boolean[bound + 1];
        reachable[0] = true;
        for (int value = 1; value <= bound; value++) {
            for (int alignment : alignments) {
                if (alignment <= value && reachable[value - alignment]) {
                    reachable[value] = true;
                    break;
                }
            }
        }
        return reachable;
    }
}
