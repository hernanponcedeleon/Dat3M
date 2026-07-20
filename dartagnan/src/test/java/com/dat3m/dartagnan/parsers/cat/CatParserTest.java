package com.dat3m.dartagnan.parsers.cat;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Test;

import static org.junit.Assert.assertTrue;

public class CatParserTest {

    @Test
    public void undefinedName() {
        parse("let a = b");
    }

    @Test(expected = ParsingException.class)
    public void typeMismatchAtIntersection() {
        parse("let a = R & rf");
    }

    @Test(expected = ParsingException.class)
    public void typeMismatchAtUnion() {
        parse("let a = R | rf");
    }

    @Test(expected = ParsingException.class)
    public void typeMismatchAtDifference() {
        parse("let a = R \\ rf");
    }

    @Test(expected = ParsingException.class)
    public void typeMismatchWithPredefinedRelation() {
        parse("let rf1 = rf\nlet a = b & rf1");
    }

    @Test(expected = ParsingException.class)
    public void typeMismatchWithPredefinedRelationInRecursion() {
        parse("let rf1 = rf\nlet rec a = b & rf1");
    }

    @Test
    public void recursiveSet() {
        final String text = """
                let rec r0 = domain(loc & ([W]; po; [F]; po; [R])) | domain(r1)
                and r1 = [r0]; addr
                acyclic (po & loc) | addr | data | ctrl | rf | co | fr | po ; [r0]
                """;
        final Wmm memoryModel = parse(text);
        assertTrue(memoryModel.getRelation("r0").isRecursive());
        assertTrue(memoryModel.getRelation("r0").isSet());
        assertTrue(memoryModel.getRelation("r1").isRecursive());
        assertTrue(memoryModel.getRelation("r1").isRelation());
    }

    private Wmm parse(String text) {
        return new ParserCat().parse(text);
    }
}
