package com.dat3m.svcomp.options;

import static com.dat3m.dartagnan.analysis.AnalysisTypes.RACES;
import static com.dat3m.dartagnan.analysis.AnalysisTypes.REACHABILITY;
import java.util.Arrays;
import java.util.Set;
import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.DefaultParser;
import org.apache.commons.cli.Option;
import org.apache.commons.cli.ParseException;

import com.dat3m.dartagnan.analysis.AnalysisTypes;
import com.dat3m.dartagnan.utils.options.BaseOptions;
import com.google.common.collect.ImmutableSet;
import com.google.common.io.Files;

public class SVCOMPOptions extends BaseOptions {

    private Set<String> supported_formats = ImmutableSet.copyOf(Arrays.asList("c", "i"));
    private Set<String> supported_integer_encoding = ImmutableSet.copyOf(Arrays.asList("bit-vector","unbounded-integer","wrapped-integer"));
    private String encoding = "unbounded-integer";
    private String optimization = "O0";
    private boolean witness;
    private boolean incremental_solver;
    private AnalysisTypes analysis; 
    
    public SVCOMPOptions(){
        super();
        Option catOption = new Option("cat", true,
                "Path to the CAT file");
        catOption.setRequired(true);
        addOption(catOption);

        Option propOption = new Option("p", "property", true,
                "The path to the property to be checked");
        propOption.setRequired(true);
        addOption(propOption);

        addOption(new Option("incremental_solver", false,
        		"Use an incremental solver"));

        addOption(new Option("w", "witness", false,
                "Creates a machine readable witness"));
        
        addOption(new Option("o", "optimization", true,
                "Optimization flag for LLVM compiler"));

        addOption(new Option("e", "integer_encoding", true,
                "bit-vector=use SMT bit-vector theory, " + 
                "unbounded-integer=use SMT integer theory, " +
                "wrapped-integer=use SMT integer theory but model wrap-around behavior" + 
                " [default: unbounded-integer]"));
}
    
    public void parse(String[] args) throws ParseException, RuntimeException {
    	super.parse(args);
        if(supported_formats.stream().map(f -> programFilePath.endsWith(f)). allMatch(b -> b.equals(false))) {
            throw new RuntimeException("Unrecognized program format");
        }

    	CommandLine cmd = new DefaultParser().parse(this, args);
        if(cmd.hasOption("optimization")) {
        	optimization = cmd.getOptionValue("optimization");
        }
        if(cmd.hasOption("integer_encoding")) {
        	encoding = cmd.getOptionValue("integer_encoding");
        	if(!supported_integer_encoding.contains(encoding)) {
            	throw new UnsupportedOperationException("Unrecognized encoding " + encoding);        		
        	}
        }
        witness = cmd.hasOption("witness");
        incremental_solver = cmd.hasOption("incrementalSolver");
        
        String property = Files.getNameWithoutExtension(cmd.getOptionValue("property"));
        switch(property) {
			case "no-data-race":
				analysis = RACES;
				break;
			case "unreach-call":
				analysis = REACHABILITY;
				break;
			default:
				throw new UnsupportedOperationException("Unrecognized property " + property);
        }
    }

    public String getOptimization(){
        return optimization;
    }

    public String getEncoding(){
        return encoding;
    }

    public boolean useISolver(){
        return incremental_solver;
    }

    public boolean createWitness(){
        return witness;
    }

    public AnalysisTypes getAnalysis(){
		return analysis;
    }
}
