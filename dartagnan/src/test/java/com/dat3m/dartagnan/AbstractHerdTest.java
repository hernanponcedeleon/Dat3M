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

import static com.dat3m.dartagnan.utils.ResourceHelper.getCSVFileName;
import static org.junit.Assert.fail;

public abstract class AbstractHerdTest {

	static final int SOLVER_TIMEOUT = 60;
    static final int TIMEOUT = 5000;
	
    static Iterable<Object[]> buildParameters(String litmusPath, String cat) throws IOException {
    	int n = ResourceHelper.LITMUS_RESOURCE_PATH.length();
        Map<String, Result> expectationMap = ResourceHelper.getExpectedResults();

        try (Stream<Path> fileStream = Files.walk(Paths.get(ResourceHelper.LITMUS_RESOURCE_PATH + litmusPath))) {
            return fileStream
                    .filter(Files::isRegularFile)
                    .map(Path::toString)
                    .filter(f -> f.endsWith("litmus"))
                    .filter(f -> expectationMap.containsKey(f.substring(n)))
                    .collect(ArrayList::new,
                            (l, f) -> l.add(new Object[]{f, cat}), ArrayList::addAll);
        }
    }

    private final String path;
    private final String wmm;

    AbstractHerdTest(String path, String wmm) {
        this.path = path;
        this.wmm = wmm;
    }

    @Test(timeout = TIMEOUT)
    public void testHerd() {
    	try (BufferedWriter writer = new BufferedWriter(new FileWriter(getCSVFileName(getClass(), "herd", ""), true)))
    	{
    		writer.newLine();
    		writer.append(path.substring(path.lastIndexOf("/") + 1)).append(", ");
            // The flush() is required to write the content in the presence of timeouts
            writer.flush();

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
            writer.append("N/A, ").append(Long.toString(solvingTime));
    	} catch (Exception e){
    		fail(e.getMessage());
    	}
    }
}
