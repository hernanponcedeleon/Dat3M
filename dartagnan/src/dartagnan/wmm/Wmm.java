package dartagnan.wmm;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.ModelLexer;
import dartagnan.ModelParser;
import dartagnan.program.Program;
import dartagnan.program.event.filter.FilterAbstract;
import dartagnan.program.event.filter.FilterBasic;
import dartagnan.program.event.filter.FilterUtils;
import dartagnan.wmm.axiom.Axiom;
import dartagnan.wmm.relation.RecursiveRelation;
import dartagnan.wmm.relation.Relation;
import dartagnan.wmm.utils.*;
import org.antlr.v4.runtime.*;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.*;

/**
 *
 * @author Florian Furbach
 */
public class Wmm {

    private List<Axiom> axioms = new ArrayList<>();
    private Map<String, FilterAbstract> filters = new HashMap<String, FilterAbstract>();
    private RelationRepository relationRepository;
    private List<RecursiveGroup> recursiveGroups = new ArrayList<>();

    private Program program;

    public Wmm(String filePath, String target) throws IOException{
        relationRepository = new RelationRepository(Arch.encodeCtrlPo(target));
        parse(filePath);
    }

    public void addAxiom(Axiom ax) {
        axioms.add(ax);
    }

    public void addFilter(FilterAbstract filter) {
        filters.put(filter.getName(), filter);
    }

    public FilterAbstract getFilter(String name){
        FilterAbstract filter = filters.get(name);
        if(filter == null){
            name = FilterUtils.resolve(name);
            if(name != null){
                filter = new FilterBasic(name);
            }
        }
        return filter;
    }

    public RelationRepository getRelationRepository(){
        return relationRepository;
    }

    public void addRecursiveGroup(Set<RecursiveRelation> recursiveGroup){
        int id = 1 << recursiveGroups.size();
        if(id < 0){
            throw new RuntimeException("Exceeded maximum number of recursive relations");
        }
        recursiveGroups.add(new RecursiveGroup(id, recursiveGroup));
    }

    public BoolExpr encode(Program program, Context ctx, boolean approx, boolean idl) throws Z3Exception {
        this.program = program;

        for (Axiom ax : axioms) {
            ax.getRel().updateRecursiveGroupId(ax.getRel().getRecursiveGroupId());
        }

        int encodingMode = approx ? Relation.APPROX : idl ? Relation.IDL : Relation.LFP;

        for(Relation relation : relationRepository.getRelations()){
            relation.initialise(program, ctx, encodingMode);
        }

        for(RecursiveGroup recursiveGroup : recursiveGroups){
            recursiveGroup.initMaxTupleSets();
        }

        for (Axiom ax : axioms) {
            ax.getRel().getMaxTupleSet();
        }

        for (Axiom ax : axioms) {
            ax.getRel().addEncodeTupleSet(ax.getEncodeTupleSet());
        }

        Collections.reverse(recursiveGroups);
        for(RecursiveGroup recursiveGroup : recursiveGroups){
            recursiveGroup.updateEncodeTupleSets();
        }

        BoolExpr enc = ctx.mkTrue();
        for (Axiom ax : axioms) {
            enc = ctx.mkAnd(enc, ax.getRel().encode());
        }

        if(encodingMode == Relation.LFP){
            for(RecursiveGroup group : recursiveGroups){
                enc = ctx.mkAnd(enc, group.encode(ctx));
            }
        }

        return enc;
    }

    public BoolExpr consistent(Program program, Context ctx) throws Z3Exception {
        if(this.program != program){
            throw new RuntimeException("Wmm relations must be encoded before consistency predicate");
        }
        BoolExpr expr = ctx.mkTrue();
        for (Axiom ax : axioms) {
            expr = ctx.mkAnd(expr, ax.consistent(ctx));
        }
        return expr;
    }

    public BoolExpr inconsistent(Program program, Context ctx) throws Z3Exception {
        if(this.program != program){
            throw new RuntimeException("Wmm relations must be encoded before inconsistency predicate");
        }
        BoolExpr expr = ctx.mkFalse();
        for (Axiom ax : axioms) {
            expr = ctx.mkOr(expr, ax.inconsistent(ctx));
        }
        return expr;
    }

    public String toString() {
        StringBuilder sb = new StringBuilder();

        for (Axiom axiom : axioms) {
            sb.append(axiom).append("\n");
        }

        for (Relation relation : relationRepository.getRelations()) {
            if(relation.getIsNamed()){
                sb.append(relation).append("\n");
            }
        }

        for (Map.Entry<String, FilterAbstract> filter : filters.entrySet()){
            sb.append(filter.getValue()).append("\n");
        }

        return sb.toString();
    }

    private void parse(String filePath) throws IOException{
        File file = new File(filePath);
        FileInputStream stream = new FileInputStream(file);
        CharStream charStream = CharStreams.fromStream(stream);
        ModelLexer lexer = new ModelLexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);
        ModelParser parser = new ModelParser(tokenStream);
        parser.setErrorHandler(new BailErrorStrategy());
        parser.mcm(this);
    }
}
