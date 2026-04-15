package com.dat3m.svcomp;

import com.dat3m.dartagnan.Dartagnan;
import com.dat3m.dartagnan.utils.options.BaseOptions;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.utils.ExitCode;

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
import java.util.EnumSet;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.utils.ExitCode.*;

@Options
public class SVCOMPRunner extends BaseOptions {

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
        } else if(p.contains("valid-memsafety")) {
            property = EnumSet.of(Property.TRACKABILITY, Property.PROGRAM_SPEC);
        } else if(p.contains("unreach-call") || p.contains("no-overflow")) {
            property = EnumSet.of(Property.PROGRAM_SPEC);
        } else {
            throw new IllegalArgumentException("Unrecognized property " + p);
        }
    }

    @Option(
        name=NATIVE,
        description="Run Dartagnan in native mode rather than using the JVM.")
    private boolean nativeExecution = true;

    private static final Set<String> supportedFormats = 
        ImmutableSet.copyOf(Arrays.asList(".c", ".i"));

    public static void main(String[] args) throws Exception {

        if(Arrays.asList(args).contains("--help")) {
            Dartagnan.printOptions();
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
            System.out.println("UNKNOWN");
            return;
        }

        int exitCode = ExitCode.BOUNDED_RESULT.asInt();
        while(exitCode == ExitCode.BOUNDED_RESULT.asInt()) {
            ArrayList<String> cmd = new ArrayList<>();
            if (r.nativeExecution) {
                cmd.add(System.getenv().get("DAT3M_HOME") + "/dartagnan/target/dartagnan");
                cmd.add("-DlogLevel=INFO");
                cmd.add("-DLOGNAME=" + Files.getNameWithoutExtension(programPath));
                cmd.add("-Djava.library.path=" + System.getenv().get("DAT3M_HOME") + "/dartagnan/target/libs/");
            } else {
                cmd.add("java");
                cmd.add("-DlogLevel=info");
                cmd.add("-DLOGNAME=" + Files.getNameWithoutExtension(programPath));
                cmd.add("-jar");
                cmd.add(System.getenv().get("DAT3M_HOME") + "/dartagnan/target/dartagnan.jar");
            }
            cmd.add(fileModel.toString());
            cmd.add(programPath);
            cmd.add("svcomp.properties");
            cmd.add("--bound.load=" + boundsFilePath);
            cmd.add("--bound.save=" + boundsFilePath);
            cmd.add(String.format("--%s=%s", PROPERTY, r.property.stream().map(Enum::name).collect(Collectors.joining(","))));
            cmd.addAll(filterOptions(config));

            ProcessBuilder processBuilder = new ProcessBuilder(cmd);
            try {
                Process proc = processBuilder.start();
                BufferedReader read = new BufferedReader(new InputStreamReader(proc.getInputStream()));
                exitCode = proc.waitFor();
                if (exitCode == ExitCode.UNKNOWN_ERROR.asInt()) {
                    System.out.println("Unknown error in dartagnan");
                    System.exit(0);
                }
                if (isExternalError(exitCode)) { // E.g., SMT solver crash
                    System.out.println("Unknown external error");
                    System.exit(0);
                }
                while(read.ready()) {
                    System.out.println(read.readLine());
                }
            } catch(Exception e) {
                System.out.println(e.getMessage());
                System.exit(0);
            }
        }
    }
    
    private static boolean isExternalError(int exitCode) {
        return Arrays.stream(ExitCode.values())
                    .mapToInt(ExitCode::asInt)
                    .noneMatch(code -> code == exitCode);
    }

    private static List<String> filterOptions(Configuration config) {
        List<String> skip = Arrays.asList(PROPERTYPATH, NATIVE);

        return Arrays.stream(config.asPropertiesString().split("\n")).
            filter(p -> skip.stream().noneMatch(s -> s.equals(p.split(" = ")[0]))).
            map(p -> "--" + p.split(" = ")[0] + "=" + p.split(" = ")[1]).
            collect(Collectors.toList());
    }
    
}