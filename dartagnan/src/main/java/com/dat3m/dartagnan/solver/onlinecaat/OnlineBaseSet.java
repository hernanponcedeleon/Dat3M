package com.dat3m.dartagnan.solver.onlinecaat;

import com.dat3m.dartagnan.solver.caat.domain.Domain;
import com.dat3m.dartagnan.solver.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.caat.predicates.sets.Element;
import com.dat3m.dartagnan.solver.caat.predicates.sets.base.AbstractBaseSet;
import com.dat3m.dartagnan.solver.caat.predicates.sets.base.SimpleSet;
import com.dat3m.dartagnan.wmm.Relation;

import java.util.*;
import java.util.stream.Stream;

/*
    The set analogue of OnlineBaseGraph.
    For each event, <atom> is
        NOT_MEMBER (-2) if the event can never be in the set,
        STATIC (-1) if the event is in the set iff it is executed,
        a (non-negative) atom id, if the event is in the set iff it is executed and the atom is true.
 */
public final class OnlineBaseSet extends AbstractBaseSet {

    static final int NOT_MEMBER = -2;
    static final int STATIC = -1;

    final Relation relation;
    private final OnlineCAATPropagator theory;
    final int[] atom;
    private final SimpleSet set = new SimpleSet();
    private final boolean isStatic;

    OnlineBaseSet(OnlineCAATPropagator theory, Relation relation, int[] atom) {
        this.theory = theory;
        this.relation = relation;
        this.atom = atom;
        this.isStatic = Arrays.stream(atom).allMatch(a -> a < 0);
    }

    public Relation getRelation() { return relation; }
    public boolean isStatic() { return isStatic; }

    @Override
    public boolean hasStaticMembership() { return isStatic; }

    void collectOnExec(int e, int time, List<Element> out) {
        final int a = atom[e];
        if (a == STATIC || (a >= 0 && theory.atomValue(a) > 0)) {
            out.add(new Element(e, time, 0));
        }
    }

    void collectOnAtomTrue(int e, int time, List<Element> out) {
        if (theory.isExecuted(e)) {
            out.add(new Element(e, time, 0));
        }
    }

    @Override
    public Element get(Element e) {
        final Element stored = set.get(e);
        if (stored != null) {
            return stored;
        }
        final int id = e.getId();
        return (id >= 0 && id < atom.length && atom[id] == STATIC) ? new Element(id) : null;
    }

    @Override
    @SuppressWarnings("unchecked")
    public Collection<Element> forwardPropagate(CAATPredicate changedSource, Collection<? extends Derivable> added) {
        final List<Element> changes = new ArrayList<>(added.size());
        for (Element e : (Collection<Element>) added) {
            if (set.add(e)) {
                changes.add(e);
            }
        }
        return changes;
    }

    @Override
    public void backtrackTo(int time) { set.backtrackTo(time); }

    @Override
    public void initializeToDomain(Domain<?> domain) {
        super.initializeToDomain(domain);
        set.initializeToDomain(domain);
    }

    @Override
    public int size() { return set.size(); }

    @Override
    public Stream<Element> elementStream() { return set.elementStream(); }

    @Override
    public Iterator<Element> elementIterator() { return set.elementIterator(); }

    @Override
    public Iterable<Element> elements() { return set.elements(); }

    @Override
    public String toString() { return getName(); }
}
