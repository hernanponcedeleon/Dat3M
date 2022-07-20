package com.dat3m.dartagnan.wmm.relation.base.local;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.wmm.relation.base.stat.StaticRelation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import org.sosy_lab.java_smt.api.BooleanFormula;

import static com.dat3m.dartagnan.configuration.Arch.RISCV;

abstract class BasicRegRelation extends StaticRelation {

    @Override
    public BooleanFormula getSMTVar(Tuple t, EncodingContext context) {
        return context.dependency(t.getFirst(), t.getSecond());
    }
}