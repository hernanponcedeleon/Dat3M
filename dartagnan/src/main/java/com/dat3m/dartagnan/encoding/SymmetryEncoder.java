package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.analysis.ThreadSymmetry;
import com.dat3m.dartagnan.utils.equivalence.EquivalenceClass;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.BooleanFormula;

import java.util.Comparator;
import java.util.Set;

import static com.dat3m.dartagnan.configuration.OptionNames.BREAK_SYMMETRY_ON;

@Options
public class SymmetryEncoder {

    private static final Logger logger = LoggerFactory.getLogger(SymmetryEncoder.class);

    private static final String CO = "co";
    private static final String CF = "cf";

    private final EncodingContext context;

    @Option(name = BREAK_SYMMETRY_ON,
            description = """
                    The target to break symmetry on. Allowed options are:
                    - "co" to break symmetry on the coherence order of symmetric stores (see CoSymmetryBreaking).
                    - "cf" to break symmetry on the control flow (see CfSymmetryBreaking).
                    - The empty string to disable symmetry breaking.""",
            secure = true)
    private String symmBreakTarget = "";

    // =====================================================================

    private SymmetryEncoder(EncodingContext c, Configuration config) throws InvalidConfigurationException {
        context = c;
        config.inject(this);

        switch (symmBreakTarget) {
            case "" -> logger.info("Symmetry breaking disabled.");
            case CO -> logger.info("Breaking symmetry on coherence.");
            case CF -> {
                logger.info("Breaking symmetry on control flow.");
                c.getAnalysisContext().requires(BranchEquivalence.class);
            }
            default -> throw new InvalidConfigurationException(String.format(
                    "Unknown value \"%s\" for option %s. Allowed values are \"%s\", \"%s\", and \"\".",
                    symmBreakTarget, BREAK_SYMMETRY_ON, CO, CF));
        }
    }

    public static SymmetryEncoder withContext(EncodingContext context) throws InvalidConfigurationException {
        return new SymmetryEncoder(context, context.getTask().getConfig());
    }

    public BooleanFormula encodeFullSymmetryBreaking() {
        if (!symmBreakTarget.isEmpty()) {
            final Set<? extends EquivalenceClass<Thread>> classes =
                    context.getAnalysisContext().requires(ThreadSymmetry.class).getNonTrivialClasses();
            logger.info("Found {} class(es) of symmetric threads: {}", classes.size(), classes.stream()
                    .sorted(Comparator.comparingInt(c -> c.getRepresentative().getId()))
                    .map(c -> c.size() + " x " + c.getRepresentative().getName()).toList());
        }
        return switch (symmBreakTarget) {
            case CO -> new CoSymmetryBreaking(context).encode();
            case CF -> new CfSymmetryBreaking(context).encode();
            default -> context.getBooleanFormulaManager().makeTrue();
        };
    }
}
