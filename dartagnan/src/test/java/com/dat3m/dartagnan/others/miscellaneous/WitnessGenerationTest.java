package com.dat3m.dartagnan.others.miscellaneous;

import com.dat3m.dartagnan.Dartagnan;

import org.junit.Test;
import java.nio.file.Path;
import java.nio.file.Files;

import static org.junit.Assert.*;

import static com.dat3m.dartagnan.configuration.OptionNames.*;

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

        Dartagnan.runAsApplication(programPath, catPath, String.format("--%s=png", WITNESS));
        assertTrue("Witness not found at: " + witnessPath.toAbsolutePath().toString(), Files.exists(witnessPath));
    }

    @Test
    public void testGeneratesWitnessWithFilename() throws Exception {
        final String programName = "ttas-acq2rx";
        final String witnessName = "witness";
        final Path programPath = testDir.resolve(programName + ".ll");
        final Path witnessPath = outputDir.resolve(witnessName + ".png");

        Dartagnan.runAsApplication(programPath, catPath, String.format("--%s=png", WITNESS), String.format("--%s=%s", WITNESS_FILENAME, witnessName));
        assertTrue("Witness not found at: " + witnessPath.toAbsolutePath().toString(), Files.exists(witnessPath));
    }

    @Test
    public void testShowRelationsWitness() throws Exception {
        final String programName = "ttas-acq2rx";
        final Path programPath = testDir.resolve(programName + ".ll");
        final Path witnessPath = outputDir.resolve(programName + ".dot");
        final String relToShow = "ppo";

        Dartagnan.runAsApplication(programPath, catPath, String.format("--%s=dot", WITNESS), String.format("--%s=%s", WITNESS_SHOW, relToShow));

        final String witnessContent = Files.readString(witnessPath);

        assertTrue("The witness  does not show the expected relations: " + relToShow, witnessContent.contains(relToShow));
    }
}