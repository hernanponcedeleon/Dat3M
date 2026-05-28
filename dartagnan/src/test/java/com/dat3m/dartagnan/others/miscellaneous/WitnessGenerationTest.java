import org.junit.Test;
import static org.junit.Assert.*;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.concurrent.TimeUnit;

public class WitnessGenerationTest {

    @Test
    public void testGeneratesDefaultWitness() throws Exception {
        final String dat3mHome = System.getenv("DAT3M_HOME");
        assertNotNull("DAT3M_HOME environment variable is not set!", dat3mHome);
        
        final String programName = "ttas-acq2rx";
        File expectedFile = Paths.get(dat3mHome, "output", programName + ".png").toFile();

        ProcessBuilder pb = new ProcessBuilder(
            "java",
            "-jar",
            dat3mHome + "/dartagnan.jar",
            "cat/vmm.cat",
            dat3mHome + "/dartagnan/src/test/resources/locks/" + programName + ".ll",
            "--witness=png"
        );        
        
        Process process = pb.start();
        boolean finished = process.waitFor(30, TimeUnit.SECONDS);

        assertTrue("Witness not found at: " + expectedFile.getAbsolutePath(), expectedFile.exists());
    }

    @Test
    public void testGeneratesWitnessWithFilename() throws Exception {
        final String dat3mHome = System.getenv("DAT3M_HOME");
        assertNotNull("DAT3M_HOME environment variable is not set!", dat3mHome);
        
        final String programName = "ttas-acq2rx";
        final String witnessName = "witness";
        File expectedFile = Paths.get(dat3mHome, "output", witnessName + ".png").toFile();

        ProcessBuilder pb = new ProcessBuilder(
            "java",
            "-jar",
            dat3mHome + "/dartagnan.jar",
            "cat/vmm.cat",
            dat3mHome + "/dartagnan/src/test/resources/locks/" + programName + ".ll",
            "--witness=png",
            "--witness.filename=" + witnessName
        );        
        
        Process process = pb.start();
        boolean finished = process.waitFor(30, TimeUnit.SECONDS);

        assertTrue("Witness not found at: " + expectedFile.getAbsolutePath(), expectedFile.exists());
    }

    @Test
    public void testShowRelationsWitness() throws Exception {
        final String dat3mHome = System.getenv("DAT3M_HOME");
        assertNotNull("DAT3M_HOME environment variable is not set!", dat3mHome);
        
        final String programName = "ttas-acq2rx";
        File expectedFile = Paths.get(dat3mHome, "output", programName + ".dot").toFile();

        ProcessBuilder pb = new ProcessBuilder(
            "java",
            "-jar",
            dat3mHome + "/dartagnan.jar",
            "cat/vmm.cat",
            dat3mHome + "/dartagnan/src/test/resources/locks/" + programName + ".ll",
            "--witness=png",
            "--witness.show=ppo"
        );        
        
        Process process = pb.start();
        boolean finished = process.waitFor(30, TimeUnit.SECONDS);

        final String witnessContent = Files.readString(expectedFile.toPath());
        final String expectedSnippet = "ppo";

        assertTrue("The witness  does not show the expected relations: " + expectedSnippet, witnessContent.contains(expectedSnippet));
    }
}