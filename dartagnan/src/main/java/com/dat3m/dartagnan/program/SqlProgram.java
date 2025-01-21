package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.TypeOffset;
import com.dat3m.dartagnan.parsers.SqlApplication;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.sql.AbstractSqlEvent;
import com.dat3m.dartagnan.program.event.sql.CreateEvent;
import com.dat3m.dartagnan.program.event.sql.SelectEvent;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.misc.NonDetValue;
import com.google.common.base.Preconditions;

import java.util.*;
import java.util.stream.Collectors;

public class SqlProgram extends Program{

    private final List<CreateEvent> table_create_stms = new ArrayList<>();
    private final List<SelectEvent> assertions = new ArrayList<>();;

    public SqlProgram(String name){
        super(name,null, Program.SourceLanguage.SQL);
    }

    public void add_Table_create_stms(CreateEvent createEvent) {
        this.table_create_stms.add(createEvent);
    }

    public void add_assertion(SelectEvent selectEvent) {
        assertions.add(selectEvent);
    }

    public List<CreateEvent> getTable_create_stms() {
        return table_create_stms;
    }

    public List<SelectEvent> getAssertions() {
        return assertions;
    }
}