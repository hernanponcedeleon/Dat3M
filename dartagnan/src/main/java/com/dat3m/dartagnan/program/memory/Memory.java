package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.program.memory.utils.IllegalMemoryAccessException;
import com.google.common.collect.BiMap;
import com.google.common.collect.HashBiMap;
import com.google.common.collect.ImmutableSet;

import static com.dat3m.dartagnan.program.utils.Utils.convertToIntegerFormula;
import static com.dat3m.dartagnan.program.utils.Utils.generalEqual;

import java.math.BigInteger;
import java.util.*;
import java.util.stream.Collectors;

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

    private int nextIndex = 1;

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
            for(int i = 1; i < array.size(); i++){
            	IntegerFormula e2 = convertToIntegerFormula(array.get(i).toIntFormula(ctx), ctx);
				IntegerFormula newAddress = imgr.add(convertToIntegerFormula(e1, ctx), imgr.makeNumber(BigInteger.ONE));
				enc = bmgr.and(enc, generalEqual(e2, newAddress, ctx));
                e1 = e2;
            }
        }
        // Following SMACK, only address with constant values can have negative values.
        for(Address add : getAllAddresses()) {
        	if(!add.hasConstantValue()) {
        		enc = bmgr.and(enc, imgr.greaterThan(
        							convertToIntegerFormula(add.toIntFormula(ctx), ctx),
        							imgr.makeNumber(BigInteger.ZERO)));
        	}
        }
        
        BooleanFormula distinct = getAllAddresses().size() > 1 ?
        		imgr.distinct(getAllAddresses().stream()
                		.map(a -> convertToIntegerFormula(a.toIntFormula(ctx), ctx))
                		.collect(Collectors.toList())) :
                bmgr.makeTrue();

        return bmgr.and(enc, distinct);
    }

    // Assigns each Address a fixed memory address.
    public BooleanFormula fixedMemoryEncoding(SolverContext ctx) {
        FormulaManager fmgr = ctx.getFormulaManager();
		IntegerFormulaManager imgr = fmgr.getIntegerFormulaManager();

    	BooleanFormula[] addrExprs = getAllAddresses().stream().filter(x -> !x.hasConstantValue())
        		.map(add -> imgr.equal(convertToIntegerFormula(add.toIntFormula(ctx), ctx),
        								imgr.makeNumber(add.getValue().intValue())))
        		.toArray(BooleanFormula[]::new);
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