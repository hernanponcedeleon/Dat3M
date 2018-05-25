/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dartagnan.wmm;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Program;
import java.util.Set;

/**
 *
 * @author Florian Furbach
 */
public class EmptyRel extends Relation{

    public EmptyRel() {
        super("0");
        containsRec=false;
    }

    @Override
    public BoolExpr encodeBasic(Program program, Context ctx) throws Z3Exception {
        return EncodingsCAT.satEmpty(this.getName(), program.getEvents(), ctx);
    }

    @Override
    public BoolExpr encode(Program program, Context ctx, Set<String> encodedRels) throws Z3Exception {
        return EncodingsCAT.satEmpty(this.getName(), program.getEvents(), ctx);
    }

    @Override
    protected BoolExpr encodePredicateBasic(Program program, Context ctx) throws Z3Exception {
        return EncodingsCAT.satEmpty(this.getName(), program.getEvents(), ctx);
    }

    @Override
    protected BoolExpr encodePredicateApprox(Program program, Context ctx) throws Z3Exception {
        //TODO: quantor adden.
        return EncodingsCAT.satEmpty(this.getName(), program.getEvents(), ctx);
    }
    
    
    
}
