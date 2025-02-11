package com.dat3m.dartagnan.encoding.sql;

import com.dat3m.dartagnan.encoding.Encoder;
import com.dat3m.dartagnan.encoding.ProverWithTracker;
import com.dat3m.dartagnan.parsers.SqlApplication;
import com.dat3m.dartagnan.parsers.SqlApplicationBaseVisitor;
import io.github.cvc5.Solver;
import io.github.cvc5.Sort;
import io.github.cvc5.Term;
import io.github.cvc5.Solver;
import org.antlr.v4.runtime.tree.RuleNode;

import java.util.ArrayList;
import java.util.List;

public class CreateSqlEncoder extends SqlApplicationBaseVisitor<CreateSqlEncoder.Table> implements Encoder {

    public record Table(String name, Sort table,Sort row,List<String> col_names) { }
    
    private final Solver tm;

    public CreateSqlEncoder(Solver tm){
        super();
        this.tm = tm;
    }

    @Override
    public Table visitChildren(RuleNode node) {
        throw new UnsupportedOperationException(
                "This expection originates from encoding a SQL Statement with constructs that are not yet supported"
        );
    }

    @Override
    public Table visitCreatestmt(SqlApplication.CreatestmtContext ctx){
        String name = ctx.qualified_name(0).getText();
        // TODO merge to record Row(String,Sort)
        List<Sort> row_sorts = new ArrayList<>();
        List<String> col_names = new ArrayList<>();
        for(SqlApplication.TableelementContext table_element : ctx.opttableelementlist().tableelementlist().tableelement()){

            SqlApplication.ColumnDefContext colDef =table_element.columnDef();
            Sort row_sort = switch (colDef.typename().getText()) {
                case "INTEGER" -> tm.getIntegerSort();
                case "VARCHAR" -> tm.getStringSort();
                default ->
                        throw new IllegalStateException("Unexpected value: " + table_element.columnDef().typename().getText());
            };

            row_sorts.add(row_sort);
            col_names.add(colDef.colid().getText());

        }
        Sort row = tm.mkTupleSort(row_sorts.toArray(new Sort[0]));
        Sort table = tm.mkBagSort(row);
        return new Table(name,table,row,col_names);
    }


}
