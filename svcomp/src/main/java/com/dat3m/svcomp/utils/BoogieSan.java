package com.dat3m.svcomp.utils;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.stream.Stream;

public class BoogieSan {

    public static void write(String boogieFileName) {
    	String shortName = Paths.get(boogieFileName).getFileName().toString();
    	try {
    		shortName = shortName.substring(0, shortName.lastIndexOf("."));
            BufferedWriter writer = new BufferedWriter(new FileWriter(System.getenv("DAT3M_HOME") + "/output/" + shortName + "-sanitised.bpl"));
            try (Stream<String> stream = Files.lines(Paths.get(boogieFileName))) {
                stream.filter(s -> !skip(s)).forEach(s -> {
    					try {
    						writer.write(s + "\n");
    					} catch (IOException ignore) {}
    			});
            }    		        	
            writer.close();
    	} catch(Exception ignore) {}
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
