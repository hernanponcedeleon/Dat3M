package com.dat3m.dartagnan.program.encoding;

import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.google.common.base.Preconditions;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.*;

import java.math.BigInteger;
import java.util.List;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.program.utils.Utils.convertToIntegerFormula;
import static com.dat3m.dartagnan.program.utils.Utils.generalEqual;

@Options
public class MemoryEncoder implements Encoder {

    private static final Logger logger = LogManager.getLogger(MemoryEncoder.class);

    // =========================== Configurables ===========================

    @Option(name = "encoding.useFixedMemory",
            description = "Pre-assigns fixed values to dynamically allocated objects if possible.",
            secure = true)
    private boolean shouldUseFixedMemoryEncoding = false;

    public boolean shouldUseFixedMemoryEncoding() { return shouldUseFixedMemoryEncoding; }
    public void setShouldUseFixedMemoryEncoding(boolean value) { shouldUseFixedMemoryEncoding = value; }

    // ====================================================================

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

    public BooleanFormula encodeMemory(SolverContext ctx) {
        Preconditions.checkState(memory != null, "The encoder needs to get initialized for encoding first.");
        return shouldUseFixedMemoryEncoding ? encodeFixedMemory(ctx) : encodeVariableMemory(ctx);
    }

    private BooleanFormula encodeVariableMemory(SolverContext ctx){
        logger.info("Encoding variable memory");

        FormulaManager fmgr = ctx.getFormulaManager();
        BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();
        IntegerFormulaManager imgr = fmgr.getIntegerFormulaManager();

        BooleanFormula enc = bmgr.makeTrue();
        for(List<Address> array : memory.getArrays()){
            Formula e1 = array.get(0).toIntFormula(ctx);
            for(int i = 1; i < array.size(); i++){
                NumeralFormula.IntegerFormula e2 = convertToIntegerFormula(array.get(i).toIntFormula(ctx), ctx);
                NumeralFormula.IntegerFormula newAddress = imgr.add(convertToIntegerFormula(e1, ctx), imgr.makeNumber(BigInteger.ONE));
                enc = bmgr.and(enc, generalEqual(e2, newAddress, ctx));
                e1 = e2;
            }
        }
        // Following SMACK, only address with constant values can have negative values.
        for(Address add : memory.getAllAddresses()) {
            if(!add.hasConstantValue()) {
                enc = bmgr.and(enc, imgr.greaterThan(
                        convertToIntegerFormula(add.toIntFormula(ctx), ctx),
                        imgr.makeNumber(BigInteger.ZERO)));
            }
        }

        BooleanFormula distinct = memory.getAllAddresses().size() > 1 ?
                imgr.distinct(memory.getAllAddresses().stream()
                        .map(a -> convertToIntegerFormula(a.toIntFormula(ctx), ctx))
                        .collect(Collectors.toList())) :
                bmgr.makeTrue();

        return bmgr.and(enc, distinct);
    }

    // Assigns each Address a fixed memory address.
    private BooleanFormula encodeFixedMemory(SolverContext ctx) {
        logger.info("Encoding fixed memory");

        FormulaManager fmgr = ctx.getFormulaManager();
        IntegerFormulaManager imgr = fmgr.getIntegerFormulaManager();

        BooleanFormula[] addrExprs = memory.getAllAddresses().stream().filter(x -> !x.hasConstantValue())
                .map(add -> imgr.equal(convertToIntegerFormula(add.toIntFormula(ctx), ctx),
                        imgr.makeNumber(add.getValue().intValue())))
                .toArray(BooleanFormula[]::new);
        return fmgr.getBooleanFormulaManager().and(addrExprs);
    }

}
