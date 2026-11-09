package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.frontend.cat.ParserCat;
import com.dat3m.dartagnan.test.ResourceHelper;
import com.dat3m.dartagnan.test.TestHelper;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.PolarityAnalysis;
import com.dat3m.dartagnan.wmm.definition.TransitiveClosure;
import org.junit.Test;

import java.io.IOException;
import java.util.Set;
import java.util.stream.Collectors;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

public class LazyClosureCandidatesTest {

    @Test
    public void closureUnderAxiomIsNegative() {
        assertTrue(isNegativeClosure("let r = po+\nacyclic r"));
        assertTrue(isNegativeClosure("let r = po+\nirreflexive r;rf"));
    }

    @Test
    public void closureUnderNegatedAxiomIsPositive() {
        assertFalse(isNegativeClosure("let r = po+\n~empty r"));
        // Flags are violated if the axiom holds, so they behave like the axiom
        assertFalse(isNegativeClosure("let r = po+\nflag ~empty r as f"));
        assertTrue(isNegativeClosure("let r = po+\nflag empty r as f"));
    }

    @Test
    public void subtrahendFlipsPolarity() {
        assertFalse(isNegativeClosure("let r = po+\nempty rf \\ r"));
        assertTrue(isNegativeClosure("let r = po+\nflag ~empty rf \\ r as f"));
    }

    @Test
    public void closureWithBothPolaritiesIsNotNegative() {
        assertFalse(isNegativeClosure("let r = po+\nacyclic r\nflag ~empty r as f"));
    }

    @Test
    public void closuresOfShippedModels() throws IOException {
        // vmm: hb+ is used by the data race flags only
        assertTrue(negativeClosureOperands("vmm").contains("hb"));
        // power: hb* and com* are used by the propagation and observation axioms
        assertTrue(negativeClosureOperands("power").containsAll(Set.of("hb", "com")));
    }

    private static boolean isNegativeClosure(String model) {
        final Wmm memoryModel = new ParserCat().parse(model);
        return WmmEncoder.getNegativelyUsedClosures(memoryModel, PolarityAnalysis.of(memoryModel)).contains(memoryModel.getRelation("r"));
    }

    private static Set<String> negativeClosureOperands(String modelName) throws IOException {
        final Wmm memoryModel = TestHelper.parseWmm(ResourceHelper.getCatPathFromName(modelName));
        return WmmEncoder.getNegativelyUsedClosures(memoryModel, PolarityAnalysis.of(memoryModel)).stream()
                .map(r -> ((TransitiveClosure) r.getDefinition()).getOperand().getNameOrTerm())
                .collect(Collectors.toSet());
    }
}
