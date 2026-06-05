package com.dat3m.dartagnan.program.analysis.alias;

import org.junit.Test;

import java.util.Objects;

import static org.junit.Assert.*;

public class ModifierTraitTest {

    @Test
    public void checkUnit() {
        final var t = new ModifierTrait.VoidTrait();
        final Void unit = t.constantModifier(0);
        assertFalse(t.isFunctional(unit));
        assertTrue(t.isIdentity(unit));
        assertTrue(t.mayOverlap(unit, unit));
        assertTrue(t.mustInclude(unit, unit));
        assertEquals(0, t.level(unit));
        assertEquals(unit, t.constantModifier(1));
        assertEquals(unit, t.relaxedModifier(1));
        assertEquals(unit, t.compose(unit, unit));
        assertEquals(unit, t.accelerate(unit));
    }

    @Test
    public void checkFiniteSets() {
        final var t = new ModifierTrait.Offsets();
        checkBasicProperties(t);
    }

    @Test
    public void checkSdLinearSets() {
        final var t = new ModifierTrait.SdLinear();
        checkBasicProperties(t);
    }

    @Test
    public void checkMdLinearSets() {
        final var t = new ModifierTrait.MdLinear();
        checkBasicProperties(t);
    }

    private <T> void checkBasicProperties(ModifierTrait<T> t) {
        final T id = t.constantModifier(0);
        final T all = t.relaxedModifier(1);
        assertEquals(id, t.compose(id, id));
        assertEquals(id, t.accelerate(id));
        assertTrue(t.level(all) <= t.level(id));
        assertTrue(t.mustInclude(id, id));
        assertTrue(t.mayOverlap(id, id));
        checkBasicPropertiesForInstance(t, all);
        assertTrue(t.mustInclude(all, id));
        for (int i = 16; i < 1024; i += 16) {
            final T positive = t.constantModifier(i);
            final T negative = t.constantModifier(-i);
            checkBasicPropertiesForInstance(t, positive);
            if (Objects.equals(positive, negative)) {
                assertFalse(t.isFunctional(positive));
                continue;
            }
            checkBasicPropertiesForInstance(t, negative);
            assertNotEquals(positive, negative);
            checkOverlap(false, t, id, positive);
            checkOverlap(false, t, id, negative);
            checkOverlap(false, t, positive, negative);
            checkOverlap(true, t, all, positive);
            checkOverlap(true, t, all, negative);
            assertTrue(t.level(all) <= t.level(positive));
            assertTrue(t.level(all) <= t.level(negative));
            assertEquals(positive, t.constantModifier(i));
            assertEquals(id, t.compose(positive, negative));
            assertEquals(id, t.compose(negative, positive));
            assertEquals(positive, t.compose(positive, id));
            assertEquals(positive, t.compose(id, positive));
            assertEquals(negative, t.compose(negative, id));
            assertEquals(negative, t.compose(id, negative));
            assertTrue(t.mustInclude(all, positive));
            assertTrue(t.mustInclude(all, negative));
        }
    }

    private <M> void checkBasicPropertiesForInstance(ModifierTrait<M> t, M m) {
        final M mm = t.compose(m, m);
        final M a = t.accelerate(m);
        assertEquals(t.isFunctional(m), t.isFunctional(mm));
        assertFalse(t.isIdentity(m));
        assertFalse(t.isIdentity(mm));
        assertFalse(t.isIdentity(a));
        assertFalse(t.isFunctional(a));
        assertTrue(t.mayOverlap(m, m));
        if (t.isFunctional(m)) {
            checkOverlap(false, t, mm, m);
        }
        checkOverlap(true, t, mm, mm);
        checkOverlap(true, t, a, m);
        checkOverlap(true, t, a, mm);
        checkOverlap(true, t, a, a);
        assertTrue(t.mustInclude(m, m));
        assertTrue(t.mustInclude(mm, mm));
        assertTrue(t.mustInclude(a, m));
        assertTrue(t.mustInclude(a, mm));
        assertTrue(t.mustInclude(a, a));
        if (t.isFunctional(m)) {
            assertFalse(t.mustInclude(m, mm));
            assertFalse(t.mustInclude(m, a));
            assertFalse(t.mustInclude(mm, m));
        }
        assertTrue(t.level(a) <= t.level(m));
        assertTrue(t.level(a) <= t.level(mm));
    }

    private <M> void checkOverlap(boolean expected, ModifierTrait<M> t, M l, M r) {
        assertEquals(expected, t.mayOverlap(l, r));
        assertEquals(expected, t.mayOverlap(r, l));
    }
}
