package com.dat3m.testgen.smt_classes;

import java.util.List;

public class CatRelation {
    
    public final String name;
    public List <CatRelation> definition;
    public List <CatRelation> expansion;
    public Relation.relation_t base_relation;

    public CatRelation(
        String r_name,
        List <CatRelation> r_definition,
        List <CatRelation> r_expansion,
        Relation.relation_t r_base_relation
    ) {
        name = r_name;
        definition = r_definition;
        expansion = r_expansion;
        base_relation = r_base_relation;
    }

}
