package com.dat3m.svcomp;

import com.dat3m.dartagnan.parsers.witness.ParserWitness;
import com.dat3m.dartagnan.utils.options.BaseOptions;
import com.dat3m.dartagnan.witness.graphml.WitnessGraph;
import com.dat3m.dartagnan.configuration.Property;
import com.google.common.collect.ImmutableSet;
import com.google.common.io.Files;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import static com.dat3m.dartagnan.configuration.OptionInfo.collectOptions;
import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.parsers.program.utils.Compilation.*;
import static com.dat3m.dartagnan.witness.WitnessType.GRAPHML;
import static com.dat3m.dartagnan.witness.graphml.GraphAttributes.UNROLLBOUND;
import static java.lang.Integer.parseInt;

@Options
public class SVCOMPRunner extends BaseOptions {

    private static final Logger logger = LogManager.getLogger(SVCOMPRunner.class);

    private Property property;
    
    @Option(
        name= PROPERTYPATH,
        required=true,
        description="The path to the property to be checked.")
    private void property(String p) {
        //TODO process the property file instead of assuming its contents based of its name
        if(p.contains("no-data-race")) {
            property = Property.DATARACEFREEDOM;
        } else if(p.contains("unreach-call") || p.contains("no-overflow") || p.contains("valid-memsafety")) {
            property = Property.PROGRAM_SPEC;
        } else {
            throw new IllegalArgumentException("Unrecognized property " + p);
        }
    }

    @Option(
        name=UMIN,
        description="Starting unrolling bound <integer>.")
    private int umin = 1;

    @Option(
        name=UMAX,
        description="Ending unrolling bound <integer>.")
    private int umax = Integer.MAX_VALUE;

    @Option(
        name=STEP,
        description="Step size for the increasing unrolling bound <integer>.")
    private int step = 1;

    @Option(
        name=VALIDATE,
        description="Run Dartagnan as a violation witness validator. Argument is the path to the witness file.")
    private String witnessPath;

    private static final Set<String> supportedFormats = 
        ImmutableSet.copyOf(Arrays.asList(".c", ".i"));

    public static void main(String[] args) throws Exception {

        if(Arrays.asList(args).contains("--help")) {
            collectOptions();
            return;
        }

        if(Arrays.stream(args).noneMatch(a -> supportedFormats.stream().anyMatch(a::endsWith))) {
            throw new IllegalArgumentException("Input program not given or format not recognized");
        }
        if(Arrays.stream(args).noneMatch(a -> a.endsWith(".cat"))) {
            throw new IllegalArgumentException("CAT model not given or format not recognized");
        }
        File fileModel = new File(Arrays.stream(args).filter(a -> a.endsWith(".cat")).findFirst().get());
        String programPath = Arrays.stream(args).filter(a -> supportedFormats.stream().anyMatch(a::endsWith)).findFirst().get();
        File fileProgram = new File(programPath);

        String[] argKeyword = Arrays.stream(args)
            .filter(s->s.startsWith("-"))
            .toArray(String[]::new);
        Configuration config = Configuration.fromCmdLineArguments(argKeyword);
        SVCOMPRunner r = new SVCOMPRunner();
        config.recursiveInject(r);

        if(r.property == null) {
            logger.warn("Unrecognized property");
            System.out.println("UNKNOWN");
            return;
        }

        WitnessGraph witness = new WitnessGraph(); 
        if(r.witnessPath != null) {
            witness = new ParserWitness().parse(new File(r.witnessPath));
            if(!fileProgram.getName().equals(Paths.get(witness.getProgram()).getFileName().toString())) {
                throw new RuntimeException("The witness was generated from a different program than " + fileProgram);
            }
        }

        int bound = witness.hasAttributed(UNROLLBOUND.toString()) ? parseInt(witness.getAttributed(UNROLLBOUND.toString())) : r.umin;

        File file;
        String output = "UNKNOWN";
        while(output.equals("UNKNOWN")) {
            file = compileWithClang(fileProgram, "");
            file = applyLlvmPasses(file);    

            String llvmName = System.getenv().get("DAT3M_HOME") + "/output/" + Files.getNameWithoutExtension(programPath) + "-opt.ll";
	        
            ArrayList<String> cmd = new ArrayList<>();
            cmd.add("java");
            cmd.add("-Dlog4j.configurationFile=" + System.getenv().get("DAT3M_HOME") + "/dartagnan/src/main/resources/log4j2.xml");
            cmd.add("-DLOGNAME=" + Files.getNameWithoutExtension(programPath));
            cmd.addAll(Arrays.asList("-jar", System.getenv().get("DAT3M_HOME") + "/dartagnan/target/dartagnan.jar"));
            cmd.add(fileModel.toString());
            cmd.add(llvmName);
            cmd.add(String.format("--%s=%s", PROPERTY, r.property.asStringOption()));
            cmd.add(String.format("--%s=%s", BOUND, bound));
            cmd.add(String.format("--%s=%s", WITNESS, GRAPHML.asStringOption()));
            cmd.add(String.format("--%s=%s", WITNESS_ORIGINAL_PROGRAM_PATH, programPath));
            cmd.addAll(filterOptions(config));

            ProcessBuilder processBuilder = new ProcessBuilder(cmd);
            try {
                Process proc = processBuilder.start();
                BufferedReader read = new BufferedReader(new InputStreamReader(proc.getInputStream()));
                proc.waitFor();
                while(read.ready()) {
                    String next = read.readLine();
                    // This is now the last line in the console.
                    // We avoid updating the output
                    if(next.contains("Total verification time:")) {
                        break;
                    }
                    output = next;
                    System.out.println(output);
                }
                if(proc.exitValue() == 1) {
                    BufferedReader error = new BufferedReader(new InputStreamReader(proc.getErrorStream()));
                    while(error.ready()) {
                        System.out.println(error.readLine());
                    }
                    System.exit(0);
                }
            } catch(Exception e) {
                System.out.println(e.getMessage());
                System.exit(0);
            }
            if(bound > r.umax) {
                System.out.println("PASS");
                break;
            }
            // We always do iterations 1 and 2 and then use the step
            bound = bound == 1 ? 2 : bound + r.step;
        }
    }
    
    private static List<String> filterOptions(Configuration config) {
    	
        // BOUND is computed based on umin and the information from the witness
        List<String> skip = Arrays.asList(PROPERTYPATH, UMIN, UMAX, STEP, BOUND);
    	
        return Arrays.stream(config.asPropertiesString().split("\n")).
            filter(p -> skip.stream().noneMatch(s -> s.equals(p.split(" = ")[0]))).
            map(p -> "--" + p.split(" = ")[0] + "=" + p.split(" = ")[1]).
            collect(Collectors.toList());
    }
    
}