package com.dat3m.svcomp;

import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.DefaultParser;
import org.apache.commons.cli.ParseException;

import com.dat3m.dartagnan.parsers.boogie.C2BoogieRunner;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.svcomp.options.SVCOMPOptions;
import com.dat3m.svcomp.utils.SVCOMPSanitizer;
import com.dat3m.svcomp.utils.SVCOMPWitness;

public class SVCOMPRunner {

    public static void main(String[] args) throws IOException {
		try {
			CommandLine cmd = new DefaultParser().parse(new SVCOMPOptions(), args);
	        String programFilePath = cmd.getOptionValue("input");
	    	
			programFilePath = new C2BoogieRunner(new SVCOMPSanitizer(programFilePath).run(1)).run();

	       	File file = new File(programFilePath);
	       	
			String tool = "java -Djava.library.path=./lib/ -jar dartagnan/target/dartagnan-2.0.4-jar-with-dependencies.jar";
			String program = " -i " + file.getAbsolutePath();
			String cat = " -cat cat/sc.cat";
			String compile = " -t none ";
			int bound = 1;

			String output = "UNKNOWN";

			while(output.equals("UNKNOWN")) {
				try {
					String exec = tool + program + cat + compile + " -unroll " + bound;
					Process proc = Runtime.getRuntime().exec(exec);
					BufferedReader read = new BufferedReader(new InputStreamReader(proc.getInputStream()));
					try {
						proc.waitFor();
					} catch(InterruptedException e) {
						System.out.println(e.getMessage());
						System.exit(0);
					}
					while(read.ready()) {
						output = read.readLine();
						bound++;
					}
					if(proc.exitValue() == 1) {
						BufferedReader error = new BufferedReader(new InputStreamReader(proc.getErrorStream()));
						while(error.ready()) {
							System.out.println(error.readLine());
						}
						System.exit(0);
					}
				} catch(IOException e) {
					System.out.println(e.getMessage());
					System.exit(0);
				}			
			}
			Result result = output.equals("FAIL") ? FAIL : PASS;
			System.out.println(result);
			
	        if(result.equals(FAIL)) {
	        	Program p = new ProgramParser().parse(new File(programFilePath));
	            //new SVCOMPWitness(p, options).write();;
	        }
		} catch (ParseException e) {
			e.printStackTrace();
		}
        return;        	
    }
}
