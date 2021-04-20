package com.dat3m.dartagnan.wmm.relation;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.filter.FilterAbstract;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.google.common.collect.HashMultimap;
import com.google.common.collect.Multimap;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

import java.util.HashSet;
import java.util.Set;

public class EdgeTestHelper {

    private final Program program;
    private final Relation relation;
    private final FilterAbstract filter1;
    private final FilterAbstract filter2;

    public EdgeTestHelper(Program program, Relation relation, FilterAbstract filter1, FilterAbstract filter2){
        this.program = program;
        this.relation = relation;
        this.filter1 = filter1;
        this.filter2 = filter2;
    }

    // Encode violation of expected event pairs in the relation
    public BoolExpr encodeIllegalEdges(int[] data, Context ctx){
        Set<Tuple> all = mkAllTuples();
        Set<Tuple> max = relation.getMaxTupleSet();
        Set<Tuple> expected = mkExpectedTuples(all, data);
        BoolExpr enc = ctx.mkFalse();

        for(Tuple tuple : all){
            BoolExpr edge = relation.getSMTVar(tuple, ctx);
            if(expected.contains(tuple)){
                enc = ctx.mkOr(enc, ctx.mkNot(edge));
            } else if(max.contains(tuple)){
                enc = ctx.mkOr(enc, edge);
            }
        }
        return enc;
    }

    // Generate set of all possible pairs (can be greater than maxTupleSet of the relation)
    private Set<Tuple> mkAllTuples(){
        Set<Tuple> result = new HashSet<>();
        for(Event e1 : program.getCache().getEvents(filter1)){
            for(Event e2 : program.getCache().getEvents(filter2)){
                result.add(new Tuple(e1, e2));
            }
        }
        return result;
    }

    // Convert expected result to a set of tuples
    private Set<Tuple> mkExpectedTuples(Set<Tuple> all, int[] data){
        if(data.length % 2 == 1){
            throw new IllegalArgumentException("Invalid definition of expected edges");
        }

        Multimap<Integer, Integer> map = HashMultimap.create();
        for(int i = 0; i < data.length; i += 2){
            map.put(data[i], data[i + 1]);
        }

        Set<Tuple> result = new HashSet<>();
        for(Tuple tuple : all){
            int id1 = tuple.getFirst().getOId();
            int id2 = tuple.getSecond().getOId();
            if(map.containsEntry(id1, id2)){
                result.add(tuple);
            }
        }
        return result;
    }
}
