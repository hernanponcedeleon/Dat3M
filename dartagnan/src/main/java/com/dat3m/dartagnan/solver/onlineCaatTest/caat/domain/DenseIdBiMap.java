package com.dat3m.dartagnan.solver.onlineCaatTest.caat.domain;


import com.google.common.base.Preconditions;

import java.util.*;

/*
    This class is intended to map some domain D into a dense range of ids [0, ..., |D| - 1].
 */
public class DenseIdBiMap<T> {

    private final Map<T, Integer> objToIdMap;
    private List<T> idToObjMap;
    private final ArrayList<Integer> backtrackPoints;

    @SuppressWarnings("unchecked")
    private DenseIdBiMap(int expectedMaxId, Map<T, Integer> objToIdMap) {
        Preconditions.checkArgument(expectedMaxId > 0, "expectedMaxId must be positive");
        Preconditions.checkNotNull(objToIdMap);

        this.objToIdMap = objToIdMap;
        this.idToObjMap = new ArrayList<>(expectedMaxId);
        this.backtrackPoints = new ArrayList<>(expectedMaxId);
    }

    public DenseIdBiMap() {
        this.objToIdMap = new HashMap<>();
        this.idToObjMap = new ArrayList<>();
        this.backtrackPoints = new ArrayList<>();
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

    public int push() {
        int level = size();
        backtrackPoints.add(level);
        return level;
    }

    public int addObject(T obj) {
        final int nextId = size();
        if (objToIdMap.putIfAbsent(obj, nextId) == null) {
            idToObjMap.add(obj);
            assert(idToObjMap.get(nextId).equals(obj));
            return nextId;
        } else {
            return -1;
        }
    }

    public int removeObjectsFromTop(int number) {
        if (number > backtrackPoints.size() || number <= 0) {
            return -1;
        }
        int level = -1;
        for (int i = 0; i < number; i++) {
            level = backtrackPoints.remove(backtrackPoints.size() - 1);
            for(int size = size() - 1; size >= level; size--) {
                T obj = getObject(size);
                objToIdMap.remove(obj);
            }
            idToObjMap = idToObjMap.subList(0, level);
        }
        return level;
    }

    public int getId(Object obj) {
        Integer id = objToIdMap.get(obj);
        return id != null ? id : -1;
    }

    public T getObject(int id) {
        Preconditions.checkArgument(id >= 0, "id must be positive.");
        Preconditions.checkArgument(id < size(), "id must be less than size.");
        return idToObjMap.get(id);
    }

    public int size() {
        return idToObjMap.size();
    }

    public void clear() {
        idToObjMap.clear();
        objToIdMap.clear();
    }

}
