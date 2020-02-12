package com.dat3m.svcomp;

import static com.dat3m.dartagnan.utils.Compilation.compile;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Iterator;
import org.apache.commons.cli.HelpFormatter;

import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.svcomp.options.SVCOMPOptions;
import com.dat3m.svcomp.utils.SVCOMPSanitizer;
import com.dat3m.svcomp.utils.SVCOMPWitness;

public class SVCOMPRunner {

    public static void main(String[] args) {
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

        File file = new SVCOMPSanitizer(options.getProgramFilePath()).run(1);
		String path = file.getAbsolutePath();
		// File name contains "_tmp.c"
		String name = path.substring(path.lastIndexOf('/'), path.lastIndexOf('_'));
		String catPath = options.getTargetModelFilePath();
		Iterator<Integer> bounds = options.getBounds().iterator();
		int bound;
		String output = "UNKNOWN";
		while(output.equals("UNKNOWN") && bounds.hasNext()) {
			try {
				compile(file);
			} catch (IOException e1) {
				e1.printStackTrace();
			}
	        // If not removed here, file is not removed when we reach the timeout
	        // File can be safely deleted since it was created by the SVCOMPSanitizer 
	        // (it not the original C file) and we already created the Boogie file
	        file.delete();
			bound = bounds.next();
			try {
				Process proc = Runtime.getRuntime().exec("java -jar dartagnan/target/dartagnan-2.0.5-jar-with-dependencies.jar -i ./output/" + name + ".bpl -cat " + catPath + " -unroll " + bound);
				BufferedReader read = new BufferedReader(new InputStreamReader(proc.getInputStream()));
				try {
					proc.waitFor();
				} catch(InterruptedException e) {
					System.out.println(e.getMessage());
					System.exit(0);
				}
				while(read.ready()) {
					output = read.readLine();
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
	        file = new SVCOMPSanitizer(options.getProgramFilePath()).run(bound);
		}
		output = output.equals("UNKNOWN") ? "PASS" : output;
		System.out.println(output);
		
        if(options.getCreateWitness() && output.equals("FAIL")) {
			try {
				Program p = new ProgramParser().parse(file);
	            new SVCOMPWitness(p, options).write();;
			} catch (IOException e) {
				e.printStackTrace();
			}
        }
        file.delete();
        return;        	
    }
}
