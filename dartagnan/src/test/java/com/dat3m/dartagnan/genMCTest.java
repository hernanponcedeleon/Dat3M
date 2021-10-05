package com.dat3m.dartagnan;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import static com.dat3m.dartagnan.utils.ResourceHelper.getCSVFileName;
import static com.dat3m.dartagnan.utils.ResourceHelper.initialiseCSVFile;
import static org.junit.Assert.fail;

@RunWith(Parameterized.class)
public class genMCTest {

	static final int TIMEOUT = 1800000;

    private final String path;

	@Parameterized.Parameters(name = "{index}: {0} target={2}")
    public static Iterable<Object[]> data() throws IOException {

    	// We want the files to be created every time we run the unit tests
        initialiseCSVFile(genMCTest.class, "genMC", "");

		List<Object[]> data = new ArrayList<>();

        data.add(new Object[]{System.getenv("DAT3M_HOME") + "/benchmarks/locks/ttas-5.c"});
        data.add(new Object[]{System.getenv("DAT3M_HOME") + "/benchmarks/locks/ttas-5-acq2rx.c"});
        data.add(new Object[]{System.getenv("DAT3M_HOME") + "/benchmarks/locks/ttas-5-rel2rx.c"});

        data.add(new Object[]{System.getenv("DAT3M_HOME") + "/benchmarks/locks/ticketlock-3.c"});
        data.add(new Object[]{System.getenv("DAT3M_HOME") + "/benchmarks/locks/ticketlock-3-acq2rx.c"});
        data.add(new Object[]{System.getenv("DAT3M_HOME") + "/benchmarks/locks/ticketlock-3-rel2rx.c"});

        data.add(new Object[]{System.getenv("DAT3M_HOME") + "/benchmarks/locks/mutex-3.c"});
        data.add(new Object[]{System.getenv("DAT3M_HOME") + "/benchmarks/locks/mutex-3-acq2rx-futex.c"});
        data.add(new Object[]{System.getenv("DAT3M_HOME") + "/benchmarks/locks/mutex-3-acq2rx-lock.c"});
        data.add(new Object[]{System.getenv("DAT3M_HOME") + "/benchmarks/locks/mutex-3-rel2rx-futex.c"});
        data.add(new Object[]{System.getenv("DAT3M_HOME") + "/benchmarks/locks/mutex-3-rel2rx-unlock.c"});

        data.add(new Object[]{System.getenv("DAT3M_HOME") + "/benchmarks/locks/spinlock-5.c"});
        data.add(new Object[]{System.getenv("DAT3M_HOME") + "/benchmarks/locks/spinlock-5-acq2rx.c"});
        data.add(new Object[]{System.getenv("DAT3M_HOME") + "/benchmarks/locks/spinlock-5-rel2rx.c"});
        
        data.add(new Object[]{System.getenv("DAT3M_HOME") + "/benchmarks/locks/linuxrwlock-3.c"});
        data.add(new Object[]{System.getenv("DAT3M_HOME") + "/benchmarks/locks/linuxrwlock-3-acq2rx.c"});
        data.add(new Object[]{System.getenv("DAT3M_HOME") + "/benchmarks/locks/linuxrwlock-3-rel2rx.c"});
        
        data.add(new Object[]{System.getenv("DAT3M_HOME") + "/benchmarks/locks/mutex_musl-3.c"});
        data.add(new Object[]{System.getenv("DAT3M_HOME") + "/benchmarks/locks/mutex_musl-3-acq2rx-futex.c"});
        data.add(new Object[]{System.getenv("DAT3M_HOME") + "/benchmarks/locks/mutex_musl-3-acq2rx-lock.c"});
        data.add(new Object[]{System.getenv("DAT3M_HOME") + "/benchmarks/locks/mutex_musl-3-rel2rx-futex.c"});
        data.add(new Object[]{System.getenv("DAT3M_HOME") + "/benchmarks/locks/mutex_musl-3-rel2rx-unlock.c"});

        return data;
    }

    public genMCTest(String path) {
        this.path = path;
    }

    @Test(timeout = TIMEOUT)
    public void test() {
    	String output = "";
    	ArrayList<String> cmd = new ArrayList<String>();
    	cmd.add("genmc");
    	cmd.add("-imm");
    	cmd.add(path);
    	ProcessBuilder processBuilder = new ProcessBuilder(cmd);
    	
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(getCSVFileName(getClass(), "genMC", ""), true)))
           {
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
	   			// Three times to match the other files where we have TSO, POWER and ARM
                String result = output.contains("violation") ? "FAIL" : "PASS";
                writer.append(path.substring(path.lastIndexOf("/") + 1)).append(", ")
          	  		  .append(result).append(", ")	
          	  		  .append(Long.toString(solvingTime));
	   			writer.newLine();
           } catch (Exception e){
               fail(e.getMessage());
           }
        try {
		} catch(Exception e) {
			System.out.println(e.getMessage());
			System.exit(0);
		}
    }
}