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
import com.dat3m.dartagnan.utils.ExitCode;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.EnumSet;
import java.util.stream.Collectors;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import static com.dat3m.dartagnan.configuration.OptionInfo.collectOptions;
import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.witness.graphml.GraphAttributes.UNROLLBOUND;
import static java.lang.Integer.parseInt;
import static com.dat3m.dartagnan.utils.ExitCode.*;

@Options
public class SVCOMPRunner extends BaseOptions {

    private static final Logger logger = LogManager.getLogger(SVCOMPRunner.class);

    private EnumSet<Property> property;
    
    @Option(
        name= PROPERTYPATH,
        required=true,
        description="The path to the property to be checked.")
    private void property(String p) {
        // TODO process the property file instead of assuming its contents based of its name
        // We always enable PROGRAM_SPEC to detect calls to unknown functions.
        // DRF and termination use --program.processing.skipAssertionsOfType=USER to avoid reporting safety problems
        if(p.contains("no-data-race")) {
            property = EnumSet.of(Property.DATARACEFREEDOM, Property.PROGRAM_SPEC);
        } else if(p.contains("termination")) {
            property = EnumSet.of(Property.TERMINATION, Property.PROGRAM_SPEC);
        } else if(p.contains("unreach-call") || p.contains("no-overflow") || p.contains("valid-memsafety")) {
            property = EnumSet.of(Property.PROGRAM_SPEC);
        } else {
            throw new IllegalArgumentException("Unrecognized property " + p);
        }
    }

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
        // To be sure we do not mixed benchmarks, if the bounds file exists, delete it
        final String boundsFilePath = System.getenv("DAT3M_OUTPUT") + "/bounds.csv";
        new File(boundsFilePath).delete();

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
                System.out.println("The witness was generated from a different program than " + fileProgram);
                System.exit(WRONG_WITNESS_FILE.asInt());
            }
        }

        int bound = witness.hasAttributed(UNROLLBOUND.toString()) ? parseInt(witness.getAttributed(UNROLLBOUND.toString())) : 1;

        String result = "UNKNOWN";
        while(result.contains("UNKNOWN")) {
            ArrayList<String> cmd = new ArrayList<>();
            cmd.add("java");
            cmd.add("-DlogLevel=info");
            cmd.add("-DLOGNAME=" + Files.getNameWithoutExtension(programPath));
            cmd.addAll(Arrays.asList("-jar", System.getenv().get("DAT3M_HOME") + "/dartagnan/target/dartagnan.jar"));
            cmd.add(fileModel.toString());
            cmd.add(programPath);
            cmd.add("svcomp.properties");
            cmd.add("--bound.load=" + boundsFilePath);
            cmd.add("--bound.save=" + boundsFilePath);
            cmd.add(String.format("--%s=%s", PROPERTY, r.property.stream().map(Enum::name).collect(Collectors.joining(","))));
            cmd.add(String.format("--%s=%s", BOUND, bound));
            cmd.add(String.format("--%s=%s", WITNESS_ORIGINAL_PROGRAM_PATH, programPath));
            cmd.addAll(filterOptions(config));

            ProcessBuilder processBuilder = new ProcessBuilder(cmd);
            try {
                Process proc = processBuilder.start();
                BufferedReader read = new BufferedReader(new InputStreamReader(proc.getInputStream()));
                proc.waitFor();
                while(read.ready()) {
                    String next = read.readLine();
                    if(next.contains("Result:")) {
                        result = next.substring(next.indexOf(' ') + 1);
                    }
                    System.out.println(next);
                }
            } catch(Exception e) {
                System.out.println(e.getMessage());
                System.exit(0);
            }
        }
    }
    
    private static List<String> filterOptions(Configuration config) {
    	
        List<String> skip = Arrays.asList(PROPERTYPATH);
    	
        return Arrays.stream(config.asPropertiesString().split("\n")).
            filter(p -> skip.stream().noneMatch(s -> s.equals(p.split(" = ")[0]))).
            map(p -> "--" + p.split(" = ")[0] + "=" + p.split(" = ")[1]).
            collect(Collectors.toList());
    }
    
}