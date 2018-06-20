package porthosc.languages.syntax.xgraph.visitors.iterators.old;//package porthosc.languages.syntax.xgraph.visitors.iterators.old;
//
//import porthosc.languages.syntax.xgraph.events.XEvent;
//import porthosc.languages.syntax.xgraph.process.XFlowGraph;
//
//import java.util.Iterator;
//import java.util.Queue;
//
//
//public class XgraphLineariserTraverser implements Iterator<XEvent> {
//
//    private final Iterator<XEvent> linearisedOrderIterator;
//
//    //TODO: traverse graph on verifying stage (right after building) and saving this info as min-path labels foreach node
//    public XgraphLineariserTraverser(XFlowGraph process) {
//        XgraphLineariser lineariser = new XgraphLineariser(process);
//        Queue<XEvent> linearsedEventsList = lineariser.build();
//        linearisedOrderIterator = linearsedEventsList.iterator();
//    }
//
//    @Override
//    public boolean hasNext() {
//        return linearisedOrderIterator.hasNext();
//    }
//
//    @Override
//    public XEvent next() {
//        return linearisedOrderIterator.next();
//    }
//
//}
