package com.dat3m.dartagnan.wmm.utils;

import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.filter.FilterAbstract;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.relation.RecursiveRelation;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.relation.RelationNameRepository;
import com.dat3m.dartagnan.wmm.relation.base.RelCrit;
import com.dat3m.dartagnan.wmm.relation.base.RelRMW;
import com.dat3m.dartagnan.wmm.relation.base.local.RelAddrDirect;
import com.dat3m.dartagnan.wmm.relation.base.local.RelCASDep;
import com.dat3m.dartagnan.wmm.relation.base.local.RelIdd;
import com.dat3m.dartagnan.wmm.relation.base.memory.RelCo;
import com.dat3m.dartagnan.wmm.relation.base.memory.RelLoc;
import com.dat3m.dartagnan.wmm.relation.base.memory.RelRf;
import com.dat3m.dartagnan.wmm.relation.base.stat.*;
import com.dat3m.dartagnan.wmm.relation.binary.*;
import com.dat3m.dartagnan.wmm.relation.unary.RelInverse;
import com.dat3m.dartagnan.wmm.relation.unary.RelTrans;
import com.dat3m.dartagnan.wmm.relation.unary.UnaryRelation;
import com.google.common.base.Preconditions;

import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.*;

public class RelationRepository {

    private final Map<String, Relation> relationMap = new HashMap<>();

    public Set<Relation> getRelations(){
        Set<Relation> set = new HashSet<>();
        for(Map.Entry<String, Relation> entry : relationMap.entrySet()){
            if(!entry.getValue().getIsNamed() || entry.getValue().getName().equals(entry.getKey())){
                set.add(entry.getValue());
            }
        }
        return set;
    }

    public Relation getRelation(String name){
        Relation relation = relationMap.get(name);
        if(relation == null){
            if(RelationNameRepository.contains(name)){
                relation = getBasicRelation(name);
                addRelation(relation);
            }
        }
        return relation;
    }

