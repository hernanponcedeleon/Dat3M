package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.google.common.base.Preconditions;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.*;

import static com.dat3m.dartagnan.expression.utils.Utils.convertToIntegerFormula;

@Options
public class MemoryEncoder implements Encoder {

    private static final Logger logger = LogManager.getLogger(MemoryEncoder.class);

    private Memory memory;

    private MemoryEncoder(Configuration config) throws InvalidConfigurationException {
        config.inject(this);
    }

    public static MemoryEncoder fromConfig(Configuration config) throws InvalidConfigurationException {
        return new MemoryEncoder(config);
    }


    @Override
    public void initialise(VerificationTask task, SolverContext context) {
        this.memory = task.getProgram().getMemory();
    }

    // Assigns each Address a fixed memory address.
    public BooleanFormula encodeMemory(SolverContext ctx) {
        Preconditions.checkState(memory != null, "The encoder needs to get initialized.");
        logger.info("Encoding fixed memory");

        FormulaManager fmgr = ctx.getFormulaManager();
        IntegerFormulaManager imgr = fmgr.getIntegerFormulaManager();

        // Some addresses already have a constant value (obtained from parsing the boogie file)
        BooleanFormula[] addrExprs = memory.getAllAddresses().stream().filter(x -> !x.hasConstantValue())
                .map(addr -> imgr.equal(convertToIntegerFormula(addr.toIntFormula(ctx), ctx),
                        imgr.makeNumber(addr.getValue().intValue())))
                .toArray(BooleanFormula[]::new);
        return fmgr.getBooleanFormulaManager().and(addrExprs);
     }
}