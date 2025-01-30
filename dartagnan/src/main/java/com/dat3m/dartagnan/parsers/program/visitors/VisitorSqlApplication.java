package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.SqlApplicationBaseVisitor;
import com.dat3m.dartagnan.parsers.SqlApplication;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.SqlProgram;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.sql.*;
import org.antlr.v4.runtime.tree.ParseTree;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.ArrayList;
import java.util.List;

public class VisitorSqlApplication extends SqlApplicationBaseVisitor<Object> {

    private static final Logger logger = LogManager.getLogger(VisitorSqlApplication.class);

    public final ProgramBuilder programBuilder = ProgramBuilder.forLanguage(Program.SourceLanguage.SQL);

    static int thread_id=0;

    @Override
    public SqlProgram visitApplication(SqlApplication.ApplicationContext ctx) {

        logger.info(String.format("Compile SQL program %s to internal representation",ctx.identifiert().getText()));

        ctx.table_definitions().accept(this);

        ctx.assertions().accept(this);

        visitProgramm(ctx.programm());
        return (SqlProgram) programBuilder.build();
    }

    @Override
    public Object visitTable_definitions(SqlApplication.Table_definitionsContext ctx){
        for(SqlApplication.CreatestmtContext cstm: ctx.createstmt()){
            CreateEvent create_event = new CreateEvent(cstm);
            ((SqlProgram)programBuilder.getProgram()).add_Table_create_stms(create_event);
        }

        return null;
    }

    @Override
    public Object visitAssertions(SqlApplication.AssertionsContext ctx){
        for(SqlApplication.SelectstmtContext sstm: ctx.selectstmt()){
            AssertionEvent select_event = new AssertionEvent(sstm);
            ((SqlProgram)programBuilder.getProgram()).add_assertion(select_event);
        }

        return null;
    }

    @Override
    public Object visitTxn(SqlApplication.TxnContext ctx){
        logger.info(ctx.getText());
        thread_id++;
        String name = "txn_"+thread_id;
        programBuilder.newThread(name,thread_id);

        for(SqlApplication.PreparablestmtContext t : ctx.preparablestmt()){
            visitPreparablestmt(t);
        }
        return null;
    }


//    preparablestmt
//    : selectstmt
//    | insertstmt
//    | updatestmt
//    | deletestmt
//    ;

    @Override
    public Object visitSelectstmt(SqlApplication.SelectstmtContext ctx) {
        return programBuilder.addChild(thread_id,new SelectEvent(ctx));
    }

    @Override
    public Object visitInsertstmt(SqlApplication.InsertstmtContext ctx) {
         return programBuilder.addChild(thread_id,new InsertEvent(ctx));
    }

    @Override
    public Object visitDeletestmt(SqlApplication.DeletestmtContext ctx) {
        return programBuilder.addChild(thread_id,new DeleteEvent(ctx));
    }







}
