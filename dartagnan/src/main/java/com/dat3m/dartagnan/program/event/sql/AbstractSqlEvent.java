package com.dat3m.dartagnan.program.event.sql;


import com.dat3m.dartagnan.encoding.sql.CreateSqlEncoder;
import com.dat3m.dartagnan.parsers.PostgreSQLParser;
import com.dat3m.dartagnan.program.event.AbstractEvent;
import com.dat3m.dartagnan.verification.solving.AssumeSolver;
import io.github.cvc5.*;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.*;

public abstract class AbstractSqlEvent extends AbstractEvent {

    public record Table(String table_name,Term constant){}

    protected static final Logger logger = LogManager.getLogger(AbstractSqlEvent.class);

    public abstract Term encode(TermManager tm, Map<String, CreateSqlEncoder.Table> tables);

    public abstract Set<Table> getInputTables();
    public abstract Table getOutputTable();

    /**
     * This function just list all const the stm. uses to be printed by the model
     * @return
     */
    public List<Term> getTables(){
        List<Term> t = new ArrayList<>(getInputTables().stream().map(Table::constant).toList());
        if(getOutputTable()!=null){
            t.add(getOutputTable().constant);
        }
        return t;
    }

}
