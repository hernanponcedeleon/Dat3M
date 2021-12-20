package com.dat3m.dartagnan.witness;

import com.dat3m.dartagnan.parsers.witness.ParserWitness;
import com.dat3m.dartagnan.utils.ResourceHelper;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@RunWith(Parameterized.class)
public class ParseWitnessTest {

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Iterable<Object[]> data() throws IOException {
        try (Stream<Path> fileStream = Files.walk(Paths.get(ResourceHelper.TEST_RESOURCE_PATH + "witness/"))) {
            return fileStream
                    .filter(Files::isRegularFile)
                    .filter(f -> (f.toString().endsWith("bpl")))
                    .map(f -> new Object[]{f.toString()})
                    .collect(Collectors.toList());
        }
    }

    private final String path;

    public ParseWitnessTest(String path) {
        this.path = path;
    }

    @Test
    public void correct() {
    	try {
			WitnessGraph witness = new ParserWitness().parse(new File(path));
			assert(witness.getEdges().size() == witness.getNodes().size() - 1);
			witness.addNode("END");
			witness.getNode("N1");
			Node n1 = witness.getNode("N1");
			Node n2 = witness.getNode("END");
			witness.addEdge(new Edge(n1, n2));
			assert(witness.getEdges().size() == witness.getNodes().size() - 1);
		} catch (IOException ignore) {}
    }
}