    public Relation getRelation(Class<?> cls, Object... args){
        Class<?>[] argClasses = getArgsForClass(cls);
        try{
            Method method = cls.getMethod("makeTerm", argClasses);
            String term = (String)method.invoke(null, args);
            Relation relation;
            if(containsRelation(term)) {
            	relation = relationMap.get(term);
            } else {
                Constructor<?> constructor = cls.getConstructor(argClasses);
                relation = (Relation)constructor.newInstance(args);
                addRelation(relation);            	
            }
            return relation;
        } catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    public void updateRelation(Relation relation){
        if(relation.getIsNamed()){
            String name = relation.getName();
            Preconditions.checkState(!relationMap.containsKey(name), "Relation " + name + " is already declared");
            relationMap.put(name, relation);
        }
    }

    public void addRelation(Relation relation) {
        relationMap.put(relation.getTerm(), relation);
        if(relation.getIsNamed()){
            relationMap.put(relation.getName(), relation);
        }
    }

    public void addAlias(String alias, Relation relation) {
        relationMap.put(alias, relation);
    }

    public boolean containsRelation(String name) {
        return relationMap.containsKey(name);
    }

    private Class<?>[] getArgsForClass(Class<?> cls){
        if(BinaryRelation.class.isAssignableFrom(cls)){
            return new Class<?>[]{Relation.class, Relation.class};
        } else if(UnaryRelation.class.isAssignableFrom(cls)){
            return new Class<?>[]{Relation.class};
        } else if(RelCartesian.class.isAssignableFrom(cls)){
            return new Class<?>[]{FilterAbstract.class, FilterAbstract.class};
        } else if(RelFencerel.class.isAssignableFrom(cls) || RelSetIdentity.class.isAssignableFrom(cls)){
            return new Class<?>[]{FilterAbstract.class};
        } else if(RecursiveRelation.class.isAssignableFrom(cls)) {
            return new Class<?>[]{String.class};
        }

        throw new UnsupportedOperationException("Method getArgsForClass is not implemented for " + cls.getName());
    }

    private Relation getBasicRelation(String name){
        Preconditions.checkArgument(RelationNameRepository.contains(name), name + " is not listed in RelationNameRepository.");
        switch (name){
            case POWITHLOCALEVENTS:
                return new RelPo(true);
            case PO:
                return new RelPo();
            case LOC:
                return new RelLoc();
            case ID:
                return new RelId();
            case INT:
                return new RelInt();
            case EXT:
                return new RelExt();
            case CO:
                return new RelCo();
            case RF:
                return new RelRf();
            case RMW:
                return new RelRMW();
            case CASDEP:
                return new RelCASDep();
            case CRIT:
                return new RelCrit();
            case IDD:
                return new RelIdd();
            case ADDRDIRECT:
                return new RelAddrDirect();
            case CTRLDIRECT:
                return new RelCtrlDirect();
            case EMPTY:
                return new RelEmpty();
            case RFINV:
                return getRelation(RelInverse.class, getRelation(RF));
            case FR:
                return getRelation(RelComposition.class, getRelation(RFINV), getRelation(CO)).setName(FR);
            case MM:
                return getRelation(RelCartesian.class, FilterBasic.get(Tag.MEMORY), FilterBasic.get(Tag.MEMORY));
            case MV:
                return getRelation(RelCartesian.class, FilterBasic.get(Tag.MEMORY), FilterBasic.get(Tag.VISIBLE));
            case IDDTRANS:
                return getRelation(RelTrans.class, getRelation(IDD));
            case DATA:
                return getRelation(RelIntersection.class, getRelation(IDDTRANS), getRelation(MM)).setName(DATA);
            case ADDR:
                return getRelation(RelIntersection.class,
                        getRelation(
                                RelUnion.class,
                                getRelation(ADDRDIRECT),
                                getRelation(RelComposition.class, getRelation(IDDTRANS), getRelation(ADDRDIRECT))
                        ),
                        getRelation(MM)).setName(ADDR);
            case CTRL:
                return getRelation(RelIntersection.class,
                        getRelation(
                        		RelComposition.class, 
                        		getRelation(IDDTRANS), 
                        		getRelation(CTRLDIRECT)),
                        getRelation(MV)).setName(CTRL);
            case POLOC:
                return getRelation(RelIntersection.class, getRelation(PO), getRelation(LOC)).setName(POLOC);
            case RFE:
                return getRelation(RelIntersection.class, getRelation(RF), getRelation(EXT)).setName(RFE);
            case RFI:
                return getRelation(RelIntersection.class, getRelation(RF), getRelation(INT)).setName(RFI);
            case COE:
                return getRelation(RelIntersection.class, getRelation(CO), getRelation(EXT)).setName(COE);
            case COI:
                return getRelation(RelIntersection.class, getRelation(CO), getRelation(INT)).setName(COI);
            case FRE:
                return getRelation(RelIntersection.class, getRelation(FR), getRelation(EXT)).setName(FRE);
            case FRI:
                return getRelation(RelIntersection.class, getRelation(FR), getRelation(INT)).setName(FRI);
            case MFENCE:
                return getRelation(RelFencerel.class, FilterBasic.get(MFENCE));
            case ISH:
                return getRelation(RelFencerel.class, FilterBasic.get(ISH));
            case ISB:
                return getRelation(RelFencerel.class, FilterBasic.get(ISB));
            case SYNC:
                return getRelation(RelFencerel.class, FilterBasic.get(SYNC));
            case ISYNC:
                return getRelation(RelFencerel.class, FilterBasic.get(ISYNC));
            case LWSYNC:
                return getRelation(RelFencerel.class, FilterBasic.get(LWSYNC));
            case CTRLISYNC:
                return getRelation(RelIntersection.class, getRelation(CTRL), getRelation(ISYNC)).setName(CTRLISYNC);
            case CTRLISB:
                return getRelation(RelIntersection.class, getRelation(CTRL), getRelation(ISB)).setName(CTRLISB);
            default:
                throw new RuntimeException(name + "is part of RelationNameRepository but it has no associated relation.");
        }
    }
}
