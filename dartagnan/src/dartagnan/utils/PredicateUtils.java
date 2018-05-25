/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dartagnan.utils;

import com.microsoft.z3.Context;
import dartagnan.program.Program;

/**
 *
 * @author Florian Furbach
 */
public abstract class PredicateUtils {
    //states whether we use predicate logic
    public static boolean usePredicate=false;
    //the program we currently use, for aramis and dartagnan there is only one, for artemis this is more complicated and must be up to date!
    private static Program currentProg;

    public static Program getCurrentProg() {
        return currentProg;
    }
    
    /**
     * Sets the current Program and defines its EnumSort for the events if necessary.
     * @param currentProg
     * @param ctx
     */
    public static void setCurrentProg(Program currentProg,Context ctx) {
        usePredicate=true;
//        PredicateUtils.currentProg = currentProg;
//        if(currentProg.eventSort==null){
//            String[] eventnames=new String[currentProg.getEvents().size()];
//            int i=0;
//            for (Event event : currentProg.getEvents()) {
//                eventnames[i]=event.repr();
//                i++;
//            }
//            //currentProg.getEvents().forEach(i->);
//            currentProg.eventSort=ctx.mkEnumSort(currentProg.name, eventnames);
//            i=0;
//            for (Event event : currentProg.getEvents()) {
//                event.exp=currentProg.eventSort.getConst(i);
//                i++;
//            }
//        }
    }
    
//    public static FuncDecl getRel(String name, Context ctx){
//        if(currentProg.predicateRels.get(name)==null){
//            Sort[] input={currentProg.eventSort, currentProg.eventSort};
//            FuncDecl value=ctx.mkFuncDecl(name, input, ctx.getBoolSort());
//            currentProg.predicateRels.put(name, value);
//            return value;
//        } else return currentProg.predicateRels.get(name);
//    }
//    public static FuncDecl getUnaryBool(String name, Context ctx){
//        if(currentProg.predicateBoolUnary.get(name)==null){
//            FuncDecl value=ctx.mkFuncDecl(name, currentProg.eventSort, ctx.getBoolSort());
//            currentProg.predicateBoolUnary.put(name, value);
//            return value;
//        } else return currentProg.predicateBoolUnary.get(name);
//    }
//
//    public static FuncDecl getUnaryInt(String name, Context ctx){
//        if(currentProg.predicateIntUnary.get(name)==null){
//            FuncDecl value=ctx.mkFuncDecl(name, currentProg.eventSort, ctx.getIntSort());
//            currentProg.predicateIntUnary.put(name, value);
//            return value;
//        } else return currentProg.predicateIntUnary.get(name);
//    }    
//    public static FuncDecl getBinaryInt(String name, Context ctx){
//        if(currentProg.predicateIntBinary.get(name)==null){
//            Sort[] input={currentProg.eventSort, currentProg.eventSort};
//            FuncDecl value=ctx.mkFuncDecl(name, input, ctx.getIntSort());
//            currentProg.predicateIntBinary.put(name, value);
//            return value;
//        } else return currentProg.predicateIntBinary.get(name);
//    }        
//    public static BoolExpr getEdge(String relName, Expr e1, Expr e2, Context ctx){
//        return (BoolExpr) getRel(relName, ctx).apply(e1,e2);
//    }
}