package com.dat3m.dartagnan.program;


import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.asserts.AbstractAssert;
import com.dat3m.dartagnan.asserts.AssertCompositeOr;
import com.dat3m.dartagnan.asserts.AssertInline;
import com.dat3m.dartagnan.asserts.AssertTrue;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Local;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.memory.Location;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.program.utils.ThreadCache;
import com.dat3m.dartagnan.utils.equivalence.BranchEquivalence;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.google.common.collect.ImmutableSet;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.log.BasicLogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import static com.dat3m.dartagnan.program.utils.Utils.generalEqual;

import java.util.*;

public class Program {

    private final static Logger logger = LogManager.getLogger(Program.class);

    private String name;
	private AbstractAssert ass;
    private AbstractAssert assFilter;
	private final List<Thread> threads;
	private final ImmutableSet<Location> locations;
	private final Memory memory;
	private Arch arch;
    private ThreadCache cache;
    private boolean isUnrolled;
    private boolean isCompiled;
    private VerificationTask task;
    private BranchEquivalence branchEquivalence;
    public static SolverContext defaultCtx;

    public Program(Memory memory, ImmutableSet<Location> locations){
        this("", memory, locations);
    }

	public Program (String name, Memory memory, ImmutableSet<Location> locations) {
		this.name = name;
		this.memory = memory;
		this.locations = locations;
		this.threads = new ArrayList<>();
	}

	public boolean isCompiled(){
        return isCompiled;
    }

    public boolean isUnrolled(){
        return isUnrolled;
    }

	public String getName(){
        return name;
    }

	public void setName(String name){
	    this.name = name;
    }

	public void setArch(Arch arch){
	    this.arch = arch;
    }

	public Arch getArch(){
	    return arch;
    }

    public Memory getMemory(){
        return this.memory;
    }

    public AbstractAssert getAss() {
        return ass;
    }

    public void setAss(AbstractAssert ass) {
        this.ass = ass;
    }

    public AbstractAssert getAssFilter() {
        return assFilter;
    }

    public void setAssFilter(AbstractAssert ass) {
        this.assFilter = ass;
    }

    public void add(Thread t) {
		threads.add(t);
	}

    public ThreadCache getCache(){
        if(cache == null){
            cache = new ThreadCache(getEvents());
        }
        return cache;
    }

    public void clearCache(){
    	for(Thread t : threads){
    		t.clearCache();
    	}
    	cache = null;
    }

    public List<Thread> getThreads() {
        return threads;
    }

    public ImmutableSet<Location> getLocations(){
        return locations;
    }

	public List<Event> getEvents(){
        // TODO: Why don't we use the cache if available?
        List<Event> events = new ArrayList<>();
		for(Thread t : threads){
			events.addAll(t.getCache().getEvents(FilterBasic.get(EType.ANY)));
		}
		return events;
	}

    public BranchEquivalence getBranchEquivalence() {
        if (branchEquivalence == null) {
            branchEquivalence = new BranchEquivalence(this);
        }
        return branchEquivalence;
    }

	public void updateAssertion() {
		if(ass != null) {
			return;
		}
		List<Event> assertions = new ArrayList<>();
		for(Thread t : threads){
			assertions.addAll(t.getCache().getEvents(FilterBasic.get(EType.ASSERTION)));
		}
		ass = new AssertTrue();
		if(!assertions.isEmpty()) {
    		ass = new AssertInline((Local)assertions.get(0));
    		for(int i = 1; i < assertions.size(); i++) {
    			ass = new AssertCompositeOr(ass, new AssertInline((Local)assertions.get(i)));
    		}
    	}
	}

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    public int unroll(int bound, int nextId) {
        for(Thread thread : threads){
            nextId = thread.unroll(bound, nextId);
        }
        isUnrolled = true;
        cache = null;
        return nextId;
    }


    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    public int compile(Arch target, int nextId) {
        if (!isUnrolled()) {
            throw new IllegalStateException("The program needs to be unrolled first.");
        }

        for(Thread thread : threads){
            nextId = thread.compile(target, nextId);
        }
        isCompiled = true;
        cache = null;
        return nextId;
    }


    // Encoding
    // -----------------------------------------------------------------------------------------------------------------

    public void initialise(VerificationTask task, SolverContext ctx) {
        if (!isCompiled) {
            throw new IllegalStateException("The program needs to be compiled first.");
        }
        this.task = task;
        for(Event e : getEvents()){
            e.initialise(task, ctx);
        }
        Program.defaultCtx = ctx;
    }

