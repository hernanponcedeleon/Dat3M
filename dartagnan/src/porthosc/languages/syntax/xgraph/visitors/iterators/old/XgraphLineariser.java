package porthosc.languages.syntax.xgraph.visitors.iterators.old;//package porthosc.languages.syntax.xgraph.visitors.iterators.old;
//
//import porthosc.languages.syntax.xgraph.events.XEvent;
//import porthosc.languages.syntax.xgraph.events.computation.XComputationEvent;
//import porthosc.languages.syntax.xgraph.process.XFlowGraph;
//import porthosc.utils.patterns.Builder;
//
//import java.util.*;
//
//// TODO: Implement this as a Comparator! and then just sort the events list
//public class XgraphLineariser extends Builder<Queue<XEvent>> {
//    private final XFlowGraph process;
//
//    private final Deque<XEvent> linearised;
//    private final Set<XEvent> tempMarks;
//    private final Set<XEvent> permMarks;
//    private final Queue<XEvent> nonVisited;
//
//    public XgraphLineariser(XFlowGraph process) {
//        this.process = process;
//        this.linearised = new ArrayDeque<>();
//        this.tempMarks = new HashSet<>();
//        this.permMarks = new HashSet<>();
//        this.nonVisited = new ArrayDeque<>();
//    }
//
//    @Override
//    public Queue<XEvent> build() {
//        nonVisited.add(process.entry);
//        while (!nonVisited.isEmpty()) {
//            XEvent event = nonVisited.remove();
//            processDfsLinearisation(event);
//        }
//        assert tempMarks.isEmpty(): tempMarks.size();
//        assert permMarks.size() == linearised.size();
//        return linearised;
//    }
//
//    private void processDfsLinearisation(XEvent current) {
//        if (permMarks.contains(current)) {
//            return;
//        }
//        assert !tempMarks.contains(current); //not a dag in this case
//        tempMarks.add(current);
//
//        XEvent nextLinear = process.epsilonJumps.get(current);
//        if (nextLinear != null) {
//            processDfsLinearisation(nextLinear);
//        }
//        else if (current != process.exit) {
//            XComputationEvent currentComputationEvent = (XComputationEvent) current;
//            XEvent nextThen = process.condTrueJumps.get(currentComputationEvent);
//            XEvent nextElse = process.condFalseJumps.get(currentComputationEvent);
//            assert nextThen != null;
//            assert nextElse != null;
//            nonVisited.add(nextElse);
//            processDfsLinearisation(nextThen);
//        }
//
//        tempMarks.remove(current);
//        permMarks.add(current);
//        linearised.addFirst(current); //todo: check, should add to the head (index=0)
//    }
//}
