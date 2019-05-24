package com.dat3m.dartagnan.utils;

import com.dat3m.dartagnan.wmm.utils.Mode;
import com.dat3m.dartagnan.wmm.utils.alias.Alias;
import com.google.common.base.Joiner;
import com.google.common.collect.ImmutableSet;

import java.util.Arrays;
import java.util.Collection;

public class Settings {

    public static final String TACTIC = "qfbv";

    private static final boolean FORCE_PRECISE_EDGES_IN_GRAPH = true;

    private Mode mode;
    private Alias alias;
    private int bound;

    private boolean draw = false;
    private ImmutableSet<String> relations = ImmutableSet.of();

    public Settings(Mode mode, Alias alias, int bound){
        this.mode = mode == null ? Mode.KNASTER : mode;
        this.alias = alias == null ? Alias.CFIS : alias;
        this.bound = Math.max(1, bound);
    }

    public Settings(Mode mode, Alias alias, int bound, boolean draw, Collection<String> relations){
        this(mode, alias, bound);
        if(draw){
            this.draw = true;
            if(FORCE_PRECISE_EDGES_IN_GRAPH && mode == Mode.KNASTER){
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

    public Settings(Mode mode, Alias alias, int bound, boolean draw, String... relations){
        this(mode, alias, bound, draw, Arrays.asList(relations));
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

    public boolean getDrawGraph(){
        return draw;
    }

    public ImmutableSet<String> getGraphRelations(){
        return relations;
    }

    // TODO: UI and command line options for this parameter
    public boolean getUseSeqEncoding(){
        return false;
    }

    // TODO: UI and command line options for this parameter
    public boolean canAccessUninitializedMemory(){
        return true;
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
