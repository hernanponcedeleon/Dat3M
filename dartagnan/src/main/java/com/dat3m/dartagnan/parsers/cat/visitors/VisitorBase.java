package com.dat3m.dartagnan.parsers.cat.visitors;

import com.dat3m.dartagnan.parsers.CatBaseVisitor;
import com.dat3m.dartagnan.parsers.CatVisitor;
import com.dat3m.dartagnan.parsers.CatParser;
import com.dat3m.dartagnan.parsers.cat.utils.ParsingException;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.filter.FilterAbstract;
import com.dat3m.dartagnan.wmm.relation.RecursiveRelation;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.RelationRepository;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.util.HashSet;
import java.util.Set;

public class VisitorBase extends CatBaseVisitor<Object> implements CatVisitor<Object> {

    RelationRepository relationRepository;
    VisitorRelation relationVisitor;
    VisitorFilter filterVisitor;
    Wmm wmm;

    boolean recursiveDef;
    private Set<RecursiveRelation> recursiveGroup;

    public VisitorBase(){
        this.wmm = new Wmm();
        relationRepository = wmm.getRelationRepository();
        filterVisitor = new VisitorFilter(this);
        relationVisitor = new VisitorRelation(this);
    }

    @Override
    public Object visitMcm(CatParser.McmContext ctx) {
        super.visitMcm(ctx);
        return wmm;
    }

    @Override
    public Object visitAxiomDefinition(CatParser.AxiomDefinitionContext ctx) {
        try{
            Relation r = ctx.e.accept(relationVisitor);
            if(r == null){
                throw new ParsingException(ctx.getText());
            }
            Constructor<?> constructor = ctx.cls.getConstructor(Relation.class);
            wmm.addAxiom((Axiom) constructor.newInstance(r));
        } catch (NoSuchMethodException | InstantiationException | IllegalAccessException | InvocationTargetException e){
            throw new ParsingException(ctx.getText());
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
        recursiveDef = true;

        RecursiveRelation rRecursive = (RecursiveRelation)relationRepository.getRelation(RecursiveRelation.class, ctx.n.getText());
        Relation rConcrete = ctx.e.accept(relationVisitor);
        if(rRecursive == null || rConcrete == null){
            throw new ParsingException(ctx.getText());
        }

        rRecursive.setConcreteRelation(rConcrete);
        recursiveGroup.add(rRecursive);

        for(CatParser.LetRecAndDefinitionContext c : ctx.letRecAndDefinition()){
            c.accept(this);
        }

        wmm.addRecursiveGroup(recursiveGroup);
        recursiveDef = false;
        return null;
    }

    @Override
    public Object visitLetRecAndDefinition(CatParser.LetRecAndDefinitionContext ctx) {
        RecursiveRelation rRecursive = (RecursiveRelation)relationRepository.getRelation(RecursiveRelation.class, ctx.n.getText());
        Relation rConcrete = ctx.e.accept(relationVisitor);
        if(rRecursive == null || rConcrete == null){
            throw new ParsingException(ctx.getText());
        }
        rRecursive.setConcreteRelation(rConcrete);
        recursiveGroup.add(rRecursive);
        return null;
    }
}

