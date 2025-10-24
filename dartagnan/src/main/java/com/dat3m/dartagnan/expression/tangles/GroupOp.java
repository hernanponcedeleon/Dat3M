package com.dat3m.dartagnan.expression.tangles;

import com.dat3m.dartagnan.expression.ExpressionKind;

public enum GroupOp implements ExpressionKind {
    REDUCE, INCLUSIVESCAN, EXCLUSIVESCAN, CLUSTEREDREDUCE,
    PARTITIONEDREDUCENV, PARTITIONEDINCLUSIVESCANNV, PARTITIONEDEXCLUSIVESCANNV;

    @Override
    public String getSymbol() {
        return switch (this) {
            case REDUCE -> "reduce";
            case INCLUSIVESCAN -> "inclusive_scan";
            case EXCLUSIVESCAN -> "exclusive_scan";
            case CLUSTEREDREDUCE -> "clustered_reduce";
            case PARTITIONEDREDUCENV -> "partitioned_reduce_nv";
            case PARTITIONEDINCLUSIVESCANNV -> "partitioned_inclusive_scan_nv";
            case PARTITIONEDEXCLUSIVESCANNV -> "partitioned_exclusive_scan_nv";
        };
    }

    @Override
    public String toString() {
        return getSymbol();
    }

    public boolean isSupported() {
        return switch (this) {
            case REDUCE -> true;
            case INCLUSIVESCAN -> true;
            case EXCLUSIVESCAN -> true;
            case CLUSTEREDREDUCE -> false;
            case PARTITIONEDREDUCENV -> false;
            case PARTITIONEDINCLUSIVESCANNV -> false;
            case PARTITIONEDEXCLUSIVESCANNV -> false;
        };
    }
}
