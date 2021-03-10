package com.dat3m.dartagnan.wmm.utils;

import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.filter.FilterAbstract;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.relation.RecursiveRelation;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.relation.base.RelCrit;
import com.dat3m.dartagnan.wmm.relation.base.RelRMW;
import com.dat3m.dartagnan.wmm.relation.base.local.RelAddrDirect;
import com.dat3m.dartagnan.wmm.relation.base.local.RelIdd;
import com.dat3m.dartagnan.wmm.relation.base.memory.RelCo;
import com.dat3m.dartagnan.wmm.relation.base.memory.RelLoc;
import com.dat3m.dartagnan.wmm.relation.base.memory.RelRf;
import com.dat3m.dartagnan.wmm.relation.base.stat.*;
import com.dat3m.dartagnan.wmm.relation.binary.BinaryRelation;
import com.dat3m.dartagnan.wmm.relation.binary.RelComposition;
import com.dat3m.dartagnan.wmm.relation.binary.RelIntersection;
import com.dat3m.dartagnan.wmm.relation.binary.RelUnion;
import com.dat3m.dartagnan.wmm.relation.unary.RelInverse;
import com.dat3m.dartagnan.wmm.relation.unary.RelTrans;
import com.dat3m.dartagnan.wmm.relation.unary.UnaryRelation;

import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

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
            relation = getBasicRelation(name);
            if(relation != null){
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
            Relation relation = relationMap.get(term);

            if(relation == null){
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
            if(relationMap.get(relation.getName()) != null){
                throw new RuntimeException("Relation " + relation.getName() + " is already declared");
            }
            relationMap.put(relation.getName(), relation);
        }
    }

    private void addRelation(Relation relation) {
        relationMap.put(relation.getTerm(), relation);
        if(relation.getIsNamed()){
            relationMap.put(relation.getName(), relation);
        }
    }

    private Class<?>[] getArgsForClass(Class<?> cls){
        if(BinaryRelation.class.isAssignableFrom(cls)){
            return new Class<?>[]{Relation.class, Relation.class};
        } else if(UnaryRelation.class.isAssignableFrom(cls)){
            return new Class<?>[]{Relation.class};
        } else if(RelCartesian.class.isAssignableFrom(cls)){
            return new Class<?>[]{FilterAbstract.class, FilterAbstract.class};
        } else if(RelSetIdentity.class.isAssignableFrom(cls)){
            return new Class<?>[]{FilterAbstract.class};
        } else if(RelFencerel.class.isAssignableFrom(cls) || RecursiveRelation.class.isAssignableFrom(cls)) {
            return new Class<?>[]{String.class};
        }

        throw new RuntimeException("Method getArgsForClass is not implemented for " + cls.getName());
    }

    private Relation getBasicRelation(String name){
        switch (name){
            case "_po":
                return new RelPo(true);
            case "po":
                return new RelPo();
            case "loc":
                return new RelLoc();
            case "id":
                return new RelId();
            case "int":
                return new RelInt();
            case "ext":
                return new RelExt();
            case "co":
                return new RelCo();
            case "rf":
                return new RelRf();
            case "rmw":
                return new RelRMW();
            case "crit":
                return new RelCrit();
            case "idd":
                return new RelIdd();
            case "addrDirect":
                return new RelAddrDirect();
            case "ctrlDirect":
                return new RelCtrlDirect();
            case "0":
                return new RelEmpty("0");
            case "rf^-1":
                return getRelation(RelInverse.class, getRelation("rf"));
            case "fr":
                return getRelation(RelComposition.class, getRelation("rf^-1"), getRelation("co")).setName("fr");
            case "(R*W)":
                return getRelation(RelCartesian.class, FilterBasic.get(EType.READ), FilterBasic.get(EType.WRITE));
            case "(R*M)":
                return getRelation(RelCartesian.class, FilterBasic.get(EType.READ), FilterBasic.get(EType.MEMORY));
            case "idd^+":
                return getRelation(RelTrans.class, getRelation("idd"));
            case "data":
                return getRelation(RelIntersection.class, getRelation("idd^+"), getRelation("(R*W)")).setName("data");
            case "addr":
                return getRelation(RelIntersection.class,
                        getRelation(
                                RelUnion.class,
                                getRelation("addrDirect"),
                                getRelation(RelComposition.class, getRelation("idd^+"), getRelation("addrDirect"))
                        ), getRelation("(R*M)")).setName("addr");
            case "ctrl":
                return getRelation(RelComposition.class, getRelation("idd^+"), getRelation("ctrlDirect")).setName("ctrl");
            case "po-loc":
                return getRelation(RelIntersection.class, getRelation("po"), getRelation("loc")).setName("po-loc");
            case "rfe":
                return getRelation(RelIntersection.class, getRelation("rf"), getRelation("ext")).setName("rfe");
            case "rfi":
                return getRelation(RelIntersection.class, getRelation("rf"), getRelation("int")).setName("rfi");
            case "coe":
                return getRelation(RelIntersection.class, getRelation("co"), getRelation("ext")).setName("coe");
            case "coi":
                return getRelation(RelIntersection.class, getRelation("co"), getRelation("int")).setName("coi");
            case "fre":
                return getRelation(RelIntersection.class, getRelation("fr"), getRelation("ext")).setName("fre");
            case "fri":
                return getRelation(RelIntersection.class, getRelation("fr"), getRelation("int")).setName("fri");
            case "mfence":
                return getRelation(RelFencerel.class,"Mfence");
            case "ish":
                return getRelation(RelFencerel.class,"Ish");
            case "isb":
                return getRelation(RelFencerel.class,"Isb");
            case "sync":
                return getRelation(RelFencerel.class,"Sync");
            case "isync":
                return getRelation(RelFencerel.class,"Isync");
            case "lwsync":
                return getRelation(RelFencerel.class,"Lwsync");
            case "ctrlisync":
                return getRelation(RelIntersection.class, getRelation("ctrl"), getRelation("isync")).setName("ctrlisync");
            case "ctrlisb":
                return getRelation(RelIntersection.class, getRelation("ctrl"), getRelation("isb")).setName("ctrlisb");
            default:
                return null;
        }
    }
}
