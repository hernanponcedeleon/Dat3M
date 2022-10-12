package com.dat3m.dartagnan.witness;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.expression.BConst;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.lang.svcomp.EndAtomic;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.utils.Result;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverException;

import java.io.File;
import java.io.FileInputStream;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.function.Predicate;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.configuration.OptionNames.WITNESS_ORIGINAL_PROGRAM_PATH;
import static com.dat3m.dartagnan.program.event.Tag.C11.PTHREAD;
import static com.dat3m.dartagnan.program.event.Tag.WRITE;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.witness.EdgeAttributes.*;
import static com.dat3m.dartagnan.witness.GraphAttributes.*;
import static com.google.common.base.Preconditions.checkNotNull;
import static java.lang.String.valueOf;

@Options
public class WitnessBuilder {
	
	private final EncodingContext context;
	private final ProverEnvironment prover;
	private final String type;

    // =========================== Configurables ===========================

	@Option(
			name=WITNESS_ORIGINAL_PROGRAM_PATH,
			description="Path to the original C file (for which to create a witness).",
			secure=true)
	private String originalProgramFilePath;

    public boolean canBeBuilt() { return originalProgramFilePath != null; }

    // =====================================================================

	private final Map<Event, Integer> eventThreadMap = new HashMap<>();
	
	private WitnessBuilder(EncodingContext c, ProverEnvironment p, Result r) {
		context = checkNotNull(c);
		prover = checkNotNull(p);
		type = r.equals(FAIL) ? "violation" : "correctness";
	}

	public static WitnessBuilder of(EncodingContext context, ProverEnvironment prover, Result result) throws InvalidConfigurationException {
		WitnessBuilder b = new WitnessBuilder(context, prover, result);
		context.getTask().getConfig().inject(b);
		return b;
	}

	public WitnessGraph build() {
		for(Thread t : context.getTask().getProgram().getThreads()) {
			for(Event e : t.getEntry().getSuccessors()) {
				eventThreadMap.put(e, t.getId() - 1);
			}
		}

		WitnessGraph graph = new WitnessGraph();
		graph.addAttribute(UNROLLBOUND.toString(), valueOf(context.getTask().getProgram().getUnrollingBound()));
		graph.addAttribute(WITNESSTYPE.toString(), type + "_witness");
		graph.addAttribute(SOURCECODELANG.toString(), "C");
		graph.addAttribute(PRODUCER.toString(), "Dartagnan");
		graph.addAttribute(SPECIFICATION.toString(), "CHECK( init(main()), LTL(G ! call(reach_error())))");
		graph.addAttribute(PROGRAMFILE.toString(), originalProgramFilePath);
		graph.addAttribute(PROGRAMHASH.toString(), getFileSHA256(new File(originalProgramFilePath)));
		graph.addAttribute(ARCHITECTURE.toString(), "32bit");
		
		DateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
		df.setTimeZone(TimeZone.getTimeZone("UTC"));
		// "If the timestamp is in UTC time, it ends with a 'Z'."
		// https://github.com/sosy-lab/sv-witnesses/blob/main/README-GraphML.md
		graph.addAttribute(CREATIONTIME.toString(), df.format(new Date())+"Z");

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
			return graph;
		}

		SolverContext ctx = context.getSolverContext();
		try (Model model = prover.getModel()) {
			List<Event> execution = reOrderBasedOnAtomicity(context.getTask().getProgram(), getSCExecutionOrder(model));

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
				
				// End is also WRITE and PTHREAD, but it does not have
				// CLines and thus won't create an edge (as expected)
				if (e.hasFilter(WRITE) && e.hasFilter(PTHREAD)) {
					edge.addAttribute(CREATETHREAD.toString(), valueOf(threads));
					threads++;
				}
				
				if(e instanceof Load) {
					RegWriter l = (RegWriter)e;
					edge.addAttribute(EVENTID.toString(), valueOf(e.getUId()));
					edge.addAttribute(LOADEDVALUE.toString(), String.valueOf(model.evaluate(l.getResultRegister().toIntFormulaResult(e, ctx))));
				}

				if(e instanceof Store) {
					Store s = (Store)e;
					edge.addAttribute(EVENTID.toString(), valueOf(e.getUId()));
					edge.addAttribute(STOREDVALUE.toString(), s.getMemValue().getIntValue(s, model, ctx).toString());
				}

				graph.addEdge(edge);

				nextNode++;
				if (e.hasFilter(Tag.ASSERTION)) {
					break;
				}
			}
		}  catch (SolverException ignore) {
			// The if above guarantees that if we reach this try, a Model exists
		}
		graph.getNode("N" + nextNode).addAttribute("violation", "true");
		return graph;
	}
	
	private List<Event> getSCExecutionOrder(Model model) {
		List<Event> execEvents = new ArrayList<>();
		// TODO: we recently added many cline to many events and this might affect the witness generation.
		Predicate<Event> executedCEvents = e -> Boolean.TRUE.equals(model.evaluate(context.execution(e))) &&  e.getCLine() > - 1;
		execEvents.addAll(context.getTask().getProgram().getCache().getEvents(FilterBasic.get(Tag.INIT)).stream().filter(executedCEvents).collect(Collectors.toList()));
		execEvents.addAll(context.getTask().getProgram().getEvents().stream().filter(executedCEvents).collect(Collectors.toList()));
		Map<Integer, List<Event>> map = new HashMap<>();
        for(Event e : execEvents) {
			// TODO improve this: these events correspond to return statements
			if(e instanceof MemEvent && ((MemEvent)e).getMemValue() instanceof BConst && !((BConst)((MemEvent)e).getMemValue()).getValue()) {
				continue;
			}
        	BigInteger var = model.evaluate(context.clockVariable("hb", e));
        	if(var != null) {
        		map.computeIfAbsent(var.intValue(), x -> new ArrayList<>()).add(e);
        	}
        }

        List<Event> exec = map.keySet().stream().sorted()
				.flatMap(key -> map.get(key).stream()).collect(Collectors.toList());
        return exec.isEmpty() ? execEvents : exec;
	}
	
	private List<Event> reOrderBasedOnAtomicity(Program program, List<Event> order) {
		List<Event> result = new ArrayList<>();
		Set<Event> processedEvents = new HashSet<>(); // Maintained for constant lookup time
		// All the atomic blocks in the code that have to stay together in any execution
		List<List<Event>> atomicBlocks = program.getCache().getEvents(FilterBasic.get(Tag.SVCOMP.SVCOMPATOMIC))
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
	
	private String getFileSHA256(File file) {
		try {
			MessageDigest digest = MessageDigest.getInstance("SHA-256");
			
		    //Get file input stream for reading the file content
		    FileInputStream fis = new FileInputStream(file);
		     
		    //Create byte array to read data in chunks
		    byte[] byteArray = new byte[1024];
		    int bytesCount = 0; 
		      
		    //Read file data and update in message digest
		    while ((bytesCount = fis.read(byteArray)) != -1) {
		        digest.update(byteArray, 0, bytesCount);
		    };
		     
		    //close the stream; We don't need it now.
		    fis.close();
		     
		    //Get the hash's bytes
		    byte[] bytes = digest.digest();
		     
		    //This bytes[] has bytes in decimal format;
		    //Convert it to hexadecimal format
		    StringBuilder sb = new StringBuilder();
		    for(int i=0; i < bytes.length ;i++)
		    {
		        sb.append(Integer.toString((bytes[i] & 0xff) + 0x100, 16).substring(1));
		    }
		     
		    //return complete hash
		   return sb.toString();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}
}