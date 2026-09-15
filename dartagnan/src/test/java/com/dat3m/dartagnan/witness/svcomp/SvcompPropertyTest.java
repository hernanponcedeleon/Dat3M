package com.dat3m.dartagnan.witness.svcomp;

import org.junit.Test;

import java.util.List;

import static org.junit.Assert.assertEquals;

public class SvcompPropertyTest {

    @Test
    public void classifiesSupportedAssertionViolations() {
        assertEquals(SvcompProperty.UNREACH_CALL,
                SvcompProperty.fromAssertionError("user assertion"));
        assertEquals(SvcompProperty.NO_OVERFLOW,
                SvcompProperty.fromAssertionError("integer overflow"));
        assertEquals(SvcompProperty.VALID_DEREF,
                SvcompProperty.fromAssertionError("invalid dereference"));
        assertEquals(SvcompProperty.VALID_FREE,
                SvcompProperty.fromAssertionError("invalid free"));
    }

    @Test
    public void usesTheMatchingSvcompSpecification() {
        assertEquals("CHECK( init(main()), LTL(G ! overflow) )",
                SvcompProperty.NO_OVERFLOW.specification());
        assertEquals("CHECK( init(main()), LTL(G valid-deref) )",
                SvcompProperty.VALID_DEREF.specification());
        assertEquals("CHECK( init(main()), LTL(G valid-free) )",
                SvcompProperty.VALID_FREE.specification());
        assertEquals("CHECK( init(main()), LTL(G ! data-race) )",
                SvcompProperty.DATA_RACE.specification());
    }

    @Test
    public void listsSupportedPropertyNames() {
        assertEquals(List.of("unreach-call", "no-overflow", "valid-deref", "valid-free", "no-data-race"),
                SvcompWitnessExtractor.supportedPropertyNames());
    }
}
