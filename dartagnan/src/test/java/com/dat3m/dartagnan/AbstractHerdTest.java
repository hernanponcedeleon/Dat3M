package com.dat3m.dartagnan;

import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.utils.Result;
import org.junit.Test;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Map;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.GlobalSettings.SKIP_TIMINGOUT_LITMUS;
import static com.dat3m.dartagnan.utils.ResourceHelper.getCSVFileName;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static org.junit.Assert.fail;
import static org.junit.jupiter.api.Assertions.assertEquals;

public abstract class AbstractHerdTest {

	static final int SOLVER_TIMEOUT = 60;
    static final int TIMEOUT = 60000;
	
    static Iterable<Object[]> buildParameters(String litmusPath, String cat) throws IOException {
    	int n = ResourceHelper.LITMUS_RESOURCE_PATH.length();
        Map<String, Result> expectationMap = ResourceHelper.getExpectedResults();

        try (Stream<Path> fileStream = Files.walk(Paths.get(ResourceHelper.LITMUS_RESOURCE_PATH + litmusPath))) {
            return fileStream
                    .filter(Files::isRegularFile)
                    .map(Path::toString)
                    .filter(f -> f.endsWith("litmus"))
                    // All litmus test timing out with refinement match this
                    .filter(f -> !SKIP_TIMINGOUT_LITMUS || !f.contains("manual/extra"))
                    .filter(f -> !SKIP_TIMINGOUT_LITMUS || !f.contains("PPC/Dart-"))
                    .filter(f -> expectationMap.containsKey(f.substring(n)))
                    .map(f -> new Object[]{f, expectationMap.get(f.substring(n))})
                    .collect(ArrayList::new,
                            (l, f) -> l.add(new Object[]{f[0], f[1], cat}), ArrayList::addAll);
        }
    }

    private final String path;
    private final Result expected;
    private final String wmm;

    AbstractHerdTest(String path, Result expected, String wmm) {
        this.path = path;
        this.expected = expected;
        this.wmm = wmm;
    }

    @Test(timeout = TIMEOUT)
    public void testHerd() {
    	try (BufferedWriter writer = new BufferedWriter(new FileWriter(getCSVFileName(getClass(), "herd", ""), true)))
    	{
    		writer.append(path.substring(path.lastIndexOf("/") + 1)).append(", ");
    		
    		String output = "";
        	ArrayList<String> cmd = new ArrayList<String>();
        	cmd.add("herd7");
        	cmd.add("-model");
        	String dat3m = System.getenv("DAT3M_HOME");
			cmd.add(dat3m + "/" + wmm);
        	if(wmm.contains("linux")) {
            	cmd.add("-macros");
            	cmd.add(dat3m + "/cat/linux-kernel.def");
            	cmd.add("-bell");
            	cmd.add(dat3m + "/cat/linux-kernel.bell");
            	cmd.add("-I");
            	cmd.add(dat3m + "/cat/");        		
        	}
        	cmd.add(dat3m + path.substring(2));
        	ProcessBuilder processBuilder = new ProcessBuilder(cmd);
        	
        	long start = System.currentTimeMillis();
           	Process proc = processBuilder.start();
   			BufferedReader read = new BufferedReader(new InputStreamReader(proc.getInputStream()));
   			proc.waitFor();
   			while(read.ready()) {
   				output = output + read.readLine();
   			}
   			if(proc.exitValue() == 1) {
   				BufferedReader error = new BufferedReader(new InputStreamReader(proc.getErrorStream()));
   				while(error.ready()) {
   					System.out.println(error.readLine());
   				}
   				System.exit(0);
   			}
   			long solvingTime = System.currentTimeMillis() - start;
   			Result result = output.contains("No") ? PASS : FAIL;
            assertEquals(expected, result);
            writer.append(result.toString()).append(", ")
            	  .append(Long.toString(solvingTime));
   			writer.newLine();
    	} catch (Exception e){
    		fail(e.getMessage());
    	}
    }
}
