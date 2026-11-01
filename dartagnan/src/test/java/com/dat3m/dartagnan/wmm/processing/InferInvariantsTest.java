package com.dat3m.dartagnan.wmm.processing;

import com.dat3m.dartagnan.frontend.cat.ParserCat;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.axiom.Emptiness;
import com.dat3m.dartagnan.wmm.definition.Difference;
import org.junit.Test;

import java.util.List;
import java.util.Set;

import static com.dat3m.dartagnan.test.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.test.TestHelper.parseWmm;
import static org.junit.Assert.*;

public class InferInvariantsTest {

    @Test
    public void inferredBounds() throws Exception {
        final Wmm wmm = parseWmm(getRootPath("cat/rc11.cat"));
        final TransitiveBounds bounds = TransitiveBounds.compute(wmm.getRelations());
        final Relation loc = wmm.getRelation("loc");
        final Relation intRel = wmm.getRelation("int");
        final Relation eco = wmm.getRelation("eco");
        final Relation hb = wmm.getRelation("hb");

        assertTrue(bounds.isTransitive(loc));
        assertTrue(bounds.isTransitive(eco));
        assertTrue(bounds.isTransitive(hb));
        assertFalse("co must not be treated as transitive", bounds.isTransitive(wmm.getRelation("co")));

        // fr = rf^-1;co | [R \ range(rf)];loc;[W]
        assertEquals(Set.of(loc, eco), bounds.getBounds(wmm.getRelation("fr")));
        assertTrue(bounds.getBounds(wmm.getRelation("rf")).containsAll(List.of(loc, eco)));
        assertTrue(bounds.getBounds(wmm.getRelation("po")).containsAll(List.of(intRel, hb)));
        assertFalse(bounds.getBounds(wmm.getRelation("po")).contains(loc));
        // hb & loc
        assertTrue(bounds.getBounds(wmm.getRelation("hbl")).containsAll(List.of(loc, hb)));
    }

    @Test
    public void inferredTransitiveRelations() {
        final Wmm wmm = new ParserCat().parse("""
                let wlw = [W];loc;[W]
                let lw = loc;[W]
                let hb = (po | rf)+
                let hbinv = hb^-1
                let scopes = scta & swg
                let notTrans = [W];po;[R]
                let setLike = [W];[W]
                acyclic wlw | lw | hb | hbinv | scopes | sr | ssg | notTrans | setLike
                """);
        final TransitiveBounds bounds = TransitiveBounds.compute(wmm.getRelations());
        for (String name : List.of("wlw", "lw", "hb", "hbinv", "scopes", "scta", "swg", "ssg")) {
            assertTrue(name + " should be transitive", bounds.isTransitive(wmm.getRelation(name)));
        }
        for (String name : List.of("sr", "notTrans", "setLike", "co", "po")) {
            assertFalse(name + " should not be transitive", bounds.isTransitive(wmm.getRelation(name)));
        }
        // Bounds through the new transitive relations
        assertTrue(bounds.getBounds(wmm.getRelation("wlw")).contains(wmm.getRelation("loc")));
        assertFalse(bounds.getBounds(wmm.getRelation("hb")).contains(wmm.getRelation("hbinv")));
        assertTrue(bounds.getBounds(wmm.getRelation("scopes")).containsAll(
                List.of(wmm.getRelation("scta"), wmm.getRelation("swg"))));
    }

    @Test
    public void boundsBecomeInvariants() throws Exception {
        final Wmm wmm = parseWmm(getRootPath("cat/rc11.cat"));
        final List<Axiom> axioms = wmm.getAxioms();
        WmmProcessingManager.newInstance().run(wmm);
        final Relation fr = wmm.getRelation("fr");
        final Relation loc = wmm.getRelation("loc");

        assertFalse(wmm.getInvariants().isEmpty());
        assertTrue("fr ⊆ loc was not inferred", hasInvariant(wmm, fr, loc));
        // Invariants are not part of the axioms, and neither are their helper relations part of the semantics.
        assertEquals(axioms.size(), wmm.getAxioms().size());
        assertTrue(wmm.getAxioms().stream().noneMatch(Axiom::isInvariant));
        final Set<Relation> relevant = wmm.getRelationsRelevantForSemantics();
        for (Axiom inv : wmm.getInvariants()) {
            assertTrue(inv.isInvariant());
            assertFalse(relevant.contains(inv.getRelation()));
        }
        assertTrue(relevant.containsAll(List.of(fr, loc)));
    }

    @Test
    public void inferenceIsIdempotent() throws Exception {
        final Wmm wmm = parseWmm(getRootPath("cat/rc11.cat"));
        WmmProcessingManager.newInstance().run(wmm);
        final int invariants = wmm.getInvariants().size();
        InferInvariants.newInstance().run(wmm);
        assertEquals(invariants, wmm.getInvariants().size());
    }

    private static boolean hasInvariant(Wmm wmm, Relation r, Relation t) {
        return wmm.getInvariants().stream().anyMatch(a -> a instanceof Emptiness && !a.isNegated()
                && a.getRelation().getDefinition() instanceof Difference d
                && d.getMinuend().equals(r) && d.getSubtrahend().equals(t));
    }
}
