package com.dat3m.dartagnan.others.miscellaneous;

import com.dat3m.dartagnan.Dartagnan;

import org.junit.Test;
import java.nio.file.Path;
import java.nio.file.Files;

import static org.junit.Assert.*;

public class WitnessGenerationTest {

    private final Path dat3mHome = Path.of(System.getenv("DAT3M_HOME"));
    private final Path testDir = dat3mHome.resolve("dartagnan/src/test/resources/locks");
    private final Path catPath = dat3mHome.resolve("cat/vmm.cat");
    private final Path outputDir = dat3mHome.resolve("output");

    @Test
    public void testGeneratesDefaultWitness() throws Exception {
        final String programName = "ttas-acq2rx";
        final Path programPath = testDir.resolve(programName + ".ll");
        final Path witnessPath = outputDir.resolve(programName + ".png");

        Dartagnan.runAsApplication(programPath, catPath, "--witness=png");
        assertTrue("Witness not found at: " + witnessPath.toAbsolutePath().toString(), Files.exists(witnessPath));
    }

    @Test
    public void testGeneratesWitnessWithFilename() throws Exception {
        final String programName = "ttas-acq2rx";
        final String witnessName = "witness";
        final Path programPath = testDir.resolve(programName + ".ll");
        final Path witnessPath = outputDir.resolve(witnessName + ".png");

        Dartagnan.runAsApplication(programPath, catPath, "--witness=png", "--witness.filename=" + witnessName);
        assertTrue("Witness not found at: " + witnessPath.toAbsolutePath().toString(), Files.exists(witnessPath));
    }

    @Test
    public void testShowRelationsWitness() throws Exception {
        final String programName = "ttas-acq2rx";
        final Path programPath = testDir.resolve(programName + ".ll");
        final Path witnessPath = outputDir.resolve(programName + ".dot");

        Dartagnan.runAsApplication(programPath, catPath, "--witness=dot", "--witness.show=ppo");

        final String witnessContent = Files.readString(witnessPath);
        final String expectedSnippet = "ppo";

        assertTrue("The witness  does not show the expected relations: " + expectedSnippet, witnessContent.contains(expectedSnippet));
    }
}