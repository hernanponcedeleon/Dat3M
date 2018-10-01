package dartagnan.wmm.utils;

import dartagnan.program.event.Event;

import java.util.*;

public class TupleSet implements Set<Tuple>{

    private Set<Tuple> tuples = new HashSet<>();
    private Map<Event, Set<Tuple>> byFirst = new HashMap<>();
    private Map<Event, Set<Tuple>> bySecond = new HashMap<>();
    private boolean isUpdated = false;

    @Override
    public boolean add(Tuple e){
        boolean result = tuples.add(e);
        isUpdated |= result;
        return result;
    }

    @Override
    public boolean addAll(Collection<? extends Tuple> c){
        boolean result = c instanceof TupleSet ? tuples.addAll(((TupleSet)c).tuples) : tuples.addAll(c);
        isUpdated |= result;
        return result;
    }

    @Override
    public void clear(){
        tuples.clear();
        isUpdated = true;
    }

    @Override
    public boolean contains(Object e){
        return tuples.contains(e);
    }

    @Override
    public boolean containsAll(Collection<?> c){
        return c instanceof TupleSet ? tuples.containsAll(((TupleSet)c).tuples) : tuples.containsAll(c);
    }

    @Override
    public boolean equals(Object obj){
        if (this == obj)
            return true;

        if (obj == null || getClass() != obj.getClass())
            return false;

        return tuples.equals(((TupleSet)obj).tuples);
    }

    @Override
    public int hashCode(){
        return tuples.hashCode();
    }

    @Override
    public boolean isEmpty(){
        return tuples.isEmpty();
    }

    @Override
    public Iterator<Tuple> iterator(){
        return tuples.iterator();
    }

    @Override
    public boolean remove(Object e){
        boolean result = tuples.remove(e);
        isUpdated |= result;
        return result;
    }

    @Override
    public boolean removeAll(Collection<?> c){
        boolean result = c instanceof TupleSet ? tuples.removeAll(((TupleSet)c).tuples) : tuples.removeAll(c);
        isUpdated |= result;
        return result;
    }

    @Override
    public boolean retainAll(Collection<?> c){
        boolean result = c instanceof TupleSet ? tuples.retainAll(((TupleSet)c).tuples) : tuples.retainAll(c);
        isUpdated |= result;
        return result;
    }

    @Override
    public int size(){
        return tuples.size();
    }

    @Override
    public Object[] toArray(){
        return tuples.toArray();
    }

    @Override
    public <T> T[] toArray(T[] a){
        return tuples.toArray(a);
    }

    @Override
    public String toString(){
        return tuples.toString();
    }

    public Set<Tuple> getByFirst(Event e){
        if(isUpdated){
            updateAuxiliary();
        }
        //return new HashSet<>(byFirst.get(e));
        byFirst.putIfAbsent(e, new HashSet<>());
        return byFirst.get(e);
    }

    public Set<Tuple> getBySecond(Event e){
        if(isUpdated){
            updateAuxiliary();
        }
        //return new HashSet<>(bySecond.get(e));
        bySecond.putIfAbsent(e, new HashSet<>());
        return bySecond.get(e);
    }

    public Map<Event, Set<Event>> transMap(){
        Map<Event, Set<Event>> map = new HashMap<>();

        for(Tuple tuple : tuples){
            map.putIfAbsent(tuple.getFirst(), new HashSet<>());
            map.putIfAbsent(tuple.getSecond(), new HashSet<>());
            Set<Event> events = map.get(tuple.getFirst());
            events.add(tuple.getSecond());
        }

        boolean changed = true;

        while (changed){
            changed = false;
            for(Event e1 : map.keySet()){
                Set<Event> newEls = new HashSet<>();
                for(Event e2 : map.get(e1)){
                    if(!(e1.getEId().equals(e2.getEId()))){
                        newEls.addAll(map.get(e2));
                    }
                }
                if(map.get(e1).addAll(newEls))
                    changed = true;
            }
        }

        return map;
    }

    private void updateAuxiliary(){
        byFirst.clear();
        bySecond.clear();
        for(Tuple e : tuples){
            byFirst.putIfAbsent(e.getFirst(), new HashSet<>());
            byFirst.get(e.getFirst()).add(e);
            bySecond.putIfAbsent(e.getSecond(), new HashSet<>());
            bySecond.get(e.getSecond()).add(e);
        }
        isUpdated = false;
    }
}
