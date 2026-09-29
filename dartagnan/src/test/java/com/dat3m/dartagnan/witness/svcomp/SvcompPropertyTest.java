package com.dat3m.dartagnan.witness.svcomp;

import org.junit.Test;

import java.util.List;

import static com.dat3m.dartagnan.witness.svcomp.SvcompProperty.DATA_RACE;
import static com.dat3m.dartagnan.witness.svcomp.SvcompProperty.NO_OVERFLOW;
import static com.dat3m.dartagnan.witness.svcomp.SvcompProperty.UNREACH_CALL;
import static com.dat3m.dartagnan.witness.svcomp.SvcompProperty.VALID_DEREF;
import static com.dat3m.dartagnan.witness.svcomp.SvcompProperty.VALID_FREE;
import static com.dat3m.dartagnan.witness.svcomp.SvcompProperty.fromAssertionError;
import static com.dat3m.dartagnan.witness.svcomp.SvcompProperty.supportedPropertyNames;
import static org.junit.Assert.assertEquals;

public class SvcompPropertyTest {

    @Test
    public void classifiesSupportedAssertionViolations() {
        assertEquals(UNREACH_CALL,
                fromAssertionError("user assertion"));
        assertEquals(NO_OVERFLOW,
                fromAssertionError("integer overflow"));
        assertEquals(VALID_DEREF,
                fromAssertionError("invalid dereference"));
        assertEquals(VALID_FREE,
                fromAssertionError("invalid free"));
    }

    @Test
    public void usesTheMatchingSvcompSpecification() {
        assertEquals("CHECK( init(main()), LTL(G ! overflow) )",
                NO_OVERFLOW.specification());
        assertEquals("CHECK( init(main()), LTL(G valid-deref) )",
                VALID_DEREF.specification());
        assertEquals("CHECK( init(main()), LTL(G valid-free) )",
                VALID_FREE.specification());
        assertEquals("CHECK( init(main()), LTL(G ! data-race) )",
                DATA_RACE.specification());
    }

    @Test
    public void listsSupportedPropertyNames() {
        assertEquals(List.of("unreach-call", "no-overflow", "valid-deref", "valid-free", "no-data-race"),
                supportedPropertyNames());
    }
}
