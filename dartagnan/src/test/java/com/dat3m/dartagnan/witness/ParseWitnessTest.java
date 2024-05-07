package com.dat3m.dartagnan.witness;

import com.dat3m.dartagnan.parsers.witness.ParserWitness;
import com.dat3m.dartagnan.witness.graphml.Edge;
import com.dat3m.dartagnan.witness.graphml.Node;
import com.dat3m.dartagnan.witness.graphml.WitnessGraph;

import org.junit.Test;

import java.io.File;
import java.io.IOException;

import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static org.junit.Assert.assertEquals;

public class ParseWitnessTest {

    @Test
    public void ParseExtend() throws IOException {
        WitnessGraph witness = new ParserWitness().parse(new File(getTestResourcePath("witness/witness.graphml")));
        assertEquals(witness.getEdges().size(), witness.getNodes().size() - 1);
        witness.addNode("END");
        witness.getNode("N1");
        Node n1 = witness.getNode("N1");
        Node n2 = witness.getNode("END");
        witness.addEdge(new Edge(n1, n2));
        assertEquals(witness.getEdges().size(), witness.getNodes().size() - 1);
    }
}
