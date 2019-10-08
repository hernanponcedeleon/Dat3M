package com.dat3m.svcomp;

import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.fromString;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;

import org.apache.commons.cli.HelpFormatter;
import com.dat3m.dartagnan.parsers.boogie.C2BoogieRunner;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.svcomp.options.SVCOMPOptions;
import com.dat3m.svcomp.utils.SVCOMPSanitizer;
import com.dat3m.svcomp.utils.SVCOMPWitness;

public class SVCOMPRunner {

    public static void main(String[] args) throws IOException {
    	SVCOMPOptions options = new SVCOMPOptions();
        try {
            options.parse(args);
        }
        catch (Exception e){
            if(e instanceof UnsupportedOperationException){
                System.out.println(e.getMessage());
            }
            new HelpFormatter().printHelp("SVCOMP Runner", options);
            System.exit(1);
            return;
        }

		String programFilePath = new C2BoogieRunner(new SVCOMPSanitizer(options.getProgramFilePath()).run(1)).run();
       	File file = new File(programFilePath);
       	
		String tool = "java -Djava.library.path=./lib/ -jar dartagnan/target/dartagnan-2.0.4-jar-with-dependencies.jar";
		String program = " -i " + file.getAbsolutePath();
		String cat = " -cat cat/svcomp.cat";
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
			programFilePath = new C2BoogieRunner(new SVCOMPSanitizer(options.getProgramFilePath()).run(bound)).run();
	       	file = new File(programFilePath);
		}
		Result result = fromString(output);
		System.out.println(result);
		
        if(options.getCreateWitness() && result.equals(FAIL)) {
        	Program p = new ProgramParser().parse(new File(programFilePath));
            new SVCOMPWitness(p, options).write();;
        }
        file.delete();
        return;        	
    }
}
