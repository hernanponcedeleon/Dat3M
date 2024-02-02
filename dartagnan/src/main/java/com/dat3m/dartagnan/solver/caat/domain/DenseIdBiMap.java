package com.dat3m.dartagnan.solver.caat.domain;


import com.google.common.base.Preconditions;

import java.util.*;

/*
    This class is intended to map some domain D into a dense range of ids [0, ..., |D| - 1].
 */
public class DenseIdBiMap<T> {

    private final Map<T, Integer> objToIdMap;
    private T[] idToObjMap;

    @SuppressWarnings("unchecked")
    private DenseIdBiMap(int expectedMaxId, Map<T, Integer> objToIdMap) {
        Preconditions.checkArgument(expectedMaxId > 0, "expectedMaxId must be positive");
        Preconditions.checkNotNull(objToIdMap);

        this.objToIdMap = objToIdMap;
        this.idToObjMap = (T[])(new Object[expectedMaxId]);
    }

    public static <V> DenseIdBiMap<V> createHashBased(int expectedMaxId) {
        return new DenseIdBiMap<>(expectedMaxId, new HashMap<>(4 * expectedMaxId / 3));
    }

    public static <V> DenseIdBiMap<V> createIdentityBased(int expectedMaxId) {
        return new DenseIdBiMap<>(expectedMaxId, new IdentityHashMap<>(4 * expectedMaxId / 3));
    }

    public Set<T> getKeys() {
        return objToIdMap.keySet();
    }

    public int addObject(T obj) {
        final int nextId = size();
        if (objToIdMap.putIfAbsent(obj, nextId) == null) {
            if (nextId >= idToObjMap.length) {
                idToObjMap = Arrays.copyOf(idToObjMap, idToObjMap.length * 2);
            }
            idToObjMap[nextId] = obj;
            return nextId;
        } else {
            return -1;
        }
    }

    public int getId(Object obj) {
        Integer id = objToIdMap.get(obj);
        return id != null ? id : -1;
    }

    public T getObject(int id) {
        Preconditions.checkArgument(id >= 0, "id must be positive.");
        Preconditions.checkArgument(id < size(), "id must be less than size.");
        return idToObjMap[id];
    }

    public int size() {
        return objToIdMap.size();
    }

    public void clear() {
        Arrays.fill(idToObjMap, 0, size(), null);
        objToIdMap.clear();
    }

}
