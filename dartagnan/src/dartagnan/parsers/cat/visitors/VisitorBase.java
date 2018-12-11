package dartagnan.parsers.cat.visitors;

import dartagnan.parsers.CatBaseVisitor;
import dartagnan.parsers.CatParser;
import dartagnan.parsers.CatVisitor;
import dartagnan.parsers.cat.utils.CatSyntaxException;
import dartagnan.wmm.Wmm;
import dartagnan.wmm.axiom.Axiom;
import dartagnan.wmm.filter.FilterAbstract;
import dartagnan.wmm.relation.RecursiveRelation;
import dartagnan.wmm.relation.Relation;
import dartagnan.wmm.utils.RelationRepository;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.util.HashSet;
import java.util.Set;

public class VisitorBase extends CatBaseVisitor<Object> implements CatVisitor<Object> {

    private Wmm wmm;
    private RelationRepository relationRepository;
    private VisitorRelation relationVisitor;
    private VisitorFilter filterVisitor;
    private Set<RecursiveRelation> recursiveGroup;

    public VisitorBase(String target){
        this.wmm = new Wmm(target);
        relationRepository = wmm.getRelationRepository();
        filterVisitor = new VisitorFilter(wmm);
        relationVisitor = new VisitorRelation(relationRepository, filterVisitor);
    }

    public Object visitMcm(CatParser.McmContext ctx) {
        super.visitMcm(ctx);
        return wmm;
    }

    @Override
    public Object visitAxiomDefinition(CatParser.AxiomDefinitionContext ctx) {
        try{
            Relation r = ctx.e.accept(relationVisitor);
            if(r == null){
                throw new CatSyntaxException(ctx.getText());
            }
            Constructor constructor = ctx.cls.getConstructor(Relation.class, boolean.class);
            wmm.addAxiom((Axiom) constructor.newInstance(r, ctx.negate != null));

        } catch (NoSuchMethodException | InstantiationException | IllegalAccessException | InvocationTargetException e){
            throw new CatSyntaxException(ctx.getText());
        }
        return null;
    }

    @Override
    public Object visitLetDefinition(CatParser.LetDefinitionContext ctx) {
        Relation r = ctx.e.accept(relationVisitor);
        if(r != null){
            r.setName(ctx.n.getText());
            relationRepository.updateRelation(r);
        } else {
            FilterAbstract f = ctx.e.accept(filterVisitor);
            f.setName(ctx.n.getText());
            wmm.addFilter(f);
        }
        return null;
    }

    @Override
    public Object visitLetRecDefinition(CatParser.LetRecDefinitionContext ctx) {
        recursiveGroup = new HashSet<>();
        relationVisitor.setRecursiveDef(true);

        RecursiveRelation rRecursive = (RecursiveRelation)relationRepository.getRelation(RecursiveRelation.class, ctx.n.getText());
        Relation rConcrete = ctx.e.accept(relationVisitor);
        if(rRecursive == null || rConcrete == null){
            throw new CatSyntaxException(ctx.getText());
        }

        rRecursive.setConcreteRelation(rConcrete);
        recursiveGroup.add(rRecursive);

        for(CatParser.LetRecAndDefinitionContext c : ctx.letRecAndDefinition()){
            c.accept(this);
        }

        wmm.addRecursiveGroup(recursiveGroup);
        relationVisitor.setRecursiveDef(false);
        return null;
    }

    @Override
    public Object visitLetRecAndDefinition(CatParser.LetRecAndDefinitionContext ctx) {
        RecursiveRelation rRecursive = (RecursiveRelation)relationRepository.getRelation(RecursiveRelation.class, ctx.n.getText());
        Relation rConcrete = ctx.e.accept(relationVisitor);
        if(rRecursive == null || rConcrete == null){
            throw new CatSyntaxException(ctx.getText());
        }
        rRecursive.setConcreteRelation(rConcrete);
        recursiveGroup.add(rRecursive);
        return null;
    }
}