    public static void initCtx() {
        try {
            Configuration config = Configuration.defaultConfiguration();
			defaultCtx = SolverContextFactory.createSolverContext(
			        config, 
			        BasicLogManager.create(config), 
			        ShutdownManager.create().getNotifier(), 
			        Solvers.Z3);
		} catch (Exception e) {
			e.printStackTrace();
		}
    }
    
    public BooleanFormula encodeCF(SolverContext ctx) {
        if (this.task == null) {
            throw new RuntimeException("The program needs to get initialised first.");
        }

        BooleanFormula enc = GlobalSettings.FIXED_MEMORY_ENCODING ? memory.fixedMemoryEncoding(ctx) : memory.encode(ctx);
        for(Thread t : threads){
            enc = ctx.getFormulaManager().getBooleanFormulaManager().and(enc, t.encodeCF(ctx));
        }
        return enc;
    }

    public BooleanFormula encodeFinalRegisterValues(SolverContext ctx){
        FormulaManager fmgr = ctx.getFormulaManager();
		BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();
        
        if (this.task == null) {
            throw new RuntimeException("The program needs to get initialised first.");
        }

        Map<Register, List<Event>> eMap = new HashMap<>();
        for(Event e : getCache().getEvents(FilterBasic.get(EType.REG_WRITER))){
            Register reg = ((RegWriter)e).getResultRegister();
            eMap.putIfAbsent(reg, new ArrayList<>());
            eMap.get(reg).add(e);
        }

        BranchEquivalence eq = getBranchEquivalence();
		BooleanFormula enc = bmgr.makeTrue();
        for (Register reg : eMap.keySet()) {
            Thread thread = threads.get(reg.getThreadId());

            List<Event> events = eMap.get(reg);
            events.sort(Collections.reverseOrder());

            // =======================================================
            // Optimizations that remove registers which are guaranteed to get overwritten
            //TODO: Make sure that this is correct even for EXCL events
            for (int i = 0; i < events.size(); i++) {
                if (eq.isImplied(thread.getExit(), events.get(i))) {
                    events = events.subList(0, i + 1);
                    break;
                }
            }
            final List<Event> events2 = events;
            events.removeIf(x -> events2.stream().anyMatch(y -> y.getCId() > x.getCId() && eq.isImplied(x, y)));
            // ========================================================


            for(int i = 0; i <  events.size(); i++){
                Event w1 = events.get(i);
                BooleanFormula lastModReg = w1.exec();
                for(int j = 0; j < i; j++){
                    Event w2 = events.get(j);
                    if (!eq.areMutuallyExclusive(w1, w2)) {
                        lastModReg = bmgr.and(lastModReg, bmgr.not(w2.exec()));
                    }
                }
                
                BooleanFormula same =  generalEqual(reg.getLastValueExpr(ctx), ((RegWriter)w1).getResultRegisterExpr(), ctx);
                enc = bmgr.and(enc, bmgr.implication(lastModReg, same));
            }
        }
        return enc;
    }
    
    public BooleanFormula encodeNoBoundEventExec(SolverContext ctx){
        if (this.task == null) {
            throw new RuntimeException("The program needs to get initialised first.");
        }

        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		BooleanFormula enc = bmgr.makeTrue();
        for(Event e : getCache().getEvents(FilterBasic.get(EType.BOUND))){
        	enc = bmgr.and(enc, bmgr.not(e.exec()));
        }
        return enc;
    }



    // ----------------------------- Preprocessing -----------------------------------

    public void reorder() {
        if (isUnrolled) {
            throw new IllegalStateException("Reordering should be performed before unrolling.");
        }

        for (Thread t : getThreads()) {
            t.reorderBranches();
        }
    }

    public void eliminateDeadCode() {
        if (isUnrolled) {
            throw new IllegalStateException("Dead code elimination should be performed before unrolling.");
        }
        int id = 0;
        for (Thread t : getThreads()) {
            id = t.eliminateDeadCode(id);
        }
        cache = null;
    }

    public void simplify() {
        // Some simplification are only applicable after others.
        // Thus we apply them iteratively until we reach a fixpoint.
        int size = getEvents().size();
        logger.info("pre-simplification: " + size + " events");
        one_step_simplify();
        while(getEvents().size() != size) {
            size = getEvents().size();
            one_step_simplify();
        }
        logger.info("post-simplification: " + size + " events");
    }

    private void one_step_simplify() {
        for(Thread thread : threads){
            thread.simplify();
        }
        cache = null;
    }


}