package com.dat3m.svcomp.options;

import static com.dat3m.dartagnan.analysis.AnalysisTypes.RACES;
import static com.dat3m.dartagnan.analysis.AnalysisTypes.REACHABILITY;
import static com.dat3m.dartagnan.analysis.AnalysisTypes.TERMINATION;
import static com.dat3m.dartagnan.analysis.AnalysisTypes.fromString;
import static java.util.stream.IntStream.rangeClosed;

import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.DefaultParser;
import org.apache.commons.cli.Option;
import org.apache.commons.cli.ParseException;

import com.dat3m.dartagnan.analysis.AnalysisTypes;
import com.dat3m.dartagnan.utils.options.BaseOptions;
import com.google.common.collect.ImmutableSet;

public class SVCOMPOptions extends BaseOptions {

    protected Set<String> supportedFormats = ImmutableSet.copyOf(Arrays.asList("c", "i")); 
    protected List<Integer> bounds = rangeClosed(1, 10000).boxed().collect(Collectors.toList());
    protected String optimization = "O0";
    protected boolean witness;
    protected String overApproxFilePath;
    protected boolean bp;
    protected boolean iSolver;
    private Set<AnalysisTypes> analyses = ImmutableSet.copyOf(Arrays.asList(REACHABILITY, RACES, TERMINATION));
    private AnalysisTypes analysis = REACHABILITY; 
    
    public SVCOMPOptions(){
        super();
        Option catOption = new Option("cat", true,
                "Path to the CAT file");
        catOption.setRequired(true);
        addOption(catOption);

        addOption(new Option("analysis", true,
                "The analysis to be performed: reachability (default), data-race detection, termination"));
        
        addOption(new Option("incrementalSolver", false,
        		"Use an incremental solver"));

        addOption(new Option("w", "witness", false,
                "Creates a violation witness"));
        
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
        if(cmd.hasOption("analysis")) {
        	AnalysisTypes selectedAnalysis = fromString(cmd.getOptionValue("analysis"));
        	if(!analyses.contains(selectedAnalysis)) {
        		throw new RuntimeException("Unrecognized analysis");
        	}
        	analysis = selectedAnalysis;
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

    public List<Integer> getBounds() {
        return bounds;
    }
}
