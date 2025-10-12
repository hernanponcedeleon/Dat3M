package com.dat3m.dartagnan.parsers.cat;

import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Test;

import static org.junit.Assert.assertTrue;

public class CatParserTest {

    @Test
    public void recursiveSet() {
        final String text = """
                let rec r0 = domain(loc & ([W]; po; [F]; po; [R])) | domain([r0]; addr)
                acyclic (po & loc) | addr | data | ctrl | rf | co | fr | po ; [r0]
                """;
        final Wmm memoryModel = new ParserCat().parse(text);
        assertTrue(memoryModel.getRelation("r0").isRecursive());
    }
}
