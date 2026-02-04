package com.dat3m.dartagnan.program.analysis.interval;

import com.dat3m.dartagnan.configuration.IntervalAnalysisOptions;
import com.dat3m.dartagnan.verification.VerificationTask;

import static com.dat3m.dartagnan.configuration.OptionNames.INTERVAL_ANALYSIS_METHOD;

import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.dat3m.dartagnan.utils.Utils;
import com.dat3m.dartagnan.expression.type.IntegerType;

import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;


import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.util.*;


/**
 * Interval Analysis computes intervals for registers at each program event.
 * Registers must be of the IntegerType type
 * The analysis offers three levels of precision
 * <ul>
 *      <li>Naive: Lightweight analysis that always derives the most pessimistic bound</li>
 *      <li>Local: Worklist based algorithm that analyses thread local events and computations for increased precision</li>
 *      <li>Global: Worklist based algorithm that extends Local by considering store and load events from shared memory. Most precise out of the three</li>
 * </ul>
 * Register can be queried for further use.
 * Metrics about the analysis are printed if the appropriate log level is enabled.
 */


public interface IntervalAnalysis {

    Logger logger = LoggerFactory.getLogger(IntervalAnalysis.class);

    /**
     * Returns the interval associated with a register at a specific event from the result of the analysis.
     * The interval of a register at a specific event is determined based on previous events not the current one.
     * e.g. in local event r1 <- r1 + 1 the interval of r1 will not include the addition performed in this event but will include it in the next event.
     * @param event
     *  The event at which the register is queried.
     * @param r
     *  The register that is queried.
     * @return
     *  The interval of register {@code r} at event {@code event}.
     * @throws RuntimeException
     *  If the event was not encountered during analysis or if the register is not of the IntegerType type.
     */

    Interval getIntervalAt(Event event, Register r) throws RuntimeException;


    /**
     *  Initialises an analysis instance based on configuration options (default: NAIVE)
     *
     * @param program
     *  The program that is under analysis.
     * @param analysisContext
     *  Global analysis depends on {@link RelationAnalysis}.
     * @param task
     *  Verification task required to get the memory model when using the RelationAnalysis.
     * @param config
     * - Contains configuration options for choosing the desired analysis.
     * @return
     *  A completed interval analysis.
     * @throws InvalidConfigurationException
     */


    static IntervalAnalysis fromConfig(Program program, Context analysisContext, VerificationTask task, Configuration config) throws InvalidConfigurationException {
        Config c = new Config(config);
        logger.info("Selected interval analysis: {}", c.method);
        long t0 = System.currentTimeMillis();
        IntervalAnalysis analysis = switch (c.method) {
            case NAIVE -> IntervalAnalysisNaive.fromConfig();
            case LOCAL -> IntervalAnalysisLocal.fromConfig(program);
            case GLOBAL -> IntervalAnalysisGlobal.fromConfig(program, analysisContext, task);
        };
        long t1 = System.currentTimeMillis();
        logger.info("Finished interval analysis in {}", Utils.toTimeString(t1 - t0));
        if (logger.isInfoEnabled()) {
            analysis.computeAnalysisMetrics(program);
        }
        return analysis;
    }


    @Options
    class Config {
        @Option(
            name = INTERVAL_ANALYSIS_METHOD,
            description = "Indicates the desired precision of the interval analysis"
        )

        IntervalAnalysisOptions method = IntervalAnalysisOptions.getDefault();

        Config(Configuration config) throws InvalidConfigurationException {
            config.inject(this);
        }
    }



    private void computeAnalysisMetrics(Program program) {
        // Iterate over the program.
        // For each register check if their bound is reduced.
        // Only executed if logger.isInfoEnabled = true
        // Rounds half up for decimal values.
        double totalRegReads = 0;
        double totalRegWrites = 0;
        double totalIntervalsReduced = 0;
        double totalIntervalsTop = 0;
        BigDecimal totalReducedIntervalSize = BigDecimal.ZERO;
        for (Event e : program.getThreadEvents()) {
            if (e instanceof RegReader rr) {
                if (e instanceof RegWriter) {
                    totalRegWrites++;
                }
                Set<Register.Read> regReads = rr.getRegisterReads();
                totalRegReads += regReads.stream().filter(read -> read.register().getType() instanceof IntegerType).count();
                for (Register.Read read : regReads) {
                    Register r = read.register();
                    if (r.getType() instanceof IntegerType) {
                        Interval computedInterval = getIntervalAt(e, r);
                        if (computedInterval.isTop()) {
                            totalIntervalsTop++;
                        } else {
                            totalIntervalsReduced++;
                            totalReducedIntervalSize = totalReducedIntervalSize.add(new BigDecimal(computedInterval.size()));
                        }
                    }

                }
            } else if (e instanceof RegWriter) {
                totalRegWrites++;
            }
        }
        DecimalFormat df = new DecimalFormat("#.##");
        double percentageIntervalsReduced = 0;
        double percentageIntervalsTop = 0;
        if (totalRegReads != 0) {
            percentageIntervalsReduced = (totalIntervalsReduced / totalRegReads) * 100;
            percentageIntervalsTop = (totalIntervalsTop / totalRegReads) * 100;
        }
        BigDecimal averageReducedIntervalSize = BigDecimal.ZERO;
        if (totalIntervalsReduced != 0) {
            averageReducedIntervalSize = totalReducedIntervalSize.divide(BigDecimal.valueOf((long) totalIntervalsReduced), RoundingMode.HALF_UP);
        }

        logger.info("""

            ============== Interval Analysis Summary ====================
            Total register writes: {}
            Total register reads: {}
            Total register bounded {}
            Total registers top {}
            Percentage bounded: {}%
            Percentage top: {}%
            Average reduced interval size: {}
            ============== Interval Analysis Summary End ================
            """,
            totalRegWrites,
            totalRegReads,
            totalIntervalsReduced,
            totalIntervalsTop,
            df.format(percentageIntervalsReduced),
            df.format(percentageIntervalsTop),
            averageReducedIntervalSize);


        Set<Object> unsupportedOperators = Interval.getUnsupportedOperatorsFound();
        if (!unsupportedOperators.isEmpty()) {
            if (logger.isWarnEnabled()) {
                logger.warn("Unsupported operators found: {}", Interval.getUnsupportedOperatorsFound());

            }

        }
    }
}
