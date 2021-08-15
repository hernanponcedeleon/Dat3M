package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.program.memory.utils.IllegalMemoryAccessException;
import com.google.common.collect.BiMap;
import com.google.common.collect.HashBiMap;
import com.google.common.collect.ImmutableSet;

import static com.dat3m.dartagnan.program.utils.Utils.generalEqual;

import java.math.BigInteger;
import java.util.*;
import java.util.stream.Collectors;

import org.sosy_lab.java_smt.api.BitvectorFormula;
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
		BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();
        IntegerFormulaManager imgr = fmgr.getIntegerFormulaManager();

		BooleanFormula enc = bmgr.makeTrue();
		for(List<Address> array : arrays.values()){
        	Formula e1 = array.get(0).toIntFormula(ctx);
        	boolean bv = e1 instanceof BitvectorFormula;
            for(int i = 1; i < array.size(); i++){
            	Formula e2 = array.get(i).toIntFormula(ctx);
				Formula newAddress = bv ?
						fmgr.getBitvectorFormulaManager().add((BitvectorFormula)e1, fmgr.getBitvectorFormulaManager().makeBitvector(array.get(0).getPrecision(), BigInteger.ONE)) :
						imgr.add((IntegerFormula)e1, imgr.makeNumber(BigInteger.ONE));
				;
				enc = bmgr.and(enc, generalEqual(e2, newAddress, ctx));
                e1 = e2;
            }
        }
        // Following SMACK, only address with constant values can have negative values.
        for(Address add : getAllAddresses()) {
        	if(!add.hasConstantValue()) {
        		enc = bmgr.and(enc, add.toIntFormula(ctx) instanceof BitvectorFormula ?
        				imgr.greaterThan(fmgr.getBitvectorFormulaManager().toIntegerFormula((BitvectorFormula)add.toIntFormula(ctx), false), imgr.makeNumber(BigInteger.ZERO)) :
        				imgr.greaterThan((IntegerFormula)add.toIntFormula(ctx), imgr.makeNumber(BigInteger.ZERO)));
        	}
        }
        
        BooleanFormula distinct = getAllAddresses().size() > 1 ?
        		imgr.distinct(getAllAddresses().stream()
                		.map(a -> convertToIntegerFormula(a.toIntFormula(ctx), ctx))
                		.collect(Collectors.toList())) : 
                bmgr.makeTrue();
        
        return bmgr.and(enc, distinct);        	
    }

    private IntegerFormula convertToIntegerFormula(Formula f, SolverContext ctx) {
    	return f instanceof BitvectorFormula ? 
    			ctx.getFormulaManager().getBitvectorFormulaManager().toIntegerFormula((BitvectorFormula) f, false) : 
    			(IntegerFormula)f;
    }
    
    // Assigns each Address a fixed memory address.
    public BooleanFormula fixedMemoryEncoding(SolverContext ctx) {
        FormulaManager fmgr = ctx.getFormulaManager();
		IntegerFormulaManager imgr = fmgr.getIntegerFormulaManager();

        boolean bv = getAllAddresses().iterator().next().toIntFormula(ctx) instanceof BitvectorFormula;
    	BooleanFormula[] addrExprs;
    	if(bv) {
        	addrExprs = getAllAddresses().stream().filter(x -> !x.hasConstantValue())
            		.map(add -> {
                        Formula e1 = add.toIntFormula(ctx);
                        fmgr.getBitvectorFormulaManager().toIntegerFormula((BitvectorFormula) e1, false);
						return imgr.equal((IntegerFormula) e1, imgr.makeNumber(add.getValue().intValue()));})
            		.toArray(BooleanFormula[]::new);
    	} else {
        	addrExprs = getAllAddresses().stream().filter(x -> !x.hasConstantValue())
            		.map(add -> imgr.equal((IntegerFormula) add.toIntFormula(ctx), fmgr.getIntegerFormulaManager().makeNumber(add.getValue().intValue())))
            		.toArray(BooleanFormula[]::new);
    	}
        return fmgr.getBooleanFormulaManager().and(addrExprs);
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