package com.dat3m.dartagnan.program.memory;

import java.util.Set;

/**
 * Provides methods for the alias analysis.
 * All local and global variables (registers and locations) implement it.
 * @author Florian Furbach
 */
public interface Variable {

    /**
     *
     * @return a set of all variables that there are outgoing edges to in the alias analysis graph.
     */
    Set<Variable> getAliasEdges();

    /**
     *
     * @return a set of all variables that the variable may point to
     */
    Set<Address> getAliasAddresses();
}
