package com.dat3m.dartagnan.encoding.sql;

import com.dat3m.dartagnan.encoding.EncodingContext;
import io.github.cvc5.*;

import java.util.ArrayList;
import java.util.List;

public class LambdaContext {

    private final Solver tm;

    LambdaContext parent;

    private CreateSqlEncoder.Table currentTable;

    private Term currentRow;
    private DatatypeConstructor constructor_currentRow;

    private Sort currentinitialVariableSort;
    private Term currentinitialValue;
    private Term initialVariable;


    private LambdaContext(Solver tm,CreateSqlEncoder.Table currentTable, LambdaContext parent){
        this.tm=tm;
        this.currentTable = currentTable;
        this.parent = parent;
    }

    public static LambdaContext openLambdaContext(EncodingContext ctx,CreateSqlEncoder.Table currentTable){
        return new LambdaContext(ctx.solver,currentTable,null);
    }

    public LambdaContext deriveContext(){
        LambdaContext child = new LambdaContext(tm,currentTable,this);
        child.currentTable = currentTable;
        return child;
    }

    public Term makeRowVariable(String name){
        Sort row_sort = currentTable.row();

        constructor_currentRow = row_sort.getDatatype().getConstructor(0);
        currentRow = tm.mkVar(row_sort, name);

        return currentRow;
    }

    public Term getRowVariable(){
        if(currentRow==null){
            return parent.getRowVariable();
        }

        return currentRow;
    }

    public Term getColumnFromRowVariable(String column_name){
        int idx = currentTable.col_names().indexOf(column_name);
        Term sel = this.constructor_currentRow.getSelector(idx).getTerm();

        return tm.mkTerm(Kind.APPLY_SELECTOR, sel, this.currentRow);
    }

    public Term makeInitialVariable(String name, Sort sort, Term initialval) {

        this.currentinitialVariableSort = sort;
        this.initialVariable = tm.mkVar(currentinitialVariableSort,name);
        this.currentinitialValue = initialval;

        return initialVariable;
    }

    public Term getInitialVariable() {
        return initialVariable;
    }

    public Term getCurrentinitialValue() {
        return currentinitialValue;
    }

    public Sort getCurrentinitialVariableSort() {
        return currentinitialVariableSort;
    }

    public LambdaContext close() {
        return parent;
    }
}
