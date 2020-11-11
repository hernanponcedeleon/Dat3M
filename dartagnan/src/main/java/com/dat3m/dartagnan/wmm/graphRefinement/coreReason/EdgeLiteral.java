package com.dat3m.dartagnan.wmm.graphRefinement.coreReason;

import com.dat3m.dartagnan.wmm.graphRefinement.decoration.Edge;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.RelationData;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.Utils;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

/*
EdgeLiterals encode arbitrary edges as reason literals.
It is only expected to be used with rf and _co, so we might want to explicitly create classes for those two.
 */
public class EdgeLiteral implements CoreLiteral {
    private RelationData relData;
    private Edge edge;

    public RelationData getRelation() {
        return relData;
    }

    public Edge getEdge() {
        return edge;
    }

    public EdgeLiteral(RelationData relData, Edge edge) {
        this.relData = relData;
        this.edge = edge;
    }

    @Override
    public int hashCode() {
        return relData.hashCode() + 31 * edge.hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null || !(obj instanceof EdgeLiteral))
            return false;
        EdgeLiteral other = (EdgeLiteral) obj;
        return this.relData.equals(other.relData) && this.edge.equals(other.edge);
    }

    @Override
    public String toString() {
        return relData.toString() + edge.toString();
    }

    @Override
    public BoolExpr getZ3BoolExpr(Context ctx) {
        String name = relData.getRelation().getName();
        if ( name.equals("_co"))
            name = "co";
        return Utils.edge(name, edge.getFirst().getEvent(), edge.getSecond().getEvent(), ctx);
    }

    @Override
    public boolean hasOpposite() {
        return relData.getRelation().getName().equals("co") || relData.getRelation().getName().equals("_co");
    }

    @Override
    public CoreLiteral getOpposite() {
        if (!hasOpposite())
            return null;
        return new EdgeLiteral(relData, edge.getInverse());
    }
}
