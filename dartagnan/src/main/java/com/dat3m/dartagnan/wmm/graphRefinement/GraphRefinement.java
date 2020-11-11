package com.dat3m.dartagnan.wmm.graphRefinement;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Empty;
import com.dat3m.dartagnan.wmm.axiom.Irreflexive;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.CoLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.EdgeLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.EventLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.Edge;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.EventData;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.RelationData;
import com.dat3m.dartagnan.wmm.graphRefinement.edgeSet.*;
import com.dat3m.dartagnan.wmm.graphRefinement.edgeSet.axiom.EdgeSetEmptyAxiom;
import com.dat3m.dartagnan.wmm.graphRefinement.edgeSet.axiom.EdgeSetIrreflexiveAxiom;
import com.dat3m.dartagnan.wmm.graphRefinement.edgeSet.basic.*;
import com.dat3m.dartagnan.wmm.graphRefinement.edgeSet.binary.EdgeSetComposition;
import com.dat3m.dartagnan.wmm.graphRefinement.edgeSet.binary.EdgeSetIntersection;
import com.dat3m.dartagnan.wmm.graphRefinement.edgeSet.binary.EdgeSetMinus;
import com.dat3m.dartagnan.wmm.graphRefinement.edgeSet.binary.EdgeSetUnion;
import com.dat3m.dartagnan.wmm.graphRefinement.edgeSet.unary.EdgeSetInverse;
import com.dat3m.dartagnan.wmm.graphRefinement.edgeSet.unary.EdgeSetTransitive;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.DNF;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.SortedClauseSet;
import com.dat3m.dartagnan.wmm.relation.base.memory.RelCo;
import com.dat3m.dartagnan.wmm.relation.base.memory.RelLoc;
import com.dat3m.dartagnan.wmm.relation.base.memory.RelRf;
import com.dat3m.dartagnan.wmm.relation.base.stat.RelPo;
import com.dat3m.dartagnan.wmm.relation.binary.*;
import com.dat3m.dartagnan.wmm.relation.unary.RelInverse;
import com.dat3m.dartagnan.wmm.relation.unary.RelTrans;
import com.microsoft.z3.Context;
import com.microsoft.z3.Model;

import java.util.*;
import java.util.stream.Collectors;


public class GraphRefinement {

    private GraphContext context;

    // ====== Data specific for a single refinement =======
    private PriorityQueue<Task> tasks;

    private EdgeSetRf rf;
    private EdgeSetCo writeOrder; // non-transitive coherence
    private EdgeSetTransitive co;

    private List<EdgeSet> axioms;

    public GraphRefinement(Program program, Wmm memoryModel) {
        context = new GraphContext(program, memoryModel);
        tasks = new PriorityQueue<>();
        computeEdgeSets();
        axioms = context.getRelationDataList().stream().filter(x -> x.isAxiom()).
                map(x -> x.getEdgeSet()).collect(Collectors.toList());
    }

    public void populateFromModel(Model model, Context ctx) {
        context.init(model, ctx);
        tasks.clear();

        initialize();
        propagate();
    }

    private Map<Integer, Set<Edge>> possibleCoEdges = new HashMap<>();
    private SortedClauseSet<CoreLiteral> coreReasonsSorted = new SortedClauseSet<>();
    public DNF<CoreLiteral> search() {

        int time = 0;
        coreReasonsSorted.clear();
        possibleCoEdges.clear();
        initSearch();
        propagate();

        if (checkViolations()) {
            computeViolations();
            return resolveViolations();
        }
        /*if (reasonGraph.hasViolations()) {
            computeViolations();
            return resolveViolations();
        }*/

        List<Edge> coSearchList = new ArrayList<>();
        for (Set<Edge> coEdges : possibleCoEdges.values()) {
            coSearchList.addAll(coEdges);
        }
        sortCoSearchList(coSearchList);

        boolean progress = false;
        boolean invalid = false;
        do {
            int curTime = time;
            progress = false;
            for (int i = 0; i < coSearchList.size(); i++) {
                Edge coEdge = coSearchList.get(i);
                if (co.contains(coEdge) || co.contains((coEdge.getInverse()))) {
                    coSearchList.remove(i);
                    coSearchList.remove(coEdge.getInverse());
                    progress = true;
                    break;
                }
                addCoEdge(coEdge, time + 1);
                propagate();
                if (checkViolations()) {
                    computeViolations();
                    progress = true;
                    coSearchList.remove(i);
                    coSearchList.remove(coEdge.getInverse());
                    backtrack(time);
                    addCoEdge(coEdge.getInverse(), time);
                    propagate();
                    if (checkViolations()) {
                        computeViolations();
                        invalid = true;
                    }
                    break;
                }
                backtrack(time);
            }
        } while(progress && !invalid);

        return resolveViolations();
    }

