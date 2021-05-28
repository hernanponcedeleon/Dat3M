package com.dat3m.svcomp.options;

import static com.dat3m.dartagnan.analysis.AnalysisTypes.RACES;
import static com.dat3m.dartagnan.analysis.AnalysisTypes.REACHABILITY;
import static com.dat3m.dartagnan.analysis.SolverTypes.TWO;
import static com.dat3m.dartagnan.analysis.SolverTypes.fromString;

import java.util.Arrays;
import java.util.Set;
import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.DefaultParser;
import org.apache.commons.cli.Option;
import org.apache.commons.cli.ParseException;

import com.dat3m.dartagnan.analysis.AnalysisTypes;
import com.dat3m.dartagnan.analysis.SolverTypes;
import com.dat3m.dartagnan.utils.options.BaseOptions;
import com.google.common.collect.ImmutableSet;
import com.google.common.io.Files;

public class SVCOMPOptions extends BaseOptions {

	private static final String PROPERTY_OPTION = "property";
	private static final String SOLVER_OPTION = "solver";
	private static final String WITNESS_PATH_OPTION = "witness";
	private static final String OPTIMIZATION_OPTION = "optimization";
	private static final String INTERGER_ENCODING_OPTION = "integer_encoding";
	private static final String BOOGIESAN = "sanitise";
	
    private Set<String> supported_formats = ImmutableSet.copyOf(Arrays.asList("c", "i"));
    private Set<String> supported_integer_encoding = ImmutableSet.copyOf(Arrays.asList("bit-vector","unbounded-integer","wrapped-integer"));
    private Set<SolverTypes> supported_solvers = ImmutableSet.copyOf(Arrays.asList(SolverTypes.values()));
    private String encoding;
    private String optimization;
    private SolverTypes solver;
    private AnalysisTypes analysis;
    private String witnessFilePath;
    private boolean boogiesan;
    
    public SVCOMPOptions(){
        super();
        Option catOption = new Option("cat", true,
                "Path to the CAT file");
        catOption.setRequired(true);
        addOption(catOption);

        Option propOption = new Option("p", PROPERTY_OPTION, true,
                "The path to the property to be checked");
        propOption.setRequired(true);
        addOption(propOption);

        addOption(new Option(WITNESS_PATH_OPTION, true,
                "Run Dartagnan as a violation witness validator. Argument is the path to the witness file"));

        addOption(new Option(SOLVER_OPTION, true,
        		"The solver method to be used: two (default), incremental, assume"));

        addOption(new Option("o", OPTIMIZATION_OPTION, true,
                "Optimization flag for LLVM compiler"));

        addOption(new Option("e", INTERGER_ENCODING_OPTION, true,
                "bit-vector=use SMT bit-vector theory, " + 
                "unbounded-integer=use SMT integer theory, " +
                "wrapped-integer=use SMT integer theory but model wrap-around behavior" + 
                " [default: unbounded-integer]"));

        addOption(new Option(BOOGIESAN, false,
                "Generates (also) a sanitised boogie file saved as /output/boogiesan.bpl"));
}
    
    public void parse(String[] args) throws ParseException, RuntimeException {
    	super.parse(args);
        if(supported_formats.stream().map(f -> programFilePath.endsWith(f)). allMatch(b -> b.equals(false))) {
            throw new RuntimeException("Unrecognized program format");
        }

    	CommandLine cmd = new DefaultParser().parse(this, args);
        
    	optimization = cmd.hasOption(OPTIMIZATION_OPTION) ? cmd.getOptionValue(OPTIMIZATION_OPTION) : "O0";
        witnessFilePath = cmd.hasOption(WITNESS_PATH_OPTION) ? cmd.getOptionValue(WITNESS_PATH_OPTION) : null;
        boogiesan = cmd.hasOption(BOOGIESAN);
        
        solver = cmd.hasOption(SOLVER_OPTION) ? fromString(cmd.getOptionValue(SOLVER_OPTION)) : TWO;
        if(!supported_solvers.contains(solver)) {
            throw new UnsupportedOperationException("Unrecognized solver method: " + solver);        		
        }
        
        encoding = cmd.hasOption(INTERGER_ENCODING_OPTION) ? cmd.getOptionValue(INTERGER_ENCODING_OPTION) : "unbounded-integer";
        if(!supported_integer_encoding.contains(encoding)) {
            throw new UnsupportedOperationException("Unrecognized encoding: " + encoding);        		
        }
        
        String property = Files.getNameWithoutExtension(cmd.getOptionValue(PROPERTY_OPTION));
        switch(property) {
			case "no-data-race":
				analysis = RACES;
				break;
			case "unreach-call":
				analysis = REACHABILITY;
				break;
			default:
				throw new UnsupportedOperationException("Unrecognized property: " + property);
        }
    }

    public String getOptimization(){
        return optimization;
    }

    public String getEncoding(){
        return encoding;
    }

    public String getWitnessPath(){
        return witnessFilePath;
    }

    public SolverTypes getSolver(){
        return solver;
    }

    public AnalysisTypes getAnalysis(){
		return analysis;
    }

    public boolean getBoogieSan(){
		return boogiesan;
    }
}
