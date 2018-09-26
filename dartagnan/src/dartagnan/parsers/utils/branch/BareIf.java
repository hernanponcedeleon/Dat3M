package dartagnan.parsers.utils.branch;

import dartagnan.expression.AExpr;
import dartagnan.expression.Atom;
import dartagnan.expression.BExpr;
import dartagnan.program.event.If;
import dartagnan.program.event.Skip;
import dartagnan.program.Thread;

public class BareIf extends Thread {

    private AExpr a1;
    private AExpr a2;
    private BExpr pred;
    private Thread t1;
    private Thread t2;

    private String elseLabel;
    private String endLabel;

    public BareIf(AExpr a1, AExpr a2) {
        this.a1 = a1;
        this.a2 = a2;
    }

    public void setOp(String op){
        pred = new Atom(a1, op, a2);
    }

    public void setElseLabel(String label){
        elseLabel = label;
    }

    public void setEndLabel(String label){
        endLabel = label;
    }

    public void setT1(Thread t){
        t1 = t;
    }

    public void setT2(Thread t){
        t2 = t;
    }

    public String getElseLabel(){
        return elseLabel;
    }

    public String getEndLabel(){
        return endLabel;
    }

    public If toIf(){
        if(t1 == null){
            t1 = new Skip();
        }
        if(t2 == null){
            t2 = new Skip();
        }
        return new If(pred, t1, t2);
    }

    // TODO: Implement or remove
    public BareIf clone(){
        throw new RuntimeException("Clone not supported for " + this.getClass().getName());
    }
}
