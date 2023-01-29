package com.dat3m.dartagnan.witness;

import com.dat3m.dartagnan.parsers.witness.ParserWitness;
import com.dat3m.dartagnan.utils.ResourceHelper;
import org.junit.Test;

import java.io.File;
import java.io.IOException;

import static org.junit.Assert.assertEquals;

public class ParseWitnessTest {

    @Test
    public void ParseExtend() throws IOException {
        WitnessGraph witness = new ParserWitness().parse(new File(ResourceHelper.TEST_RESOURCE_PATH + "witness/witness.graphml"));
        assertEquals(witness.getEdges().size(), witness.getNodes().size() - 1);
        witness.addNode("END");
        witness.getNode("N1");
        Node n1 = witness.getNode("N1");
        Node n2 = witness.getNode("END");
        witness.addEdge(new Edge(n1, n2));
        assertEquals(witness.getEdges().size(), witness.getNodes().size() - 1);
    }
}
