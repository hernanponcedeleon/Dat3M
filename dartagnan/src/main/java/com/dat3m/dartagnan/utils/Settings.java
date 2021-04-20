package com.dat3m.dartagnan.utils;

import com.dat3m.dartagnan.wmm.utils.Mode;
import com.dat3m.dartagnan.wmm.utils.alias.Alias;
import com.google.common.base.Joiner;
import com.google.common.collect.ImmutableSet;

import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

public class Settings {

    public static final String TACTIC = "qfbv";
    
    // TODO: UI and console options to set these flags
    public static final int FLAG_FORCE_PRECISE_EDGES_IN_GRAPHS      = 0;
    public static final int FLAG_USE_SEQ_ENCODING_REL_RF            = 1;
    public static final int FLAG_CAN_ACCESS_UNINITIALIZED_MEMORY    = 2;

    private Mode mode;
    private final Alias alias;
    private final int bound;
    private final int solver_timeout;

    private boolean draw = false;
    private ImmutableSet<String> relations = ImmutableSet.of();

    private final Map<Integer, Boolean> flags = new HashMap<>(){{
            put(FLAG_FORCE_PRECISE_EDGES_IN_GRAPHS, true);
            put(FLAG_USE_SEQ_ENCODING_REL_RF, true);
            put(FLAG_CAN_ACCESS_UNINITIALIZED_MEMORY, false);
    }};

    public Settings(Mode mode, Alias alias, int bound, int solver_timeout){
        this.mode = mode == null ? Mode.KNASTER : mode;
        this.alias = alias == null ? Alias.CFIS : alias;
        this.bound = Math.max(1, bound);
        this.solver_timeout = solver_timeout;
    }

    public Settings(Mode mode, Alias alias, int bound, int solver_timeout, boolean draw, Collection<String> relations){
        this(mode, alias, bound, solver_timeout);
        if(draw){
            this.draw = true;
            if(flags.get(FLAG_FORCE_PRECISE_EDGES_IN_GRAPHS) && mode == Mode.KNASTER){
                this.mode = Mode.IDL;
            }
            ImmutableSet.Builder<String> builder = new ImmutableSet.Builder<>();
            builder.addAll(Graph.getDefaultRelations());
            if(relations != null) {
                builder.addAll(relations);
            }
            this.relations = builder.build();
        }
    }

    public Settings(Mode mode, Alias alias, int bound, int solver_timeout, boolean draw, String... relations){
        this(mode, alias, bound, solver_timeout, draw, Arrays.asList(relations));
    }

    public Mode getMode(){
        return mode;
    }

    public Alias getAlias(){
        return alias;
    }

    public int getBound(){
        return bound;
    }

    public int getSolverTimeout(){
        return solver_timeout;
    }

    public boolean hasSolverTimeout(){
        return solver_timeout > 0;
    }

    public boolean getDrawGraph(){
        return draw;
    }

    public ImmutableSet<String> getGraphRelations(){
        return relations;
    }

    public boolean getFlag(int flag){
        if(!flags.containsKey(flag)){
            throw new UnsupportedOperationException("Unrecognized settings flag");
        }
        return flags.get(flag);
    }

    public void setFlag(int flag, boolean value){
        if(!flags.containsKey(flag)){
            throw new UnsupportedOperationException("Unrecognized settings flag");
        }
        flags.put(flag, value);
    }

    @Override
    public String toString(){
        StringBuilder sb = new StringBuilder();
        sb.append("mode=").append(mode).append(" alias=").append(alias).append(" bound=").append(bound);
        if(draw){
            sb.append(" draw=").append(Joiner.on(",").join(relations));
        }
        return sb.toString();
    }
}
