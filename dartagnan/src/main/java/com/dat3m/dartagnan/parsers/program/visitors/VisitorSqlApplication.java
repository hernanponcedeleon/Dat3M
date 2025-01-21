package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.parsers.SqlApplicationBaseVisitor;
import com.dat3m.dartagnan.parsers.SqlApplication;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.SqlProgram;
import com.dat3m.dartagnan.program.event.sql.CreateEvent;
import com.dat3m.dartagnan.program.event.sql.SelectEvent;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class VisitorSqlApplication extends SqlApplicationBaseVisitor<Object> {
    private static final Logger logger = LogManager.getLogger(VisitorSqlApplication.class);

    private SqlProgram program;

    @Override
    public SqlProgram visitApplication(SqlApplication.ApplicationContext ctx) {
        program= new SqlProgram(ctx.identifiert().getText());

        logger.info(String.format("Compile SQL program %s to internal representation",ctx.identifiert().getText()));

        ctx.table_definitions().accept(this);

        ctx.assertions().accept(this);

        visitProgramm(ctx.programm());
        return program;
    }

    @Override
    public Object visitTable_definitions(SqlApplication.Table_definitionsContext ctx){
        for(SqlApplication.CreatestmtContext cstm: ctx.createstmt()){
            CreateEvent create_event = new CreateEvent(cstm);
            program.add_Table_create_stms(create_event);
        }

        return null;
    }

    @Override
    public Object visitAssertions(SqlApplication.AssertionsContext ctx){
        for(SqlApplication.SelectstmtContext sstm: ctx.selectstmt()){
            SelectEvent select_event = new SelectEvent(sstm);
            program.add_assertion(select_event);
        }

        return null;
    }

    @Override
    public Object visitTxn(SqlApplication.TxnContext ctx){
        logger.info(ctx.getText());
        //SqlApplication.PreparestmtContext ctx.preparablestmt(2)
        return null;
    }






}
