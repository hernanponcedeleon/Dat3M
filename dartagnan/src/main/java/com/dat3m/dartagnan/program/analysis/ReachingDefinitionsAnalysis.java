package com.dat3m.dartagnan.program.analysis;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;

import java.util.*;

/**
 * Instances of this analysis shall over-approximate the relationship between {@link RegWriter} and {@link RegReader},
 * where the writer performs the latest reassignment on the register being used by the reader.
 */
public interface ReachingDefinitionsAnalysis {

    /**
     * Lists all potential definitions for registers used by an event.
     * @param reader Event of interest to fetch information about.
     */
    Writers getWriters(RegReader reader);

    /**
     * Lists all relevant definitions for registers marked as used at the end of the program.
     */
    Writers getFinalWriters();

    /**
     * Local information for either a {@link RegReader} or the final state of the program.
     */
    interface Writers {

        /**
         * Lists all registers directly read by the associated reader.
         * @return Registers of interest.
         */
        Set<Register> getUsedRegisters();

        /**
         * Fetches register-specific information from the associated state.
         * @param register Contained in {@link #getUsedRegisters()}.
         * @return Writers in program order.
         */
        RegisterWriters ofRegister(Register register);
    }

    /**
     * Instances of this class are associated with a {@link Register} and either a {@link RegReader} or the final state of the program or function.
     */
    interface RegisterWriters {

        /**
         * Checks if the program guarantees that the register is initialized.
         * @return {@code true}, if all executions have the associated reader use an initialized state,
         * otherwise this property is unknown.
         */
        boolean mustBeInitialized();

        /**
         * Lists writers s.t. there may be executions, where some instance of the associated reader directly uses the result of an instance of that writer.
         * @return Writers in program order.
         */
        List<RegWriter> getMayWriters();

        /**
         * Lists writers s.t. all event instances of the associated reader in any execution read from all instances of that writer in that execution.
         * @return Writers in program order.
         */
        List<RegWriter> getMustWriters();
    }
}