    private boolean checkViolations() {
        for(EdgeSet axiom : axioms) {
            if (axiom.edgeIterator().hasNext())
                return true;
        }
        return false;
    }

    private void computeViolations() {
        for (EdgeSet axiom : axioms) {
            Iterator<Edge> iterator = axiom.edgeIterator();
            if (iterator.hasNext()) {
                Conjunction<CoreLiteral> clause = axiom.computeShortestReason(iterator.next());
                coreReasonsSorted.add(clause.removeIf(x -> canBeRemoved(x, clause)));
                return; // Stop on the first violation for now
            }
        }
        /*for (ReasonGraph.Node violation : reasonGraph.getViolations()) {
            //coreReasons = coreReasons.or(violation.computeSingleCoreReason());
            Conjunction<CoreLiteral> clause = violation.getSingleCoreReason();
            coreReasonsSorted.add(clause.removeIf(x -> canBeRemoved(x, clause)));
        }*/
    }

    private boolean canBeRemoved(CoreLiteral literal, Conjunction<CoreLiteral> clause) {
        if (!(literal instanceof EventLiteral))
            return false;
        EventLiteral eventLit = (EventLiteral)literal;
        return clause.getLiterals().stream().anyMatch(x -> {
            if (!(x instanceof EdgeLiteral) || x.hasOpposite())
                return false;
            EdgeLiteral edgeLiteral = (EdgeLiteral)x;
            return edgeLiteral.getEdge().getFirst().equals(eventLit.getEvent())
                    || edgeLiteral.getEdge().getSecond().equals(eventLit.getEvent());
        });
    }

    private DNF<CoreLiteral> resolveViolations() {
        SortedClauseSet<CoreLiteral> res =  coreReasonsSorted.computeAllResolvents();
        res.removeWhere(y -> y.hasOpposite());
        return new DNF<>(res.getClauses());
    }

    private void sortCoSearchList(List<Edge> list) {
        int index = 0;
        for (int i = 0; i < list.size(); i++) {
            Edge t = list.get(i);
            if (i > index && (rf.inEdgeIterator(t.getFirst()).hasNext() || rf.inEdgeIterator(t.getSecond()).hasNext()
            || rf.outEdgeIterator(t.getSecond()).hasNext() || rf.outEdgeIterator(t.getSecond()).hasNext()))
            {
                list.set(i, list.get(index));
                list.set(index++, t);
            }
        }
    }


    private void backtrack(int to) {
       // reasonGraph.forgetHistory(to);
        for (RelationData relData : context.getRelationDataList())
            relData.getEdgeSet().forgetHistory(to);
    }

    private void merge(int at) {
        //reasonGraph.mergeHistory(at);
        for (RelationData relData : context.getRelationDataList())
            relData.getEdgeSet().mergeHistory(at);
    }

    private void initSearch() {
        for (Map.Entry<Integer, Set<EventData>> addressedWrites : context.getAddressWritesMap().entrySet()) {
            Set<EventData> writes = addressedWrites.getValue();
            Integer address = addressedWrites.getKey();
            Set<Edge> coEdges = new HashSet<>();
            possibleCoEdges.put(address, coEdges);

            for (EventData e1 : writes) {
                for (EventData e2: writes) {
                    if (e2.getId() >= e1.getId())
                        continue;

                    if (e1.isInit() && !e2.isInit()) {
                        addCoEdge(new Edge(e1, e2), 0);
                        // Test code: add violation for anti initial writes cause we will
                        // never search for them otherwise
                        coreReasonsSorted.add( new Conjunction<>(new CoLiteral(new Edge(e2, e1), context)));
                    } else if (!e1.isInit() && !e2.isInit()) {
                        coEdges.add(new Edge(e1, e2));
                    }
                }
            }

        }
    }

    private boolean addCoEdge(Edge edge, int time) {
        if (writeOrder.add(edge, time)) {
            Task newTask = new Task(writeOrder, co, Collections.singleton(edge), time);
            tasks.add(newTask);
            return true;
        }
        return false;
    }

    private void propagate() {
        while (!tasks.isEmpty() /*&& !reasonGraph.hasViolations()*/)
            tasks.poll().perform();
        tasks.clear();
    }


    private void initialize() {
        for (RelationData data : context.getRelationDataList()) {
            Set<Edge> updatedEdges = data.getEdgeSet().initialize(context);

            if (!updatedEdges.isEmpty()) {
                for (RelationData dependent : data.getDependents()) {
                    Task newTask = new Task(data.getEdgeSet(), dependent.getEdgeSet(), updatedEdges, 0);
                    tasks.add(newTask);
                }
            }
        }
    }


