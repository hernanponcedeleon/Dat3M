package com.dat3m.dartagnan.utils.options;

import com.dat3m.dartagnan.analysis.Analysis;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;
import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.DefaultParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Option;
import org.apache.commons.cli.ParseException;

import java.util.Arrays;
import java.util.Comparator;
import java.util.Set;
import java.util.stream.Collectors;

public class DartagnanOptions extends BaseOptions {

	public static final String ANALYSIS_OPTION = "analysis";
	public static final String WITNESS_OPTION = "create_witness";
	public static final String WITNESS_PATH_OPTION = "witness";

    private final Set<String> supportedFormats = 
    		ImmutableSet.copyOf(Arrays.asList("litmus", "bpl", "c", "i"));

    private final Set<String> supportedAnalyses =
    		ImmutableSet.copyOf(Arrays.stream(Analysis.values())
            .sorted(Comparator.comparing(Analysis::toString))
            .map(Analysis::asStringOption)
    		.collect(Collectors.toList()));

    private Analysis analysis;
    private String witness;
    private String witnessFilePath;

    private DartagnanOptions(){
        super();
        Option catOption = new Option("cat", true,
                "Path to the CAT file");
        catOption.setRequired(true);
        addOption(catOption);

        addOption(new Option("w", WITNESS_OPTION, true,
                "Creates a machine readable witness. "
                + "The argument is the original *.c file from which the Boogie code was generated."));

        addOption(new Option("a", ANALYSIS_OPTION, true,
        		"The analysis to be performed: " + supportedAnalyses));
        
        addOption(new Option(WITNESS_PATH_OPTION, true,
        		"Path to the machine readable witness file."));
        }
    
    public static DartagnanOptions fromArgs(String[] args) {
        DartagnanOptions options = new DartagnanOptions();
        try {
            options.parse(args);
        }
        catch (Exception e){
            if(e instanceof UnsupportedOperationException){
                System.out.println(e.getMessage());
            }
            new HelpFormatter().printHelp("DARTAGNAN", options);
            System.exit(1);
        }
        return options;
    }
    
    protected void parse(String[] args) throws ParseException, RuntimeException {
    	super.parse(args);
    	Preconditions.checkArgument(supportedFormats.stream().anyMatch(f -> programFilePath.endsWith(f)), "Unrecognized program format");
        CommandLine cmd = new DefaultParser().parse(this, args);
        analysis = Analysis.get(cmd.getOptionValue(ANALYSIS_OPTION, Analysis.getDefault().asStringOption()));
        witness = cmd.hasOption(WITNESS_OPTION) ? cmd.getOptionValue(WITNESS_OPTION) : null;
        witnessFilePath = cmd.hasOption(WITNESS_PATH_OPTION) ? cmd.getOptionValue(WITNESS_PATH_OPTION) : null;
    }
    
    public Analysis getAnalysis(){
		return analysis;
    }

    public String createWitness(){
        return witness;
    }

    public String getWitnessPath() {
        return witnessFilePath;
    }
}
