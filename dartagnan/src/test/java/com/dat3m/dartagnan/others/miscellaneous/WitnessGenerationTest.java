package com.dat3m.dartagnan.others.miscellaneous;

import org.junit.Test;
import java.nio.file.Path;
import java.nio.file.Files;

import static org.junit.Assert.*;

import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.GlobalSettings.*;
import static com.dat3m.dartagnan.utils.TestHelper.runDartagnanApplication;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;

public class WitnessGenerationTest {

    private final Path dat3mHome = Path.of(getHomeDirectory(true));
    private final Path testDir = dat3mHome.resolve("dartagnan").resolve(getTestResourcePath("locks"));
    private final Path catPath = Path.of(getCatDirectory(true)).resolve("vmm.cat");
    private final Path outputDir = Path.of(getOutputDirectory(true));

    @Test
    public void testGeneratesDefaultWitness() throws Exception {
        final String programName = "ttas-acq2rx";
        final Path programPath = testDir.resolve(programName + ".ll");
        final Path witnessPath = outputDir.resolve(programName + ".png");

        runDartagnanApplication(programPath, catPath, String.format("--%s=png", WITNESS));
        assertTrue("Witness not found at: " + witnessPath.toAbsolutePath().toString(), Files.exists(witnessPath));
    }

    @Test
    public void testGeneratesWitnessWithFilename() throws Exception {
        final String programName = "ttas-acq2rx";
        final String witnessName = "witness";
        final Path programPath = testDir.resolve(programName + ".ll");
        final Path witnessPath = outputDir.resolve(witnessName + ".png");

        runDartagnanApplication(programPath, catPath, String.format("--%s=png", WITNESS), String.format("--%s=%s", WITNESS_FILENAME, witnessName));
        assertTrue("Witness not found at: " + witnessPath.toAbsolutePath().toString(), Files.exists(witnessPath));
    }

    @Test
    public void testShowRelationsWitness() throws Exception {
        final String programName = "ttas-acq2rx";
        final Path programPath = testDir.resolve(programName + ".ll");
        final Path witnessPath = outputDir.resolve(programName + ".dot");
        final String relToShow = "ppo";

        runDartagnanApplication(programPath, catPath, String.format("--%s=dot", WITNESS), String.format("--%s=%s", WITNESS_SHOW, relToShow));

        final String witnessContent = Files.readString(witnessPath);

        assertTrue("The witness  does not show the expected relations: " + relToShow, witnessContent.contains(relToShow));
    }
}