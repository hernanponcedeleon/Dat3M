package com.dat3m.boogiesan;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.stream.Stream;

import org.apache.commons.cli.HelpFormatter;

public class BoogieSan {

    public static void main(String[] args) throws IOException {
    	
    	BoogieSanOptions options = new BoogieSanOptions();
        try {
            options.parse(args);
        }
        catch (Exception e){
            if(e instanceof UnsupportedOperationException){
                System.out.println(e.getMessage());
            }
            new HelpFormatter().printHelp("BoogieSAN", options);
            System.exit(1);
            return;
        }
        
        BufferedWriter writer = new BufferedWriter(new FileWriter(System.getenv().get("DAT3M_HOME") + "/output/boogieSan.bpl"));
        try (Stream<String> stream = Files.lines(Paths.get(options.getProgramFilePath()))) {
            stream.filter(s -> !skip(s)).forEach(s -> {
				try {
					writer.write(s + "\n");
				} catch (IOException ignore) {}
			});
        }
        writer.close();
    }
    
    private static boolean skip(String s) {
    	if(s.contains("assume") && s.contains("true;")) {
    		return true;
    	}
    	if(s.contains("boogie_si_record")) {
    		return true;
    	}
    	if(s.contains("warning: over-approximating bitwise operation")) {
    		return true;
    	}
    	return false;
    }
}
