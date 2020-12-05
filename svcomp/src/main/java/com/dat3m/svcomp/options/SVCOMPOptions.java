package com.dat3m.svcomp.options;

import static com.dat3m.dartagnan.analysis.AnalysisTypes.RACES;
import static com.dat3m.dartagnan.analysis.AnalysisTypes.REACHABILITY;
import static com.dat3m.dartagnan.analysis.AnalysisTypes.TERMINATION;
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

    protected Set<String> supportedFormats = ImmutableSet.copyOf(Arrays.asList("c", "i")); 
    protected String optimization = "O0";
    protected boolean witness;
    protected boolean bp;
    protected boolean iSolver;
    private AnalysisTypes analysis; 
    
    public SVCOMPOptions(){
        super();
        Option catOption = new Option("cat", true,
                "Path to the CAT file");
        catOption.setRequired(true);
        addOption(catOption);

        Option propOption = new Option("property", true,
                "The path to the property to be checked");
        propOption.setRequired(true);
        addOption(propOption);

        addOption(new Option("incrementalSolver", false,
        		"Use an incremental solver"));

        addOption(new Option("w", "witness", false,
                "Creates a machine readable witness"));
        
        addOption(new Option("o", "optimization", true,
                "Optimization flag for LLVM compiler"));
        
        addOption(new Option("bp", "bit-precise", false,
                "Use bit precise encoding"));
}
    
    public void parse(String[] args) throws ParseException, RuntimeException {
    	super.parse(args);
        if(supportedFormats.stream().map(f -> programFilePath.endsWith(f)). allMatch(b -> b.equals(false))) {
            throw new RuntimeException("Unrecognized program format");
        }

    	CommandLine cmd = new DefaultParser().parse(this, args);
        if(cmd.hasOption("optimization")) {
        	optimization = cmd.getOptionValue("optimization");
        }
        witness = cmd.hasOption("witness");
        iSolver = cmd.hasOption("incrementalSolver");
        bp = cmd.hasOption("bit-precise");
        
        String property = Files.getNameWithoutExtension(cmd.getOptionValue("property"));
        switch(property) {
			case "no-data-race":
				analysis = RACES;
				break;
			case "termination":
				analysis = TERMINATION;
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

    public boolean useISolver(){
        return iSolver;
    }

    public boolean createWitness(){
        return witness;
    }

    public boolean useBP(){
        return bp;
    }

    public AnalysisTypes getAnalysis(){
		return analysis;
    }
}
