package com.dat3m.dartagnan.parsers.cat.visitors;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.parsers.CatBaseVisitor;
import com.dat3m.dartagnan.parsers.CatParser;
import com.dat3m.dartagnan.program.filter.FilterAbstract;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.relation.RecursiveRelation;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.relation.RelationNameRepository;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.util.Set;

public class VisitorBase extends CatBaseVisitor<Object> {

    VisitorRelation relationVisitor;
    VisitorFilter filterVisitor;
    Wmm wmm;

    public VisitorBase(){
        this.wmm = new Wmm();
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
            Constructor<?> constructor = ctx.cls.getConstructor(Relation.class, boolean.class, boolean.class);
            Axiom axiom = (Axiom) constructor.newInstance(r, ctx.negate != null, ctx.flag != null);
            if(ctx.NAME() != null) {
            	axiom.setName(ctx.NAME().toString());
            }
			wmm.addAxiom(axiom);
        } catch (NoSuchMethodException | InstantiationException | IllegalAccessException | InvocationTargetException e){
            throw new ParsingException(ctx.getText());
        }
        return null;
    }

    @Override
    public Object visitLetDefinition(CatParser.LetDefinitionContext ctx) {
        Relation r = ctx.e.accept(relationVisitor);
        if(r != null){
        	if(RelationNameRepository.contains(r.getName()) || r.getIsNamed()) {
        		wmm.addAlias(ctx.n.getText(), r);
        	} else {
                r.setName(ctx.n.getText());
                wmm.updateRelation(r);
        	}
        } else {
            FilterAbstract f = ctx.e.accept(filterVisitor);
            f.setName(ctx.n.getText());
            wmm.addFilter(f);
        }
        return null;
    }

    @Override
    public Object visitLetRecDefinition(CatParser.LetRecDefinitionContext ctx) {
        int size = ctx.letRecAndDefinition().size();
        RecursiveRelation[] recursiveGroup = new RecursiveRelation[size + 1];
        recursiveGroup[0] = new RecursiveRelation(ctx.n.getText());
        for (int i = 0; i < size; i++) {
            recursiveGroup[i + 1] = new RecursiveRelation(ctx.letRecAndDefinition(i).n.getText());
        }
        for (RecursiveRelation r : recursiveGroup) {
            wmm.addRelation(r);
        }
        recursiveGroup[0].setConcreteRelation(relation(ctx.e));
        for (int i = 0; i < size; i++) {
            recursiveGroup[i + 1].setConcreteRelation(relation(ctx.letRecAndDefinition(i).e));
        }
        wmm.addRecursiveGroup(Set.of(recursiveGroup));
        return null;
    }

    private Relation relation(CatParser.ExpressionContext ctx) {
        Relation r = ctx.accept(relationVisitor);
        if (r == null) {
            throw new ParsingException("expected relation from expression " + ctx.getText());
        }
        return r;
    }
}

