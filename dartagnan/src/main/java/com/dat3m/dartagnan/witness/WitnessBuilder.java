package com.dat3m.dartagnan.witness;

import com.dat3m.dartagnan.expression.BConst;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.event.Store;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.svcomp.event.EndAtomic;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.options.DartagnanOptions;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverException;

import java.io.BufferedReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.math.BigInteger;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.function.Predicate;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.program.utils.EType.PTHREAD;
import static com.dat3m.dartagnan.program.utils.EType.WRITE;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.witness.EdgeAttributes.*;
import static com.dat3m.dartagnan.witness.GraphAttributes.*;
import static com.dat3m.dartagnan.wmm.utils.Utils.intVar;
import static java.lang.String.valueOf;

public class WitnessBuilder {
	
	private final WitnessGraph graph;
	private final Program program;
	private final SolverContext ctx;
	private final ProverEnvironment prover;
	private final String type ;
	private final String path;
	
	private final Map<Event, Integer> eventThreadMap = new HashMap<>();
	
	public WitnessBuilder(Program program, SolverContext ctx, ProverEnvironment prover, Result result, DartagnanOptions options) {
		this.graph = new WitnessGraph();
		this.graph.addAttribute(UNROLLBOUND.toString(), valueOf(options.getSettings().getBound()));
		this.program = program;
		this.ctx = ctx;
		this.prover = prover;
		this.type = result.equals(FAIL) ? "violation" : "correctness";
		this.path = options.createWitness();
		buildGraph();
	}
	
	public void write() {
		try (FileWriter fw = new FileWriter(System.getenv().get("DAT3M_HOME") + "/output/witness.graphml")) {
			fw.write("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n");
			fw.write("<graphml xmlns=\"http://graphml.graphdrawing.org/xmlns\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n");
			for(GraphAttributes attr : GraphAttributes.values()) {fw.write("<key attr.name=\"" + attr.toString() + "\" attr.type=\"string\" for=\"graph\" id=\"" + attr + "\"/>\n");}
			for(NodeAttributes attr : NodeAttributes.values()) {fw.write("<key attr.name=\"" + attr.toString() + "\" attr.type=\"boolean\" for=\"node\" id=\"" + attr + "\"/>\n");}
			for(EdgeAttributes attr : EdgeAttributes.values()) {fw.write("<key attr.name=\"" + attr.toString() + "\" attr.type=\"string\" for=\"edge\" id=\"" + attr + "\"/>\n");}
			fw.write(graph.toXML());
			fw.write("</graphml>\n");
		} catch (IOException e1) {
			e1.printStackTrace();
		}		
	}

	private void buildGraph() {
		populateMap();
		graph.addAttribute(WITNESSTYPE.toString(), type + "_witness");
		graph.addAttribute(SOURCECODELANG.toString(), "C");
		graph.addAttribute(PRODUCER.toString(), "Dartagnan");
		graph.addAttribute(SPECIFICATION.toString(), "CHECK( init(main()), LTL(G ! call(reach_error())))");
		graph.addAttribute(PROGRAMFILE.toString(), path);
		graph.addAttribute(ARCHITECTURE.toString(), "32bit");
		graph.addAttribute(PROGRAMHASH.toString(), checksum());
		
		DateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
		df.setTimeZone(TimeZone.getTimeZone("UTC"));
		graph.addAttribute(CREATIONTIME.toString(), df.format(new Date()));

		Node v0 = new Node("N0");
		v0.addAttribute("entry", "true");
		Node v1 = new Node("N1");
		Node v2 = new Node("N2");
		
		Edge edge = new Edge(v0, v1); 
		edge.addAttribute(CREATETHREAD.toString(), "0");
		graph.addEdge(edge);
		edge = new Edge(v1, v2); 
		edge.addAttribute(THREADID.toString(), "0");
		edge.addAttribute(ENTERFUNCTION.toString(), "main");
		graph.addEdge(edge);
		
		int nextNode = 2;
		int threads = 1;
		
		if(type.equals("correctness")) {
			return;
		}

		try (Model model = prover.getModel()) {
			List<Event> execution = reOrderBasedOnAtomicity(program, getSCExecutionOrder(model));

			for (int i = 0; i < execution.size(); i++) {
				Event e = execution.get(i);
				if (i + 1 < execution.size()) {
					Event next = execution.get(i + 1);
					if (e.getCLine() == next.getCLine() && e.getThread() == next.getThread()) {
						continue;
					}
				}

				edge = new Edge(new Node("N" + nextNode), new Node("N" + (nextNode + 1)));
				edge.addAttribute(THREADID.toString(), valueOf(eventThreadMap.get(e)));
				edge.addAttribute(STARTLINE.toString(), valueOf(e.getCLine()));

				if (e.hasFilter(WRITE) && e.hasFilter(PTHREAD)) {
					edge.addAttribute(CREATETHREAD.toString(), valueOf(threads));
					threads++;
				}
				
				if(e instanceof Load) {
					RegWriter l = (RegWriter)e;
					edge.addAttribute(EVENTID.toString(), valueOf(e.getUId()));
					edge.addAttribute(LOADEDVALUE.toString(), l.getWrittenValue(e, model, ctx).toString());
				}

				if(e instanceof Store) {
					Store s = (Store)e;
					edge.addAttribute(EVENTID.toString(), valueOf(e.getUId()));
					edge.addAttribute(STOREDVALUE.toString(), s.getMemValue().getIntValue(s, model, ctx).toString());
				}

				graph.addEdge(edge);

				nextNode++;
				if (e.hasFilter(EType.ASSERTION)) {
					break;
				}
			}
		}  catch (SolverException ignore) {
			// The if above guarantees that if we reach this try, a Model exists
		}
		graph.getNode("N" + nextNode).addAttribute("violation", "true");
	}
	
