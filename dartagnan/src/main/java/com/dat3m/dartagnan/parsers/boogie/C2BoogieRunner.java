package com.dat3m.dartagnan.parsers.boogie;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class C2BoogieRunner {

	String filePath;
	
	public C2BoogieRunner(String filePath) {
		this.filePath = filePath;
	}

	public String run() {
		String tool = "smack";
		String input = filePath;
		String output = filePath.split(".c", -1)[0] + ".bpl";				
		String exec = tool +" " + input + " -bpl " + output + " -t";

		try {
			Process proc = Runtime.getRuntime().exec(exec);
			BufferedReader read = new BufferedReader(new InputStreamReader(proc.getInputStream()));
			try {
				proc.waitFor();
			} catch(InterruptedException e) {
				System.out.println(e.getMessage());
				System.exit(0);
			}
			while(read.ready()) {
				System.out.println(read.readLine());
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
		return output;
	}
}
