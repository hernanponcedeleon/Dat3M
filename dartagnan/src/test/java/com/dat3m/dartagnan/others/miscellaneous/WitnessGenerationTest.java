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

    private final Path dat3mHome = getHomeDirectory(true);
    private final Path testDir = dat3mHome.resolve("dartagnan").resolve(getTestResourcePath("locks"));
    private final Path catPath = getCatDirectory(true).resolve("vmm.cat");
    private final Path outputDir = getOutputDirectory(true);

    @Test
    public void testGeneratesDefaultWitness() throws Exception {
        final String programName = "ttas-acq2rx";
        final Path programPath = testDir.resolve(programName + ".ll");
        final Path pngPath = outputDir.resolve(programName + ".png");
        final Path dotPath = outputDir.resolve(programName + ".dot");

        runDartagnanApplication(programPath, catPath, String.format("--%s=png", WITNESS));
        assertTrue("Witness not found at: " + pngPath.toAbsolutePath().toString(), Files.exists(pngPath));
        Files.deleteIfExists(pngPath);
        Files.deleteIfExists(dotPath);
    }

    @Test
    public void testGeneratesWitnessWithFilename() throws Exception {
        final String programName = "ttas-acq2rx";
        final String witnessName = "witness";
        final Path programPath = testDir.resolve(programName + ".ll");
        final Path pngPath = outputDir.resolve(witnessName + ".png");
        final Path dotPath = outputDir.resolve(programName + ".dot");

        runDartagnanApplication(programPath, catPath, String.format("--%s=png", WITNESS), String.format("--%s=%s", WITNESS_FILENAME, witnessName));
        assertTrue("Witness not found at: " + pngPath.toAbsolutePath().toString(), Files.exists(pngPath));
        Files.deleteIfExists(pngPath);
        Files.deleteIfExists(dotPath);
    }

    @Test
    public void testShowRelationsWitness() throws Exception {
        final String programName = "ttas-acq2rx";
        final Path programPath = testDir.resolve(programName + ".ll");
        final Path dotPath = outputDir.resolve(programName + ".dot");
        final String relToShow = "ppo";

        runDartagnanApplication(programPath, catPath, String.format("--%s=dot", WITNESS), String.format("--%s=%s", WITNESS_SHOW, relToShow));

        final String witnessContent = Files.readString(dotPath);

        assertTrue("The witness  does not show the expected relations: " + relToShow, witnessContent.contains(relToShow));
        Files.deleteIfExists(dotPath);
    }
}