	private void populateMap() {
		for(Thread t : program.getThreads()) {
			for(Event e : t.getEntry().getSuccessors()) {
				eventThreadMap.put(e, t.getId() - 1);
			}
		}
	}
	
	private List<Event> getSCExecutionOrder(Model model) {
		List<Event> execEvents = new ArrayList<>();
		Predicate<Event> executedCEvents = e -> e.wasExecuted(model) &&  e.getCLine() > - 1;
		execEvents.addAll(program.getCache().getEvents(FilterBasic.get(EType.INIT)).stream().filter(executedCEvents).collect(Collectors.toList()));
		execEvents.addAll(program.getEvents().stream().filter(executedCEvents).collect(Collectors.toList()));
		
		Map<Integer, List<Event>> map = new HashMap<>();
        for(Event e : execEvents) {
			// TODO improve this: these events correspond to return statements
			if(e instanceof MemEvent && ((MemEvent)e).getMemValue() instanceof BConst && !((BConst)((MemEvent)e).getMemValue()).getValue()) {
				continue;
			}
        	BigInteger var = model.evaluate(intVar("hb", e, ctx));
        	if(var != null) {
        		map.computeIfAbsent(var.intValue(), x -> new ArrayList<>()).add(e);
        	}
        }

        List<Event> exec = map.keySet().stream().sorted()
				.flatMap(key -> map.get(key).stream()).collect(Collectors.toList());
        return exec.isEmpty() ? execEvents : exec;
	}
	
	public List<Event> reOrderBasedOnAtomicity(Program program, List<Event> order) {
		List<Event> result = new ArrayList<>();
		Set<Event> processedEvents = new HashSet<>(); // Maintained for constant lookup time
		// All the atomic blocks in the code that have to stay together in any execution
		List<List<Event>> atomicBlocks = program.getCache().getEvents(FilterBasic.get(EType.SVCOMPATOMIC))
				.stream().map(e -> ((EndAtomic)e).getBlock().stream().
						filter(order::contains).
						collect(Collectors.toList()))
				.collect(Collectors.toList());

		for (Event next : order) {
			if (processedEvents.contains(next)) {
				// next was added as part of a previous block
				continue;
			}
			List<Event> block = atomicBlocks.stream()
					.filter(b -> Collections.binarySearch(b, next) >= 0).findFirst()
					.orElseGet(() -> Collections.singletonList(next));
			result.addAll(block);
			processedEvents.addAll(block);
		}
		return result;
	}
	
	private String checksum() {
		String output = "";
		try {
			Process proc = Runtime.getRuntime().exec("sha256sum " + path);
			try (BufferedReader read = new BufferedReader(new InputStreamReader(proc.getInputStream()))) {
				proc.waitFor();
				while (read.ready()) {
					output = read.readLine();
				}
				if (proc.exitValue() == 1) {
					// No try-with-resources is needed as process will terminate anyways
					BufferedReader error = new BufferedReader(new InputStreamReader(proc.getErrorStream()));
					while (error.ready()) {
						System.out.println(error.readLine());
					}
					System.exit(0);
				}
			}
		} catch(IOException | InterruptedException e) {
			System.out.println(e.getMessage());
			System.exit(0);
		}

		output = output.substring(0, output.lastIndexOf(' '));
		output = output.substring(0, output.lastIndexOf(' '));
		return output;
	}

}
