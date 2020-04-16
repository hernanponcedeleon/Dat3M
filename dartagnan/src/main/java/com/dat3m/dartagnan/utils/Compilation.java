package com.dat3m.dartagnan.utils;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public class Compilation {
	
	static List<String> libraries = Arrays.asList("smack.c", "stdlib.c", "errno.c");

	public static void compile(File file, String flag) throws IOException {
		List<String> cmds = new ArrayList<String>();
		List<String> bcFiles = new ArrayList<String>();
		String path = file.getAbsolutePath();
		String name = path.contains("_tmp") ? path.substring(path.lastIndexOf('/'), path.lastIndexOf('_')) : path.substring(path.lastIndexOf('/'), path.lastIndexOf('.'));

	    // Compile all files
        cmds.add("clang -c -Wall -Wno-everything -emit-llvm -" + flag + " -g -Xclang -disable-O0-optnone " + file.getAbsolutePath() + " -o ./output/" + name + ".bc");
        bcFiles.add("./output/" + name + ".bc");
        for(String library : libraries) {
        	String bfFile = library.substring(0, library.lastIndexOf('.')) + ".bc";
			cmds.add("clang -c -Wall -emit-llvm -O0 -g -Xclang -disable-O0-optnone -I ./include/ ./lib/" + library + " -o ./output/" + bfFile);
        	bcFiles.add("./output/" + bfFile);
        }
        // Link them into one
        cmds.add("llvm-link -o ./output/all.bc " + bcFiles.stream().collect(Collectors.joining(" ")));
        // Convert to BOOGIE
        cmds.add("llvm2bpl ./output/all.bc -bpl ./output/" + name + "-" + flag + ".bpl -warn-type silent -colored-warnings -source-loc-syms -entry-points main -mem-mod-impls");
        cmds.add("rm ./output/all.bc " + bcFiles.stream().collect(Collectors.joining(" ")));
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
