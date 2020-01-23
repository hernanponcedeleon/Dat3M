package com.dat3m.svcomp;

import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.fromString;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.cli.HelpFormatter;

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

        File file = new SVCOMPSanitizer(options.getProgramFilePath()).run(1);
        
		int bound = 0;

		String output = "UNKNOWN";

		while(output.equals("UNKNOWN")) {
	        compile(file);
			bound++;
			try {
				Process proc = Runtime.getRuntime().exec("java -jar dartagnan/target/dartagnan-2.0.5-jar-with-dependencies.jar -i ./output/input.bpl -cat cat/svcomp.cat -t none -unroll " + bound);
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
		Result result = fromString(output);
		System.out.println(result);
		
        if(options.getCreateWitness() && result.equals(FAIL)) {
        	Program p = new ProgramParser().parse(file);
            new SVCOMPWitness(p, options).write();;
        }
        file.delete();
        return;        	
    }

	private static void compile(File file) throws IOException {
		List<String> cmds = new ArrayList<String>();
	    // Compile all files
        cmds.add("clang -c -Wall -Wno-everything -emit-llvm -O0 -g -Xclang -disable-O0-optnone " + file.getAbsolutePath() + " -o ./output/input.bc");
        cmds.add("clang -c -Wall -emit-llvm -O0 -g -Xclang -disable-O0-optnone -I ./include/ ./lib/smack.c -o ./output/smack.bc");
        cmds.add("clang -c -Wall -emit-llvm -O0 -g -Xclang -disable-O0-optnone -I ./include/ ./lib/stdlib.c -o ./output/std.bc");
        cmds.add("clang -c -Wall -emit-llvm -O0 -g -Xclang -disable-O0-optnone -I ./include/ ./lib/errno.c -o ./output/error.bc");
        // Link them into one
        cmds.add("llvm-link -o ./output/all.bc ./output/input.bc ./output/smack.bc ./output/std.bc ./output/error.bc");
        cmds.add("rm ./output/input.bc ./output/smack.bc ./output/std.bc ./output/error.bc");
        // Convert to BOOGIE
        cmds.add("llvm2bpl ./output/all.bc -bpl ./output/input.bpl -warn-type silent -colored-warnings -source-loc-syms -entry-points main -mem-mod-impls");
        cmds.add("rm ./output/all.bc");
        for(String cmd : cmds) {
        	Process proc = Runtime.getRuntime().exec(cmd);
			try {
				proc.waitFor();
			} catch(InterruptedException e) {
				System.out.println(e.getMessage());
				System.exit(0);
			}
        }
	}
}
