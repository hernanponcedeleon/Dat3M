package porthosc.app.modules.aramis;///*
// * To change this license header, choose License Headers in Project Properties.
// * To change this template file, choose Tools | Templates
// * and open the template in the editor.
// */
//package old.aramis;
//
///**
// *
// * @author Florian Furbach
// */
//import java.io.File;
//import java.io.IOException;
//import java.util.Arrays;
//import java.util.List;
//
//import org.antlr.v4.runtime.ANTLRInputStream;
//import org.antlr.v4.runtime.CommonTokenStream;
//import org.apache.commons.io.FileUtils;
//
//import com.microsoft.z3.Context;
//import com.microsoft.z3.Solver;
//import com.microsoft.z3.Status;
//import com.microsoft.z3.Z3Exception;
//import com.microsoft.z3.enumerations.Z3_ast_print_mode;
//
//import porthosc.languages.parsers.*;
//import porthosc.program.XProgram;
//import porthosc.memorymodels.Domain;
//import porthosc.wmm.MemoryModel;
//import porthosc.memorymodels.relations.old.BasicRelation;
//import porthosc.memorymodels.axioms.old.CandidateAxiom;
//import porthosc.memorymodels.relations.old.RelComposition;
//import porthosc.memorymodels.relations.old.RelInterSect;
//import porthosc.memorymodels.relations.old.RelMinus;
//import porthosc.memorymodels.relations.old.RelTrans;
//import porthosc.memorymodels.relations.old.RelTransRef;
//import porthosc.memorymodels.relations.old.RelUnion;
//import porthosc.memorymodels.relations.old.Relation;
//import java.util.ArrayList;
//import java.util.HashMap;
//import java.util.Map;
//import java.util.Objects;
//
//import java.util.logging.ConsoleHandler;
//import java.util.logging.Level;
//import java.util.logging.Logger;
//
//import org.apache.commons.cli.*;
//
//@SuppressWarnings("deprecation")
//public class Aramis {
//
//    private static final Logger log = Logger.getLogger(Aramis.class.getName());
//
//    private static XProgram parseProgramFile(String inputFilePath, String target) throws IOException {
//        File file = new File(inputFilePath);
//
//        String program = FileUtils.readFileToString(file, "UTF-8");
//        ANTLRInputStream input = new ANTLRInputStream(program);
//
//        XProgram p = new XProgram(inputFilePath);
//
//        if (inputFilePath.endsWith("litmus")) {
//            LitmusLexer lexer = new LitmusLexer(input);
//            CommonTokenStream tokens = new CommonTokenStream(lexer);
//            LitmusParser parser = new LitmusParser(tokens);
//            p = parser.program(inputFilePath).p;
//        }
//
//        if (inputFilePath.endsWith("pts")) {
//            PorthosLexer lexer = new PorthosLexer(input);
//            CommonTokenStream tokens = new CommonTokenStream(lexer);
//            PorthosParser parser = new PorthosParser(tokens);
//            p = parser.program(inputFilePath).p;
//        }
//
//        p.initialize();
//        p.compile(target, false, true);
//        return p;
//    }
//    private static int unchecked = 0;
//    private static final ArrayList<CandidateAxiom> candidates = new ArrayList<>();
//    private static ArrayList<XProgram> posPrograms;
//    private static ArrayList<XProgram> negPrograms;
//    private static ArrayList<Solver> posSolvers;
//    private static ArrayList<Solver> negSolvers;
//    private static HashMap<XProgram, Solver> solvers = new HashMap<>();
//    private static final Context ctx = new Context();
//    private static int[] current;
//    private static MemoryModel currentCandidate;
//
//    /**
//     *
//     * @param unchecked index of the first unchecked candidate
//     * @param end the the last checked index+1
//     * @param currentAxiom the index of the current axiom in current
//     * @return
//     */
//    private static boolean CheckingCandidates(int unchecked, int end, int currentAxiom) {
//        //if we have set all candidates
//        if (currentAxiom < 0) {
//            return checkCurrent();
//        }
//        //if we have not enough candidates for the axioms left
//        if (end - unchecked < currentAxiom + 1) {
//            return false;
//        }
//        boolean temp = false;
//        int i = unchecked;
//        while (i < end && !temp) {
//            current[currentAxiom] = i;
//            if (candidates.get(i).consistent) {
//                if (CheckingCandidates(0, i - 1, currentAxiom - 1)) {
//                    temp = true;
//                }
//            }
//            i++;
//        }
//        return temp;
//    }
//
//    private static void add(Relation rel) {
//        CandidateAxiom ax = new CandidateAxiom(rel);
//        ax.consistent = checkCandidate(ax);
//        candidates.add(ax);
//        log.fine("Adding and Checking" + rel.getName()+". Consistent: "+ax.consistent);
//    }
//
//        private static void add(Relation rel, HashMap<XProgram, Boolean> map) {
//        CandidateAxiom ax = new CandidateAxiom(rel);
//        ax.consProg=map;
//        ax.consistent = checkCandidate(ax);
//        candidates.add(ax);
//        log.fine("Adding and Checking" + rel.getName()+". Consistent: "+ax.consistent);
//    }
//
//    private static void add(Relation rel, boolean cons) {
//        CandidateAxiom ax = new CandidateAxiom(rel);
//        ax.consistent = cons;
//        candidates.add(ax);
//        log.fine("Adding " + rel.getName() + ", Consistent: " + cons);
//    }
//
//    private static void addCandidates() {
//        int oldsize = candidates.size();
//        for (int j = unchecked; j < oldsize; j++) {
//            Relation r1 = candidates.get(j).getRel();
//            //candidates.get(j).consProg.fir
//            boolean consr1 = candidates.get(j).consistent;
//            Map<XProgram, Boolean> r1consProg = candidates.get(j).consProg;
//            if (!(r1 instanceof RelTransRef)) {
//                //add(new RelTransRef(r1), consr1);
//            }
//            if (!(r1 instanceof RelTransRef) && !(r1 instanceof RelTrans)) {
//                //add(new RelTrans(r1), consr1);
//            }
//            if (!(r1 instanceof RelMinus)) {
//                add(new RelMinus(r1, new BasicRelation("WR")), consr1);
//            }
//
//            for (int i = 0; i < j; i++) {
//                //       if(i!=j){
//                Relation r2 = candidates.get(i).getRel();
//                boolean consr2 = candidates.get(i).consistent;
//                Map<XProgram, Boolean> r2consProg = candidates.get(i).consProg;
//
//                //unions are always added from the left
//                if (!(r2 instanceof RelUnion)) {
//                    if (!consr1 || !consr2) {
//
//                        add(new RelUnion(r1, r2), false);
//                    } else {
//                        add(new RelUnion(r1, r2));
//                    }
//                }
//                boolean unionCons = candidates.get(candidates.size() - 1).consistent;
//                HashMap<XProgram, Boolean> unionProgCons =candidates.get(candidates.size() - 1).consProg;
//
//                //intersections are always added from the left
//                if (!(r2 instanceof RelInterSect)) {
//                    if (consr1 && consr2) {
//                        add(new RelInterSect(r1, r2), true);
//                    } else {
//                        HashMap<XProgram, Boolean> tempmap =new HashMap<>(posPrograms.size());
//                        for (Map.Entry<XProgram, Boolean> entry : r2consProg.entrySet()) {
//                            XProgram key = entry.getKey();
//                            Boolean value = entry.getValue();
//                            if(value=Boolean.TRUE){
//                                if(r1consProg.get(key)==Boolean.TRUE)
//                                    tempmap.put(key, Boolean.TRUE);
//                            }
//                        }
//                        add(new RelInterSect(r1, r2),tempmap);
//                    }
//                }
//                boolean intersectCons = candidates.get(candidates.size() - 1).consistent;
//
//                if (!(r2 instanceof RelComposition)) {
//                    if (unionCons) {
//                        add(new RelComposition(r1, r2), true);
//                        add(new RelComposition(r2, r1), true);
//
//                    } else if (!intersectCons) {
//                        add(new RelComposition(r1, r2), false);//add unionProgCons
//                        add(new RelComposition(r2, r1), false);//add unionProgCons
//                    } else {
//                        add(new RelComposition(r1, r2));
//                        add(new RelComposition(r2, r1));
//                    }
//                }
//                //  }
//            }
//        }
//        unchecked = oldsize;
//    }
//
//    private static void addBasicrels() {
//        add(new BasicRelation("co"));
//        add(new BasicRelation("po"));
//        add(new BasicRelation("fr"));
//        add(new BasicRelation("rf"));
//        //add(new BasicRelation("poloc"));
//        //add(new BasicRelation("mfence"));
//        //add(new BasicRelation("rfe"));
//        //add(new BasicRelation("WR")));
//
//    }
//
//    public static void main(String[] args), IOException {
//        log.setLevel(Level.FINEST);
//        ConsoleHandler handler = new ConsoleHandler();
//        ctx.setPrintMode(Z3_ast_print_mode.Z3_PRINT_SMTLIB_FULL);
//
//        // PUBLISH this level
//        handler.setLevel(Level.FINEST);
//        log.addHandler(handler);
//        log.info("Starting...");
//        Options options = new Options();
//
//        Option pos = new Option("p", "positive", true, "Directory of program files that should pass the reachability src.porthosc.tests");
//        pos.setRequired(true);
//        options.addOption(pos);
//
//        Option neg = new Option("n", "negative", true, "Directory of program files that should fail the reachability src.porthosc.tests");
//        neg.setRequired(true);
//        options.addOption(neg);
//
//        Option axs = new Option("ax", "axioms", true, "Number of expected Axioms in the model to be synthesized");
//        axs.setRequired(false);
//        options.addOption(axs);
//
//        List<String> MCMs = Arrays.asList("sc", "tso", "pso", "rmo", "alpha", "power", "arm");
//
//        Option targetOpt = new Option("t", "target", true, "target MCM");
//        targetOpt.setRequired(true);
//        options.addOption(targetOpt);
//
//        CommandLineParser parserCmd = new DefaultParser();
//        HelpFormatter formatter = new HelpFormatter();
//        CommandLine cmd;
//
//        try {
//            cmd = parserCmd.parse(options, args);
//        } catch (ParseException e) {
//            System.out.println(e.getMessage());
//            formatter.printHelp("Aramis", options);
//            System.exit(1);
//            return;
//        }
//
//        String target = cmd.getOptionValue("target");
//        if (!MCMs.stream().anyMatch(mcms -> mcms.trim().equals(target))) {
//            System.out.println("Unrecognized target");
//            System.exit(0);
//            return;
//        }
//        File positiveDir = new File(cmd.getOptionValue("positive"));
//        posPrograms = new ArrayList<>(positiveDir.listFiles().length);
//        posSolvers = new ArrayList<>(positiveDir.listFiles().length);
//        for (File listFile : positiveDir.listFiles()) {
//            String string = listFile.getPath();
//
//            if (!string.endsWith("pts") && !string.endsWith("litmus")) {
//                log.warning("Unrecognized program format for " + string);
//
//            } else {
//                log.fine("Positive litmus test: " + string);
//                XProgram p = parseProgramFile(string, target);
//                posPrograms.add(p);
//                solvers.put(p, ctx.mkSolver());
//                Solver s = solvers.get(p);
//                s.add(p.encodeDF(ctx));
//                s.add(p.ass.encode(ctx));
//                s.add(p.encodeCF(ctx));
//                s.add(p.encodeDF_RF(ctx));
//                s.add(Domain.encode(p, ctx));
//            }
//
//        }
//
//        File negativeDir = new File(cmd.getOptionValue("negative"));
//        negPrograms = new ArrayList<>(negativeDir.listFiles().length);
//        for (File listFile : negativeDir.listFiles()) {
//            String string = listFile.getPath();
//            if (!string.endsWith("pts") && !string.endsWith("litmus")) {
//                log.warning("Unrecognized program format for " + string);
//
//            } else {
//                log.fine("Negative litmus test: " + string);
//                XProgram p = parseProgramFile(string, target);
//                negPrograms.add(p);
//                solvers.put(p, ctx.mkSolver());
//                Solver s = solvers.get(p);
//                s.add(p.encodeDF(ctx));
//                s.add(p.ass.encode(ctx));
//                s.add(p.encodeCF(ctx));
//                s.add(p.encodeDF_RF(ctx));
//                s.add(Domain.encode(p, ctx));
//            }
//
//        }
//
//        if (cmd.hasOption("ax")) {
//            int nrOfAxioms = Integer.parseInt(cmd.getOptionValue("ax"));
//            current = new int[nrOfAxioms];
//            log.fine("Axiom: " + nrOfAxioms + ". Pos: " + posPrograms.size() + ". Neg: " + negPrograms.size());
//            addBasicrels();
//            boolean temp = false;
//            while (!temp) {
//                if (CheckingCandidates(unchecked, candidates.size(), current.length - 1)) {
//                    System.out.println("Found Model: " + currentCandidate.write());
//                    log.info("Number of enumerated relations: "+candidates.size());
//                    temp = true;
//                } else {
//
//                    addCandidates();
//                }
//            }
//        } else {
//            log.fine("Pos: " + posPrograms.size() + ". Neg: " + negPrograms.size());
//            addBasicrels();
//            boolean temp = false;
//            while (!temp) {
//                if (CheckingCandidates(unchecked, candidates.size(), current.length - 1)) {
//                    System.out.println("Found Model: " + currentCandidate.write());
//                    temp = true;
//                } else {
//
//                    addCandidates();
//                }
//            }
//
//        }
//    }
//
//    private static boolean checkCandidate(CandidateAxiom ax) {
//        for (XProgram posProgram : posPrograms) {
//            if (!Objects.equals(ax.consProg.get(posProgram), Boolean.TRUE)) {
//                if (!checkCandidate(ax, posProgram)) {
//                    ax.consProg.put(posProgram, Boolean.FALSE);
//                    return false;
//                } else {
//                    ax.consProg.put(posProgram, Boolean.TRUE);
//                }
//            }
//        }
//        return true;
//    }
//
//    private static boolean checkCandidate(CandidateAxiom ax, XProgram p) {
//        MemoryModel tempmodel = new MemoryModel();
//        tempmodel.addAxiom(ax);
//        Solver s = solvers.get(p);
//        s.push();
//        s.add(tempmodel.encode(p, ctx));
//        s.add(tempmodel.Consistent(p, ctx));
//        Status sat = s.check();
//        s.pop();
//        return (sat == Status.SATISFIABLE);
//    }
//
//    private static boolean checkCurrent() {
//        currentCandidate = new MemoryModel();
//        for (int i : current) {
//            currentCandidate.addAxiom(candidates.get(i));
//        }
//        log.fine("Checking " + currentCandidate.write());
//        for (XProgram p : negPrograms) {
//            //check if p is already knwon to be inconsistent with one of the axioms, if so we can skip it.
//            boolean cons = true;
//            for (int i : current) {
//                if (candidates.get(i).consProg.get(p) == Boolean.FALSE) {
//                    cons = false;
//                }
//            }
//            if (cons) {
//                log.finer("Checking neg " + p.name);
//                Solver s = solvers.get(p);
//                s.push();
//                s.add(currentCandidate.encode(p, ctx));
//                s.add(currentCandidate.Consistent(p, ctx));
//                Status sat = s.check();
//                s.pop();
//                if (sat == Status.SATISFIABLE) {
//                    return false;
//                }
//            }
//
//        }
//        for (XProgram p : posPrograms) {
//            log.finer("Checking pos " + p.name);
//            Solver s = solvers.get(p);
//            s.push();
//            s.add(currentCandidate.encode(p, ctx));
//            s.add(currentCandidate.Consistent(p, ctx));
//            Status sat = s.check();
//            s.pop();
//            if (sat != Status.SATISFIABLE) {
//                return false;
//            }
//
//        }
//        return true;
//
//    }
//}
