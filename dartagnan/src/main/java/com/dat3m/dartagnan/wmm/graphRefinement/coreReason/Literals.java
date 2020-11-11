package com.dat3m.dartagnan.wmm.graphRefinement.coreReason;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.graphRefinement.GraphContext;
import com.dat3m.dartagnan.wmm.graphRefinement.analysis.Equivalence;
import com.dat3m.dartagnan.wmm.graphRefinement.dataStructures.Vect;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.Edge;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.EventData;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

import java.util.HashMap;
import java.util.Map;


// Literals will be ordered as: eventLiterals, rfLiterals, (locLiterals), coLiterals
// where the coLiterals have opposing pairs next to each other
public class Literals {
    private GraphContext context;
    private Vect<CoreLiteral> literals;
    private int numRfLiterals;
    private int numEventLiterals;
    private int numLocLiterals;
    private int numCoLiterals;

    // We store negative and positive co-literals next to each other
    // coParity tells us if all the positive literals fall on even indices or on odd indices
    private int coParity;
    //TODO: We might want to add fake negative literals also to rf and po
    // such that we can avoid any special treatment for co

    private Map<CoreLiteral, Integer> literalIndexMap;

    public Literals(GraphContext ctx) {
        this.context = ctx;
        literals = new Vect<>(0);
        literalIndexMap = new HashMap<>();
    }

    public void init() {
        literalIndexMap.clear();
        literals.clear();

        for (Equivalence<Event>.Representative rep : context.getBranchEquivalence().getRepresentatives()) {
            CoreLiteral newLit = new EventLiteral(context.getData(rep.getData()));
            literalIndexMap.put(newLit, literals.size());

            literals.ensureCapacity(1, literals.size());
            literals.appendUnsafe(newLit);
        }
        numEventLiterals = literals.size();

        for (Map.Entry<EventData, EventData> rfEdge : context.getReadWriteMap().entrySet()) {
            CoreLiteral newLit = new RfLiteral(new Edge(rfEdge.getKey(), rfEdge.getValue()), context);
            literalIndexMap.put(newLit, literals.size());

            literals.ensureCapacity(1, literals.size());
            literals.appendUnsafe(newLit);
        }
        numRfLiterals = literals.size() - numEventLiterals;

        coParity = literals.size() & 1;
        //TODO: We do not create literals for loc yet.
    }

    public int getLiteralIndex(CoreLiteral lit) {
        return literalIndexMap.get(lit);
    }

    public CoreLiteral getLiteral(int i) {
        assert i > 0 && i < literals.size();
        return literals.getUnsafe(i);
    }

    public int addCoherenceLiteral(Tuple edge) {
        return 0;
    }


}
