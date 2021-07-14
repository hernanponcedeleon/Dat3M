package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.program.memory.utils.IllegalMemoryAccessException;
import com.google.common.collect.BiMap;
import com.google.common.collect.HashBiMap;
import com.google.common.collect.ImmutableSet;

import java.math.BigInteger;
import java.util.*;
import java.util.stream.Collectors;

import org.sosy_lab.java_smt.api.BitvectorFormula;
import org.sosy_lab.java_smt.api.BitvectorFormulaManager;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.IntegerFormulaManager;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;
import org.sosy_lab.java_smt.api.SolverContext;

public class Memory {

    private final BiMap<Location, Address> map;
    private final Map<String, Location> locationIndex;
    private final Map<String, List<Address>> arrays;

    private int nextIndex = 0;

    public Memory(){
        map = HashBiMap.create();
        locationIndex = new HashMap<>();
        arrays = new HashMap<>();
    }

    public Location getLocationForAddress(Address address){
        return map.inverse().get(address);
    }

    public BooleanFormula encode(SolverContext ctx){
    	FormulaManager fmgr = ctx.getFormulaManager();
    	BitvectorFormulaManager bvmgr = fmgr.getBitvectorFormulaManager();
		IntegerFormulaManager imgr = fmgr.getIntegerFormulaManager();
		BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();

		BooleanFormula enc = bmgr.makeTrue();
        for(List<Address> array : arrays.values()){
        	Formula e1 = array.get(0).toZ3Int(ctx);
        	boolean bv = e1 instanceof BitvectorFormula;
            for(int i = 1; i < array.size(); i++){
            	Formula e2 = array.get(i).toZ3Int(ctx);
				Formula newAddress = bv ?
            			bvmgr.add((BitvectorFormula)e1, bvmgr.makeBitvector(array.get(0).getPrecision(), BigInteger.ONE)) :
            			imgr.add((IntegerFormula)e1, imgr.makeNumber(BigInteger.ONE));
				enc = bmgr.and(enc, bv ? 
						bvmgr.equal((BitvectorFormula)e2, (BitvectorFormula)newAddress) : 
						imgr.equal((IntegerFormula)e2, (IntegerFormula)newAddress));
                e1 = e2;
            }
        }
        // Following SMACK, only address with constant values can have negative values.
        for(Address add : getAllAddresses()) {
        	if(!add.hasConstantValue()) {
        		enc = bmgr.and(enc, add.toZ3Int(ctx) instanceof BitvectorFormula ?
        				imgr.greaterThan(bvmgr.toIntegerFormula((BitvectorFormula)add.toZ3Int(ctx), false), imgr.makeNumber(BigInteger.ZERO)) :
        				imgr.greaterThan((IntegerFormula)add.toZ3Int(ctx), imgr.makeNumber(BigInteger.ZERO)));
        	}
        }
        
        return bmgr.and(enc, imgr.distinct(getAllAddresses().stream()
        		.map(a -> convertToIntegerFormula(a.toZ3Int(ctx), ctx))
        		.collect(Collectors.toList())));        	
    }

    private IntegerFormula convertToIntegerFormula(Formula f, SolverContext ctx) {
    	return f instanceof BitvectorFormula ? 
    			ctx.getFormulaManager().getBitvectorFormulaManager().toIntegerFormula((BitvectorFormula) f, false) : 
    			(IntegerFormula)f;
    }
    
    // Assigns each Address a fixed memory address.
    public BooleanFormula fixedMemoryEncoding(SolverContext ctx) {
        BitvectorFormulaManager bvmgr = ctx.getFormulaManager().getBitvectorFormulaManager();
        IntegerFormulaManager imgr = ctx.getFormulaManager().getIntegerFormulaManager();

        boolean bv = getAllAddresses().iterator().next().toZ3Int(ctx) instanceof BitvectorFormula;
    	BooleanFormula[] addrExprs;
    	if(bv) {
        	addrExprs = getAllAddresses().stream().filter(x -> !x.hasConstantValue())
            		.map(add -> {
                        Formula e1 = add.toZ3Int(ctx);
						bvmgr.toIntegerFormula((BitvectorFormula) e1, false);
						return (BooleanFormula)imgr.equal((IntegerFormula) e1, imgr.makeNumber(add.getValue().intValue()));})
            		.toArray(BooleanFormula[]::new);
    	} else {
        	addrExprs = getAllAddresses().stream().filter(x -> !x.hasConstantValue())
            		.map(add -> (BooleanFormula)imgr.equal((IntegerFormula) add.toZ3Int(ctx), imgr.makeNumber(add.getValue().intValue())))
            		.toArray(BooleanFormula[]::new);
    	}
        return ctx.getFormulaManager().getBooleanFormulaManager().and(addrExprs);
    }

    public List<Address> malloc(String name, int size, int precision){
        if(!arrays.containsKey(name) && size > 0){
            List<Address> addresses = new ArrayList<>();
            for(int i = 0; i < size; i++){
                addresses.add(new Address(nextIndex++, precision));
            }
            arrays.put(name, addresses);
            return addresses;
        }
        throw new IllegalMemoryAccessException("Illegal malloc for " + name);
    }

    public Location getOrCreateLocation(String name, int precision){
        if(!locationIndex.containsKey(name)){
            Location location = new Location(name, new Address(nextIndex++, precision));
            map.put(location, location.getAddress());
            locationIndex.put(name, location);
            return location;
        }
        return locationIndex.get(name);
    }

    public ImmutableSet<Address> getAllAddresses(){
        Set<Address> result = new HashSet<>(map.values());
        for(List<Address> array : arrays.values()){
            result.addAll(array);
        }
        return ImmutableSet.copyOf(result);
    }

    public boolean isArrayPointer(Address address) {
    	return arrays.values().stream()
        	.collect(ArrayList::new, List::addAll, List::addAll).contains(address);
    }
    
    public List<Address> getArrayfromPointer(Address address) {
    	for(List<Address> array : arrays.values()) {
    		if(array.contains(address)) {
    			return array;
    		}
    	}
    	// This method shall be called after isArrayPointer to avoid returning null
		return null;
    }
}