    private void computeEdgeSets() {
        for (RelationData relData : context.getRelationDataList()) {
            computeEdgeSet(relData);
        }
    }

    private EdgeSet computeEdgeSet(RelationData relData) {
        if (relData.getEdgeSet() != null)
            return relData.getEdgeSet();

        if (relData.isAxiom()) {
            Class axiomClass = relData.getAxiom().getClass();
            EdgeSet inner = computeEdgeSet(relData.getInner());
            if (axiomClass == Irreflexive.class)
                relData.setEdgeSet(new EdgeSetIrreflexiveAxiom(relData, inner));
            else if (axiomClass == Empty.class) {
                relData.setEdgeSet(new EdgeSetEmptyAxiom(relData, inner));
            }
            else
                throw new RuntimeException(new ClassNotFoundException(axiomClass.toString() + " is no supported axiom"));

            return relData.getEdgeSet();
        }

        //Relation rel = relData.getRelation();
        Class relClass = relData.getRelation().getClass();
        if (relClass == RelRf.class) {
            relData.setEdgeSet(rf = new EdgeSetRf(relData));
        } else if (relClass == RelLoc.class) {
            relData.setEdgeSet(new EdgeSetLoc(relData));
        } else if (relClass == RelPo.class) {
            relData.setEdgeSet(new EdgeSetPo(relData));
        } else if (relClass == RelCo.class) {
            // A little ugly
            if (relData.getRelation().getName().equals("_co"))
                relData.setEdgeSet(writeOrder = new EdgeSetCo(relData));
            else
                relData.setEdgeSet(co = new EdgeSetTransitive(relData, writeOrder));
        } else if (relData.isUnaryRelation()) {
            RelationData innerRelData = relData.getInner();
            EdgeSet inner = computeEdgeSet(innerRelData);
            // A safety check because recursion might compute this edge set
            if (relData.getEdgeSet() != null)
                return relData.getEdgeSet();
            if (relClass == RelInverse.class) {
                relData.setEdgeSet(new EdgeSetInverse(relData, inner));
            } else if (relClass == RelTrans.class) {
                relData.setEdgeSet(new EdgeSetTransitive(relData, inner));
            } //TODO: RelTransRef.class is missing
        } else if (relData.isBinaryRelation()) {
            EdgeSet first = computeEdgeSet(relData.getFirst());
            EdgeSet second = computeEdgeSet(relData.getSecond());

            // Might be the case when recursion is in play
            if (relData.getEdgeSet() != null)
                return relData.getEdgeSet();

            if (relClass == RelUnion.class) {
                relData.setEdgeSet(new EdgeSetUnion(relData, first, second));
            } else if (relClass == RelIntersection.class) {
                relData.setEdgeSet(new EdgeSetIntersection(relData, first, second));
            } else if (relClass == RelComposition.class) {
                relData.setEdgeSet(new EdgeSetComposition(relData, first, second));
            } else if (relClass == RelMinus.class) {
                relData.setEdgeSet(new EdgeSetMinus(relData, first, second));
            }
        } else if (relData.isRecursiveRelation()) {
            EdgeSetRecursive recEdgeSet = new EdgeSetRecursive(relData);
            relData.setEdgeSet(recEdgeSet);
            recEdgeSet.setConcreteSet(computeEdgeSet(relData.getInner()));
        } else if (relData.isStaticRelation()) {
            relData.setEdgeSet(new EdgeSetStatic(relData));
        } else {
            throw new RuntimeException(new ClassNotFoundException(relClass.toString() + " is no supported relation class"));
        }
        return relData.getEdgeSet();
    }


    private class Task implements Comparable<Task> {
        private EdgeSet from;
        private EdgeSet target;
        private Set<Edge> added;
        private int time;

        public Task(EdgeSet from, EdgeSet target, Set<Edge> added, int time) {
            this.from = from;
            this.target = target;
            this.added = added;
            this.time = time;
        }

        @Override
        public int compareTo(Task o) {
            return target.getRelation().getTopologicalIndex()
                    - o.target.getRelation().getTopologicalIndex();
        }

        public void perform() {
            Set<Edge> newEdges = target.update(from, added, time);
            if (newEdges.isEmpty())
                return;;

            for (RelationData dependent : target.getRelation().getDependents()) {
                Task newTask = new Task(target, dependent.getEdgeSet(), newEdges, time);
                tasks.add(newTask);
            }
        }
    }

}
