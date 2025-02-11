package com.dat3m.dartagnan.expression.sql;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.base.LiteralExpressionBase;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.TableType;
import com.dat3m.dartagnan.program.Register;
import com.google.common.collect.ImmutableSet;

import java.util.List;

public class TableReference extends LiteralExpressionBase<TableType> {

    public TableReference(TableType table_type){
        super(table_type);
    };

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return null;
    }

    @Override
    public ImmutableSet<Register> getRegs() {
        return super.getRegs();
    }

}
